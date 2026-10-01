---
description: "Prepare or create the pre-release pull request promoting `dev` into `main` using the GitHub workflow."
argument-hint: "Title, issue links, and whether push/create is approved"
---

Prepare or create the pre-release pull request promoting `dev` into `main` using the GitHub workflow.

Use the `git-create-pr`, `gh-prs`, and `git-repo-flow` skills.

Arguments: $ARGUMENTS

Run read-only preflight first. Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`. Target `main` for `dev` (and `hotfix/*`) release PRs. Require explicit approval before push, PR creation, PR edits, comments, or GitHub API calls. Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch) — never push on `main`, `master`, `dev`, or a detached HEAD; if the release flow needs a protected-branch push (for example `dev` has unpushed commits), give the user the exact command to run. After the PR merges, tell the user to run `/sync-dev` so `dev` does not show as behind `main`.
