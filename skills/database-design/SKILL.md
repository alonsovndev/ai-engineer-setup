---
name: database-design
description: Use this skill when modeling relational schemas, planning migrations, and validating persistence behavior for correctness and performance.
---

When data models or persistence behavior change, use this skill to preserve invariants, performance, and migration safety.

## When to Use This Skill

Activate this skill when the user:

- Designs new entities or relationships
- Adds constraints, indexes, or query-heavy features
- Plans schema migrations or data backfills
- Investigates persistence bugs or performance bottlenecks

## How to Apply This Skill

### Step 1: Model Around Invariants

- Define entities and relationships from business rules
- Capture required constraints and validity rules explicitly

### Step 2: Plan Storage Strategy

- Choose keys and indexing strategy for expected access patterns
- Validate hot-path queries and guard against N+1 patterns

### Step 3: Prepare Migrations

- Design forward-safe migrations with rollback awareness
- Plan backfill and deployment ordering for low-risk rollout

### Step 4: Verify Data Behavior

- Add tests for critical persistence and transactional behavior
- Confirm timestamps and audit-relevant fields are handled consistently

## Guidelines

- Prefer explicit constraints over app-only enforcement
- Keep migrations small and reviewable when possible
- Measure query behavior on realistic data sizes
- Store timestamps in UTC and keep conventions consistent
