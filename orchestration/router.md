# Orchestration Router

Routes work to the appropriate domain subagent. Prefer one primary subagent at a time; add quality/contract subagents only when triggers match.

## Primary Domain Routing

| Domain | Trigger | Primary Subagent | Skills to Load |
|---|---|---|---|
| **Frontend UI** | React components, hooks, state, AntD usage, type safety, accessibility | `react-ui` | `react-vite-antd`, `component-design`, `state-management` |
| **Backend Services** | FastAPI routes, use cases, domain logic, DI wiring, layer placement | `python-api` | `python-fastapi-ddd`, `clean-architecture-ddd`, `api-design` |
| **Database** | Schema design, SQL, migrations, indexing, ORM models, repository persistence | `postgresql` | `relational-db-orm`, `database-design` |
| **Infrastructure** | Terraform/OpenTofu modules, providers, state, IAM, CI/CD workflow | `terraform` | `terraform` |
| **Cross-stack Architecture** | Layer boundaries, dependency direction, ports & adapters, DDD aggregates | `clean-architecture` | `clean-architecture-ddd`, `design-patterns` |
| **Visual/UX Review** | Visual hierarchy, animation, responsive behavior, polish | `frontend-design` | `frontend-design`, `component-design` |
| **Requirements** | Backlog, acceptance criteria, user stories, prioritization | `product-ba` | `agile-planning`, `technical-writer` |
| **Architecture Planning** | C4 diagrams, ADRs, technical planning, sequencing, risk analysis | `tech-lead` | `diagram-author`, `technical-writer` |
| **Post-change Review** | Correctness, security, tests, verification before completion | `code-review` | `quality-gates`, `secure-code-generation` |

## Secondary (Triggered) Routing

| Trigger | Subagent / Skill |
|---|---|
| API request/response surface changes | `api-design` skill + `rest-api` skill |
| Auth, JWT, tokens, permissions, secrets | `secure-code-generation` skill + `security-basics` skill |
| Unknown regressions, flaky behavior | `test-strategy` skill |
| Missing or weak tests for touched code | `test-strategy` or `tdd` skill |
| Query or hot-path performance concerns | `postgresql` subagent (database) or `quality-gates` skill |
| Redux state, slices, selectors, RTK Query | `redux-logic` skill |
| GitHub Actions workflow changes | `github-actions` skill |
| Sentry/observability changes | `sentry-observability` skill |

## Routing Rules

1. **Start with scope**: Identify which domain the work touches first.
2. **One primary at a time**: Route to one domain subagent; add others only when findings reveal cross-domain concerns.
3. **Serial over fan-out**: Hand off sequentially — requirements → architecture → implementation → review.
4. **Do not over-delegate**: If the main agent can handle it directly with a skill, do so.
5. **Preserve conventions**: Do not impose architecture patterns on projects that don't use them unless explicitly requested.

## Platform Notes

- **opencode**: Subagents are defined in `agents/opencode/*.md`. Skills in `skills/`.
- **Claude Code**: Subagents are defined in `agents/claude/*.md`. Skills in `skills/`.
- **Copilot CLI**: Agents are defined in `agents/copilot/*.agent.md`. Skills in `skills/`.

All three platforms share the same skill directory and instructions. Router logic is identical; only the agent file format differs.
