#!/usr/bin/env python3
"""Validate local-only vs tracked storage boundaries from a JSON config."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Any


def _run_git(repo_root: Path, args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *args],
        cwd=repo_root,
        check=False,
        text=True,
        capture_output=True,
    )


def _repo_root() -> Path:
    cp = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        check=False,
        text=True,
        capture_output=True,
    )
    if cp.returncode != 0:
        raise SystemExit("Not inside a git repository.")
    return Path(cp.stdout.strip())


def _load_config(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("Config must be a JSON object.")
    return payload


def _as_list(payload: dict[str, Any], key: str) -> list[str]:
    value = payload.get(key, [])
    if not isinstance(value, list) or not all(isinstance(v, str) for v in value):
        raise ValueError(f"Config key {key!r} must be a list of strings.")
    return value


def _is_ignored(repo_root: Path, rel_path: str) -> bool:
    cp = _run_git(repo_root, ["check-ignore", "-q", rel_path])
    return cp.returncode == 0


def _tracked_entries(repo_root: Path, rel_path: str) -> list[str]:
    cp = _run_git(repo_root, ["ls-files", "--", rel_path])
    if cp.returncode != 0:
        return []
    return [line.strip() for line in cp.stdout.splitlines() if line.strip()]


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate local-only vs tracked storage boundaries."
    )
    parser.add_argument(
        "--config",
        default="docs/policies/storage_boundaries.example.json",
        help="Boundary config JSON path.",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Return non-zero exit on findings.",
    )
    args = parser.parse_args()

    repo_root = _repo_root()
    config_path = (repo_root / args.config).resolve()
    if not config_path.exists():
        raise SystemExit(f"Config not found: {config_path}")

    try:
        cfg = _load_config(config_path)
        local_only = _as_list(cfg, "local_only")
        tracked = _as_list(cfg, "tracked")
    except Exception as exc:  # pragma: no cover - command line guard
        raise SystemExit(f"Invalid config: {exc}") from exc

    findings: list[str] = []

    for rel_path in local_only:
        if not _is_ignored(repo_root, rel_path):
            findings.append(
                f"local_only path is not gitignored: {rel_path}"
            )
        tracked_matches = _tracked_entries(repo_root, rel_path)
        if tracked_matches:
            findings.append(
                f"local_only path has tracked files: {rel_path} "
                f"(example: {tracked_matches[0]})"
            )

    for rel_path in tracked:
        if _is_ignored(repo_root, rel_path):
            findings.append(f"tracked path appears gitignored: {rel_path}")

    if findings:
        print("Storage boundary findings:")
        for item in findings:
            print(f"- {item}")
        if args.strict:
            return 1
        return 0

    print("Storage boundary audit passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
