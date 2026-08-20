---
description: Check readiness for dev to main release PRs and vX.Y.Z production tags.
agent: tech-lead
---

Use the `git-repo-flow`, `gh-prs`, and `pr-review` skills to check release readiness.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only checks first.
- Verify `dev` to `main` candidate flow and release tag assumptions.
- Confirm main HEAD versus latest release tag for hotfixes.
- Check PR approvals, unresolved threads, CI status, and verification evidence when data is available.
- Require explicit approval before creating tags, pushing tags, merging, or calling GitHub APIs.
