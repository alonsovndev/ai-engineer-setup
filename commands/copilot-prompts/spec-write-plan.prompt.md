---
description: "Write the refined requirement into a phased implementation plan under specs/"
name: "Spec Write Plan"
argument-hint: "Optional raw idea if not already refined in this conversation"
agent: "tech-lead"
---
Use the `spec-planning` skill to write a phased implementation plan.

Arguments: $ARGUMENTS

If no refined requirement exists yet in this conversation, run the refinement questions first using $ARGUMENTS as the raw idea. Ensure `specs/` exists with a `specs/.gitignore` (`*` then `!.gitignore`) so the folder is tracked but its contents stay local-only. Write the plan to `specs/<YYYY-MM-DD>-<slug>.md` with the refined requirement, phased implementation details (task, context, constraints, inputs, expected output, done criteria, suggested owner per phase), and delegation notes. Do not overwrite an existing file with the same name without asking. Report the file path.
