---
description: "Sync dev from main after a promote-release pull request has merged"
name: "Sync Dev"
argument-hint: "Optional confirmation that the promote-release PR merged and whether push is approved"
agent: "agent"
---
Use the `git-repo-flow` skill to sync dev from main.

Requirements:
- Run read-only preflight first.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Fetch the remote that owns `main`: `upstream` in fork mode, `origin` in direct mode.
- Check fast-forward eligibility with `git merge-base --is-ancestor dev <remote>/main`.
  - If it succeeds, fast-forward: `git checkout dev && git merge --ff-only <remote>/main`.
  - If it fails, merge instead of rebasing: `git merge --no-ff <remote>/main -m "Merge main into dev after release"`.
- Push the updated `dev` to `origin` only after explicit approval.
- Never force-push or hard-reset `dev`.
- Never run this on a dirty worktree.

Arguments: $ARGUMENTS
