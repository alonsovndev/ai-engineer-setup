---
name: update-docs
description: "Compare a project's documentation against current code, flag drift, and draft or apply targeted updates."
---

Use this skill when the user invokes `$update-docs` or asks for this workflow. Apply any scope, options, and details supplied with the invocation.

Compare a project's documentation against current code, flag drift, and draft or apply targeted updates.

Use the `doc-tracker` skill and agent, delegating prose/formatting to `technical-writer` and `markdown-author`.

## How To Use This Command

- `$update-docs` — check the default doc location(s) (`docs/`, then README) against the whole codebase.
- `$update-docs <path>` — check a specific doc file or code scope.
- `$update-docs --apply` — after reporting drift, apply the approved fixes rather than only proposing them.

## Scope

Drift detection and targeted correction only: stale claims, missing coverage for new public behavior the project already documents, and broken references. Not for first-draft authoring of new documentation with no drift signal (use `technical-writer`) or changelog/release-notes generation (not covered).

Never invent facts (owners, SLAs, dates, URLs, infra decisions) — mark unknowns as `TBD`. Never commit or push.

