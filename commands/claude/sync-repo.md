Inspect and synchronize a fork-based or direct repository safely.

Use the `git-repo-flow` skill.

Arguments: $ARGUMENTS

Run read-only preflight first. Detect whether the repository uses fork mode (`origin` + `upstream`) or direct mode (`origin` only). Explain the safest sync option. Require explicit approval before `git sync`, `git resync`, hard reset, force push, or GitHub API calls.
