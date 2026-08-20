---
name: clean-architecture-ddd
description: "Use when designing, implementing, reviewing, or refactoring Clean Architecture, Hexagonal Ports & Adapters, Domain-Driven Design, repository ports, use cases, dependency injection, DTOs, mappers, and composition root wiring. Keywords: clean architecture, hexagonal, ports and adapters, DDD, domain driven design, repository pattern, use case pattern, dependency injection, DTO, mapper, composition root."
argument-hint: "Describe the stack, target files, feature or bounded context, and whether the task is implementation, review, migration planning, or architecture guidance."
user-invocable: true
---
# Clean Architecture DDD Skill

Apply Clean Architecture with Hexagonal Ports & Adapters and DDD concepts pragmatically: protect domain rules, keep dependency direction inward, and wire concrete infrastructure only at the composition root.

For general object-creation and behavioral patterns beyond this DDD-specific set (Strategy, Observer, Decorator, Builder, Adapter, etc.), use the `design-patterns` skill.

## Use This Skill For

- Designing or reviewing layered application structure with `domain`, `application`, `infrastructure`, and `presentation` boundaries.
- Implementing use cases, repository ports, adapter implementations, DTOs, mappers, and dependency injection wiring.
- Checking whether business rules live in the right layer.
- Planning incremental migration toward Clean Architecture or hexagonal boundaries.
- Reviewing Composition Root wiring and dependency direction violations.

## Do Not Use This Skill For

- Forcing Clean Architecture onto small scripts, prototypes, notebooks, simple CRUD apps, or legacy systems with established local conventions.
- Creating abstractions for every class by default.
- Adding repositories, ports, DTOs, or mappers when they add no boundary protection or test seam.
- Refactoring architecture and changing behavior in the same change unless explicitly requested.
- Replacing stack-specific guidance; use this as the architecture baseline, then apply relevant stack skills.

## First Checks

1. Read project instructions, README, package/build files, existing architecture docs, and representative source files.
2. Identify the active stack and existing conventions before proposing structure.
3. Confirm whether the requested work is greenfield, feature addition, review, or migration.
4. Preserve local architecture when it conflicts with generic guidance unless the user explicitly asks to migrate.
5. Keep changes vertical and thin: one use case or feature slice at a time.

## Layer Responsibilities

| Layer | Owns | Must not own |
|---|---|---|
| Domain | Entities, value objects, domain services, invariants, domain events, repository port contracts when domain-owned | Framework annotations, ORM models, HTTP, persistence, queues, config, logging infrastructure |
| Application | Use cases, orchestration, transactions, authorization decisions, command/query DTOs, port usage | Framework controllers, ORM queries, HTTP clients, SQL, request parsing |
| Infrastructure | Repository implementations, ORM models, external API clients, filesystem, queues, email, cache, framework adapters | Business invariants, workflow policy that belongs in use cases |
| Presentation | REST controllers, handlers, CLI commands, request/response DTOs, input validation, HTTP status mapping | Domain entities as API contracts, repository implementation selection |
| Composition Root | Dependency graph assembly, concrete adapter selection, config binding | Business logic, request-specific branching, domain rules |

## Dependency Direction

- Dependencies point inward: presentation and infrastructure depend on application/domain, not the reverse.
- Domain must be framework-agnostic and persistence-agnostic.
- Application depends on domain abstractions and ports, not concrete adapters.
- Infrastructure implements ports defined by domain or application.
- Presentation calls use cases; it should not orchestrate repositories directly.
- Domain entities must not be returned directly as external API DTOs unless the project explicitly accepts that coupling.

## Domain-Driven Design Guidance

- Use domain terms from the codebase, docs, and business language.
- Put invariants in entities, value objects, or domain services, not controllers or repositories.
- Use value objects for validated concepts with behavior, not for passive wrappers around every primitive.
- Define aggregate boundaries around consistency rules and transaction needs.
- Keep domain services focused on rules that do not naturally belong to one entity.
- Treat domain events as facts that happened, not commands to do work.

## Use Case Pattern

- One use case represents one application action or workflow.
- Use cases orchestrate domain objects and ports; they do not contain low-level I/O details.
- Put transaction boundaries at the application layer unless the stack has a stricter convention.
- Accept command/query input objects when there are several inputs or a stable contract improves clarity.
- Return application DTOs or result objects, not ORM models or framework responses.

## Repository Pattern

- Define repository ports around domain needs, not database table shape.
- Keep repository methods intention-revealing, such as `findActiveByCustomerId` or `save`, instead of leaking arbitrary query construction into use cases.
- Repository implementations translate between persistence models and domain entities.
- Do not put business decisions in repository implementations; they should fetch, persist, and translate.
- Do not create a repository for every entity unless the domain actually needs direct persistence access.

## DTO And Mapper Patterns

- Use DTOs at external boundaries: HTTP requests/responses, messages, CLI input/output, and use case input/output when useful.
- Keep DTOs free of domain behavior.
- Map explicitly between DTOs, domain entities, and persistence models at layer boundaries.
- Place mappers near the boundary they serve unless the repo has a clear shared mapper convention.
- Avoid exposing ORM persistence fields, lazy-loaded relationships, or internal identifiers by accident.

## Dependency Injection And Composition Root

- Prefer constructor or provider injection over creating concrete dependencies inside business code.
- The composition root is the only place that chooses concrete infrastructure implementations for ports.
- Keep factories small and explicit; avoid hidden global service locators.
- Configuration values enter through the composition root or config layer, not domain objects.
- Tests should be able to supply in-memory or fake port implementations without database, network, or framework startup.

## Architecture Review Checklist

- Layer placement matches responsibility.
- No inward layer imports an outward layer.
- Domain has no framework, ORM, HTTP, or infrastructure dependency.
- Use cases orchestrate one workflow and depend on ports, not concrete adapters.
- Repositories are ports plus implementations, with explicit mapping across persistence boundaries.
- DTOs protect external contracts and do not leak domain or ORM internals unintentionally.
- Composition root owns concrete wiring and object graph assembly.
- Tests can exercise domain and application logic without I/O.
- New abstractions solve a real boundary, testability, or substitution problem.

## Migration Guidance

- Start by identifying current seams and the highest-risk dependency direction violations.
- Move one vertical slice at a time: route/handler, DTO, use case, domain behavior, port, adapter, tests, wiring.
- Keep existing behavior stable with characterization tests or integration tests before moving code.
- Avoid big-bang folder reshuffles with no behavior or testability improvement.
- Defer abstractions until a boundary is actively being protected.

## Output Contract

When delivering Clean Architecture or DDD work, include:

- Files changed or reviewed.
- Layer and boundary decisions made.
- Dependency direction or composition root impacts.
- Tests or architecture checks run.
- Any deliberate deviations from the pattern and why they are simpler or safer.
