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

## Dependency and Security Defaults

- Dependabot version updates enabled for GitHub Actions and Python (`pip`).
- Dependabot security updates enabled.
- Private vulnerability reporting enabled.
- CodeQL enabled for Python and GitHub Actions.

## CI and Quality Defaults

- Python lint (`ruff`).
- Markdown lint (`markdownlint-cli2`).
- YAML lint (`yamllint`).
- Pre-commit hooks to mirror CI checks locally.

## Release and Audit Defaults

- Semantic version tags and release notes.
- Changelog maintained in-repo.
- Security policy maintained in-repo.
