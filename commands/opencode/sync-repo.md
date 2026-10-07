---
description: Inspect and synchronize a fork-based or direct repository safely.
agent: build
---

Usage: Optional branch, topology, or sync goal.

Use the `git-repo-flow` skill to inspect repository topology and recommend the safest sync option.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, branch, remotes, recent log.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Explain and recommend the appropriate sync command for the situation:
  - Fork mode, preserving local commits on a working branch: `git sync`.
  - Fork mode, disposable local copy of a shared branch: `git resync` — user-run only.
  - Direct mode, preserving local commits on a working branch: `git fetch origin && git merge origin/$(git branch --show-current)`.
  - Normal sync of protected branches (`main`, `master`, `dev`): fetch, then `git merge --ff-only <remote>/<branch>`; stop if fast-forward is impossible. Never run `git sync` or a merge that creates a commit on these branches, and never run `git sync` or `git resync` while on a protected branch — both aliases push the current branch. If a protected branch needs a push, give the user the exact command to run.
- Require explicit approval before any sync operation.
- Treat `git resync`, hard reset, and force push as destructive — `git resync` performs `reset --hard` and `push --force-with-lease` and is user-run only.
- Never hard-reset or force-push a branch that contains unmerged or unpushed local work.
- Never run sync operations on a dirty worktree.
