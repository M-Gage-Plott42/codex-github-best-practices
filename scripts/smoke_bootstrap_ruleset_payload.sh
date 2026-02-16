#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

payload_default="${tmp_dir}/ruleset_default.json"
payload_with_codeql="${tmp_dir}/ruleset_with_codeql.json"
placeholder_repo="example-owner/example-repo"

RULESET_PAYLOAD_ONLY=1 RULESET_PAYLOAD_PATH="${payload_default}" \
  bash "${script_dir}/bootstrap_repo.sh" "${placeholder_repo}" >/dev/null

REQUIRE_CODEQL_CHECKS=1 RULESET_PAYLOAD_ONLY=1 RULESET_PAYLOAD_PATH="${payload_with_codeql}" \
  bash "${script_dir}/bootstrap_repo.sh" "${placeholder_repo}" >/dev/null

python3 -m json.tool "${payload_default}" >/dev/null
python3 -m json.tool "${payload_with_codeql}" >/dev/null

for context in ruff markdownlint yamllint actionlint shellcheck; do
  rg -F -q "\"context\": \"${context}\"" "${payload_default}"
done

if rg -F -q '"context": "Analyze (python)"' "${payload_default}"; then
  echo "Unexpected CodeQL context in default payload." >&2
  exit 1
fi

rg -F -q '"context": "Analyze (python)"' "${payload_with_codeql}"
rg -F -q '"context": "Analyze (actions)"' "${payload_with_codeql}"

echo "Ruleset payload smoke test passed."
