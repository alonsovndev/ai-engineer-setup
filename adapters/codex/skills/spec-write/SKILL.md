---
name: spec-write
description: "Write the refined requirement from this conversation into a phased implementation plan under `specs/` in the current project's repo root."
---

Use this skill when the user invokes `$spec-write` or asks for this workflow. Apply any scope, options, and details supplied with the invocation.

Write the refined requirement from this conversation into a phased implementation plan under `specs/` in the current project's repo root.

Use the `spec-planning` skill.

If no refined requirement exists yet in this conversation, run the `$spec-clarify` clarification first using any text in the invocation details as the raw idea. Ensure `specs/` exists with a `specs/.gitignore` that ignores its contents but keeps itself tracked (`*` then `!.gitignore`) — create both if missing. Write the plan to `specs/<YYYY-MM-DD>-<slug>.md` following the spec-planning skill's template: refined requirement plus phased implementation details (task, context, constraints, inputs, expected output, done criteria, suggested owner) per phase, and delegation notes referencing `orchestration/router.md` and `orchestration/handoff-contract.md` when present. Do not overwrite an existing spec file with the same name without asking. Report the file path and remind the user that `specs/` is local-only and not committed.
