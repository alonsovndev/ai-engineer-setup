# Bug Template

Copy this template to report data/platform defects. Focus on reproducible evidence for issues like stale data, missing tables, schema mismatches, and connection failures.

## Required Fields

### Title

**Format**: `[Domain/Component] Data Issue Description`

Examples:

- `[Revenue Dashboard] Data not refreshed since 2026-05-26 02:00 UTC`
- `[Warehouse] Missing table analytics.customer_orders`
- `[Ingestion Job] Connection timeout to Postgres source`

Make the title specific enough to identify impacted data asset and symptom.

### Severity

How critical is this issue? Choose one:

- **Critical**: System down, data loss, security breach, or severe feature unavailable
- **High**: Feature partially broken, workaround difficult, affecting multiple users
- **Medium**: Feature broken but workaround exists, limited user impact
- **Low**: Minor issue, cosmetic, or affecting one user only

### Environment

Where was the bug found? Choose one or more:

- `Development` (dev/local machine)
- `Production` (live system)

Also include:

- Data platform/environment (example: Snowflake prod)
- Pipeline/orchestrator (example: Airflow DAG, dbt job)

### Description

Provide the following sections:

```
## What is the issue?
Brief summary of the data/platform failure.

## What should happen?
Describe expected freshness, availability, schema, or connectivity behavior.

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Etc.]

## Environment
- Environment: [Development/Production]
- Data platform: [Snowflake, Postgres, etc.]
- Pipeline/job: [DAG name, dbt model]
- Affected dataset/table: [schema.table]
- First observed: [Date/time with timezone]

## Evidence
- Expected vs actual result (include row counts/timestamps where possible)
- Error message/code (exact text)
- Query ID / Job Run ID / Trace ID
- Last successful refresh timestamp

## Additional Context
- SQL query or API call used to validate the issue
- Screenshots, logs, stack traces
- Frequency: Always / Sometimes / One-time
- Workaround: [If available]
```

## Optional Fields

### Affected Component

Which component is broken? Examples: `Ingestion Connector`, `Airflow DAG`, `dbt Model`, `Warehouse`

### Affected Data Scope

Document impact scope clearly:

- Affected tables/views
- Affected date range/partition
- Affected consumers (dashboards, reports, downstream jobs)

### Root Cause (if known)

If you've identified the cause, document it:

```
Root Cause: Source connector credentials expired at 02:00 UTC.
Ingestion failed for 4 hourly runs, so downstream table was not refreshed.
```

### Linked Issues

Link to related bugs, stories, or the epic if applicable:

- **Blocks**: If this bug is preventing other work
- **Duplicates**: If this is a repeat of another bug
- **Caused By**: If a recent change introduced this bug

## Optional: Acceptance Criteria

Define what fixing this bug means:

```
✓ Data freshness SLA restored (for example <= 60 minutes lag)
✓ Missing table/view recreated and queryable
✓ Connection retries and alerting validated
✓ Backfill completed for affected window
✓ Regression test/monitor added
```

---

## Example (Filled)

**Title**: `[Revenue Dashboard] Data not refreshed for daily sales metrics`

**Severity**: `High`

**Environment**: `Production`

**Description**:

```
## What is the issue?
Daily revenue dashboard shows yesterday's numbers all day.
The source fact table was last updated at 2026-05-27 01:00 UTC.

## What should happen?
Dashboard should reflect hourly refreshes with max 60-minute lag.

## Steps to Reproduce
1. Open BI dashboard "Revenue - Daily Overview"
2. Compare value for current date with source table query result
3. Check table metadata for last updated timestamp
4. Verify Airflow DAG run history for `revenue_hourly_pipeline`
5. Observe failed connection runs and stale table data

## Environment
- Environment: Production
- Data platform: Snowflake
- Pipeline/job: revenue_hourly_pipeline (Airflow)
- Affected dataset/table: analytics.fact_revenue_daily
- First observed: 2026-05-28 08:10 UTC

## Evidence
- Expected: latest record timestamp >= now() - 60 minutes
- Actual: latest record timestamp = 2026-05-27 01:00 UTC
- Error: "FATAL: password authentication failed for user etl_reader"
- Airflow Run IDs: scheduled__2026-05-28T02:00:00+00:00 to +05:00:00
- Last successful refresh: 2026-05-27 01:00 UTC

## Additional Context
- Validation query:
	SELECT MAX(updated_at) FROM analytics.fact_revenue_daily;
- Frequency: Always since first failed run
- Workaround: Manual rerun with temporary credential update
```

**Affected Component**: `Airflow DAG`, `Snowflake Warehouse`, `Revenue Dashboard`

**Root Cause**: Warehouse source credentials rotated but were not updated in Airflow connection. Five consecutive hourly runs failed; downstream table remained stale.

**Acceptance Criteria**:
```
✓ Connection secret updated and validated in production
✓ Failed windows backfilled for 2026-05-28 02:00-05:00 UTC
✓ Dashboard values match source queries
✓ Alert includes actionable error context (connection id, job run id)
```

---

## Quick Tips

- **No evidence, no bug quality:** Include query results, timestamps, and exact errors
- **Freshness issue?** Always provide expected SLA and actual lag
- **Missing table?** Include exact `schema.table` and where it is referenced
- **Connection error?** Include connector/connection id and run ids
- **Already reported?** Search for duplicates before creating
- **Security issue?** Use confidential/private flag if supported
