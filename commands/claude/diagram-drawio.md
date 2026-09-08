---
description: "Generate, improve, or review Draw.io diagrams using the `drawio-author` skill as the canonical `.drawio` XML and layout standard."
---

Generate, improve, or review Draw.io diagrams using the `drawio-author` skill as the canonical `.drawio` XML and layout standard.

## How To Use This Command

- `/diagram-drawio` - ask the user what to diagram, then generate a `.drawio` file.
- `/diagram-drawio --update {file}` - read an existing `.drawio` file and apply requested changes.
- `/diagram-drawio --review {file}` - review XML structure, labels, layout, and rendering risks without changing the file.
- `/diagram-drawio --type c4-context` - generate a C4 L1 context diagram.
- `/diagram-drawio --type c4-container` - generate a C4 L2 container diagram.
- `/diagram-drawio --type data-flow` - generate a data-flow diagram.
- `/diagram-drawio --type sequence` - generate a sequence or interaction diagram.
- `/diagram-drawio --type custom` - generate a diagram from the user's description.

## Required Skill

Use the `drawio-author` skill before writing, editing, or reviewing Draw.io files. Treat that skill as the source of truth for:

- Valid `.drawio` and `mxfile` XML structure.
- Required `mxCell` roots, parents, IDs, geometries, and relationships.
- Shape templates, C4 colors, labels, titles, and legends.
- Layout, multi-page diagrams, links, and exported asset constraints.
- Quality checks before delivery.

## Save Location

Check the project's `AGENTS.md`, `CLAUDE.md`, docs README, or existing diagram folders for the canonical architecture location.

Default fallback: `docs/architecture/{descriptive-name}.drawio`.

If updating an existing file, read it first.

## After Generating

State:

1. File created or updated and its path.
2. Diagram type generated and why Draw.io fits.
3. How to open it: diagrams.net, Draw.io desktop, or VS Code Draw.io extension.
4. Any layout simplifications, workarounds, assumptions, or `TBD` values.
