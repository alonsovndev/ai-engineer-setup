# Python / FastAPI / DDD Standards

Use these standards only for projects that actually use Python with FastAPI, DDD or hexagonal layering, SQLAlchemy, pytest, PostgreSQL, Docker, or batch/CronJob patterns.

Do not impose this structure on small scripts, Flask/Django projects, data notebooks, legacy projects that follow another established architecture, or repositories with conflicting local conventions.

## Project Structure

Feature-first layout. Every feature is self-contained:

```text
src/
  app/
    features/<feature>/
      domain/          # entities, value objects, repository ports (ABC)
      application/     # use cases, orchestration, transaction boundaries
      infrastructure/  # SQLAlchemy models, DB repositories, HTTP clients
      presentation/    # FastAPI routers, Pydantic schemas
    container.py       # Composition Root: single object graph assembly point
    config/            # AppConfig singleton, env loading
  shared/
    domain/            # cross-feature ports and domain primitives
    infrastructure/    # shared DB setup, retry helpers, logging
    utils/             # pure helpers with no I/O
  main.py              # include_router wiring only
tests/
  unit/                # pure domain logic, no I/O
  integration/         # TestClient plus dependency_overrides
  architecture/        # AST-based import boundary enforcement
```

## Layer Placement

- Business rule or invariant: `domain/`
- Orchestration, workflow, or transaction boundary: `application/`
- Database, HTTP, file I/O, or external service implementation: `infrastructure/`
- FastAPI route or Pydantic schema: `presentation/`
- Cross-cutting logging, config, retry, or pure helpers: `shared/`

## Dependency Direction

Inner layers never import outer layers. Infrastructure implements domain ports, never the reverse.

| Layer | Can import | Cannot import |
|---|---|---|
| `domain` | stdlib, own layer | application, infrastructure, presentation |
| `application` | domain | infrastructure, presentation |
| `infrastructure` | domain, application ports | presentation |
| `presentation` | application, shared | domain entities directly |

## FastAPI Conventions

- One `APIRouter` per feature; all routers are registered in `main.py` with `include_router`.
- `src/app/container.py` is the composition root and the only place the full object graph is assembled.
- Do not instantiate repositories, services, or use cases inside route functions.
- Route functions receive already wired dependencies through `Depends(container.some_factory)`.
- `container.py` is the only file that knows which infrastructure implementation backs each domain port.
- Response schemas are Pydantic models in `presentation/`; do not return ORM models directly.
- Provide `/health` on every service.
- Disable Swagger docs outside local or docker environments.

## Batch / CronJob Conventions

- `main.py` is a plain Python entry point unless the job also exposes an API.
- Accept `batch_id` as a UUID at entry and propagate it through every call for traceability.
- Make writes idempotent with upserts so reruns are safe.
- Add overlap protection with a lock or running flag; skip if already running.
- Log structured JSON at start, completion, and error; include `batch_id` in every entry.

## Testing Conventions

- Unit tests cover pure domain logic with zero DB, HTTP, or filesystem access.
- Integration tests use `TestClient` and `app.dependency_overrides`.
- Use SQLite in-memory for DB isolation when compatible with the behavior under test.
- Put shared fixtures in root `conftest.py`; feature-level builders may live in feature `conftest.py` files.
- Mark tests with `@pytest.mark.unit` or `@pytest.mark.integration` when the project uses marker-based CI filters.
- Add `tests/architecture/test_architecture_rules.py` with AST-based import boundary enforcement when missing and appropriate for the project.

## Local Python Environment (venv policy)

Apply the shared-venv-first policy from `../AGENTS.md` for all Python work. Operational details for this stack:

- Shared venv (preferred): `/Users/alonso/Documents/Workspace/pipenvdev/dev` — activate with `source /Users/alonso/Documents/Workspace/pipenvdev/dev/bin/activate` (alias `pipactivate`).
- Missing package in the shared venv: `pip install <pkg>` without asking, unless it conflicts with an installed version.
- Project venv fallback: use `.venv/bin/activate` (or `venv/bin/activate`) when the shared venv cannot satisfy the project's pinned dependencies.
- If neither exists or works, ask the user to create a project venv for build and validation. Never install into system Python.

## PostgreSQL Conventions

- Use SQLAlchemy 2.x.
- Use `AsyncSession` for FastAPI services and sync `Session` for batch jobs.
- `get_db()` is a generator yielding a session and is wired with `Depends(get_db)` in presentation.
- SQLAlchemy ORM models live in `infrastructure/`; domain entities live in `domain/`.
- Domain entities and ORM models are distinct classes; map between them explicitly.
- Use Flyway SQL migrations in `flyway/sql/`; never auto-migrate in application code.
- For test isolation, override `get_db` with SQLite in-memory and drop all tables after each test.

## Docker Conventions

- Base image: `python:3.12-slim`.
- Run as non-root `appuser` with uid `999`.
- Set `ENV PYTHONPATH=. PYTHONUNBUFFERED=TRUE PYTHONDONTWRITEBYTECODE=TRUE`.
- `EXPOSE 8080`.
- Use `/start.sh` as entrypoint when pre-start hooks are needed.
- Use `.env` for local secrets; never copy `.env` into the image.
- Local `docker-compose` setup should include `app`, `postgres`, and `flyway` when the service needs them.
