---
description: "Bootstrap a freshly cloned repository: create dev from main if missing, and scaffold missing hygiene files"
name: "Setup Repo"
argument-hint: "Repo path, license choice or skip, whether branch changes are approved"
agent: "agent"
---
Use the `git-repo-setup` and `git-repo-flow` skills to bootstrap the repository.

Requirements:
- Run read-only preflight first: remotes, current branch, detected topology (fork vs direct), and which of `dev`/`main` already exist on the relevant remote.
- If `main` doesn't exist, stop and ask.
- If `dev` is missing, confirm before creating it from `main`; create the local branch only and give the user the exact command to run (`git push -u <remote> dev`) — never push `dev` yourself.
- Scaffold `README.md`, `.gitignore`, `LICENSE`, and `CONTRIBUTING.md` only for files that don't already exist — never overwrite an existing one.
- Never assume a license; ask which one (or to skip) every run.
- Do not configure branch protection or rulesets — out of scope for this command; the user sets it up manually.
- Never push a protected branch yourself; any needed push is handed to the user as the exact command to run.
- Report what was created vs. already existed, and any `TBD` items.

Arguments: $ARGUMENTS
