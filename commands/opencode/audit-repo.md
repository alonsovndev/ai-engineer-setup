---
description: Scan, evaluate, and produce a prioritized enhancement plan for the current repository.
agent: build
---

Usage: Optional --scope (architecture|principles|security|tests|style), --fix, or --quick.

Scan, evaluate, and produce a prioritized enhancement plan for the current repository.

## How To Use This Command

- `/audit-repo` — full scan across architecture, principles, security, tests, and style.
- `/audit-repo --scope architecture` — focus on layer boundaries, dependency direction, and DDD/hexagonal patterns.
- `/audit-repo --scope principles` — focus on SOLID, KISS, DRY, YAGNI, and abstraction quality.
- `/audit-repo --scope security` — focus on OWASP basics, input validation, auth, secrets, and trust boundaries.
- `/audit-repo --scope tests` — focus on test coverage gaps, test quality, and strategy alignment.
- `/audit-repo --scope style` — focus on naming, comments, formatting consistency, and code generation style.
- `/audit-repo --fix` — after producing the plan, implement fixes for the highest-priority findings in small, verified steps.
- `/audit-repo --quick` — lightweight scan: read structure, sample key files, produce a summary plan without deep analysis.

## Required Skills

Load the relevant skills before scanning. Use all of them for a full audit; load only the matching ones for scoped audits:

- `clean-architecture-ddd` — layer placement, dependency direction, domain purity, use-case and repository patterns.
- `programming-principles` — SOLID, KISS, DRY, YAGNI, abstraction tradeoffs, coupling and cohesion.
- `secure-code-generation` — OWASP Top 10, API Security Top 10, input validation, auth, secrets, trust boundaries.
- `test-strategy` — test coverage gaps, test quality, fixture design, test pyramid alignment.
- `code-generation-style` — naming, comments (why not what), simplicity, abstraction decisions.
- `quality-gates` — lint, format, type-check, test, and build status for the repo.

## Scan Phase

1. **Read structure** — list top-level directories, identify language, framework, build system, test framework, and config files.
2. **Map layers** — identify presentation, application, domain, and infrastructure boundaries (or equivalent for the project's stack).
3. **Sample key files** — read entry points, config files, representative modules from each layer, and test files.
4. **Run available checks** — execute lint, format, type-check, test, and build commands; record pass/fail/skipped/blocked status.
5. **Detect patterns** — note existing conventions, naming styles, error-handling approaches, and test strategies.

Do not modify any files during the scan phase.

## Evaluate Phase

For each dimension, collect findings with:

- **Location**: file path and line range (when specific).
- **Category**: architecture, principles, security, tests, style, or performance.
- **Description**: what the issue is, in one sentence.
- **Severity**: `critical` (data loss, security breach, broken build), `high` (architecture violation, missing auth, untested critical path), `medium` (principle smell, inconsistent style, weak test), `low` (naming, comment quality, minor inconsistency).
- **Effort**: `small` (< 15 min), `medium` (15-60 min), `large` (> 60 min).

Do not produce an exhaustive inventory of every minor issue. Focus on findings that meaningfully impact correctness, maintainability, security, or developer velocity.

## Plan Phase

Produce a structured enhancement plan with these sections:

### 1. Repo Summary
- Language, framework, build system, test framework.
- Overall structure in 2-3 sentences.
- Health score: `healthy`, `needs attention`, or `needs significant work`.

### 2. Findings by Category
Group findings under: Architecture, Principles, Security, Tests, Style.
Within each group, sort by severity (critical first).

### 3. Prioritized Action Plan
Rank actions by **impact x effort** (high-impact, low-effort first).
Each action item includes:
- Title
- Finding(s) it addresses
- Estimated effort
- Risk level (low/medium/high)
- Suggested order

### 4. Quick Wins
List items that can be fixed in under 15 minutes with low risk.

### 5. Quality Gate Status
Report the current state of lint, format, type-check, tests, and build.

## Fix Phase (only with --fix flag)

When the user requests fixes:

1. Start with quick wins and high-impact, low-effort items.
2. Make one change at a time — minimal file touch.
3. Run relevant checks after each change (lint, type-check, tests).
4. Report what changed, what passed, and any risks.
5. Stop and ask before tackling medium or large effort items.

Do not fix everything in one pass. Prioritize, verify, and report incrementally.

## Constraints

- Read-only during scan — no file modifications until the user approves the plan or uses --fix.
- Preserve existing conventions — do not impose patterns the project does not use.
- Do not invent missing facts — mark unknowns as TBD.
- Keep findings focused — quality over quantity.
- Follow orchestration router rules when delegating to subagents.
- Apply quality gates from orchestration/quality-gates.md after any fix.

Arguments: $ARGUMENTS
