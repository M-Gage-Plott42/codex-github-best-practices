# Changelog

All notable changes to this repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added repository-level `AGENTS.md` for live Codex collaboration rules.
- Added `docs/AGENTS.example.md` as a downstream template.
- Added Actions lint workflow (`actionlint`).
- Added shell lint workflow (`shellcheck`).
- Added `CONTRIBUTING.md` and `.github/CODEOWNERS`.

### Changed

- Updated CodeQL workflow to use explicit `build-mode: none` for Python and
  GitHub Actions in advanced setup.
- Updated bootstrap automation to disable CodeQL default setup when applying
  this template, preventing advanced/default setup conflicts.
- Updated bootstrap ruleset payload to require `actionlint` and `shellcheck`.
- Added optional CodeQL-required-check rollout via
  `REQUIRE_CODEQL_CHECKS=1` after first green CodeQL run.
- Updated README and standards docs to document AGENTS pattern and CodeQL mode.

## [0.1.0] - 2026-02-16

### Added

- Initial template baseline for Codex + GitHub best practices.
- CI workflows for Python, Markdown, YAML, and CodeQL scanning.
- Dependabot updates and Actions-only Dependabot auto-merge workflow.
- Pre-commit configuration for local lint parity.
- Security policy, standards guide, and bootstrap automation script.
