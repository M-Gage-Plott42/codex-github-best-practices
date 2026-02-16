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
