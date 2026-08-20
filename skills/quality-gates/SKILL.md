---
name: quality-gates
description: "Use when selecting, running, designing, or reviewing code quality gates and verification checks after code changes: tests, lint, format checks, type-checks, builds, coverage, static analysis, architecture guards, CI checks, pre-commit hooks, smoke tests, and release readiness. Keywords: quality gates, verification, verify, build, lint, type-check, tests, coverage, static analysis, guards, CI, pipeline, pre-commit, smoke test."
argument-hint: "Describe the change, stack, available commands, and whether the goal is local verification, CI guard design, or failure diagnosis."
user-invocable: true
---
# Quality Gates Skill

Select and run the smallest reliable set of checks that proves a code change is safe, without bypassing tests, linters, type-checks, hooks, or CI gates.

## Use This Skill For

- Choosing verification commands after code changes.
- Designing or reviewing CI quality gates, pre-commit hooks, architecture guards, and build checks.
- Diagnosing failed tests, lint, type-check, build, coverage, or static-analysis checks.
- Defining release or PR readiness checks.
- Reporting what was verified and what remains unverified.

## Do Not Use This Skill For

- Skipping, weakening, deleting, or rewriting checks just to get green output.
- Adding new tools or dependencies without a concrete need and explicit approval when required.
- Triggering remote CI pipelines, deployments, or external systems without explicit user approval.
- Claiming checks passed when they were not actually run or inspected.

## Verification Selection

1. Read project instructions and package/build files before choosing commands.
2. Prefer documented repo commands over generic commands.
3. Run focused checks first for the touched area when available.
4. Run broader checks before final completion when the change affects shared logic, build config, dependencies, public API, or architecture rules.
5. If no commands exist, do static review plus the narrowest smoke test feasible.

## Check Types

| Check | Use when | Examples |
|---|---|---|
| Unit tests | Pure logic, domain rules, utility behavior | `pytest tests/unit`, `npm test -- --runInBand`, `./mvnw test` |
| Integration tests | DB, HTTP, framework, adapter, or wiring behavior changed | `pytest tests/integration`, `./gradlew integrationTest` |
| Contract/API tests | API schema, request/response, events, or external contract changed | OpenAPI lint, Pact, Postman/Newman smoke |
| Lint/format check | Source code, docs, config, or generated style-sensitive files changed | `npm run lint`, `ruff check`, `prettier --check` |
| Type-check/compile | Typed code, signatures, DTOs, generated types, or public interfaces changed | `npm run typecheck`, `mypy`, `tsc --noEmit`, `./mvnw compile` |
| Build/package | Bundles, Dockerfiles, package config, resources, or runtime startup changed | `npm run build`, `./gradlew build`, `docker build` |
| Architecture guard | Layering, imports, module boundaries, or DDD rules changed | ArchUnit, import-linter, custom AST tests |
| Smoke test | No test harness exists or runtime wiring changed | start app, health endpoint, CLI version, one safe request |

## Guard Design

- Make guards deterministic, fast enough for their CI stage, and actionable when they fail.
- Prefer repository-native tooling before adding a new quality tool.
- Put architecture guards close to the codebase's test framework when possible.
- Check important boundaries: forbidden imports, dependency direction, generated files, migrations, config schema, secrets, and public contract drift.
- Avoid guards that depend on developer machine state, live external services, mutable timestamps, or production credentials.
- Document how to run the guard locally.

## Failure Handling

- Read the first meaningful failure, not only the final summary.
- Fix the underlying issue instead of disabling the check.
- Re-run the failed check after fixing it.
- If a failure is unrelated to the change, report the evidence and avoid modifying unrelated code unless the user asks.
- If verification is blocked by missing credentials, unavailable services, or missing tools, state the blocker clearly and perform static review.

## Safety Rules

- Never use bypass flags such as `--no-verify`, `-DskipTests`, `-x test`, or disabled coverage gates unless the user explicitly requests that exact behavior.
- Do not change CI, hooks, or coverage thresholds to pass a failing change without explaining the behavioral risk.
- Do not run destructive database, container, or cleanup commands as part of verification without approval.
- Do not contact remote systems or trigger hosted pipelines without approval.

## Reporting Contract

When reporting verification, include:

- Commands run and pass/fail result.
- Focus of each command, such as unit, integration, lint, type-check, build, or smoke.
- Any failed check and the fix or remaining blocker.
- Checks intentionally not run and why.
- Residual risk, especially for unverified external services, credentials, runtime environments, or platform differences.
