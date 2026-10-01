---
description: "Prepare or create a pull request from a feature branch into dev using the GitHub workflow"
name: "Create PR"
argument-hint: "Title, issue links, and whether push/create is approved"
agent: "agent"
---

Use the `git-create-pr`, `gh-prs`, and `git-repo-flow` skills to prepare a pull request.

Requirements:

- Run read-only preflight first: status, branch, remotes, log, diff stat.
- Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`.
- Target `dev` for `feature/*` branches.
- Require explicit approval before pushing, creating, editing, commenting, or calling GitHub APIs.
- Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch) — never push on `main`, `master`, `dev`, or a detached HEAD; if the current branch is protected, stop and hand the push command to the user.
- If `gh` is unavailable, provide a compare URL plus PR title/body.

Arguments: $ARGUMENTS
