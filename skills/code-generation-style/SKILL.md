---
name: code-generation-style
description: "Use when generating, editing, or reviewing code style decisions around comments, documentation comments, simplicity, naming, abstraction, refactoring scope, and avoiding over-engineering. Keywords: code generation, comments, why not what, documentation comments, simplicity, abstraction, over-engineering, refactor, naming, maintainability."
argument-hint: "Describe the code change, language, local conventions, and whether the focus is comments, simplicity, abstraction, or review."
user-invocable: true
---
# Code Generation Style Skill

Generate and edit code that is clear by construction: simple structure, precise names, minimal abstractions, and comments only where they explain non-obvious intent.

For the classic design-pattern catalog (Factory, Singleton, Strategy, Observer, Decorator, etc.) and when each one earns its place, use the `design-patterns` skill.

## Use This Skill For

- Deciding whether generated code needs comments or documentation comments.
- Reviewing comments for usefulness, staleness, or noise.
- Choosing between local code, helper functions, classes, interfaces, flags, factories, builders, or shared abstractions.
- Keeping generated code simple, direct, and aligned with existing project style.
- Reducing over-engineered code before it spreads.
- Applying programming principles such as SOLID, KISS, DRY, and YAGNI through `programming-principles` when the tradeoff is explicit.

## Do Not Use This Skill For

- Repository documentation, ADRs, runbooks, or README work; use `technical-writer` or `markdown-author`.
- Language formatter rules that are already owned by a formatter or linter.
- Large architecture decisions; use `clean-architecture-ddd` or `tech-lead` when architecture is the primary concern.
- Adding comments to make unclear code acceptable when renaming or simplification would make the comment unnecessary.

## Comment Decision Rule

Prefer code that does not need a comment. Add a comment only when it explains a non-obvious **why**, constraint, or consequence that a reader cannot infer from names and structure.

Good reasons to comment:

- Business invariant or policy that looks arbitrary in code.
- External system quirk, vendor behavior, API limitation, or compatibility constraint.
- Security, privacy, compliance, audit, or data-retention requirement.
- Concurrency, ordering, idempotency, retry, caching, or transaction constraint.
- Performance tradeoff with measured or known reason.
- Temporary workaround with reason, scope, and removal signal.
- Surprising edge case where simplifying the code would lose important context.

Bad reasons to comment:

- Repeating what the next line does.
- Explaining obvious syntax, loops, assignments, conditionals, or function calls.
- Restating a variable or function name in prose.
- Describing historical code that no longer exists.
- Leaving commented-out code instead of deleting it.
- Creating a long explanation for code that should be renamed, split, or simplified.

## Comment Style

- Keep comments short and close to the code they explain.
- State the reason or constraint first.
- Use complete enough context for future readers, but avoid essays.
- Do not include secrets, private URLs, tickets without context, or internal names that should not be exposed.
- Prefer `TODO(<owner-or-context>): reason and removal condition` only when the repo uses TODOs and the follow-up is real.

Examples:

```typescript
// The partner API rejects ISO timestamps with offsets; send UTC without milliseconds.
const timestamp = formatPartnerTimestamp(clock.now());
```

```python
# Keep the write idempotent because the scheduler retries after network timeouts.
repository.upsert_batch_result(batch_result)
```

Avoid:

```typescript
// Loop through users and add active users to the result.
for (const user of users) {
  if (user.active) result.push(user);
}
```

## Documentation Comments

- Add public API or exported symbol documentation when the project convention, language ecosystem, or generated docs require it.
- Document parameters only when their meaning, units, constraints, or side effects are not obvious from type and name.
- Document exceptions, retries, idempotency, ordering, security expectations, and compatibility constraints when callers need them.
- Do not generate boilerplate docstrings that repeat the function signature.

## Simplicity And Abstraction

- Prefer the smallest correct change that solves the current problem.
- Keep logic local until a real second use or clear boundary justifies extraction.
- Some duplication is better than the wrong abstraction.
- Do not add interfaces, base classes, factories, builders, service layers, flags, or strategy objects unless they solve a current need.
- Avoid future-proofing for hypothetical consumers, data shapes, providers, or workflows.
- When two designs work, choose the one with fewer concepts, fewer files, and fewer names.
- Extract a helper when it names a meaningful concept, removes real repetition, or isolates a boundary.
- Use `programming-principles` for SOLID, KISS, DRY, or YAGNI decisions that need explicit tradeoff reasoning.

## Naming Before Comments

- Rename vague variables, functions, and classes before adding explanatory comments.
- Use domain terms already present in the repository.
- Avoid single-letter or vague abbreviations outside established math or local conventions.
- A good name should reduce the need for a comment.

## Refactoring Scope

- Do not mix broad cleanup with a feature or bug fix.
- Refactor only the code needed to make the current change clear and safe.
- Preserve existing style in nearby code unless that style is the source of the issue.
- Do not reformat unrelated blocks.

## Review Checklist

- Comments explain why, constraints, or consequences, not obvious mechanics.
- Stale, redundant, and commented-out code is removed.
- Names and structure are clear enough that comments are rare.
- No speculative abstraction was added.
- Local duplication was accepted when abstraction would be premature.
- The change is smaller than the explanation would need to be.

## Output Contract

When delivering style-focused code generation work, include:

- Files changed.
- Comments added, removed, or deliberately avoided and why.
- Any abstraction accepted, rejected, or removed.
- Verification performed or delegated to `quality-gates`.
