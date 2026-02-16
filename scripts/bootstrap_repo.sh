#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <owner/repo>"
  exit 1
fi

REPO="$1"

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

# Prefer actions+python when available, but fall back to actions-only for repos
# that do not yet contain Python files.
if ! gh api -X PATCH "repos/${REPO}/code-scanning/default-setup" \
  -H 'Accept: application/vnd.github+json' \
  -f state=configured \
  -f languages[]=actions \
  -f languages[]=python >/dev/null 2>&1; then
  gh api -X PATCH "repos/${REPO}/code-scanning/default-setup" \
    -H 'Accept: application/vnd.github+json' \
    -f state=configured \
    -f languages[]=actions >/dev/null
fi

echo "Creating/refreshing default-branch ruleset..."

existing_id="$(gh api "repos/${REPO}/rulesets" --jq '.[] | select(.name=="main-pr-required-checks") | .id' || true)"

cat > /tmp/repo_ruleset_payload.json <<'JSON'
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
          {
            "context": "ruff"
          },
          {
            "context": "markdownlint"
          },
          {
            "context": "yamllint"
          }
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
