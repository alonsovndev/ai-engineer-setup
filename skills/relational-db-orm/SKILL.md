---
name: relational-db-orm
description: "Use when designing, editing, or reviewing relational database schemas, SQL, ORM models, SQLAlchemy, JPA/Hibernate, table normalization, constraints, indexes, migrations, transactions, and repository persistence mapping. Keywords: relational database, SQL, ORM, SQLAlchemy, JPA, Hibernate, normalization, normalisation, schema design, table design, foreign key, index, migration, transaction."
argument-hint: "Describe the database engine, ORM/client, schema or query files, workload/query patterns, and whether the task is design, implementation, review, or migration planning."
user-invocable: true
---
# Relational DB ORM Skill

Design and review relational schemas, SQL, and ORM mappings with explicit constraints, safe migrations, query-shaped indexes, and clear boundaries between persistence and domain code.

## Use This Skill For

- Relational table design, normalization, denormalization tradeoffs, and constraints.
- SQL review for correctness, safety, injection risk, query shape, and performance.
- ORM model design for SQLAlchemy, JPA/Hibernate, Spring Data, Django ORM, or similar tools.
- Migration planning with backward-compatible rollout and recovery notes.
- Transaction boundaries, isolation, locking, retries, and idempotency.
- Repository mapping between ORM/persistence models and domain entities.

## Do Not Use This Skill For

- Connecting to databases, running SQL, or applying migrations without explicit user approval and confirmed target environment.
- PostgreSQL-specific execution, grants, locks, query plans, or migration safety when a `postgresql` agent is available; use that agent for engine-specific depth.
- NoSQL/document modeling unless the task is explicitly about relational integration.
- Adding ORM or database dependencies without a concrete need and explicit approval when required.
- Replacing project-local schema conventions with generic preferences.

## First Checks

1. Identify database engine, migration tool, ORM/client, and target environment.
2. Read existing migrations, schema definitions, ORM models, repositories, query code, and tests before changing design.
3. Identify main query patterns: lookup keys, joins, filters, ordering, grouping, pagination, and write frequency.
4. Preserve existing naming, migration, key, timestamp, soft-delete, audit, and tenancy conventions unless they are the issue.
5. Treat destructive, lock-heavy, or backward-incompatible schema changes as high-risk.

## Relational Modeling

- Give every table a clear purpose and one stable grain, such as one row per order, order line, account, or status history event.
- Use primary keys, foreign keys, unique constraints, not-null constraints, and check constraints to enforce invariants the database can own.
- Prefer explicit join tables for many-to-many relationships with metadata, lifecycle, or audit needs.
- Model tenant ownership and row-level ownership explicitly when the application is multi-tenant.
- Keep audit columns consistent with local conventions, such as `created_at`, `updated_at`, `created_by`, or version columns.
- Avoid storing derived values unless there is a documented performance, audit, or snapshot reason.

## Normalization And Denormalization

- Default to 3NF for transactional schemas: one fact in one place, non-key attributes depend on the key, and no hidden repeating groups.
- Use lookup/reference tables when values have lifecycle, metadata, ownership, or need foreign-key integrity.
- Keep enums/check constraints local when the value set is small, stable, and does not need metadata.
- Denormalize only for a proven read path, reporting need, audit snapshot, or historical point-in-time requirement.
- Document denormalized fields with source of truth, refresh/update rule, and consistency risk.
- Do not split tables only to satisfy theory if it makes the actual workload harder and adds no integrity benefit.

## SQL Guidance

- Use parameterized queries or ORM bind parameters for all untrusted values.
- Avoid string-concatenated SQL, dynamic identifiers from user input, and unchecked sort/filter fields.
- Match joins to declared relationships and expected cardinality.
- Make pagination deterministic with stable ordering.
- Use CTEs, window functions, and aggregates when they clarify intent or improve query shape; avoid clever SQL that hides business rules.
- Review `NULL` semantics explicitly in filters, unique constraints, and joins.

## Indexing And Performance

- Recommend indexes only for named query patterns.
- Align index column order with equality filters, range filters, joins, and sort order.
- Consider selectivity, write overhead, storage cost, and existing indexes before adding another index.
- Watch for N+1 query patterns, unbounded result sets, missing pagination, and accidental eager loading.
- Prefer read-only query plan evidence when the user can provide it.
- Do not add broad indexes as a substitute for understanding the workload.

## ORM Guidance

- Keep ORM models aligned with database schema and migration files.
- Keep ORM/persistence models separate from domain entities when Clean Architecture or DDD rules apply.
- Map explicitly between ORM models, domain entities, and DTOs at boundaries.
- Avoid leaking lazy-loaded relationships outside a transaction/session boundary.
- Choose relationship loading deliberately: lazy, select-in, joined, or explicit query based on access pattern.
- Avoid cascade rules that can delete or mutate more data than the use case intends.
- Keep validation that protects database integrity in constraints as well as application code when feasible.

## SQLAlchemy Guidance

- Prefer SQLAlchemy 2.x typed declarative mappings when the project uses modern SQLAlchemy.
- Use `AsyncSession` for async API request paths and sync `Session` for sync/batch paths when project conventions support that split.
- Do not share sessions across concurrent tasks or requests.
- Keep transaction boundaries explicit with context managers or application service boundaries.
- Use eager loading intentionally to prevent N+1 behavior; do not blindly eager-load large graphs.
- Keep Alembic/Flyway/raw SQL migrations as the source of deployed schema changes; do not rely on `create_all()` for deployed environments.
- Be careful with `server_default`, nullable columns, relationship cascades, and `delete-orphan` behavior.

## Migrations And Rollout

- Prefer additive, backward-compatible migrations for live systems: add nullable column, backfill, dual-read/write if needed, then enforce constraints later.
- Separate schema changes, backfills, and cleanup when lock time or deployment order matters.
- Include rollback or recovery notes for risky changes.
- Avoid table rewrites, broad updates, lock-heavy alterations, and non-concurrent index builds in production paths unless planned.
- Keep application code compatible with old and new schema during rolling deploys when applicable.

## Transactions And Concurrency

- Put transaction boundaries around one consistency unit, not around unrelated external calls.
- Avoid holding transactions open while calling HTTP APIs, queues, file systems, or user-controlled callbacks.
- Use idempotency keys, unique constraints, upserts, or version checks for retryable workflows.
- Consider isolation level, lock ordering, deadlock risk, and retry behavior for concurrent writes.
- Use optimistic locking/version columns when lost updates matter.

## Review Checklist

- Table grain and ownership are clear.
- Normalization or denormalization decision is justified by integrity, workload, or audit needs.
- Primary keys, foreign keys, unique, check, nullability, and defaults match invariants.
- ORM mappings match migrations and do not leak persistence concerns into domain or presentation layers.
- Query patterns have appropriate indexes and bounded result sets.
- Migrations are ordered, reversible or recoverable, and safe for existing data.
- Transaction scope is explicit and avoids external calls inside long-running transactions.
- Security concerns are covered: parameterization, least privilege, secrets, and tenant isolation.

## Output Contract

When delivering relational DB or ORM work, include:

- Files or database artifacts changed or reviewed.
- Schema/modeling decisions and normalization tradeoffs.
- SQL/ORM/query patterns affected.
- Migration, rollback/recovery, transaction, and locking risks.
- Tests, query-plan checks, or verification run; delegate engine-specific checks to `postgresql` when relevant.
