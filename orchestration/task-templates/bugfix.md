# Bugfix Task Template

Targeted fix workflow with regression protection.

## Workflow

```
Isolate → Fix → Regression Test → Review → Gates
```

## Phase 1: Isolate

**Agent**: Domain subagent based on bug location, or `code-review` for investigation

- Reproduce the bug (steps, environment, inputs)
- Identify root cause: logic error, missing validation, race condition, data issue, or architecture violation
- Scope the fix: which files, which layer, what behavior changes
- Check if this reveals a deeper architecture problem (layer bleeding, missing port, wrong abstraction)
- Output: root cause analysis and fix scope

## Phase 2: Fix

**Build mode** — minimal, surgical change

- Fix the root cause, not the symptom
- Touch the minimum number of files
- Preserve existing behavior except for the specific bug
- Do not refactor unrelated code in the same change
- If the fix requires an architecture change, flag it and ask whether to separate into a follow-up
- Output: the fix itself

## Phase 3: Regression Test

**Skills**: `test-strategy` or `tdd`

- Add a test that reproduces the bug (fails before fix, passes after)
- Test at the appropriate level: unit for logic bugs, integration for data/flow bugs, E2E for user-facing bugs
- If no test framework exists, document that and add a characterization test or manual reproduction steps
- Output: test file(s) that protect against regression

## Phase 4: Review

**Agent**: `code-review` (read-only)
**Skills**: `quality-gates`

- Verify the fix addresses the root cause
- Check for regressions in related behavior
- Verify no new architecture violations introduced
- Check for security implications (input validation, auth bypass, data exposure)
- Output: findings with severity

## Phase 5: Quality Gates

Run required gates from `orchestration/quality-gates.md`:

- Lint, format, type-check, tests (including new regression test), build
- Conditional gates as triggered

## Done Criteria

- Bug is fixed and reproducible test passes
- No new failures introduced
- No blocking or critical findings from review
- All required quality gates pass
- Changes committed with conventional commit message (type: `fix`)
