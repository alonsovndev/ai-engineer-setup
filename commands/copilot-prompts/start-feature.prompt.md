---
description: "Start a working branch (feature, fix, chore, or hotfix) from `main` using the standard GitHub workflow"
name: "Start Feature"
argument-hint: "Branch type, short description, and optional ticket"
agent: "agent"
---
Use the `git-repo-flow` skill to prepare a new branch, and the `git-commit` skill for commits made on it.

Requirements:
- Run read-only preflight first: status, current branch, remotes, recent log.
- Stop and ask before syncing or branching if the working tree is dirty.
- Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only).
- Always branch from an up-to-date base, never from whatever is currently checked out:
  - Every working branch (`feature/*`, `fix/*`, `chore/*`, `hotfix/*`) branches from `main`, since all PRs target `main`. Fork mode: `git feature <type>/<short-desc>` (checks out `main`, runs `git resync` to align with `upstream/main`, then branches) — never run `git feature` or `git resync` yourself; they hard-reset and force-push `main`. Ask the user to run `git feature`, or use the non-pushing equivalent: `git fetch upstream && git checkout main && git merge --ff-only upstream/main && git checkout -b <type>/<short-desc>`. Direct mode: `git fetch origin && git checkout main && git pull --ff-only origin main && git checkout -b <type>/<short-desc>`.
- Naming: `<type>/<short-desc>` where `<type>` is `feature`, `fix`, `chore`, or `hotfix` (urgent production fixes) and `<short-desc>` is kebab-case. When a ticket exists, it may prefix the description: `<type>/<ticket>-<short-desc>`.
- Never run `git feature`, `git resync`, or `reset --hard` yourself — `git resync` performs `reset --hard` and `push --force-with-lease` on `main`. Push only from the new named working branch, and only when the user explicitly asks.
- After the branch is created, remind the user that commits on it must follow Conventional Commits (`type(scope): description`) per the `git-commit` skill — use `/commit` when ready.
- Report the created branch, its base branch, and next steps.

Arguments: $ARGUMENTS
