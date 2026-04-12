# Operational Patterns (Optional, High ROI)

These patterns are optional for template adopters, but they reduce friction in
single-maintainer and AI-assisted repos.

## 1) One-command quick gate

Use a single command before push:

```bash
bash scripts/run_repo_quick_gate.sh
```

This runs:

- ruleset payload smoke (`scripts/smoke_bootstrap_ruleset_payload.sh`)
- local pre-commit parity if `pre-commit` is available

Optional boundary audit:

```bash
bash scripts/run_repo_quick_gate.sh --with-boundaries --strict-boundaries
```

## 2) Event-triggered setup (not every thread)

Recommended trigger matrix:

- Run bootstrap (`python3 -m venv`, dependency install, hooks) only when:
  - new machine / fresh clone,
  - `.venv` recreated, or
  - dependency/hook config changed.
- Run quick gate:
  - once per active work session,
  - after pulling policy/ops/workflow changes,
  - before major pushes.

## 3) Machine-readable host profiles

Use a profile JSON to standardize per-host defaults (for example jobs/backend):

- `docs/policies/host_profiles.example.json`

Set profile at shell level (if your repo supports this pattern):

```bash
export HOST_PROFILE=laptop
```

## 4) Manifest-first run provenance + index integrity

For experiment-heavy repos, use:

- per-run `manifest.json` (command, commit, env, outputs)
- central `run_index.csv` keyed by run tag / manifest path
- integrity check between manifests and index before reports

Example manifest:

- `docs/policies/run_manifest.example.json`

## 5) Storage boundary audits

For repos with large local artifacts, declare boundaries:

- `docs/policies/storage_boundaries.example.json`

Validate boundaries:

```bash
python3 scripts/check_storage_boundaries.py --config docs/policies/storage_boundaries.example.json --strict
```

## 6) Active-doc contraction + ADR memory

Keep active docs short and move historical details to archive/ADRs.

Suggested baseline:

- active focus doc: `docs/active/current_focus.example.md`
- decision memory: `docs/adr/README.md`

This keeps agent context small while preserving rationale history.

## 7) Reusable workflows for multi-repo estates

If several repositories repeat the same lint or policy workflows, extract the
common job graph into a reusable workflow and call it with `workflow_call`.

Guidance:

- keep required-check job names stable while migrating, so rulesets and branch
  protections do not lose their expected status contexts;
- prefer local reusable workflow references (`./.github/workflows/...`) when the
  caller and callee live in the same repository;
- if calling a reusable workflow from another repository, pin the reference to a
  full commit SHA instead of a moving branch or tag;
- separate the extraction/refactor from policy changes such as new required
  checks or new security gates, so rollback remains obvious.
