---
description: "Inspect and synchronize a fork-based or direct repository safely."
argument-hint: "Optional branch, topology, or sync goal"
---

Inspect and synchronize a fork-based or direct repository safely.

Use the `git-repo-flow` skill.

Arguments: $ARGUMENTS

Run read-only preflight first. Detect whether the repository uses fork mode (`origin` + `upstream`) or direct mode (`origin` only). Explain and recommend the appropriate sync command for the situation: fork mode preserving local commits on a working branch uses `git sync`; fork mode disposable local copies of shared branches may use approved `git resync`; direct mode preserving local commits on a working branch uses `git fetch origin && git merge origin/$(git branch --show-current)`; normal sync of protected branches (`main`, `master`, `dev`) uses fetch followed by `git merge --ff-only <remote>/<branch>`, stopping if a fast-forward is impossible. Never run `git sync` or a merge that creates a commit on a protected branch. Require explicit approval before `git sync`, `git resync`, hard reset, force push, or GitHub API calls — `git resync` performs `reset --hard` and `push --force-with-lease`. Never hard-reset or force-push a branch that contains unmerged or unpushed local work.
