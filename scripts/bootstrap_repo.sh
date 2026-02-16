#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <owner/repo>"
  echo "Optional: REQUIRE_CODEQL_CHECKS=1 to require CodeQL checks after first green run."
  echo "Optional: RULESET_PAYLOAD_ONLY=1 to render ruleset payload JSON and exit."
  exit 1
fi

REPO="$1"
REQUIRE_CODEQL_CHECKS="${REQUIRE_CODEQL_CHECKS:-0}"
RULESET_PAYLOAD_ONLY="${RULESET_PAYLOAD_ONLY:-0}"
RULESET_PAYLOAD_PATH="${RULESET_PAYLOAD_PATH:-/tmp/repo_ruleset_payload.json}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if REQUIRE_CODEQL_CHECKS="${REQUIRE_CODEQL_CHECKS}" "${SCRIPT_DIR}/generate_ruleset_payload.sh" > "${RULESET_PAYLOAD_PATH}"; then
  :
else
  echo "Failed to generate ruleset payload at ${RULESET_PAYLOAD_PATH}." >&2
  exit 1
fi

if [[ "${RULESET_PAYLOAD_ONLY}" == "1" ]]; then
  echo "Wrote ruleset payload to ${RULESET_PAYLOAD_PATH}."
  exit 0
fi

echo "Applying repo settings to ${REPO}..."
gh repo edit "${REPO}" \
  --enable-wiki=false \
  --enable-projects=false \
  --enable-auto-merge \
  --delete-branch-on-merge \
  --template

gh api -X PUT "repos/${REPO}/vulnerability-alerts" \
  -H 'Accept: application/vnd.github+json' >/dev/null

gh api -X PUT "repos/${REPO}/private-vulnerability-reporting" \
  -H 'Accept: application/vnd.github+json' \
  -f enabled=true >/dev/null

gh api -X PATCH "repos/${REPO}" \
  -H 'Accept: application/vnd.github+json' \
  -f 'security_and_analysis[dependabot_security_updates][status]=enabled' >/dev/null

# This template uses advanced CodeQL configuration from
# .github/workflows/codeql.yml. Default setup and advanced setup cannot both
# upload CodeQL SARIF for the same repository, so ensure default setup is off.
if gh api -X PATCH "repos/${REPO}/code-scanning/default-setup" \
  -H 'Accept: application/vnd.github+json' \
  -f state=not-configured >/dev/null 2>&1; then
  echo "Disabled CodeQL default setup (advanced workflow mode)."
else
  echo "Warning: Unable to disable CodeQL default setup via API." >&2
  echo "         Disable it manually in Security -> Code scanning to avoid conflicts." >&2
fi

legacy_dynamic_codeql_ids="$(gh api "repos/${REPO}/actions/workflows" --jq '.workflows[] | select(.path=="dynamic/github-code-scanning/codeql") | .id' || true)"
if [[ -n "${legacy_dynamic_codeql_ids}" ]]; then
  echo "Found legacy dynamic CodeQL workflow entries. Attempting cleanup..."
  while IFS= read -r workflow_id; do
    [[ -z "${workflow_id}" ]] && continue
    if gh workflow disable -R "${REPO}" "${workflow_id}" >/dev/null 2>&1; then
      echo "Disabled legacy dynamic CodeQL workflow ${workflow_id}."
    else
      echo "Warning: Unable to disable legacy dynamic CodeQL workflow ${workflow_id} via API." >&2
      echo "         Disable it manually in Security -> Code scanning settings." >&2
    fi
  done <<< "${legacy_dynamic_codeql_ids}"
fi

echo "Creating/refreshing default-branch ruleset..."

existing_id="$(gh api "repos/${REPO}/rulesets" --jq '.[] | select(.name=="main-pr-required-checks") | .id' || true)"
if [[ "${REQUIRE_CODEQL_CHECKS}" == "1" ]]; then
  echo "Including CodeQL checks in required status checks."
else
  echo "Skipping CodeQL required checks. Set REQUIRE_CODEQL_CHECKS=1 after one green CodeQL run."
fi

if [[ -n "${existing_id}" ]]; then
  gh api -X PUT "repos/${REPO}/rulesets/${existing_id}" --input "${RULESET_PAYLOAD_PATH}" >/dev/null
  echo "Updated ruleset ${existing_id}."
else
  gh api -X POST "repos/${REPO}/rulesets" --input "${RULESET_PAYLOAD_PATH}" >/dev/null
  echo "Created ruleset main-pr-required-checks."
fi

echo "Done."
