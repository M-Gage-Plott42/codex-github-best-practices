# Contributing

Thanks for contributing. This repository is a template, so changes should stay
small, portable, and easy to apply in downstream repos.

## Before Opening a PR

1. Read `README.md`, `AGENTS.md`, and `docs/standards.md`.
2. Keep workflow, script, and docs changes synchronized.
3. Update `CHANGELOG.md` under `[Unreleased]` for user-visible changes.

## Local Checks

Run the same checks expected by CI:

```bash
ruff check .
yamllint -c .yamllint.yml .
markdownlint-cli2 "**/*.md"
actionlint
shellcheck scripts/bootstrap_repo.sh
bash -n scripts/bootstrap_repo.sh
bash scripts/smoke_bootstrap_ruleset_payload.sh
```

## Pull Request Guidance

1. Keep PRs focused on one logical improvement.
2. Explain intent, risk, and rollback strategy in the PR description.
3. Include links to relevant workflow runs for CI/security changes.
4. Do not merge while required checks are red.

## CodeQL Check Rollout Policy

This template intentionally separates CodeQL rollout into two phases:

1. Keep CodeQL running but not required until the repository has at least one
   confirmed green CodeQL run after configuration changes.
2. Enable required CodeQL checks by rerunning bootstrap with:

```bash
REQUIRE_CODEQL_CHECKS=1 bash scripts/bootstrap_repo.sh <owner/repo>
```

This avoids locking PRs on unstable check contexts while preserving a clear
path to stricter enforcement.
