---
name: github-actions
description: "Use when authoring, editing, or reviewing GitHub Actions workflows: jobs, steps, triggers, caching, secrets, matrix builds, reusable workflows, and self-hosted or hosted runner selection. Keywords: github actions, workflow yaml, .github/workflows, CI pipeline, CD pipeline, runner, matrix build, reusable workflow, composite action."
argument-hint: "Describe the pipeline goal, trigger events, target environments, and whether this is a new workflow or a review of an existing one."
user-invocable: true
---

# GitHub Actions Skill

Author and review `.github/workflows/*.yml` pipelines for correctness, security, and speed.

For quality-gate selection inside a job (which checks to run, how to interpret failures), also apply the `quality-gates` skill. For secrets handling and injection risks, also apply the `secure-code-generation` skill. For Terraform/OpenTofu apply gating, also apply the `terraform` skill.

## Use This Skill For

- Writing new CI workflows (lint, type-check, test, build) or CD workflows (deploy, release, tag).
- Reviewing existing workflows for correctness, security, and unnecessary cost.
- Diagnosing a failing or flaky workflow run.
- Designing branch/PR triggers, required checks, and matrix builds.

## Do Not Use This Skill For

- Changing branch protection rules or required-check settings — use the `branch-protection` skill.
- Triggering, cancelling, or re-running workflows on the remote repository without explicit user approval.
- Adding a new CI provider or migrating off GitHub Actions without an explicit request.

## Safety Rules

- Never commit secrets, tokens, or credentials into workflow YAML; use `secrets.<NAME>` / environment secrets, never inline values.
- Do not widen `permissions:` beyond what the workflow needs; default to `permissions: {}` at the workflow level and grant per-job only what's used (e.g. `contents: read`, `pull-requests: write`).
- Pin third-party actions to a full commit SHA (or at minimum a version tag) rather than a mutable branch like `@main`; note the risk if the repo already uses tags.
- Never add `pull_request_target` or workflows that check out and execute PR head code with elevated secrets without flagging the injection risk explicitly.
- Do not disable required status checks, skip tests, or add `continue-on-error: true` to a gating job to force a pipeline green.
- Do not push workflow changes, trigger a run, or approve a deployment environment without explicit user request.

## Workflow Structure

- One workflow file per concern (`ci.yml`, `release.yml`, `deploy.yml`) rather than one monolithic file with many unrelated triggers.
- Name workflows and jobs descriptively (`name:` at workflow and job level) so the Checks tab is scannable.
- Use `concurrency:` with a group keyed on branch/PR to cancel superseded runs on the same ref.
- Prefer reusable workflows (`workflow_call`) or composite actions for logic shared across multiple pipelines instead of copy-pasted steps.
- Keep job-level `if:` conditions simple and readable; extract complex logic into a script step instead of nesting expression syntax.

## Triggers

- Scope `on:` as narrowly as the workflow needs (`paths:`, `paths-ignore:`, `branches:`) to avoid running full pipelines on unrelated changes (docs-only, unrelated directories).
- Use `pull_request` (not `pull_request_target`) for untrusted PR code unless the workflow has been specifically hardened for the target variant.
- For scheduled workflows (`schedule:`), confirm the cron expression's timezone assumption (UTC) and that a missed/late run is tolerable.
- Gate deploy/release triggers on tags, protected branches, or manual `workflow_dispatch` — not on every push to a working branch.

## Jobs And Steps

- Use `actions/checkout`, `actions/setup-node`/`setup-python`/etc. with pinned versions; enable their built-in caching (`cache:` input) before adding a manual cache step.
- Use `actions/cache` keyed on the lockfile hash (`hashFiles('**/package-lock.json')` or equivalent) for dependency caches; include a restore-key fallback.
- Fail fast on the cheapest checks first (lint/type-check before build/test) so feedback is fast, unless the project's convention runs them in parallel jobs.
- Use `matrix:` for genuinely varying dimensions (OS, language version); avoid matrices that only duplicate the same job with no meaningful variation.
- Set explicit `timeout-minutes` on jobs that call external services or could hang, so a stuck job doesn't consume runner minutes indefinitely.
- Upload test/coverage artifacts (`actions/upload-artifact`) on failure for diagnosis, not only on success.

## Secrets And Environments

- Reference `${{ secrets.NAME }}` only inside `env:` or action `with:` inputs, never interpolated directly into `run:` shell strings (this can leak into logs or enable injection); assign to an env var first, then reference the env var in the script.
- Use GitHub Environments (`environment:`) for deploy targets that need protection rules, required reviewers, or environment-scoped secrets.
- Never echo, print, or log secret values, even for debugging; mask custom sensitive values with `::add-mask::` if they must be derived at runtime.
- Scope `GITHUB_TOKEN` permissions per job; avoid `write-all`.

## Runners

- Default to GitHub-hosted runners (`ubuntu-latest`) unless the project has a documented need (licensing, hardware, network access) for self-hosted runners.
- Flag self-hosted runners used with `pull_request` triggers on public/fork-enabled repos as a security risk (arbitrary code execution on infrastructure you control) and recommend `pull_request_target` avoidance plus strict `if:` guards on fork PRs instead.
- Pin runner OS versions (`ubuntu-22.04` vs `ubuntu-latest`) when build reproducibility matters more than always getting the newest image.

## Verification

- Validate YAML syntax before proposing a change (`yamllint`, `actionlint`, or the GitHub web editor's inline validation) when the tool is available.
- Cross-check `needs:` graphs so dependent jobs don't run on failure/skip of a required upstream job when that's unintended.
- Confirm the workflow's declared triggers match what the user actually wants (e.g. don't leave `pull_request` and `pull_request_target` both present unless intentional).

## Reporting Contract

When reviewing or authoring a workflow, report:

- Trigger events and the jobs/steps added or changed.
- Permissions granted and why each is needed.
- Secrets referenced and how they are scoped.
- Caching strategy and its cache key.
- Anything not run/validated locally (e.g. "not tested against a live runner") as residual risk.
