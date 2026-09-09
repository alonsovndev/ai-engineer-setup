---
name: bug-finder
description: "Use for a proactive, correctness-only sweep of a file, module, directory, or whole repository for latent bugs — independent of any specific diff or recent change. Not for architecture, style, security, or test-coverage review (see other skills for those). Keywords: bug finder, find bugs, defect sweep, latent bugs, logic errors, edge cases, static analysis, issue hunting."
argument-hint: "Provide the scope to sweep (file/module/directory/whole repo) and any known symptom or area of suspicion."
user-invocable: true
---

# Bug Finder Skill

Proactively sweep code for latent correctness defects, independent of any specific diff or recent change.

## Use This Skill For

- Hunting for bugs across a file, module, directory, or the whole repository at any time.
- Investigating a vague symptom ("something feels off in X") without a known reproduction.
- A standing correctness check that isn't tied to reviewing a just-made change.

## Do Not Use This Skill For

- Reviewing a diff or a just-completed change — use the `code-review` agent instead.
- Architecture or DDD violations — use `clean-architecture-ddd` or the `clean-architecture` agent.
- SOLID/DRY/style concerns — use `programming-principles` or `code-generation-style`.
- Security vulnerabilities — use `secure-code-generation` or `security-basics`.
- Missing test coverage as a standalone finding — use `test-strategy`. A missing test may be cited as supporting evidence for a defect finding here, but is not itself a finding.
- A broad multi-category audit — use the `/audit-repo` command, which already covers architecture, principles, security, tests, and style together.

## Sweep Workflow

1. Confirm scope: the path(s) the user named, or the whole repo if unspecified — ask if genuinely ambiguous.
2. Read project instructions and identify language, framework, and test conventions.
3. Read the target files in full, not just recent diffs.
4. Note existing test coverage for the swept area — it helps judge whether a suspected defect is already caught.

## Defect Categories (correctness only)

- Logic errors: incorrect conditionals, off-by-one, wrong operator, inverted boolean logic.
- Boundary and edge cases: empty collections, null/undefined, zero, negative numbers, unicode, overflow.
- Error handling: swallowed exceptions, missing error paths, incorrect propagation, silent failures.
- State and concurrency: race conditions, unsynchronized shared state, incorrect async/await usage, unreleased resources (files, connections, listeners).
- Data integrity: unintended mutation, stale references, mismatched types, incorrect side effects.

## Output Format

```markdown
## Findings

- **blocking** `path/file.ext:line` - {defect}. Trigger: {concrete condition that hits it}. Fix: {one concrete fix}.

## Swept

- {scope actually covered, and anything explicitly skipped — e.g. generated code, vendored deps}

## Residual Risk

- {area not swept, or `None`}
```

## Final Response

When complete, report:

- Scope actually swept.
- Findings count by severity.
- Residual risk or areas not covered.

Do not edit files, stage changes, commit, push, or contact external services unless explicitly requested. Keep findings concrete and reproducible — do not report style, architecture, or security findings; name the correct skill instead.
