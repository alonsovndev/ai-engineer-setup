---
name: secure-code-generation
description: "Use when generating, editing, or reviewing application code for security: OWASP Top 10, OWASP API Security Top 10, authentication, authorization, input validation, output encoding, injection, XSS, CSRF, SSRF, secrets, cryptography, secure defaults, dependency risks, and security tests. Keywords: secure code, security, OWASP, OWASP Top 10, API security, injection, XSS, CSRF, SSRF, auth, authorization, authentication, secrets, crypto, SAST."
argument-hint: "Describe the feature, stack, data sensitivity, trust boundaries, and whether the task is implementation, review, or security hardening."
user-invocable: true
---
# Secure Code Generation Skill

Generate and review application code with secure defaults, explicit trust boundaries, and OWASP-aware checks. Treat security as part of the feature, not a late cleanup pass.

## Use This Skill For

- Adding or reviewing application, API, backend, frontend, CLI, batch, or integration code with security impact.
- Checking code against OWASP Top 10 and OWASP API Security Top 10 themes.
- Designing validation, authorization, secrets handling, secure error responses, logging, and dependency safeguards.
- Reviewing generated code for injection, XSS, SSRF, CSRF, broken access control, insecure deserialization, and unsafe defaults.
- Choosing security-focused tests or quality gates with `quality-gates`.

## Do Not Use This Skill For

- AI agent-specific OWASP Agentic Security Initiative compliance; use an agentic security skill when installed.
- Live penetration testing, scanning external systems, or calling security services without explicit approval.
- Inventing security policy, data classification, regulatory requirements, owners, or threat models not present in context.
- Adding dependencies, cryptographic schemes, or infrastructure controls without a concrete need and explicit approval when required.
- Hiding security failures by weakening tests, linters, scanners, or CI gates.

## First Checks

1. Read project security docs, local instructions, route/controller code, data models, auth middleware, validation code, and tests relevant to the change.
2. Identify trust boundaries: user input, service-to-service input, files, environment variables, queues, webhooks, third-party APIs, and database data reused as output.
3. Identify sensitive data: credentials, tokens, PII, financial data, health data, tenant identifiers, internal URLs, and audit data.
4. Preserve existing security architecture and framework conventions unless they are the source of the risk.
5. Ask before changing auth behavior, authorization policy, encryption, token lifetime, CORS, cookie policy, or externally visible error contracts.

## OWASP Top 10 Focus Areas

| Risk theme | Secure generation rule |
|---|---|
| Broken access control | Enforce authorization server-side on every protected resource and object-level action. Never rely on hidden UI controls. |
| Cryptographic failures | Do not invent crypto. Use vetted libraries and existing key management. Never log or expose secrets. |
| Injection | Use parameterized queries, safe command APIs, structured builders, and allowlists. Never concatenate untrusted input into SQL, shell, LDAP, templates, or queries. |
| Insecure design | Make abuse cases explicit for security-sensitive flows and choose secure defaults. |
| Security misconfiguration | Avoid permissive CORS, debug mode, verbose errors, public admin endpoints, broad actuator/metrics exposure, and default credentials. |
| Vulnerable components | Prefer existing dependencies. Do not add packages casually. Respect lockfiles and dependency scanning. |
| Auth failures | Use existing auth framework, secure session/cookie flags, token validation, rotation, expiration, and replay protections. |
| Integrity failures | Verify webhooks, signed payloads, artifacts, redirects, and update sources where relevant. |
| Logging failures | Log security events without secrets or personal data; include correlation IDs and outcomes. |
| SSRF/deserialization | Validate outbound targets with allowlists and avoid unsafe deserialization of untrusted data. |

## OWASP API Security Focus Areas

- Enforce object-level authorization for `/{id}` and tenant-scoped resources.
- Enforce function-level authorization for admin, export, import, delete, billing, and configuration endpoints.
- Validate request bodies, query parameters, path parameters, headers, and uploaded files.
- Limit payload size, pagination size, batch size, file size, and request rate where the project supports it.
- Avoid exposing internal IDs, stack traces, secrets, excessive object fields, or cross-tenant data.
- Protect mass-assignment by mapping accepted fields explicitly instead of binding full persistence models to requests.
- Use safe defaults for CORS, cookies, cache headers, redirects, and content types.
- Verify webhook signatures and reject replayed or stale messages when timestamps are available.

## Input And Output Handling

- Treat all external input as untrusted, including files, headers, webhooks, queue messages, database content from other systems, and environment variables.
- Validate at the boundary and again before dangerous sinks when the path is complex.
- Prefer allowlists over denylists for identifiers, enum values, sort fields, redirect targets, file extensions, and outbound hosts.
- Encode output for the target context: HTML, attribute, JavaScript, URL, shell, SQL, JSON, or log.
- Keep validation errors useful but not revealing.

## Authentication And Authorization

- Reuse existing auth middleware and policy mechanisms.
- Check authorization using the authenticated principal, tenant/context, requested action, and target resource.
- Do not trust client-provided role, tenant, owner, or permission fields.
- Deny by default when identity, tenant, ownership, or policy cannot be resolved.
- Keep admin or service-account paths explicit and tested.

## Secrets And Sensitive Data

- Do not commit secrets, tokens, keys, certificates, `.env` files, cookies, or generated credentials.
- Do not print, log, return, snapshot, or include secrets in errors or test fixtures.
- Load secrets from the existing secret/config mechanism.
- Redact sensitive values in logs and API responses.
- Use realistic placeholders such as `<API_TOKEN>` rather than fake-looking real secrets.

## Database, Files, And Commands

- Use parameterized database APIs and ORM-safe query methods.
- Do not build shell commands from untrusted input; prefer argument arrays and no shell interpolation.
- Normalize and constrain file paths before reading or writing user-selected files.
- Store uploaded files outside executable paths and validate type, size, and name.
- Avoid unsafe deserialization formats and constructors for untrusted content.

## Frontend And Browser Security

- Do not render untrusted HTML unless it is sanitized by an established project-approved sanitizer.
- Avoid `dangerouslySetInnerHTML`, direct DOM injection, and string-built scripts.
- Protect tokens from XSS; prefer secure, HTTP-only cookies when that matches the app architecture.
- Keep CSRF protection for cookie-authenticated state-changing requests.
- Avoid leaking sensitive data through URLs, browser storage, analytics, logs, or error tracking.

## Error Handling And Logging

- Return generic errors for auth failures and internal faults.
- Preserve enough server-side context for investigation without logging secrets or sensitive payloads.
- Log security-relevant outcomes such as denied access, failed validation, replay rejection, webhook verification failure, and suspicious rate patterns.
- Use structured logs and correlation IDs when the project supports them.

## Security Tests And Verification

- Add focused tests for authorization, tenant isolation, validation, malicious input, and security regressions where relevant.
- Include negative tests: unauthorized principal, wrong tenant, missing role, invalid ID, oversized payload, bad signature, unsafe redirect, and injection payload.
- Use existing SAST, dependency scanning, secret scanning, lint, and test commands through `quality-gates`.
- If security tooling is missing, report the gap instead of claiming coverage.

## Review Checklist

- Trust boundaries and sensitive data are identified.
- Access control is enforced server-side and object-level where needed.
- Inputs are validated and dangerous sinks are protected.
- Outputs, logs, and errors do not leak secrets or sensitive data.
- No permissive CORS, debug settings, broad admin exposure, or insecure defaults were introduced.
- New dependencies are necessary, reviewed, and compatible with lockfile/scanning conventions.
- Security behavior has focused tests or a stated verification gap.

## Output Contract

When delivering secure code generation work, include:

- Files changed or reviewed.
- Security risks addressed or intentionally out of scope.
- Auth, validation, secrets, logging, dependency, or data-exposure decisions made.
- Tests and security checks run through `quality-gates`.
- Residual risks, assumptions, and any needed human/security review.
