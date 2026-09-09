---
name: doc-tracker
description: "Use when documentation may have drifted from code: comparing docs/README against current behavior, flagging stale or missing content, and drafting targeted updates. Not for first-draft authoring of new documentation (use technical-writer) or changelog/release-notes generation. Keywords: doc drift, stale docs, documentation sync, docs update, keep docs current, doc maintenance."
argument-hint: "Provide the doc location(s) to check, the code scope or change range to compare against, and whether applying edits is approved."
user-invocable: true
---

# Doc Tracker Skill

Find where a project's documentation has drifted from its current code and correct it.

## Use This Skill For

- Comparing a project's docs (`docs/`, README, or other declared doc locations) against current code behavior.
- Flagging stale claims, missing coverage, and broken references after code changes.
- Drafting targeted corrections to existing documentation.

## Do Not Use This Skill For

- First-draft authoring of new documentation with no drift signal — use `technical-writer`.
- Changelog or release-notes generation — not covered by this skill.
- Subjective prose-quality rewrites unrelated to drift — use `technical-writer` or `markdown-author`.

## Drift Workflow

1. Confirm scope: which doc location(s) to check (default: detect `docs/`, then README; ask if ambiguous) and what code scope or change range to compare against (a base ref, a feature area, or "everything" for a full pass).
2. Read the current code/behavior for that scope.
3. Read the current doc content for the same scope.
4. Diff documented claims against actual behavior.

## Drift Categories

- Stale claims: docs describing removed/renamed functionality, old APIs, old CLI flags, old config keys, old file paths.
- Missing coverage: new public behavior (endpoints, commands, env vars, exported functions) with no doc mention, when the project's own convention documents that category of change.
- Broken references: links or paths to files/sections that no longer exist.

Do not flag subjective prose-quality issues — defer those to `technical-writer`/`markdown-author`. Do not invent a documentation requirement the project's own convention doesn't already follow.

## Update Workflow

1. Report drift findings first, each as: doc file, stale/missing claim, current actual behavior, severity.
2. Draft the corrected text using `technical-writer` conventions (accuracy, clarity, structure) and `markdown-author` formatting rules.
3. Apply edits only after explicit approval.
4. Never commit or push — hand off to `git-commit`/`git-create-pr` if the user wants that.

Never invent facts (owners, SLAs, dates, URLs, infra decisions) — mark unknowns as `TBD`, same rule as `technical-writer`.

## Output Format

```markdown
## Drift Found

- **broken** `docs/path.md` - {stale claim}. Current behavior: {what's actually true}. Proposed fix: {corrected text or summary of the edit}.

## Checked

- {doc locations and code scope actually compared}

## Left Unchanged

- {doc content reviewed and found accurate, or ambiguous cases needing the user's input}
```

## Final Response

When complete, report:

- Docs checked and code scope compared against.
- Drift found, by severity.
- Updates applied vs. proposed (and why anything was left unchanged).
