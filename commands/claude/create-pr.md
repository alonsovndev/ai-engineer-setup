Prepare or create a pull request using the GitHub Enterprise workflow.

Use the `create-pr`, `gh-prs`, and `git-repo-flow` skills.

Arguments: $ARGUMENTS

Run read-only preflight first. Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`. Default `feature/*` PRs to `dev`; default `hotfix/*` and release PRs to `main`. Require explicit approval before push, PR creation, PR edits, comments, or GitHub API calls.
