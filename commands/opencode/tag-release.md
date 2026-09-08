---
description: Check readiness and create the vX.Y.Z production tag from main.
agent: tech-lead
---

Use the `git-repo-flow`, `gh-prs`, and `pr-review` skills to check release readiness.

Arguments: $ARGUMENTS

Required behavior:

- Run read-only checks first.
- Verify `dev` to `main` candidate flow and release tag assumptions.
- Confirm main HEAD versus latest release tag for hotfixes.
- Check PR approvals, unresolved threads, CI status, and verification evidence when data is available.
- Require explicit approval before creating or pushing the release tag, merging, or calling GitHub APIs.
