---
description: Create a conventional git commit from current changes.
agent: build
---

Usage: Optional type, scope, description, and files to include.

Use the `git-commit` skill to create a conventional commit.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only preflight first: status, staged diff, unstaged diff, and recent log.
- Refuse to commit if the current branch is `main`, `master`, or `dev` — tell the user to create a feature/hotfix branch first (`/start-feature`).
- Stage only intended files; never stage secrets or unrelated changes.
- Generate or validate a Conventional Commit message.
- Require explicit user approval before committing if the intended files or message are ambiguous.
- Do not amend, skip hooks, push, or update git config.
