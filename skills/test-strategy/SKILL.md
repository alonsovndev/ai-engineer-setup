---
name: test-strategy
description: "Use when planning, adding, reviewing, or improving tests outside a strict TDD loop: unit tests, integration tests, contract tests, API tests, regression tests, characterization tests, fixtures, test seams, mocks, coverage, and test pyramid decisions. Keywords: testing, test strategy, unit test, integration test, contract test, regression test, characterization test, fixture, mock, coverage, test seam."
argument-hint: "Describe the behavior under test, stack, existing test framework, target seam, and whether the goal is new tests, review, or test cleanup."
user-invocable: true
---
# Test Strategy Skill

Plan and improve tests that verify observable behavior through stable seams, with the cheapest test type that gives useful confidence.

## Use This Skill For

- Choosing where tests belong for a code change.
- Adding or reviewing unit, integration, contract, API, regression, or characterization tests.
- Improving fixtures, test data builders, mocks, and test seams.
- Diagnosing flaky, brittle, slow, or implementation-coupled tests.
- Deciding when coverage is meaningful and when it is misleading.

## Do Not Use This Skill For

- Writing tests against private methods or implementation details just to increase coverage.
- Mocking internal collaborators by default.
- Replacing existing project test conventions with generic preferences.
- Rewriting broad test suites when a focused test would prove the change.
- Disabling or weakening tests to make a change pass.

## First Checks

1. Read existing tests for the touched area before adding new tests.
2. Identify the public seam: API endpoint, use case, CLI command, domain method, repository port, component behavior, or integration boundary.
3. Confirm the behavior that changed or the bug that must not regress.
4. Match local naming, fixture, assertion, and test runner conventions.
5. Prefer one focused behavior per test.

## Test Type Selection

| Test type | Best for | Avoid when |
|---|---|---|
| Unit | Pure domain logic, validation, calculations, branching rules | Behavior depends on DB, framework, network, or real wiring |
| Integration | Repository, framework, DB, dependency injection, adapter wiring | A pure unit test can prove the same behavior |
| Contract | API schemas, event payloads, external provider/consumer expectations | No stable external contract exists |
| API/Smoke | End-to-end request path, health, deployment wiring, Postman/Newman collections | It would require destructive calls or production credentials |
| Characterization | Legacy behavior before refactor | Existing behavior is already known to be wrong and should change |
| Regression | A bug fix with a known failing scenario | The test only restates implementation details |

## Test Quality Rules

- Test behavior users, callers, or consumers rely on.
- Name tests as specifications: `returns validation error when email is missing`.
- Use expected values from examples, specs, fixtures, or known literals, not from re-running the implementation.
- Keep setup clear and local unless a shared fixture reduces real repetition.
- Prefer builders or factories for complex domain objects.
- Use mocks only at system boundaries: network, time, randomness, filesystem, external services, or expensive infrastructure.
- Keep assertions specific enough to catch regressions but not so broad that refactors break them unnecessarily.

## Coverage Guidance

- Treat coverage as a signal, not proof of quality.
- Focus coverage on changed behavior, critical domain rules, error handling, and integration seams.
- Do not add low-value assertions just to satisfy a percentage.
- If coverage drops, either add meaningful tests or explain why generated/deleted/unreachable code changed the metric.

## Flake And Speed Guidance

- Remove dependence on real time, random order, network availability, shared global state, and test execution order.
- Prefer deterministic clocks, seeded data, isolated temp directories, and per-test database cleanup.
- Keep fast unit tests separate from slower integration or end-to-end tests when the repo supports markers or suites.
- Quarantine or skip flaky tests only with explicit rationale and follow-up, not as a default fix.

## Review Checklist

- Tests fail for the bug or behavior before the fix when feasible.
- Tests exercise public seams, not internals.
- Test names describe expected behavior.
- Mocks are only used at boundaries or where the repo convention requires them.
- Fixtures and builders make intent clearer instead of hiding important setup.
- Assertions would catch the intended regression.
- Existing tests are not weakened, deleted, or skipped without explicit approval.

## Output Contract

When delivering testing work, include:

- Test files added or updated.
- Seam and behavior covered.
- Test command run and result.
- Any test types intentionally not added and why.
- Residual risks such as untested external services, missing credentials, or slow suites not run.
