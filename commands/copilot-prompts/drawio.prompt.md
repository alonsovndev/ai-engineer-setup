---
description: "Generate, improve, or review Draw.io diagrams"
name: "Drawio"
argument-hint: "Action (generate, update, review), file path, and diagram type"
agent: "tech-lead"
---
Generate, improve, or review Draw.io diagrams using the `drawio-author` skill.

Requirements:
- Use the `drawio-author` skill before writing, editing, or reviewing Draw.io files.
- Treat that skill as the source of truth for valid `.drawio` and `mxfile` XML structure, `mxCell` roots, parents, IDs, geometries, shape templates, C4 colors, labels, titles, legends, layout, and quality checks.

How to use:
- Generate a new `.drawio` file — ask what to diagram, then generate.
- Update an existing file — read it first, then apply changes.
- Review without changing — analyze XML structure, labels, layout, and rendering risks.

Diagram types:
- **C4 Context**: L1 system context diagram.
- **C4 Container**: L2 container diagram.
- **Data Flow**: Data flow between systems/services.
- **Sequence**: Sequence or interaction diagram.
- **Custom**: From user description.

Save in `docs/architecture/{descriptive-name}.drawio` unless the project has a canonical location.

After generating, state: file path, diagram type, how to open (diagrams.net, Draw.io desktop, VS Code extension), and any layout simplifications or assumptions.

Arguments: $ARGUMENTS
