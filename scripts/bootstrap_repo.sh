#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <owner/repo>"
  echo "Optional: REQUIRE_CODEQL_CHECKS=1 to require CodeQL checks after first green run."
  exit 1
fi

REPO="$1"
REQUIRE_CODEQL_CHECKS="${REQUIRE_CODEQL_CHECKS:-0}"

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
  -f security_and_analysis[dependabot_security_updates][status]=enabled >/dev/null

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

echo "Creating/refreshing default-branch ruleset..."

existing_id="$(gh api "repos/${REPO}/rulesets" --jq '.[] | select(.name=="main-pr-required-checks") | .id' || true)"

required_checks=(
  "ruff"
  "markdownlint"
  "yamllint"
  "actionlint"
  "shellcheck"
)

if [[ "${REQUIRE_CODEQL_CHECKS}" == "1" ]]; then
  required_checks+=(
    "Analyze (python)"
    "Analyze (actions)"
  )
  echo "Including CodeQL checks in required status checks."
else
  echo "Skipping CodeQL required checks. Set REQUIRE_CODEQL_CHECKS=1 after one green CodeQL run."
fi

required_checks_json=""
for context in "${required_checks[@]}"; do
  if [[ -n "${required_checks_json}" ]]; then
    required_checks_json+=$',\n'
  fi
  required_checks_json+="          {\"context\": \"${context}\"}"
done

cat > /tmp/repo_ruleset_payload.json <<JSON
{
  "name": "main-pr-required-checks",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [
    {
      "actor_id": 5,
      "actor_type": "RepositoryRole",
      "bypass_mode": "always"
    }
  ],
  "conditions": {
    "ref_name": {
      "include": [
        "~DEFAULT_BRANCH"
      ],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "required_reviewers": [],
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true,
        "allowed_merge_methods": [
          "merge",
          "squash",
          "rebase"
        ]
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "do_not_enforce_on_create": false,
        "required_status_checks": [
${required_checks_json}
        ]
      }
    }
  ]
}
JSON

if [[ -n "${existing_id}" ]]; then
  gh api -X PUT "repos/${REPO}/rulesets/${existing_id}" --input /tmp/repo_ruleset_payload.json >/dev/null
  echo "Updated ruleset ${existing_id}."
else
  gh api -X POST "repos/${REPO}/rulesets" --input /tmp/repo_ruleset_payload.json >/dev/null
  echo "Created ruleset main-pr-required-checks."
fi

echo "Done."
