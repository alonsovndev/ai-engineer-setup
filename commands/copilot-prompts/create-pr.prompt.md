---
description: "Prepare or create a pull request from a feature branch into dev using the GitHub workflow"
name: "Create PR"
argument-hint: "Optional title, issue links, and PR details"
agent: "agent"
---

Use the `git-create-pr`, `gh-prs`, and `git-repo-flow` skills to prepare a pull request.

Requirements:

- Run read-only preflight first: status, branch, remotes, log, diff stat.
- Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`.
- Target `dev` for `feature/*` branches.
- The invocation pre-approves committing, pushing, and PR creation — do not ask for approval again inside this flow.
- Commit the current changes first: split them into logical Conventional Commits per the `git-commit` skill, split silently, and stop to ask only if changes cannot be grouped confidently or secrets are detected — never stage secrets.
- Refuse to start on `main`, `master`, `dev`, or a detached HEAD; tell the user to run start-feature first.
- Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch) — never push a protected branch.
- Still gated: force-push, PR edits, comments, and merges require explicit approval.
- Report the result: PR created or not (never claim success unless the command succeeded), PR URL, number, title, base ← head, commit subjects, a short change summary, and verification status.
- If `gh` is unavailable, provide a compare URL plus PR title/body.

Arguments: $ARGUMENTS
