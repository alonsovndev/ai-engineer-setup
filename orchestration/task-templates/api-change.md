# API Change Task Template

Workflow for adding or modifying HTTP API endpoints with contract review.

## Workflow

```
Contract Design → Implementation → Database (if needed) → Contract Review → Gates
```

## Phase 1: Contract Design

**Skills**: `api-design`, `rest-api`

- Define endpoint: method, path, request schema, response schema
- Specify status codes for success, validation errors, not found, conflicts, server errors
- Define pagination, filtering, sorting if applicable
- Define error response format (consistent envelope or problem details)
- Consider backward compatibility: breaking vs. non-breaking changes
- Document idempotency requirements for mutating endpoints
- Output: API contract (OpenAPI spec or structured document)

## Phase 2: Implementation

**Agent**: `python-api` (FastAPI) or domain subagent based on stack
**Skills**: `python-fastapi-ddd`, `clean-architecture-ddd`

### Presentation Layer
- REST controller/handler with request validation
- Request/response DTOs (Pydantic schemas for Python)
- Input validation at the boundary
- HTTP status mapping

### Application Layer
- Use case that orchestrates the workflow
- Command/query DTOs as inputs
- Port usage, not concrete adapter calls

### Domain Layer
- Entities, value objects, domain services involved
- Repository ports if persistence is needed
- Business invariants in domain objects

### Infrastructure Layer
- Repository implementations
- ORM models, external API clients
- Persistence model ↔ domain entity mapping

### Composition Root
- Wire dependencies for the new endpoint

## Phase 3: Database Changes (if applicable)

**Agent**: `postgresql`
**Skills**: `relational-db-orm`

- Schema changes: new tables, columns, indexes, constraints
- Migration file with rollback strategy
- Index strategy for query patterns
- Data migration if backfilling existing records
- Output: migration files and schema review

## Phase 4: API Contract Review

**Skills**: `api-design`, `rest-api`, `secure-code-generation`

- Request/response schemas match the contract
- Status codes are correct and consistent
- Error responses follow the project's error format
- Authentication and authorization checks present
- Input validation covers edge cases (empty, oversized, malformed)
- Rate limiting or throttling considered for public endpoints
- Backward compatibility: does this break existing consumers?
- Output: contract compliance findings

## Phase 5: Security Review (triggered for auth/data endpoints)

**Skills**: `secure-code-generation`, `security-basics`

- Authentication required on protected endpoints
- Authorization checks for resource ownership
- No sensitive data in logs or error responses
- Input sanitization against injection
- CORS configuration appropriate
- Output: security findings

## Phase 6: Quality Gates

Run required gates from `orchestration/quality-gates.md`:

- Lint, format, type-check, tests, build
- **API Contract gate**: contract compliance verified
- **Security gate**: auth, validation, injection checks pass
- **Migration gate** (if database changes): reversible, non-destructive
- **Performance gate** (if query-heavy): no N+1, indexes fit

## Done Criteria

- Endpoint implemented and matches contract
- All required and conditional quality gates pass
- Tests cover happy path, validation errors, auth failures
- No blocking or critical findings from reviews
- Changes committed with conventional commit message (type: `feat` or `fix`)
