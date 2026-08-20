---
name: postman
description: "Use when creating, editing, reviewing, or running Postman API collections, environments, tests, pre-request scripts, mocks, monitors, or Newman/Postman CLI automation. Keywords: postman, postam, collection, environment, newman, api client, api tests."
argument-hint: "Describe the API workflow, target collection/environment files, and whether output should be Postman UI guidance, JSON edits, or Newman/Postman CLI commands."
user-invocable: true
---
# Postman Skill

Work with Postman collections and API workflows in a way that is reproducible, safe, and easy to run locally or in CI.

## Use This Skill For

- Creating, editing, or reviewing Postman collection JSON files.
- Designing request folders, variables, authentication, pre-request scripts, and tests.
- Writing Newman or Postman CLI commands for local smoke tests and CI jobs.
- Converting API examples, OpenAPI specs, cURL commands, or endpoint docs into Postman workflows.
- Troubleshooting failed Postman scripts, assertions, variables, auth, or environment selection.

## Do Not Use This Skill For

- Storing secrets, tokens, passwords, API keys, cookies, or private environment values in the repository.
- Inventing base URLs, credentials, tenants, accounts, or production-safe test data.
- Load testing or performance testing beyond lightweight API smoke checks.
- Replacing contract, unit, or integration tests when the codebase already has a stronger test seam.

## Before Editing Collections

1. Read existing collection, environment, API spec, and nearby docs before changing anything.
2. Identify whether files are Postman Collection v2.1 JSON, environment JSON, OpenAPI, or generated artifacts.
3. Preserve existing folder structure, variable names, auth strategy, and script style unless they are the source of the problem.
4. Ask for the minimum missing value when auth, base URL, tenant, or destructive endpoint behavior is unclear.
5. Keep changes small and review generated JSON diffs carefully.

## Collection Design

- Group requests by user-facing workflow or API resource, not by HTTP method alone.
- Name requests as actions, such as `Create Order`, `Get Order By ID`, or `Cancel Order`.
- Prefer collection variables for shared non-secret values like `baseUrl`, `apiVersion`, and reusable IDs.
- Prefer environment variables for deploy-specific values like hostnames, tenant IDs, and feature flags.
- Use `{{variableName}}` consistently; avoid hard-coded hosts and repeated IDs.
- Include representative example request bodies when they clarify required fields.
- Keep examples non-sensitive and safe to commit.

## Authentication And Secrets

- Use variable placeholders for credentials and tokens.
- Do not commit populated secret values in collection, environment, globals, or exported data files.
- Prefer documented setup steps over checked-in secrets.
- Redact tokens, cookies, session IDs, and API keys from examples and logs.
- If a token is acquired by script, store it in an environment or collection variable only for the active run.

## Pre-Request Scripts

- Keep scripts local to the smallest applicable scope: request first, then folder, then collection.
- Use scripts for dynamic IDs, timestamps, signatures, and token acquisition when needed.
- Avoid hidden dependencies on globally stored values; set or validate required variables explicitly.
- Fail fast when required variables are missing.

Example variable guard:

```javascript
const requiredVariables = ["baseUrl", "tenantId"];

for (const variableName of requiredVariables) {
  if (!pm.variables.get(variableName)) {
    throw new Error(`Missing required Postman variable: ${variableName}`);
  }
}
```

## Tests And Assertions

- Assert observable API behavior: status, schema-critical fields, headers, IDs, and error shape.
- Do not assert volatile values unless the API contract requires them.
- Keep assertions independent from implementation details.
- Capture IDs from successful setup requests for later workflow steps.
- Include negative-path tests only when the expected error contract is known.

Example response test:

```javascript
pm.test("returns a successful response", function () {
  pm.response.to.have.status(200);
});

pm.test("returns an id", function () {
  const responseBody = pm.response.json();
  pm.expect(responseBody.id).to.be.a("string").and.not.empty;
});
```

## Newman And Postman CLI

- Prefer `newman run <collection.json> -e <environment.json>` when the repo already uses Newman.
- Prefer the Postman CLI only when the repo already documents it or the user requests it.
- Use CLI flags that make CI output actionable: reporters, bail behavior, timeout, and exported results when useful.
- Pass secrets through CI secret stores or local environment variables, not committed files.

Example Newman smoke command:

```bash
newman run postman/collection.json \
  -e postman/local.environment.json \
  --env-var "token=$API_TOKEN" \
  --bail failure
```

## Review Checklist

- Collection JSON is valid and remains compatible with the existing Postman schema version.
- Requests use shared variables instead of hard-coded environment-specific values.
- No secrets, cookies, session IDs, private URLs, or personal data were added.
- Scripts fail clearly when required inputs are missing.
- Tests assert API behavior that matters and avoid brittle implementation details.
- Destructive requests are clearly named and require explicit variables or setup.
- CLI instructions are runnable from the repository root when paths are provided.

## Output Contract

When delivering Postman work, include:

- Files created or updated.
- Collection/environment/run command affected.
- Required local or CI variables, with secret values marked as external.
- Verification performed, such as JSON validation, Newman run, or manual review.
- Any assumptions, skipped destructive calls, or missing credentials.
