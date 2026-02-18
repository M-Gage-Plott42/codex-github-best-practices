#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WITH_BOUNDARIES=0
BOUNDARY_CONFIG="$ROOT/docs/policies/storage_boundaries.example.json"
STRICT_BOUNDARIES=0

usage() {
  cat <<'USAGE'
Run the template's high-signal local checks in one command.

Usage:
  bash scripts/run_repo_quick_gate.sh [options]

Options:
  --with-boundaries           Run storage boundary audit.
  --boundaries-config PATH    Boundary JSON config path.
                              Default: docs/policies/storage_boundaries.example.json
  --strict-boundaries         Fail on boundary findings (default: warn-only).
  -h, --help                  Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-boundaries)
      WITH_BOUNDARIES=1
      shift
      ;;
    --boundaries-config)
      BOUNDARY_CONFIG="${2:?missing value for --boundaries-config}"
      shift 2
      ;;
    --strict-boundaries)
      STRICT_BOUNDARIES=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[ERROR] Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

echo "[quick-gate] ruleset payload smoke"
bash "$ROOT/scripts/smoke_bootstrap_ruleset_payload.sh"

echo "[quick-gate] pre-commit parity"
PRE_COMMIT_CMD=""
if command -v pre-commit >/dev/null 2>&1; then
  PRE_COMMIT_CMD="pre-commit"
elif [[ -x "$ROOT/.venv/bin/pre-commit" ]]; then
  PRE_COMMIT_CMD="$ROOT/.venv/bin/pre-commit"
fi

if [[ -n "$PRE_COMMIT_CMD" ]]; then
  "$PRE_COMMIT_CMD" run --all-files
else
  echo "[warn] pre-commit not found; skipping local pre-commit parity check."
fi

if [[ "$WITH_BOUNDARIES" -eq 1 ]]; then
  echo "[quick-gate] storage boundary audit"
  BOUNDARY_ARGS=(--config "$BOUNDARY_CONFIG")
  if [[ "$STRICT_BOUNDARIES" -eq 1 ]]; then
    BOUNDARY_ARGS+=(--strict)
  fi
  python3 "$ROOT/scripts/check_storage_boundaries.py" "${BOUNDARY_ARGS[@]}"
fi

echo "[quick-gate] OK"
