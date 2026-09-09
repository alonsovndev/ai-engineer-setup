---
description: "Compare a project's documentation against current code, flag drift, and draft or apply targeted updates"
name: "Update Docs"
argument-hint: "Doc location(s) to check, the code scope or change range to compare against, and whether applying edits is approved"
agent: "doc-tracker"
---
Use the `doc-tracker` skill and agent, delegating prose/formatting to `technical-writer` and `markdown-author`.

Requirements:
- `/update-docs` checks the default doc location(s) (`docs/`, then README) against the whole codebase; `/update-docs <path>` checks a specific doc file or code scope; `/update-docs --apply` applies approved fixes after reporting drift instead of only proposing them.
- Scope is drift detection and targeted correction only: stale claims, missing coverage for new public behavior the project already documents, and broken references.
- Not for first-draft authoring of new documentation with no drift signal (use `technical-writer`) or changelog/release-notes generation (not covered).
- Never invent facts (owners, SLAs, dates, URLs, infra decisions) — mark unknowns as `TBD`. Never commit or push.

Arguments: $ARGUMENTS
