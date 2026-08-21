# Feature Task Template

Full-stack feature workflow using vertical slicing and Clean Architecture.

## Workflow

```
Requirements → Architecture Plan → Vertical Slice Implementation → Review → Gates
```

## Phase 1: Requirements

**Agent**: `product-ba`
**Skills**: `agile-planning`, `technical-writer`

- Define objective, scope, constraints
- Write functional and non-functional requirements
- Define acceptance criteria (Given/When/Then format)
- Identify dependencies and risks
- Output: work items with acceptance criteria

## Phase 2: Architecture Plan (if needed)

**Agent**: `tech-lead` (for complex features) or skip for simple additions
**Skills**: `diagram-author`, `clean-architecture-ddd`

- Review existing architecture and conventions
- Identify which layers the feature touches
- Define component/use-case boundaries
- Plan data flow and API contracts
- Output: implementation plan with layer assignments

## Phase 3: Vertical Slice Implementation

**Build mode** with `vertical-slicing` + `clean-architecture-ddd` + stack-specific skills

Implement one complete vertical slice at a time. Each slice includes:

1. **Domain layer** — entities, value objects, domain services, repository ports
2. **Application layer** — use case, command/query DTOs, orchestration
3. **Infrastructure layer** — repository implementation, ORM models, external clients
4. **Presentation layer** — REST controller or UI component, request/response DTOs
5. **Composition root** — wire dependencies
6. **Tests** — unit tests for domain/application, integration tests for infrastructure/presentation

### Vertical Slicing Rules

- One feature slice at a time; do not start the next slice until the current one passes all gates
- Each slice is independently testable and potentially shippable
- Slice across all layers: presentation → application → domain → infrastructure → tests
- Keep slices thin: one user action, one use case, one data flow
- Use `clean-architecture-ddd` skill to enforce layer boundaries within each slice

### Clean Architecture Rules Within Each Slice

- Domain: no framework, ORM, HTTP, or infrastructure dependencies
- Application: depends on domain ports, not concrete adapters
- Infrastructure: implements ports, no business invariants
- Presentation: calls use cases, does not orchestrate repositories directly
- Composition root: single wiring point for concrete implementations
- Dependencies point inward; never reverse

## Phase 4: Domain-Specific Review

**Agent**: Route based on what the slice touches

| What was built | Review agent | Skills |
|---|---|---|
| React components, hooks, state | `react-ui` | `react-vite-antd`, `component-design` |
| FastAPI routes, use cases, DI | `python-api` | `python-fastapi-ddd`, `clean-architecture-ddd` |
| Schema, queries, migrations | `postgresql` | `relational-db-orm` |
| Visual polish, animation, responsive | `frontend-design` | `frontend-design` |

## Phase 5: Cross-Cutting Review

**Agent**: `code-review` (read-only, `edit: deny`)
**Skills**: `quality-gates`, `secure-code-generation`

- Correctness, edge cases, error handling
- Security: secrets, injection, auth checks
- Architecture: layer boundaries, dependency direction
- Tests: coverage of changed behavior
- Output: findings with severity (critical, blocking, advisory)

## Phase 6: Quality Gates

Run all required gates from `orchestration/quality-gates.md`:

- Lint, format, type-check, tests, build
- Conditional gates as triggered (API contract, security, migration, performance, accessibility)
- Clean Architecture gates (layer placement, dependency direction, domain purity, testability)

Report gate status. Fix any failures. Re-run gates.

## Done Criteria

- All acceptance criteria met
- All required quality gates pass
- All triggered conditional gates pass
- No blocking or critical findings from reviews
- Changes committed with conventional commit message
