---
description: "Create a conventional git commit from current changes."
argument-hint: "Optional type, scope, description, and files to include"
---

Create a conventional git commit from current changes.

Use the `git-commit` skill.

Arguments: $ARGUMENTS

Run read-only preflight first: status, staged diff, unstaged diff, and recent log. Refuse to commit if the current branch is `main`, `master`, or `dev` — tell the user to create a feature/hotfix branch first (`/start-feature`). Stage only intended files; never stage secrets or unrelated changes. Generate or validate a Conventional Commit message. Do not add AI/tool co-author trailers or signatures (e.g., `Co-authored-by: ...`). Require explicit user approval before committing if the intended files or message are ambiguous. Do not amend, skip hooks, push, or update git config.
