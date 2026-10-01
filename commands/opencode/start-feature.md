---
description: Start a feature or hotfix branch using the standard GitHub workflow.
agent: build
---

Usage: Branch name, ticket, and optional target base.

Use the `git-repo-flow` skill to prepare a new branch, and the `git-commit` skill for commits made on it.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, current branch, remotes, recent log.
- Stop and ask before syncing or branching if the working tree is dirty.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Always branch from an up-to-date base, never from whatever is currently checked out:
  - `feature/*` branches from `dev`. Fork mode: `git feature feature/<ticket>-<short-desc>` (checks out `dev`, runs `git resync` to align with `upstream/dev`, then branches) — never run `git feature` or `git resync` yourself; they hard-reset and force-push `dev`. Ask the user to run `git feature`, or use the non-pushing equivalent: `git fetch upstream && git checkout dev && git merge --ff-only upstream/dev && git checkout -b feature/<ticket>-<short-desc>`. Direct mode: `git fetch origin && git checkout dev && git pull --ff-only origin dev && git checkout -b feature/<ticket>-<short-desc>`.
  - `hotfix/*` branches from `main`, since hotfix PRs target `main`. Fetch and fast-forward `main` first, then branch.
- Naming: `feature/<ticket>-<short-desc>` for normal work, `hotfix/<ticket>-<short-desc>` for urgent production fixes; `<short-desc>` is kebab-case. If no ticket exists, drop that segment and use a plain kebab-case description after the branch type.
- Never run `git feature`, `git resync`, or `reset --hard` yourself — `git resync` performs `reset --hard` and `push --force-with-lease` on `dev`. Push only from the new named working branch, and only when the user explicitly asks.
- After the branch is created, remind the user that commits on it must follow Conventional Commits (`type(scope): description`) per the `git-commit` skill — use `/commit` when ready.
- Report the created branch, its base branch, and next steps.
