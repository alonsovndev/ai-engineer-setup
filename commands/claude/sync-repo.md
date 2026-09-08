---
description: "Inspect and synchronize a fork-based or direct repository safely."
---

Inspect and synchronize a fork-based or direct repository safely.

Use the `git-repo-flow` skill.

Arguments: $ARGUMENTS

Run read-only preflight first. Detect whether the repository uses fork mode (`origin` + `upstream`) or direct mode (`origin` only). Explain and recommend the appropriate sync command for the situation: fork mode preserving local commits uses `git sync`; fork mode disposable local copies of shared branches use `git resync`; direct mode preserving local commits uses `git fetch origin && git merge origin/$(git branch --show-current)`; direct mode fast-forward-only on shared branches uses `git fetch origin && git pull --ff-only origin $(git branch --show-current)`. Require explicit approval before `git sync`, `git resync`, hard reset, force push, or GitHub API calls — `git resync` performs `reset --hard` and `push --force-with-lease`. Never hard-reset or force-push a branch that contains unmerged or unpushed local work.
