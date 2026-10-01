---
description: Sync dev from main after a promote-release pull request has merged.
agent: build
---

Usage: Optional confirmation that the promote-release PR merged and whether push is approved.

Use the `git-repo-flow` skill to sync dev from main.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, branch, remotes, recent log.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Fetch the remote that owns `main`: `upstream` in fork mode, `origin` in direct mode.
- Check fast-forward eligibility with `git merge-base --is-ancestor dev <remote>/main`.
  - If it succeeds, fast-forward: `git checkout dev && git merge --ff-only <remote>/main`.
  - If it fails, create a named working branch from `<remote>/dev`, merge `<remote>/main` there, and open a PR into `dev`. Never create a merge commit on `dev` or rebase it.
- Never push `dev` yourself — not even with explicit approval; after the local fast-forward, give the user the exact command to run (`git push origin dev`).
- Push a working branch only after explicit approval; require approval for PR creation.
- Never force-push or hard-reset `dev`.
- Never run this on a dirty worktree.
