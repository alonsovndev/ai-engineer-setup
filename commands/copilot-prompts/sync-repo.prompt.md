---
description: "Inspect and synchronize a fork-based or direct repository safely"
name: "Sync Repo"
argument-hint: "Optional branch, topology, or sync goal"
agent: "agent"
---
Use the `git-repo-flow` skill to inspect repository topology and sync state.

Requirements:
- Run read-only preflight first.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Explain whether `git sync`, `git resync`, merge, pull, or fast-forward-only pull is appropriate.
- Require explicit approval before any sync operation.
- Treat `git resync`, hard reset, and force push as destructive.
- Never run sync operations on a dirty worktree.

Arguments: $ARGUMENTS
