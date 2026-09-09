---
description: "Proactively sweep a file, module, directory, or the whole repository for latent correctness bugs, independent of any recent diff"
name: "Find Bugs"
argument-hint: "Scope to sweep (file/module/directory/whole repo) and any known symptom or area of suspicion"
agent: "bug-finder"
---
Use the `bug-finder` skill and agent to proactively sweep for latent correctness bugs.

Requirements:
- `/find-bugs` sweeps the whole repository; `/find-bugs <path>` sweeps a specific file, module, or directory; `/find-bugs --quick` runs a lighter, sampled pass.
- Scope is correctness only: logic errors, boundary/edge cases, error-handling gaps, race conditions, resource leaks, data integrity.
- Architecture, style, security, and test-coverage findings are out of scope — defer to `clean-architecture-ddd`/`clean-architecture`, `programming-principles`/`code-generation-style`, `secure-code-generation`/`security-basics`, and `test-strategy` respectively. For a broad multi-category audit, use `/audit-repo` instead.
- Read-only. Do not edit files, stage changes, commit, push, or contact external services unless explicitly requested.

Arguments: $ARGUMENTS
