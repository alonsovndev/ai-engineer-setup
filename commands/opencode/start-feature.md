---
description: Start a feature or hotfix branch using the standard GitHub workflow.
agent: build
---

Use the `git-repo-flow` skill to prepare a new branch.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, current branch, remotes, recent log.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Require explicit approval before running `git feature`, `git resync`, `reset --hard`, or any push.
- Prefer `feature/<ticket>-<short-desc>` for normal work and `hotfix/<ticket>-<short-desc>` for urgent production fixes.
- Report the created branch and next steps.
