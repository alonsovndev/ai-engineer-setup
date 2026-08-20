---
name: sentry-observability
description: "Use when working on Sentry or general observability tasks including error tracking, issue triage, alert rules, performance/transaction monitoring, releases, source maps, session replay, cron monitors, and Sentry search/Discover query authoring. Keywords: sentry, observability, issue, error tracking, alert rule, performance, transaction, release, source map, breadcrumb, replay, cron monitor, discover query."
argument-hint: "Describe the system, observability goal, signals available, and artifact type (alert rule/dashboard/query/issue triage/runbook)."
user-invocable: true
---
# Sentry Observability Skill

Use this skill when the task is Sentry-focused or general observability work: triaging issues, defining alert rules, performance/transaction queries, release health, and service health documentation.

## Use This Skill For

- Drafting or refining Sentry dashboard specifications.
- Defining issue alert and metric alert rule requirements, including conditions, actions, and no-data behavior.
- Writing or improving Sentry issue search queries and Discover/Performance queries.
- Designing observability coverage for REST APIs, background jobs, cron schedules, and user-facing services.
- Capturing acceptance criteria for service health, error triage, release health, and operational readiness.

## Do Not Use This Skill For

- Calling Sentry APIs or changing live dashboards/alert rules without explicit user approval.
- Inventing metrics, thresholds, ownership, escalation paths, project/team names, tags, or SLAs.
- Treating dashboards as a substitute for actionable alerts and runbooks.
- Adding SDK instrumentation code when the task is only documentation or query authoring.

## Scope And Constraints

- Work from repository facts only; do not invent metrics, thresholds, ownership, or escalation paths.
- Preserve system terminology used in this repo.
- Keep edits concise; prefer updating existing observability docs over creating new files unless requested.
- Use `TBD` for unknown project names, tag keys, thresholds, owners, and runbook links.

## Signal Selection

- Issues/Errors answer what broke and provide stack traces, breadcrumbs, and context for specific failures.
- Performance/Transactions answer how fast, how often, and where time was spent across spans and service boundaries.
- Releases answer whether a deploy introduced a regression, correlating issues and performance shifts to a specific version.
- Session Replay answers what the user actually experienced when a client-side error or slow interaction occurred.
- Cron Monitors answer whether scheduled jobs ran, finished, and stayed within their expected duration.
- Alerts (issue alerts and metric alerts) answer whether a condition needs a responder now.

## Dashboard Authoring Guidance

- Define dashboard objective and target audience first.
- Organize widgets by operational flow: issue volume/triage, error rate, latency/throughput, release health, dependencies, background jobs, and data-quality signals when relevant.
- For each widget, specify: data source (Issues, Discover, or Releases), query, aggregation, group-by dimensions, and expected interpretation.
- Document useful filters such as `environment`, `project`, `release`, `transaction`, `level`, and `server_name`.
- Prefer dashboards that support a troubleshooting path over dashboards that only display many raw numbers.

## API And Instrumentation Observability

- For REST APIs, cover request throughput, error rate, transaction latency percentiles, status code groups, endpoint/transaction names, dependency spans, and auth failures when available.
- For background jobs and scheduled tasks, cover Cron Monitor check-ins, duration, missed/failed runs, and backlog.
- Tie issues, performance data, and replays together with shared tags such as `environment`, `release`, `server_name`, `trace_id`, and `user` when confirmed.
- Reference Sentry SDK setup (performance monitoring, distributed tracing, source maps for readable stack traces) only when instrumentation is already in place or explicitly requested.

## Alert Rule Guidance

- For each alert rule, document: intent, alert type (issue alert vs. metric alert), condition/trigger, action, evaluation window, and severity.
- Issue alerts trigger on event conditions such as first-seen, regression, frequency, or issue state change.
- Metric alerts trigger on thresholds over aggregated data such as error rate, event frequency, or transaction duration (p50/p95/p99).
- Capture no-data behavior and recovery/resolve expectations.
- Include runbook reference and responder/notification-target expectations when they already exist.
- Separate warning and critical thresholds when supported by source requirements.
- Scope alerts to specific projects/environments to avoid noisy cross-environment triggers.
- Avoid alerting on noisy low-signal issues unless there is a clear operator action.

## Issue Search Query Guidance

- Prefer explicit, reusable Sentry search query patterns with placeholders for project, environment, release, and correlation identifiers.
- Include practical query variants for unresolved errors, regressions, high-frequency issues, release-specific issues, and user-impact triage.
- Provide short notes on when to use each query and expected output signal.

Example placeholders:

```text
is:unresolved level:error environment:<env>
is:unresolved release:<release> project:<project-name>
is:regressed environment:<env>
transaction:<transaction-name> trace_id:<trace-id>
```

## Performance And Discover Query Guidance

- State whether the query is issue-based (search syntax) or performance-based (Discover/Transactions).
- Include aggregation, grouping tags, and evaluation window.
- Use percentiles (p50/p95/p99) for transaction duration where supported; averages can hide tail latency.
- Group by stable low-cardinality dimensions first, such as `transaction`, `environment`, `release`, or `http.status_code`.
- Avoid high-cardinality tags in alert group-bys unless the repo already uses them safely.

## Output Structure

When producing Sentry requirements artifacts, use:

- Objective and scope
- Dashboard requirements
- Alert rule requirements
- Issue search query catalog
- Performance/Discover query catalog
- Release health requirements, if applicable
- Runbook and ownership references
- Assumptions
- Open questions
- Risks and blockers
- Acceptance criteria

## Quality Checklist

- Queries are syntactically consistent and readable.
- Dashboard and alert rule definitions are testable and operationally useful.
- Signal choice matches the operational question being answered.
- Thresholds, windows, owners, and runbooks are sourced or marked `TBD`.
- Alerts identify an expected responder action.
- Tags and project/environment names follow repository or Sentry conventions already in use.
- Existing links and terminology are preserved.
- Related index docs are updated if new observability docs are added.
