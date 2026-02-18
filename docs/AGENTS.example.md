# AGENTS.md (Example Template)

Use this file as a starting point for repositories that want explicit
AI-agent collaboration rules.

## Purpose

State what this repository optimizes for and what "good changes" look like.

Example:
"This repo prioritizes secure, maintainable automation for data pipelines."

## Technical Scope

- Primary languages: `<language list>`
- Critical paths: `<key directories/services>`
- Non-goals: `<what should not be changed casually>`

## Workflow Expectations

- Start by reading: `<docs to read first>`
- Keep docs and automation in sync.
- Prefer minimal diffs with clear intent.
- Avoid speculative refactors unless explicitly requested.

## Setup Triggers (Recommended)

- Do not bootstrap on every thread.
- Bootstrap when:
  - new machine/fresh clone,
  - environment was rebuilt, or
  - dependency/hook config changed.
- Use one quick local gate before major pushes.

## Quality Gates

- Local checks to run:
  - `<lint command 1>`
  - `<test command 2>`
  - `<typecheck command 3>`
- CI must stay green on pull requests.

## Security And CI Rules

- Keep GitHub Actions pinned to immutable versions.
- Use least-privilege `permissions` blocks in workflows.
- Document secrets usage and avoid adding new secrets without justification.

## Handoff Requirements

- Summarize what changed and why.
- Call out any skipped validations.
- Provide next steps if follow-up actions are required outside the repo.

## Optional Scale Patterns

- Machine-readable host profiles for default jobs/backend.
- Manifest-first run provenance and index integrity checks.
- Storage boundary audits for local-only artifact directories.
- Active focus doc + ADR folder for low-entropy context.
