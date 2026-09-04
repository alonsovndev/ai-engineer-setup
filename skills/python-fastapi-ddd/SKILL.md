---
name: python-fastapi-ddd
description: "Use when working on Python FastAPI services, DDD/hexagonal architecture, SQLAlchemy, pytest, PostgreSQL, Docker, or batch/CronJob conventions. Keywords: fastapi, python ddd, sqlalchemy, pydantic, pytest, flyway, cronjob."
---

# Python FastAPI DDD Skill

Use this skill only when the repository actually uses Python with FastAPI, DDD or hexagonal layering, SQLAlchemy, pytest, PostgreSQL, Docker, or batch/CronJob patterns.

For Clean Architecture, Hexagonal Ports & Adapters, DDD, repository/use-case patterns, DTO/mappers, dependency injection, and composition root rules, also apply the shared `clean-architecture-ddd` skill as the architecture baseline.

For relational schema design, SQLAlchemy mappings, SQL review, normalization, indexes, migrations, transactions, and ORM/domain mapping tradeoffs, also apply `relational-db-orm`.

Before editing, read the project files first and then apply the stack guide at `../../instructions/stacks/python-fastapi-ddd.md` when it matches the repository. Do not impose that guide on Flask, Django, scripts, notebooks, or legacy projects with established local conventions.

## Required Checks

- Confirm the active stack from project files such as `pyproject.toml`, `requirements*.txt`, `src/`, `tests/`, Docker files, or existing FastAPI imports.
- Follow existing local structure when it conflicts with the guide unless the user explicitly asks for a migration.
- Keep domain, application, infrastructure, and presentation dependencies pointing inward.
- Keep FastAPI routes thin and wire concrete implementations at the composition root.
- Run the repository's available Python checks before completion, such as tests, lint, type-check, or build commands.
- Use the shared venv first (`source /Users/alonso/Documents/Workspace/pipenvdev/dev/bin/activate`, alias `pipactivate`), falling back to the project `.venv` when dependency versions conflict, and ask the user to create a project venv if neither works; see the venv policy in `../../instructions/AGENTS.md`. Never install into system Python.

## Reference

Canonical standards: `../../instructions/stacks/python-fastapi-ddd.md`.

Shared architecture baseline: `../clean-architecture-ddd/SKILL.md`.

Relational DB and ORM baseline: `../relational-db-orm/SKILL.md`.
