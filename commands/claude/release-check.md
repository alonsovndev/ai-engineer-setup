Check readiness for dev to main release PRs and vX.Y.Z production tags.

Use the `git-repo-flow`, `gh-prs`, and `pr-review` skills.

Arguments: $ARGUMENTS

Run read-only checks first. Verify branch flow, release tag assumptions, approvals, unresolved threads, CI status, and validation evidence. Require explicit approval before creating or pushing release tags, merging, or calling GitHub APIs.
