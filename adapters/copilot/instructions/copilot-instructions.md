# Workspace Guidelines

These guidelines apply to all chat requests across the workspace. They establish baseline expectations for code style, architecture patterns, and operational practices across all agents in this workspace.

Instruction governance for multi-project usage:
- See [Instruction Precedence](./INSTRUCTION-PRECEDENCE.md) for source priority and conflict handling.
- See [Agent Registry](#agent-registry) for the active agents and how work routes between them.
- See [Performance Budget](./PERFORMANCE-BUDGET.md) for response-size and context-size limits.

## Agent Registry

Active agents in this workspace. Every file in `agents/` is listed here; keep this list in sync when agents are added or removed (`scripts/verify.sh` enforces it).

1. `react-ui` (`agents/react-ui.agent.md`)
   - Purpose: React components, hooks, state management, Ant Design usage, type safety, and accessibility.
2. `python-api` (`agents/python-api.agent.md`)
   - Purpose: FastAPI routes, use cases, domain logic, DI wiring, and layer placement in Python DDD codebases.
3. `postgresql` (`agents/postgresql.agent.md`)
   - Purpose: PostgreSQL schema, SQL, migration, indexing, transaction, access-control, and ORM integration work.
   - Use `relational-db-orm` for cross-RDBMS schema design, SQLAlchemy/JPA/Hibernate mapping, table normalization, constraints, and ORM tradeoffs before PostgreSQL-specific review.
4. `terraform` (`agents/terraform.agent.md`)
   - Purpose: Terraform/OpenTofu module, plan, state, provider/backend, import, IAM/security, and CI/CD workflow work.
5. `clean-architecture` (`agents/clean-architecture.agent.md`)
   - Purpose: cross-stack layer boundaries, dependency direction, ports and adapters, and DDD aggregate design.
6. `frontend-design` (`agents/frontend-design.agent.md`)
   - Purpose: visual hierarchy, animation, responsive behavior, and UI polish. Not component architecture — use `react-ui` for that.
7. `product-ba` (`agents/product-ba.agent.md`)
   - Purpose: product ownership, business analysis, requirements discovery, backlog definition, and delivery-ready planning artifacts.
8. `tech-lead` (`agents/tech-lead.agent.md`)
   - Purpose: C4 diagrams, ADRs, technical planning, sequencing, delivery risk, and quality gates.
9. `code-review` (`agents/code-review.agent.md`)
   - Purpose: post-change review for correctness, security, tests, and verification evidence before completion.
10. `bug-finder` (`agents/bug-finder.agent.md`)
    - Purpose: proactive correctness sweep of a file, module, or repository, independent of any specific diff.
11. `doc-tracker` (`agents/doc-tracker.agent.md`)
    - Purpose: documentation drift detection and targeted corrections when docs no longer match the code.

Routing notes:
- Route discovery and requirement clarification to `product-ba`; route architecture and execution planning to `tech-lead`.
- Route stack work to the matching domain agent: `react-ui` (frontend), `python-api` (backend), `postgresql` (database), `terraform` (infrastructure).
- Route review work by intent: `code-review` for a just-made change, `bug-finder` for an untargeted sweep, `clean-architecture` for boundary and dependency-direction questions, `frontend-design` for visual and motion quality, `doc-tracker` for stale documentation.
- Prefer one primary agent at a time; add a second only when findings reveal a cross-domain concern.

## Documentation
- Write clear, actionable documentation.
- Mark unknowns as `TBD`; don't invent facts.
- Use the `technical-writer` skill for repository documentation, runbooks, ADRs, and planning artifacts.
- Use the `markdown-author` skill for Markdown structure, headings, lists, tables, and link quality.
- Use the `mermaid-author` skill for Mermaid diagram syntax, labels, rendering, and placement.
- Use the `drawio-author` skill for Draw.io XML, shape styles, labels, layout, and placement.

## Git and Version Control
- Keep commits focused; use clear, descriptive messages.
- Do not add AI or tool co-author trailers or attribution (e.g., `Co-authored-by: ...`) to commit messages.
- Prefer feature branches; require tests and review before merging.
- Before staging and again before a requested commit, check the current branch. Never stage or commit on `main`, `master`, `dev`, or a detached HEAD. Commit on any other named working branch; `feature/*`, `fix/*`, and `hotfix/*` are examples.
- Do not commit changes unless the user explicitly asks for a commit, or invokes a create-PR command or skill — that invocation counts as an explicit request to commit the current changes (splitting them logically), push the working branch, and create the PR.
- Never push commits on `main`, `master`, `dev`, or a detached HEAD — not even with explicit approval, and not within the create-PR flow. Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch), and only when the user explicitly asks or the create-PR flow has been invoked. If a protected branch needs a push, do the local step and give the user the exact command to run.
- Use the `git-repo-flow`, `git-commit`, and `git-create-pr` skills for detailed workflow rules.

## Repository Conventions
- Follow existing folder structure and naming conventions.
- Keep documentation and configuration current.
- Prefer repository-local docs under `docs/` for detailed setup, workflow, and troubleshooting guidance.

## Non-Negotiable Rules

These rules apply to **all** work. Violations block completion.

### Security
- **Never commit credentials, API keys, secrets, or PII to version control.** All secrets go in environment variables, `.env`, or a secret manager. If detected, revert immediately.
- For secure code generation, apply OWASP Top 10 and OWASP API Security Top 10 thinking: server-side authorization, input validation, output encoding, injection prevention, XSS/CSRF/SSRF safeguards, safe secrets handling, secure defaults, and focused security tests.
- Use the `secure-code-generation` skill for application/API security work. Use `agent-owasp-compliance` only for OWASP Agentic Security Initiative compliance on AI agent systems when that skill is installed.


### Communication and Token Efficiency
- **Default to low verbosity.** Keep responses concise unless the user explicitly asks for more detail.
- Use the `context-efficiency` skill for low-verbosity mode, response budgets, context trimming, concise handoffs, and caveman-like terse responses without quality loss.
- **Do not explain obvious code or standard concepts** unless asked.
- **Prioritize outcome-first responses:** state the result first, then only essential details.
- **Avoid repetition across sections and turns.** Do not restate unchanged plans or context.
- **Use compact structure:** short bullets, direct language, and minimal prose.
- **Include only relevant file references, logs, and command output summaries.** Omit noisy or redundant detail.
- **Ask clarifying questions only when they unblock execution.** Otherwise proceed with the best safe assumption.
- **Do not generate large boilerplate text when a targeted answer or minimal diff is sufficient.**


### Unknowns and Facts
- **Never invent facts:** owners, SLAs, timelines, credentials, URLs, hosting topology, or infrastructure decisions.
- **Always mark unknowns as `TBD`** and call them out explicitly when a decision cannot proceed.

### Breaking Changes
- **All breaking changes must be explicitly documented** with migration steps.

### Incomplete Work
- **Do not claim a task complete if:** tests are failing, unknowns are unresolved, or acceptance criteria are not met.
- **Flag blockers and open questions** before returning; don't hide them.

## Core Work Principles

### Think Before Acting
- Plan the approach before making changes.
- Clarify requirements and unknowns before diving into implementation.
- Consider trade-offs and edge cases upfront.

### Edit the Minimum
- Make the smallest, most focused changes that solve the problem.
- Avoid over-engineering, refactoring unrelated code, or gold-plating.
- If a change affects multiple files, keep each edit scoped and necessary.
- Prefer local code until reuse, boundary protection, or testability creates a real extraction need.
- Accept small duplication when a shared abstraction would be harder to understand or change.
- Apply KISS and YAGNI before DRY or SOLID when the abstraction is speculative.
- Use the `programming-principles` skill for SOLID, KISS, DRY, YAGNI, coupling, cohesion, or abstraction tradeoff reviews.

### Don't Repeat Code (DRY)
- Identify and extract duplicate logic into shared functions or modules.
- Reference existing utilities instead of reimplementing.
- When updating similar patterns, update all instances consistently.
- Do not add helpers, interfaces, factories, builders, flags, or base classes for hypothetical future use.
- Accept duplication when similar code changes for different reasons or a shared helper would need flags to fit callers.

### Don't Explain the Obvious
- Skip stating what the code clearly does.
- Avoid restating requirements that are already in the user's request.
- Focus explanations on trade-offs, non-obvious design choices, and risks.
- Prefer clearer names or simpler structure over explanatory comments.
- Add code comments only for non-obvious why: business invariants, external quirks, security constraints, concurrency, idempotency, performance tradeoffs, or temporary workarounds.
- Remove commented-out code and stale comments.
- Use documentation comments only when public APIs, exported symbols, side effects, units, exceptions, idempotency, or compatibility constraints need caller-facing context.

## Decision Heuristic
- Check existing code for patterns.
- Link to or reference relevant documentation.
- Ask clarifying questions; don't invent facts.
- Keep changes scoped and minimal unless broader refactoring is requested.
