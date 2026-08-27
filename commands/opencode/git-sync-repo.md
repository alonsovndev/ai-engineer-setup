---
description: Inspect and synchronize a fork-based or direct repository safely.
agent: build
---

Use the `git-repo-flow` skill to inspect repository topology and recommend the safest sync option.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, branch, remotes, recent log.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Explain and recommend the appropriate sync command for the situation:
  - Fork mode, preserving local commits: `git sync`.
  - Fork mode, disposable local copy of a shared branch: `git resync`.
  - Direct mode, preserving local commits: `git fetch origin && git merge origin/$(git branch --show-current)`.
  - Direct mode, fast-forward only (shared branches): `git fetch origin && git pull --ff-only origin $(git branch --show-current)`.
- Require explicit approval before any sync operation.
- Treat `git resync`, hard reset, and force push as destructive — `git resync` performs `reset --hard` and `push --force-with-lease`.
- Never hard-reset or force-push a branch that contains unmerged or unpushed local work.
- Never run sync operations on a dirty worktree.
