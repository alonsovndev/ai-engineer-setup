---
description: "Bootstrap a freshly cloned repository: create dev from main if missing, and scaffold missing hygiene files."
agent: build
---

Bootstrap a freshly cloned repository: create `dev` from `main` if missing, and scaffold missing hygiene files.

Use the `git-repo-setup` and `git-repo-flow` skills.

Arguments: $ARGUMENTS

Run read-only preflight first: remotes, current branch, detected topology (fork vs direct), and which of `dev`/`main` already exist on the relevant remote. If `main` doesn't exist, stop and ask. If `dev` is missing, confirm before creating it from `main` and pushing — this writes to a shared remote even though it isn't a force-push. Scaffold `README.md`, `.gitignore`, `LICENSE`, and `CONTRIBUTING.md` only for files that don't already exist — never overwrite an existing one. Never assume a license; ask which one (or to skip) every run. Do not configure branch protection or rulesets — that is out of scope for this command; the user sets it up manually. Require explicit approval before any push. Report what was created vs. already existed, and any `TBD` items.
