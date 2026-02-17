# AGENTS.md

## Purpose

This repository is a reusable template for Codex + GitHub governance defaults.
Prefer changes that improve downstream reliability, security, and clarity.

## Repository Priorities

1. Keep CI workflows stable and easy to copy into new repositories.
2. Keep security defaults explicit (Dependabot, CodeQL, vulnerability reporting).
3. Keep bootstrap automation idempotent and aligned with documented behavior.
4. Keep docs concise and synchronized with automation.

## Operating Rules For Agent Edits

- Read `README.md`, `docs/standards.md`, and `.github/workflows/*` before editing.
- When workflow behavior changes, update `README.md` and `CHANGELOG.md` in the same patch.
- Prefer minimal, auditable diffs over broad refactors.
- Use pinned GitHub Actions versions in workflows.

## Context Map

- CI/workflow changes:
  Start with `.github/workflows/*`, then `README.md`, then `docs/standards.md`.
- Governance and automation changes:
  Start with `scripts/bootstrap_repo.sh`, then `CONTRIBUTING.md`, then `docs/standards.md`.
- Agent policy changes:
  Start with `AGENTS.md`, then `docs/AGENTS.example.md`, then `README.md`.

## Planning And Steering

- For non-trivial tasks, create an execution plan before edits.
- Use `docs/execution-plan-template.md` for plan structure.
- Surface assumptions and unknowns early; do not hide them in final summaries.
- If scope changes mid-task, update the plan and call out the decision explicitly.

## Unknowns And Escalation

- If behavior is ambiguous or blocked by external settings, report exact blocker and
  provide both CLI and manual UI fallback paths.
- If docs conflict with code, treat code as current truth and include doc-sync updates
  in the same change set.
- Do not proceed with destructive operations without explicit user direction.

## CodeQL Policy

- This template uses **advanced** CodeQL setup via `.github/workflows/codeql.yml`.
- Do not configure GitHub CodeQL default setup in bootstrap for this template.
- For interpreted languages in template repos, default to `build-mode: none` unless a
  concrete build step is required.

## Validation Expectations

- Run file-relevant checks locally before finishing:
  - `ruff check .`
  - `yamllint -c .yamllint.yml .`
  - `markdownlint-cli2 "**/*.md"`
  - `actionlint`
  - `shellcheck scripts/bootstrap_repo.sh`
- If a check is unavailable locally, state that explicitly in the handoff.
