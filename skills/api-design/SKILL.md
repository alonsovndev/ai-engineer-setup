---
name: api-design
description: Use this skill when designing, reviewing, or modifying HTTP API contracts, endpoints, schemas, and compatibility behavior.
---

When API behavior is introduced or changed, use this skill to keep contracts explicit, consistent, and safe to evolve.

## When to Use This Skill

Activate this skill when the user:

- Asks to create or change REST endpoints
- Needs request and response schema design
- Mentions versioning, compatibility, or breaking changes
- Wants consistent error handling and status semantics

## How to Apply This Skill

### Step 1: Define Contract Intent

- Clarify resource boundaries and endpoint responsibilities
- Map required operations to HTTP verbs and status codes

### Step 2: Shape Schemas

- Define request and response fields explicitly
- Include validation rules and optional vs required fields
- Add machine-readable error codes and stable error structure

### Step 3: Evaluate Evolution Safety

- Identify breaking vs non-breaking changes
- Propose versioning or migration strategy when needed
- Confirm list endpoints support pagination and filtering

### Step 4: Confirm Implementation Readiness

- Ensure auth and permission requirements are explicit
- Ensure examples/tests can validate the contract behavior

## Guidelines

- Prefer predictable naming and resource-oriented URLs
- Keep error payload shape consistent across endpoints
- Avoid silent behavior changes without version notes
- Treat contract changes as product-impacting decisions
