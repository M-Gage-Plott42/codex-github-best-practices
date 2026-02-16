# codex-github-best-practices

[![License](https://img.shields.io/github/license/M-Gage-Plott42/codex-github-best-practices?label=License)](LICENSE)
[![ruff](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-python.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-python.yml)
[![markdownlint](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-markdown.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-markdown.yml)
[![yamllint](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-yaml.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-yaml.yml)
[![actionlint](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-actions.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-actions.yml)
[![shellcheck](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-shell.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-shell.yml)
[![CodeQL](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/codeql.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/codeql.yml)

Opinionated template for AI-assisted development repositories using Codex + GitHub governance defaults:

- predictable CI and lint checks,
- dependency hygiene with Dependabot,
- security defaults and vulnerability reporting,
- non-blocking admin bypass for branch rulesets,
- dual `AGENTS.md` pattern (live + illustrative template).

## Included Files

- `.github/dependabot.yml`
- `.github/workflows/lint-python.yml`
- `.github/workflows/lint-markdown.yml`
- `.github/workflows/lint-yaml.yml`
- `.github/workflows/lint-actions.yml`
- `.github/workflows/lint-shell.yml`
- `.github/workflows/codeql.yml`
- `.github/workflows/dependabot-auto-merge.yml`
- `.github/CODEOWNERS`
- `.pre-commit-config.yaml`
- `.markdownlint.yaml`
- `.yamllint.yml`
- `AGENTS.md`
- `CONTRIBUTING.md`
- `scripts/generate_ruleset_payload.sh`
- `scripts/smoke_bootstrap_ruleset_payload.sh`
- `src/template_sanity.py`
- `CHANGELOG.md`
- `SECURITY.md`
- `docs/AGENTS.example.md`
- `docs/standards.md`
- `scripts/bootstrap_repo.sh`

## Quickstart

```bash
git clone git@github.com:M-Gage-Plott42/codex-github-best-practices.git
cd codex-github-best-practices
python3 -m venv .venv
source .venv/bin/activate
pip install pre-commit ruff yamllint
pre-commit install
pre-commit run --all-files
```

## Bootstrap New Repo Settings

```bash
bash scripts/bootstrap_repo.sh M-Gage-Plott42/your-repo
```

This applies settings and rulesets with admin bypass so required checks protect PRs without blocking owner/admin direct pushes when needed.

For CodeQL, this template uses the advanced workflow in `.github/workflows/codeql.yml`, and bootstrap disables GitHub's CodeQL default setup to prevent SARIF upload conflicts.

If a legacy dynamic CodeQL workflow entry remains listed in Actions metadata, bootstrap attempts cleanup and prints a manual UI fallback if the GitHub API refuses the disable operation.

CodeQL required-check rollout is intentionally two-phase. After one confirmed green CodeQL run, enforce CodeQL checks in branch rulesets with:

```bash
REQUIRE_CODEQL_CHECKS=1 bash scripts/bootstrap_repo.sh M-Gage-Plott42/your-repo
```

Ruleset payload smoke test:

```bash
bash scripts/smoke_bootstrap_ruleset_payload.sh
```

## AGENTS.md Pattern

- `AGENTS.md` is the live operational contract for this template repository.
- `docs/AGENTS.example.md` is a reusable starting template for downstream repositories.
