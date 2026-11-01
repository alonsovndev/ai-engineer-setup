---
description: "Bootstrap a freshly cloned repository: scaffold missing hygiene files."
agent: build
---

Usage: Repo path, license choice or skip.

Bootstrap a freshly cloned repository: scaffold missing hygiene files.

Use the `git-repo-setup` and `git-repo-flow` skills.

Arguments: $ARGUMENTS

Run read-only preflight first: remotes, current branch, detected topology (fork vs direct), and whether `main` exists on the relevant remote. If `main` doesn't exist, stop and ask. Scaffold `README.md`, `.gitignore`, `LICENSE`, and `CONTRIBUTING.md` only for files that don't already exist — never overwrite an existing one. Never assume a license; ask which one (or to skip) every run. Do not configure branch protection or rulesets — that is out of scope for this command; the user sets it up manually. Never push a protected branch yourself; any needed push is handed to the user as the exact command to run. Report what was created vs. already existed, and any `TBD` items.
