---
name: sync-dev
description: "Sync `dev` from `main` after a promote-release pull request has merged."
---

Use this skill when the user invokes `$sync-dev` or asks for this workflow. Apply any scope, options, and details supplied with the invocation.

Sync `dev` from `main` after a promote-release pull request has merged.

Use the `git-repo-flow` skill.

Run read-only preflight first. Detect whether the repository uses fork mode (`origin` + `upstream`) or direct mode (`origin` only). Fetch the remote that owns `main` (`upstream` in fork mode, `origin` in direct mode) and check whether `dev` is already an ancestor of `<remote>/main` with `git merge-base --is-ancestor dev <remote>/main`. If it is, the release PR merged as a real merge commit and `dev` can fast-forward — run `git checkout dev && git merge --ff-only <remote>/main`. If it is not, the release PR was squashed or rebased and `dev` cannot fast-forward — create a named working branch from `<remote>/dev`, merge `<remote>/main` there, and open a PR into `dev`; never create the merge commit on `dev` or rebase `dev`. Push only after explicit approval, and require approval for PR creation. Push fast-forwarded `dev` to `origin` only after explicit approval. Never force-push or hard-reset `dev`. If the working tree is dirty, stop before syncing.
