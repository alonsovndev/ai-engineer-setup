---
description: "Generate C4 model architecture diagrams for the current project."
argument-hint: "C4 level (context, container, component) and optional service name"
---

Generate C4 model architecture diagrams for the current project.

## How to use this command

- `/diagram-c4` — generate Context + Container diagrams (default)
- `/diagram-c4 --level context` — L1 only
- `/diagram-c4 --level container` — L2 only
- `/diagram-c4 --level component --service {name}` — L3 for a specific service
- `/diagram-c4 --drawio` — output DrawIO XML instead of Mermaid
- `/diagram-c4 --all` — generate all applicable levels

## Before generating

Read the project's architecture source material first:
- Look for `AGENTS.md`, `CLAUDE.md`, `README.md`, or an `architecture/` docs folder in the project root
- Read any existing architecture diagrams (`.drawio`, `.mmd`, or markdown files with Mermaid) to avoid duplication and stay consistent
- If no architecture docs exist, ask the user to describe the system before generating

## C4 Level Definitions

### L1 — System Context
Scope: the system as a whole + all external actors and systems.
Audience: managers, business stakeholders, security reviewers.
Include: end users, the system boundary, external systems the system integrates with.
Focus on: what the system does, who uses it, what external systems it touches — not how.

### L2 — Container
Scope: internal services, applications, and data stores inside the system boundary.
Audience: engineers, security reviewers, lead developers.
Show: service-to-service communication, data directions, protocols (HTTP, SQL, gRPC, etc.), deployment kind (CronJob, API, Worker, etc.).

### L3 — Component
Scope: internals of a single container/service.
Audience: developers implementing or reviewing that service.
Ask the user which service to diagram if not specified.

### L4 — Code
Scope: class/function level. Generate only when explicitly requested.

## Output format

**Default (Mermaid)** — text-based, version-controllable, renders in GitHub markdown:

```
%%{init: {'theme': 'default'}}%%
C4Context
  title System Context: {System Name}

  Person(user, "{User Role}", "{What they do}")
  System_Boundary(sys, "{System Name}") {
    System(core, "{Core System}", "{What it does}")
  }
  System_Ext(ext1, "{External System}", "{Why it's connected}")
  Rel(user, core, "Uses")
  Rel(core, ext1, "{action}", "{protocol}")
```

```
C4Container
  title Container Diagram: {System Name}
  Person_Ext(user, "{User Role}")
  System_Boundary(sys, "{System Name}") {
    Container(svcA, "{Service A}", "{Tech}", "{Responsibility}")
    Container(svcB, "{Service B}", "{Tech}", "{Responsibility}")
    ContainerDb(db, "{Database}", "{Tech}", "{What it stores}")
  }
  System_Ext(ext, "{External System}", "")
  Rel(svcA, db, "Read/Write", "SQL")
  Rel(svcB, svcA, "{action}", "HTTP/JSON")
  Rel(svcB, ext, "{action}", "HTTPS")
```

**DrawIO XML** (when `--drawio` flag given) — use the `drawio-author` skill for valid `mxfile` XML, shape styles, labels, layout, title cells, and legend cells.

## Save location

Check the project's CLAUDE.md or docs README for the canonical architecture folder.
Default fallback: save in a `docs/architecture/` or `docs/01-architecture/` folder at the project root.

- Mermaid: `{arch-folder}/c4-{level}-diagram.md`
- DrawIO: `{arch-folder}/c4-{level}.drawio`

If updating an existing file, read it first.

## After generating

Tell the user:
1. File created/updated and its path
2. Which C4 level(s) were generated
3. Which audience each level targets
4. How to view the output ("renders in GitHub markdown" or "open in Draw.io desktop / VS Code Draw.io extension")
