---
description: "Prepare or create a pull request using the GitHub Enterprise workflow"
name: "Git Create PR"
argument-hint: "Base branch, title, issue links, and whether push/create is approved"
agent: "agent"
---
Use the `create-pr`, `gh-prs`, and `git-repo-flow` skills to prepare a pull request.

Requirements:
- Run read-only preflight first: status, branch, remotes, log, diff stat.
- Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`.
- Default `feature/*` PRs to `dev`; default `hotfix/*` and release PRs to `main`.
- Require explicit approval before pushing, creating, editing, commenting, or calling GitHub APIs.
- If `gh` is unavailable, provide a compare URL plus PR title/body.

Arguments: $ARGUMENTS
