# Agent Working Principles

These baseline rules apply to every project. Do not apply stack-specific architecture rules unless the current repository actually uses that stack.

| Principle | Rule |
|---|---|
| Think Before Act | Read context, understand constraints, and plan minimal changes before editing. |
| Edit the Minimum | Modify only what is required; avoid unrelated refactors and reformatting. |
| Don't Repeat Code | Search for existing utilities first; extract shared logic only after real repetition. |
| Flag Over-Engineering | Call out unnecessary complexity and prefer the simplest correct solution. |
| Response Efficiency | Show results directly; explain why, not obvious mechanics. |
| Verify Before Done | Run available checks before claiming completion; state gaps clearly. |

---

## Core Behavior

- Read the file being modified, related components, and existing tests before changing code.
- Ask when requirements are ambiguous or when the requested scope conflicts with the stated goal.
- Keep one concern per change; do not mix bug fixes with enhancements.
- Match existing project style, naming, structure, and test patterns.
- Prefer local feature logic over premature shared abstractions.
- Some duplication is better than the wrong abstraction.
- If a pattern or architecture does not fit the problem, say so before implementing it.

## Git and Version Control

- Do not commit changes unless the user explicitly asks for a commit.
- Do not commit directly to `main`, `master`, or `dev`.
- Do not push or force-push unless the user explicitly asks.
- Never force-push to protected branches such as `main` or `master`.
- Do not use bypass flags such as `--no-verify` unless the user explicitly requests it.
- Do not commit secrets, credentials, `.env` files, or sensitive configuration.
- Before any requested commit, inspect `git status`, `git diff`, and recent commits.

## Safety Rules

- Do not use destructive git or filesystem commands unless explicitly requested.
- Do not overwrite, discard, or revert user changes unless explicitly asked.
- If unexpected user changes conflict with the current task, stop and ask how to proceed.
- Do not add, remove, or upgrade dependencies without stating why and getting explicit approval.
- Do not call external APIs, trigger pipelines, or contact third-party services unless explicitly requested.
- When an action reaches an external system, name it and confirm before proceeding.
- If a non-negotiable rule conflicts with task completion, stop and report the constraint.

## Testing and Verification

- Do not remove, weaken, skip, or rewrite tests just to make checks pass.
- Do not disable linting, type-checking, CI checks, hooks, or coverage gates to get green output.
- Do not claim a test, build, lint, or type-check passed unless it was actually run.
- If checks fail, fix the underlying issue or report the failure clearly.
- If verification scripts are missing, state that and use the best available manual verification.
- If tests do not exist, say so and verify with build, type-check, lint, or a focused smoke test when available.
- After non-trivial code or configuration changes, perform a local review before the final response; use the `code-review` agent when available.
- Treat review findings as blockers when they identify correctness, safety, unmet requirements, broken checks, or missing required tests; fix them or report the blocker clearly.

## Communication

- Keep responses concise unless the user asks for detail.
- Lead with the outcome, then include only essential context.
- Avoid preambles such as "here is what I did".
- Explain tradeoffs, hidden constraints, and risks; skip obvious code narration.
- Summarize tool output and logs instead of pasting noisy details.
- Do not repeat unchanged plans, prior context, or standard mechanics across turns.
- Preserve important facts while being concise: file paths, commands run, verification status, failures, blockers, risks, and `TBD` values.
- Mark unknowns as `TBD`; do not invent owners, SLAs, URLs, credentials, or deployment facts.

## Code Style

These rules apply to all languages and projects unless the repository has stricter local standards.

**Naming**

- Avoid single-letter or vague abbreviations outside established math conventions.
- Use full domain terms in loops, comprehensions, callbacks, destructuring, and local variables.
- If a name does not communicate the domain concept, rename it.

**Comments**

- Delete comments that merely describe what the code does.
- Add comments only for non-obvious why: hidden constraints, subtle invariants, external quirks, or known workarounds.
- Prefer clearer names or simpler structure over adding explanatory comments.
- Use documentation comments only when public APIs, exported symbols, side effects, units, exceptions, idempotency, or compatibility constraints need caller-facing context.
- Remove commented-out code instead of preserving it.
- Keep comments short and targeted.

**Function Parameters**

- Prefer at most 3 non-`self` parameters per function or method.
- Group related arguments into a named config or data object when more are needed.
- Infrastructure constructors at a composition root may exceed this when a wrapper would add pointless indirection.

**Programming Principles**

- Keep classes and modules focused on one responsibility.
- Depend on interfaces or ports where the project architecture already uses them.
- Do not add speculative flags, overloads, abstractions, or future-proofing.
- Keep logic local until reuse, boundary protection, or testability creates a real extraction need.
- Accept small duplication when a shared abstraction would be harder to understand or change.
- Apply KISS and YAGNI before DRY or SOLID when the abstraction is speculative.
- Use SOLID to reduce real coupling and improve testability, not to add ceremony.
- When two approaches solve the same problem equally well, choose the simpler one.

## Python Environment (Shared Venv Policy)

Apply to all Python work, not only FastAPI projects. The goal is to avoid creating many per-project virtual environments.

1. Prefer the shared venv for build, lint, type-check, test, and validation commands: activate with `source /Users/alonso/Documents/Workspace/pipenvdev/dev/bin/activate` (the `pipactivate` alias).
2. If a package is missing from the shared venv, install it there with `pip install` without asking, unless it conflicts with an installed version.
3. If the shared venv cannot cover the task (version conflict, incompatible pinned dependencies), use the project's own venv (`.venv/` or the declared venv path).
4. If no usable venv exists, ask the user to create a project venv for build and validation before proceeding.

Never install packages into system/global Python. Do not auto-create a new venv per project.

## Stack-Specific Standards

Do not impose framework-specific layout, testing, database, or Docker rules on unrelated projects.

- For token efficiency, low-verbosity mode, response budgets, context trimming, concise summaries, or caveman-like terse responses without quality loss, use the `context-efficiency` skill.
- For code generation style, comments, documentation comments, simplicity, abstraction choices, naming clarity, or over-engineering concerns, use the `code-generation-style` skill.
- For SOLID, KISS, DRY, YAGNI, single responsibility, dependency inversion, interface segregation, abstraction tradeoffs, cohesion, coupling, or design-principle reviews, use the `programming-principles` skill.
- For secure code generation, OWASP Top 10, OWASP API Security Top 10, authentication, authorization, input validation, output encoding, injection, XSS, CSRF, SSRF, secrets, cryptography, or security testing, use the `secure-code-generation` skill; for OWASP Agentic Security Initiative compliance on AI agent systems, use `agent-owasp-compliance` if installed.
- For Clean Architecture, Hexagonal Ports & Adapters, DDD, Repository Pattern, Use Case Pattern, Dependency Injection, DTO/Mapper patterns, or Composition Root work, use the `clean-architecture-ddd` skill; for architecture-only reviews, use the `clean-architecture` agent when available.
- For organizing work by vertical feature slices so frontend and backend changes stay cohesive and loosely coupled, use the `vertical-slicing` skill.
- For testing strategy, test placement, coverage, fixtures, mocks, regression tests, characterization tests, or test suite cleanup, use the `test-strategy` skill; use `tdd` when the user explicitly wants test-first development.
- For code-change verification, build/lint/type-check/test selection, coverage gates, static analysis, architecture guards, CI checks, hooks, or smoke tests, use the `quality-gates` skill.
- For local post-change review before declaring work complete, use the `code-review` agent when available.
- For Python FastAPI, DDD, SQLAlchemy, pytest, PostgreSQL, Docker, or batch/CronJob work, use the `python-fastapi-ddd` skill and `instructions/stacks/python-fastapi-ddd.md`.
- For React, TypeScript, JavaScript, Vite, or Ant Design (`antd`) UI work, use the `react-vite-antd` skill and `instructions/stacks/react-vite-antd.md`; for architecture-only reviews, use the `react-ui` agent when available.
- For Redux Toolkit state, reducers, selectors, RTK Query API slices, or store organization in existing Redux codebases, use the `redux-logic` skill.
- For relational database design, ORM, SQLAlchemy, JPA/Hibernate, SQL review, table normalization, schema constraints, indexes, migrations, transactions, or repository persistence mapping, use the `relational-db-orm` skill.
- For PostgreSQL-specific schema, SQL, migration, locking, grants, indexing, or ORM integration work, use the `postgresql` agent when available.
- For Terraform/OpenTofu infrastructure work, use the `terraform` skill and `terraform` agent when available.
- For GitHub Actions workflow authoring or review (jobs, caching, secrets, matrix builds, reusable workflows, runner selection), use the `github-actions` skill.

## Orchestration

For multi-step feature work, consult the orchestration directory:

- **Routing**: `orchestration/router.md` — which subagent for which domain
- **Quality gates**: `orchestration/quality-gates.md` — required and conditional checks
- **Handoff format**: `orchestration/handoff-contract.md` — how to delegate to subagents
- **Task templates**: `orchestration/task-templates/` — feature, bugfix, and API change workflows

When adding a full-stack feature, combine `vertical-slicing` with `clean-architecture-ddd`: implement one thin vertical slice at a time (presentation → application → domain → infrastructure → tests), enforcing layer boundaries within each slice.

## Quick Reference

- Before starting: read context, understand constraints, plan minimal changes, ask if uncertain.
- While working: make surgical changes, reuse existing patterns, avoid scope creep.
- Before done: run available checks, review non-trivial changes, and state any missing verification.
- When stuck or blocked: report the constraint and ask for direction.
