---
description: "Proactively sweep a file, module, directory, or the whole repository for latent correctness bugs, independent of any recent diff."
---

Proactively sweep a file, module, directory, or the whole repository for latent correctness bugs, independent of any recent diff.

Use the `bug-finder` skill and agent.

## How To Use This Command

- `/find-bugs` — sweep the whole repository.
- `/find-bugs <path>` — sweep a specific file, module, or directory.
- `/find-bugs --quick` — lighter pass: sample key files rather than reading everything in scope.

## Scope

Correctness only: logic errors, boundary/edge cases, error-handling gaps, race conditions, resource leaks, data integrity. Architecture, style, security, and test-coverage findings are out of scope — defer to `clean-architecture-ddd`/`clean-architecture`, `programming-principles`/`code-generation-style`, `secure-code-generation`/`security-basics`, and `test-strategy` respectively. For a broad multi-category audit, use `/audit-repo` instead.

Read-only. Do not edit files, stage changes, commit, push, or contact external services unless explicitly requested.

Arguments: $ARGUMENTS
