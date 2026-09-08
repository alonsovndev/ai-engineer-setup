Check readiness and create the vX.Y.Z production tag from `main`.

Use the `git-repo-flow`, `gh-prs`, and `pr-review` skills.

Arguments: $ARGUMENTS

Run read-only checks first. Verify branch flow, release tag assumptions, approvals, unresolved threads, CI status, and validation evidence. Require explicit approval before creating or pushing the release tag, merging, or calling GitHub APIs.
