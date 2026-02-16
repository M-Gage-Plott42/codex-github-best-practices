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

## Release and Audit Defaults

- Semantic version tags and release notes.
- Changelog maintained in-repo.
- Security policy maintained in-repo.
