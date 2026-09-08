---
description: "Scan, evaluate, and produce a prioritized enhancement plan for the current repository"
name: "Audit Repo"
argument-hint: "Optional --scope (architecture|principles|security|tests|style), --fix, or --quick"
agent: "code-review"
---
Scan the repository, evaluate code health across multiple dimensions, and produce a prioritized enhancement plan.

Arguments: $ARGUMENTS

## Required Skills

Load the relevant skills before scanning. Use all of them for a full audit; load only the matching ones for scoped audits:

- `clean-architecture-ddd` — layer placement, dependency direction, domain purity, use-case and repository patterns.
- `programming-principles` — SOLID, KISS, DRY, YAGNI, abstraction tradeoffs, coupling and cohesion.
- `secure-code-generation` — OWASP Top 10, API Security Top 10, input validation, auth, secrets, trust boundaries.
- `test-strategy` — test coverage gaps, test quality, fixture design, test pyramid alignment.
- `code-generation-style` — naming, comments (why not what), simplicity, abstraction decisions.
- `quality-gates` — lint, format, type-check, test, and build status for the repo.

## Scope Flags

- No flag: full scan across all dimensions.
- `--scope architecture`: focus on layer boundaries, dependency direction, DDD/hexagonal patterns.
- `--scope principles`: focus on SOLID, KISS, DRY, YAGNI, abstraction quality.
- `--scope security`: focus on OWASP basics, input validation, auth, secrets, trust boundaries.
- `--scope tests`: focus on test coverage gaps, test quality, strategy alignment.
- `--scope style`: focus on naming, comments, formatting consistency, code generation style.
- `--fix`: after producing the plan, implement fixes for highest-priority findings in small, verified steps.
- `--quick`: lightweight scan — read structure, sample key files, produce summary plan.

## Process

### 1. Scan (read-only)
- Read top-level structure: directories, language, framework, build system, test framework, config files.
- Map layer boundaries: presentation, application, domain, infrastructure (or project equivalent).
- Sample key files: entry points, configs, representative modules per layer, test files.
- Run available checks: lint, format, type-check, test, build — record pass/fail/skipped/blocked.
- Detect patterns: conventions, naming, error handling, test strategy.

### 2. Evaluate
For each finding, record:
- Location: file path and line range.
- Category: architecture, principles, security, tests, style, or performance.
- Description: one sentence.
- Severity: critical, high, medium, or low.
- Effort: small (< 15 min), medium (15-60 min), or large (> 60 min).

Focus on findings that impact correctness, maintainability, security, or developer velocity. Do not produce an exhaustive inventory of minor issues.

### 3. Plan
Produce a structured enhancement plan:

**Repo Summary**: language, framework, build/test systems, 2-3 sentence overview, health score (healthy / needs attention / needs significant work).

**Findings by Category**: grouped under Architecture, Principles, Security, Tests, Style — sorted by severity within each group.

**Prioritized Action Plan**: ranked by impact x effort (high-impact, low-effort first). Each item: title, findings addressed, effort, risk level, suggested order.

**Quick Wins**: items fixable in under 15 minutes with low risk.

**Quality Gate Status**: current lint, format, type-check, tests, build state.

### 4. Fix (only with --fix)
- Start with quick wins and high-impact, low-effort items.
- One change at a time — minimal file touch.
- Run relevant checks after each change.
- Report what changed, what passed, any risks.
- Stop and ask before medium or large effort items.

## Constraints

- Read-only during scan — no modifications until plan is approved or --fix is used.
- Preserve existing conventions — do not impose patterns the project does not use.
- Do not invent missing facts — mark unknowns as TBD.
- Keep findings focused — quality over quantity.
- Apply quality gates from orchestration/quality-gates.md after any fix.
