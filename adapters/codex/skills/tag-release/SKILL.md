---
name: tag-release
description: "Check readiness and create the vX.Y.Z production tag from `main`."
---

Use this skill when the user invokes `$tag-release` or asks for this workflow. Apply any scope, options, and details supplied with the invocation.

Check readiness and create the vX.Y.Z production tag from `main`.

Use the `git-repo-flow`, `gh-prs`, and `pr-review` skills.

Run read-only checks first. Verify branch flow, release tag assumptions, approvals, unresolved threads, CI status, and validation evidence. Require explicit approval before creating or pushing the release tag, merging, or calling GitHub APIs.
