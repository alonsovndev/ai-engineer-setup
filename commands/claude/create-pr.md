---
description: "Prepare or create a pull request from a feature branch into `dev` using the GitHub Enterprise workflow."
argument-hint: "Title, issue links, and whether push/create is approved"
---

Prepare or create a pull request from a feature branch into `dev` using the GitHub Enterprise workflow.

Use the `git-create-pr`, `gh-prs`, and `git-repo-flow` skills.

Arguments: $ARGUMENTS

Run read-only preflight first. Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`. Target `dev` for `feature/*` branches. Require explicit approval before push, PR creation, PR edits, comments, or GitHub API calls.
