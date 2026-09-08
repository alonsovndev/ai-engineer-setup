---
description: "Generate, improve, or review Mermaid diagrams using the `mermaid-author` skill as the canonical syntax and rendering standard."
---

Generate, improve, or review Mermaid diagrams using the `mermaid-author` skill as the canonical syntax and rendering standard.

## How To Use This Command

- `/diagram-mermaid` - ask the user what to diagram and what type.
- `/diagram-mermaid --type flowchart` - directional data or control flow diagram.
- `/diagram-mermaid --type sequence` - service interaction or message sequence.
- `/diagram-mermaid --type c4context` - C4 L1 context diagram.
- `/diagram-mermaid --type c4container` - C4 L2 container diagram.
- `/diagram-mermaid --type c4component` - C4 L3 component diagram for one service.
- `/diagram-mermaid --type er` - entity relationship or data model diagram.
- `/diagram-mermaid --type state` - lifecycle or state machine diagram.
- `/diagram-mermaid --type gantt` - timeline or milestone diagram.
- `/diagram-mermaid --embed` - embed in a Markdown file. This is the default.
- `/diagram-mermaid --standalone` - output as a standalone `.mmd` file.
- `/diagram-mermaid --review {file}` - review Mermaid syntax, labels, scope, and rendering risks without changing the file.

## Required Skill

Use the `mermaid-author` skill before writing, editing, or reviewing Mermaid. Treat that skill as the source of truth for:

- Diagram type selection.
- Mermaid syntax and renderer compatibility.
- Embedded Markdown versus standalone `.mmd` output.
- C4, flowchart, sequence, ER, state, and Gantt conventions.
- Labels, arrows, links, placement, and quality checks.

## Save Location

Check the project's `AGENTS.md`, `CLAUDE.md`, docs README, or existing diagram folders for the canonical architecture location.

Default fallback: `docs/architecture/`.

- `--embed`: `{architecture-folder}/{diagram-name}.md`
- `--standalone`: `{architecture-folder}/{diagram-name}.mmd`

If updating an existing file, read it first.

## After Generating

State:

1. File created or updated and its path.
2. Diagram type generated and why it fits.
3. Where it renders, such as GitHub Markdown, VS Code Mermaid Preview, or Mermaid Live.
4. Any simplifications, assumptions, or `TBD` values.
