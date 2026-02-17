# Standards Baseline

This template consolidates maintainership patterns proven in the following repositories:

- `M-Gage-Plott42/qiskit-v2-guide`
- `M-Gage-Plott42/QUBO_QA`
- `M-Gage-Plott42/utc-hpc-guide`
- `M-Gage-Plott42/Dissertation_Template`

## Governance Defaults

- Required CI checks with branch rulesets.
- Admin bypass enabled in rulesets so required checks protect contributors without blocking owner/admin emergency pushes.
- Wiki and Projects disabled unless intentionally used.
- Auto-merge enabled for approved update classes.
- Automatic branch deletion on merge enabled.
- `CODEOWNERS` for ownership enforcement on critical paths.
- `CONTRIBUTING.md` for predictable contribution expectations.

## Dependency and Security Defaults

- Dependabot version updates enabled for GitHub Actions and Python (`pip`).
- Dependabot security updates enabled.
- Private vulnerability reporting enabled.
- CodeQL advanced workflow enabled for Python and GitHub Actions.
- CodeQL default setup disabled when advanced workflow is present.
- CodeQL checks move to required status checks only after one confirmed green run.

## CI and Quality Defaults

- Python lint (`ruff`).
- Markdown lint (`markdownlint-cli2`).
- YAML lint (`yamllint`).
- GitHub Actions lint (`actionlint`).
- Shell script lint (`shellcheck`).
- Pre-commit hooks to mirror CI checks locally.
- `AGENTS.md` operational guidance for repository-local agent behavior.
- `docs/AGENTS.example.md` as a copy/adapt baseline for downstream repos.
- Bootstrap ruleset payload generation covered by a dedicated smoke script.

## Harness Engineering Standards

### Legibility

- Documentation should be optimized for agent execution, not only human narrative.
- Critical operational rules should be explicit, terse, and colocated with the repo.
- The current source of truth for agent behavior is `AGENTS.md`.

### Entropy Control

- Any change to `.github/workflows/*`, `scripts/bootstrap_repo.sh`, or security posture
  must include synchronized updates to docs and changelog in the same patch.
- Conflicting docs should be treated as defects and fixed immediately.
- Policy changes should include both intent and enforcement mechanism.

### Execution Planning

- Non-trivial changes should begin with an explicit execution plan.
- Use `docs/execution-plan-template.md` for common structure and handoff format.
- Plans should list assumptions, validation steps, and rollback path.

### Steering Loop And Adaptation

- Long-running or uncertain work should expose checkpoints where scope can be adjusted.
- Unknowns and blockers should be surfaced early, with explicit fallback options.
- Standards should be revised as tools and model behavior evolve.

## Release and Audit Defaults

- Semantic version tags and release notes.
- Changelog maintained in-repo.
- Security policy maintained in-repo.
