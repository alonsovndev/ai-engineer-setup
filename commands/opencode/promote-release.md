---
description: Prepare or create the pre-release pull request promoting dev into main using the GitHub Enterprise workflow.
agent: build
---

Usage: Title, issue links, and whether push/create is approved.

Use the `git-create-pr`, `gh-prs`, and `git-repo-flow` skills to prepare a pull request.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, branch, remotes, log, diff stat.
- Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`.
- Target `main` for `dev` (and `hotfix/*`) release PRs.
- Require explicit approval before pushing, creating, editing, commenting, or calling GitHub APIs.
- If `gh` is unavailable, provide a compare URL plus PR title/body.
- After the PR merges, tell the user to run `/sync-dev` so `dev` does not show as behind `main`.
