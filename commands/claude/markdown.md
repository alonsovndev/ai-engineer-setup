Write, improve, or review Markdown documentation using the `markdown-author` skill as the canonical formatting standard.

## How To Use This Command

- `/markdown` - ask the user what document to create, improve, or review.
- `/markdown --new adr` - create a new Architecture Decision Record.
- `/markdown --new runbook` - create a new operational runbook.
- `/markdown --new spec` - create a feature or integration specification.
- `/markdown --new readme` - create a README for a service or folder.
- `/markdown --improve {file}` - refactor an existing Markdown file for clarity, structure, links, and formatting.
- `/markdown --review {file}` - review and flag Markdown issues without changing the file.

## Required Skill

Use the `markdown-author` skill before writing, editing, or reviewing Markdown. Treat that skill as the source of truth for:

- Heading hierarchy and spacing.
- Inline code and fenced code block formatting.
- Links, anchors, and internal references.
- Lists, tables, and duplicate references.
- Trailing spaces, blank lines, and final newline checks.

## Document Templates

### ADR

````markdown
# ADR-{number}: {Decision title}

**Status**: Proposed | Accepted | Deprecated | Superseded by ADR-{number}
**Date**: YYYY-MM-DD
**Deciders**: {names or roles}

## Context

{What situation prompted this decision? What constraints apply?}

## Decision

{What was decided? State it clearly and directly.}

## Consequences

**Good**: {positive outcomes}
**Bad**: {trade-offs or risks accepted}

## Alternatives Considered

| Alternative | Reason rejected |
|---|---|
| {option} | {reason} |
````

### Runbook

````markdown
# Runbook: {Procedure name}

**Trigger**: {When to use this runbook}
**Time to resolve**: ~{number} minutes
**On-call severity**: P1 | P2 | P3

## Prerequisites

- Access to {system}.
- `{tool}` installed.

## Steps

1. {First step with exact command when applicable}.

   ```bash
   command here
   ```

2. {Next step}.

## Verification

{How to confirm success.}

## Rollback

{Steps to undo the change, if applicable.}

## Escalation

{Who to contact if this runbook does not resolve the issue.}
````

### README

````markdown
# {Service or folder name}

{One-sentence description of what this is.}

## What This Does

{Two or three sentences on responsibility and scope. What problem does it solve?}

## How To Run Locally

```bash
command here
```

## Configuration

| Variable | Default | Description |
|---|---|---|
| `ENV_VAR` | `value` | What it controls. |

## Related

- [Architecture docs]({path}) - system architecture.
- [{Related service}]({path}) - related service or document.
````

### Feature Or Integration Spec

````markdown
# Spec: {Feature or integration name}

**Status**: Draft | Review | Approved
**Author**: {name or role}

## Goal

{One sentence: what this feature or integration achieves and why it is needed.}

## Scope

**In scope**: {what this spec covers}
**Out of scope**: {what this spec explicitly does not cover}

## Design

{System diagram or description of the approach.}

## Data Contract

{Request and response shapes, field definitions, or schema changes.}

## Error Handling

| Scenario | Behavior |
|---|---|
| {failure case} | {expected behavior}. |

## Testing

{How to verify this works end to end.}
````

## Save Location

Check the project's `AGENTS.md`, `CLAUDE.md`, or docs README for the canonical folder structure. When in doubt, ask the user where to save before writing.

## After Generating

State:

1. File saved and path.
2. Document type and template used.
3. Formatting checks completed, including links and internal references.
4. Any sections left as `{placeholder}` or `TBD` that the user needs to fill in.
