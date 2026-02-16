# codex-github-best-practices

[![License](https://img.shields.io/github/license/M-Gage-Plott42/codex-github-best-practices?label=License)](LICENSE)
[![ruff](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-python.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-python.yml)
[![markdownlint](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-markdown.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-markdown.yml)
[![yamllint](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-yaml.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/lint-yaml.yml)
[![CodeQL](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/codeql.yml/badge.svg?branch=main)](https://github.com/M-Gage-Plott42/codex-github-best-practices/actions/workflows/codeql.yml)

Opinionated template for AI-assisted development repositories using Codex + GitHub governance defaults:

- predictable CI and lint checks,
- dependency hygiene with Dependabot,
- security defaults and vulnerability reporting,
- non-blocking admin bypass for branch rulesets.

## Included Files

- `.github/dependabot.yml`
- `.github/workflows/lint-python.yml`
- `.github/workflows/lint-markdown.yml`
- `.github/workflows/lint-yaml.yml`
- `.github/workflows/codeql.yml`
- `.github/workflows/dependabot-auto-merge.yml`
- `.pre-commit-config.yaml`
- `.markdownlint.yaml`
- `.yamllint.yml`
- `src/template_sanity.py`
- `CHANGELOG.md`
- `SECURITY.md`
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
