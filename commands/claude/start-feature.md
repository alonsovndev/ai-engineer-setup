Start a feature or hotfix branch using the standard GitHub workflow.

Use the `git-repo-flow` skill.

Arguments: $ARGUMENTS

Run read-only preflight first and detect fork mode or direct mode. Require explicit approval before `git feature`, `git resync`, `reset --hard`, or push. Prefer `feature/<ticket>-<short-desc>` for normal work and `hotfix/<ticket>-<short-desc>` for urgent production fixes.
