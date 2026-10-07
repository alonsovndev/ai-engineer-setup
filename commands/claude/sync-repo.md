---
description: "Inspect and synchronize a fork-based or direct repository safely."
argument-hint: "Optional branch, topology, or sync goal"
---

Inspect and synchronize a fork-based or direct repository safely.

Use the `git-repo-flow` skill.

Arguments: $ARGUMENTS

Run read-only preflight first. Detect whether the repository uses fork mode (`origin` + `upstream`) or direct mode (`origin` only). Explain and recommend the appropriate sync command for the situation: fork mode preserving local commits on a working branch uses `git sync`; fork mode disposable local copies of shared branches: `git resync` is user-run only; direct mode preserving local commits on a working branch uses `git fetch origin && git merge origin/$(git branch --show-current)`; normal sync of protected branches (`main`, `master`, `dev`) uses fetch followed by `git merge --ff-only <remote>/<branch>`, stopping if a fast-forward is impossible. Never run `git sync` or a merge that creates a commit on a protected branch, and never run `git sync` or `git resync` while on a protected branch — both aliases push the current branch; if a protected branch needs a push, give the user the exact command to run. Require explicit approval before `git sync`, hard reset, force push on a working branch, or GitHub API calls — `git resync` performs `reset --hard` and `push --force-with-lease` and is user-run only. Never hard-reset or force-push a branch that contains unmerged or unpushed local work.
