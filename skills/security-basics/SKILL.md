---
name: security-basics
description: Use this skill for baseline application security checks during feature implementation, refactors, and code review.
---

When shipping or reviewing changes, use this skill to enforce practical default security controls aligned with OWASP Top 10.

## When to Use This Skill

Activate this skill when the user:

- Adds auth, permissions, or user-facing input handling
- Integrates external services, webhooks, or token-based flows
- Requests a security review before release
- Fixes vulnerabilities or abuse-prone behavior
- Asks for OWASP Top 10-aligned hardening or validation

## How to Apply This Skill

### Step 1: Review Trust Boundaries

- Identify untrusted inputs, external calls, and sensitive operations
- Confirm validation and sanitization at entry points

### Step 2: Enforce Access Controls

- Verify authentication and authorization checks are explicit
- Confirm role/permission checks protect sensitive actions

### Step 3: Protect Secrets and Transport

- Ensure secrets are not hardcoded or logged
- Use secure defaults for tokens, cookies, and HTTPS transport

### Step 4: Add Operational Safeguards

- Apply rate limits and abuse controls where relevant
- Add audit logging for sensitive behavior and investigations

### Step 5: Check Against OWASP Top 10

- Review the change for relevant OWASP Top 10 risk categories
- Call out mitigations and any remaining gaps explicitly
- Prioritize fixes for high-impact categories before release

## Guidelines

- Favor deny-by-default access decisions
- Minimize exposed sensitive data in responses and logs
- Keep error details safe while still actionable
- Treat security regressions as release-blocking risks
- Use OWASP Top 10 as a default threat-model checklist for web-facing features
