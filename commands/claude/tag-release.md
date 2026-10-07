---
description: "Check readiness and create the vX.Y.Z production tag from `main`."
argument-hint: "Release version, target repo, and candidate branch details"
---

Check readiness and create the vX.Y.Z production tag from `main`.

Use the `git-repo-flow`, `gh-prs`, and `pr-review` skills.

Arguments: $ARGUMENTS

Run read-only checks first. Verify branch flow, release tag assumptions, approvals, unresolved threads, CI status, and validation evidence. Require explicit approval before creating the release tag, merging, or calling GitHub APIs. Never push the release tag yourself — create the tag locally and give the user the exact command to run (`git push <remote> vX.Y.Z`).
