# Changelog

All notable changes to this repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added repository-level `AGENTS.md` for live Codex collaboration rules.
- Added `docs/AGENTS.example.md` as a downstream template.
- Added `docs/execution-plan-template.md` for structured non-trivial task planning.
- Added Actions lint workflow (`actionlint`).
- Added shell lint workflow (`shellcheck`).
- Added `CONTRIBUTING.md` and `.github/CODEOWNERS`.
- Added `scripts/generate_ruleset_payload.sh` for reusable ruleset JSON generation.
- Added `scripts/smoke_bootstrap_ruleset_payload.sh` for payload smoke testing.
- Added `scripts/run_repo_quick_gate.sh` as a one-command local guardrail.
- Added `scripts/check_storage_boundaries.py` for optional storage boundary audits.
- Added optional operations pattern guidance (`docs/operations-patterns.md`).
- Added optional host profile, storage boundary, and run manifest example policies.
- Added active-focus and ADR example scaffolding (`docs/active/*`, `docs/adr/*`).

### Changed

- Updated CodeQL workflow to use explicit `build-mode: none` for Python and
  GitHub Actions in advanced setup.
- Updated bootstrap automation to disable CodeQL default setup when applying
  this template, preventing advanced/default setup conflicts.
- Updated bootstrap ruleset payload to require `actionlint` and `shellcheck`.
- Added optional CodeQL-required-check rollout via
  `REQUIRE_CODEQL_CHECKS=1` after first green CodeQL run.
- Updated bootstrap to support `RULESET_PAYLOAD_ONLY=1` for payload-only runs.
- Updated bootstrap to attempt cleanup of legacy dynamic CodeQL workflow entries
  with manual UI fallback messaging if API disable is rejected.
- Updated pre-commit hooks to include `actionlint` and `shellcheck` parity checks.
- Added a "Use This Template In 60 Seconds" section to README with a first-action
  setup path and topic guidance.
- Added harness-engineering guidance across README, AGENTS, standards, and
  contributing docs.
- Updated README and standards docs to document AGENTS pattern and CodeQL mode.
- Updated AGENTS/CONTRIBUTING guidance with setup-trigger and quick-gate usage.
- Added SSH-first git transport guidance for Codex/headless push workflows.

## [0.1.0] - 2026-02-16

### Added

- Initial template baseline for Codex + GitHub best practices.
- CI workflows for Python, Markdown, YAML, and CodeQL scanning.
- Dependabot updates and Actions-only Dependabot auto-merge workflow.
- Pre-commit configuration for local lint parity.
- Security policy, standards guide, and bootstrap automation script.
