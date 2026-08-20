---
description: "Start a feature or hotfix branch using the standard GitHub workflow"
name: "Start Feature"
argument-hint: "Branch name, ticket, and optional target base"
agent: "agent"
---
Use the `git-repo-flow` skill to prepare a new branch.

Requirements:
- Run read-only preflight first: status, current branch, remotes, recent log.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Require explicit approval before `git feature`, `git resync`, `reset --hard`, or push.
- Prefer `feature/<ticket>-<short-desc>` for normal work and `hotfix/<ticket>-<short-desc>` for urgent production fixes.
- Report the branch and next steps.

Arguments: $ARGUMENTS
