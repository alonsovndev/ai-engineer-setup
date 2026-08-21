# Quality Gates

All changes must satisfy required gates. Conditional gates apply when their triggers are relevant.

## Required Gates (All Changes)

| Gate | Check | How to Verify |
|---|---|---|
| **Lint** | Code style and static analysis pass | `npm run lint`, `ruff check`, `eslint`, or project equivalent |
| **Format** | Code formatting matches project config | `npm run format`, `ruff format`, `prettier`, or project equivalent |
| **Type Check** | No type errors in touched files | `tsc --noEmit`, `pyright`, `mypy`, or project equivalent |
| **Tests** | Tests pass for touched areas | `npm test`, `pytest`, or project equivalent; or document why tests don't exist |
| **Build** | Project builds without errors | `npm run build`, `vite build`, or project equivalent |

If no test framework, lint config, or build script exists, state that explicitly and use the best available smoke test or manual verification.

## Conditional Gates (Trigger When Relevant)

| Trigger | Gate | Check |
|---|---|---|
| API request/response surface changes | **API Contract** | Request/response schemas match, status codes correct, error contract consistent |
| Auth, permissions, secrets, tokens | **Security** | No hardcoded secrets, input validation present, auth checks in place, OWASP basics covered |
| Database schema or query changes | **Migration Safety** | Migration is reversible, non-destructive or phased, indexes added concurrently if needed |
| Query or hot-path changes | **Performance** | No N+1 patterns, indexes fit queries, no unnecessary allocations or re-renders |
| New external service calls | **Resilience** | Timeouts configured, retries bounded, circuit breaker or fallback considered |
| UI component changes | **Accessibility** | Interactive elements have accessible names, keyboard navigation works, color contrast sufficient |

## Clean Architecture Gates

When working with Clean Architecture / Hexagonal / DDD:

| Gate | Check |
|---|---|
| **Layer Placement** | Code is in the correct layer (domain, application, infrastructure, presentation) |
| **Dependency Direction** | No inner layer imports an outer layer; dependencies point inward |
| **Domain Purity** | Domain has no framework, ORM, HTTP, or infrastructure dependencies |
| **Use Case Design** | Each use case orchestrates one workflow via ports, not concrete adapters |
| **Composition Root** | Concrete wiring happens in one place; no hidden service locators |
| **Testability** | Domain and application logic can be tested without database, network, or framework startup |
| **DTO Boundaries** | External contracts don't leak ORM or domain internals unintentionally |

## Gate Status Values

- **pass**: Check ran and succeeded
- **fail**: Check ran and failed — must be fixed
- **skipped**: Check not applicable — reason documented
- **blocked**: Check cannot run — missing config, dependency, or environment

## Reporting

After each implementation step, report gate status:

```
## Quality Gates
- Lint: pass | fail | skipped (reason) | blocked (reason)
- Format: pass | fail | skipped (reason) | blocked (reason)
- Type Check: pass | fail | skipped (reason) | blocked (reason)
- Tests: pass | fail | skipped (reason) | blocked (reason)
- Build: pass | fail | skipped (reason) | blocked (reason)
- [Conditional gates as applicable]
```

A change is merge-ready only when all required gates are **pass** or **skipped** (with reason), and all triggered conditional gates are **pass** or **skipped** (with reason).
