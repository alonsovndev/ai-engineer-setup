---
description: "Create a conventional git commit from current changes"
name: "Commit"
argument-hint: "Optional type, scope, description, and files to include"
agent: "agent"
---
Use the `git-commit` skill to create a conventional commit.

Requirements:
- Run read-only preflight first: current branch, status, staged diff, unstaged diff, and recent log.
- Before staging, refuse to commit if the branch is `main`, `master`, `dev`, or detached (empty branch name); tell the user to create or switch to a named working branch (`/start-feature`). Any other named branch is allowed.
- Stage only intended files; never stage secrets or unrelated changes.
- Generate or validate a Conventional Commit message.
- Do not add AI/tool co-author trailers or signatures (e.g., `Co-authored-by: ...`).
- Require explicit user approval before committing if the intended files or message are ambiguous.
- Do not amend, skip hooks, push, or update git config.

Arguments: $ARGUMENTS
