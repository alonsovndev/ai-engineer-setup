---
description: "Start a feature or hotfix branch using the standard GitHub workflow"
name: "Git Start Feature"
argument-hint: "Branch name, ticket, and optional target base"
agent: "agent"
---
Use the `git-repo-flow` skill to prepare a new branch, and the `git-commit` skill for commits made on it.

Requirements:
- Run read-only preflight first: status, current branch, remotes, recent log.
- Stop and ask before syncing or branching if the working tree is dirty.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Always branch from an up-to-date base, never from whatever is currently checked out:
  - `feature/*` branches from `dev`. Fork mode: `git feature feature/<ticket>-<short-desc>` (checks out `dev`, runs `git resync` to align with `upstream/dev`, then branches). Direct mode: `git fetch origin && git checkout dev && git pull --ff-only origin dev && git checkout -b feature/<ticket>-<short-desc>`.
  - `hotfix/*` branches from `main`, since hotfix PRs target `main`. Fetch and fast-forward `main` first, then branch.
- Naming: `feature/<ticket>-<short-desc>` for normal work, `hotfix/<ticket>-<short-desc>` for urgent production fixes; `<short-desc>` is kebab-case. If no ticket exists, drop that segment and use a plain kebab-case description after the branch type.
- Require explicit approval before running `git feature`, `git resync`, `reset --hard`, or any push — `git resync` performs `reset --hard` and `push --force-with-lease`.
- After the branch is created, remind the user that commits on it must follow Conventional Commits (`type(scope): description`) per the `git-commit` skill — use `/git-commit-changes` when ready.
- Report the created branch, its base branch, and next steps.

Arguments: $ARGUMENTS
