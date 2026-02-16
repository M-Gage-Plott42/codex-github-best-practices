#!/usr/bin/env bash
set -euo pipefail

REQUIRE_CODEQL_CHECKS="${REQUIRE_CODEQL_CHECKS:-0}"

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
fi

required_checks_json=""
for context in "${required_checks[@]}"; do
  if [[ -n "${required_checks_json}" ]]; then
    required_checks_json+=$',\n'
  fi
  required_checks_json+="          {\"context\": \"${context}\"}"
done

cat <<JSON
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
