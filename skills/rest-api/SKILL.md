---
name: rest-api
description: "Use when designing, reviewing, documenting, testing, or troubleshooting RESTful APIs, HTTP endpoints, OpenAPI specs, status codes, pagination, filtering, idempotency, versioning, auth, or API error contracts. Keywords: REST, RESTful API, HTTP API, endpoint, OpenAPI, Swagger, status code, pagination, idempotency."
argument-hint: "Describe the API, endpoint or spec files, consumer needs, and whether the output is implementation guidance, review, documentation, tests, or OpenAPI changes."
user-invocable: true
---
# REST API Skill

Design, review, and document RESTful APIs with clear HTTP semantics, stable contracts, and practical testability.

## Use This Skill For

- Designing or reviewing REST endpoint paths, methods, status codes, request bodies, and responses.
- Creating or editing OpenAPI/Swagger documentation.
- Troubleshooting API behavior involving auth, pagination, filtering, sorting, validation, errors, or idempotency.
- Defining API acceptance criteria, examples, contract tests, or Postman/Newman smoke coverage.
- Reviewing API backward compatibility and consumer-impact risks.

## Do Not Use This Skill For

- Forcing REST conventions onto GraphQL, gRPC, event-driven APIs, or framework-specific RPC patterns.
- Inventing auth schemes, rate limits, SLAs, ownership, or production URLs not present in source context.
- Replacing existing project API standards with generic preferences unless the user asks for redesign.

## Before Changing An API

1. Read existing route/controller files, OpenAPI specs, API docs, tests, and consumer notes.
2. Identify whether the task affects public contract, internal API, backward compatibility, or only documentation.
3. Preserve existing naming, envelope, pagination, error, auth, and versioning conventions unless they are the issue.
4. Ask before making breaking changes to paths, methods, field names, response shape, status codes, or auth behavior.
5. Keep examples realistic but non-sensitive.

## Resource And Method Guidance

- Use nouns for resources: `/orders`, `/orders/{orderId}`, `/customers/{customerId}/orders`.
- Use HTTP methods for actions: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
- Use action subresources only when the operation does not map cleanly to resource state, such as `/orders/{orderId}/cancellation`.
- Keep path parameters stable and descriptive; avoid vague names like `{id}` when multiple IDs appear in one path.
- Keep query parameters for filtering, sorting, pagination, sparse fields, and search criteria.

## Status Codes And Errors

- Use `200` for successful reads or updates with a response body.
- Use `201` for successful resource creation and include the new resource or its location when the API convention supports it.
- Use `202` for accepted asynchronous work.
- Use `204` for successful operations with no response body.
- Use `400` for malformed or invalid requests, `401` for unauthenticated, `403` for unauthorized, `404` for missing resources, and `409` for state conflicts.
- Keep error responses consistent with the existing project shape.
- Include machine-readable error codes when the existing API contract uses them.

## Pagination, Filtering, And Sorting

- Reuse existing pagination style: page/size, offset/limit, cursor, or token.
- Document default page size, maximum page size, sort fields, and filter operators when known.
- Make pagination metadata explicit enough for clients to fetch the next page.
- Avoid changing pagination semantics without compatibility review.

## Idempotency And Concurrency

- Make retries safe for operations likely to be retried by clients or infrastructure.
- Use idempotency keys for create/payment-like operations when duplicate side effects are a risk.
- Use ETags, versions, or explicit conflict responses when concurrent updates matter.
- Document whether `PUT`, `PATCH`, and `DELETE` are idempotent in this API's context.

## OpenAPI Guidance

- Keep operation summaries short and consumer-focused.
- Define reusable schemas for repeated request, response, and error shapes.
- Include examples only when they clarify required fields or edge cases.
- Mark deprecated fields or endpoints explicitly instead of silently removing them.
- Keep security schemes and server URLs aligned with confirmed deployment facts.

## Testing And Verification

- Prefer contract, integration, or handler tests at the public API seam used by the repo.
- Add or update Postman/Newman smoke tests when the repo uses them for API workflows.
- Verify OpenAPI syntax with the repo's existing linter or generator when available.
- For manual API checks, record method, path, required variables, expected status, and expected response shape.

## Review Checklist

- Path, method, status code, and response shape match existing API conventions.
- Request validation and error shape are explicit and consistent.
- Auth and authorization behavior are documented or tested where relevant.
- Pagination, filtering, sorting, and idempotency are addressed when applicable.
- No sensitive examples, tokens, private hosts, or personal data are committed.
- Backward compatibility risk is called out for public API changes.

## Output Contract

When delivering REST API work, include:

- Files or endpoints changed or reviewed.
- Contract changes, if any, including compatibility risk.
- Tests, OpenAPI validation, or smoke checks run.
- Assumptions and open questions about auth, consumers, data shape, or deployment.
