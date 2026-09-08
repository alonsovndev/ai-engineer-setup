Prepare or create the pre-release pull request promoting `dev` into `main` using the GitHub Enterprise workflow.

Use the `create-pr`, `gh-prs`, and `git-repo-flow` skills.

Arguments: $ARGUMENTS

Run read-only preflight first. Choose the PR target from detected topology: fork mode targets `upstream`, direct mode targets `origin`. Target `main` for `dev` (and `hotfix/*`) release PRs. Require explicit approval before push, PR creation, PR edits, comments, or GitHub API calls.
