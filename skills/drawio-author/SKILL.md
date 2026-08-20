---
name: drawio-author
description: "Use when creating, editing, or reviewing Draw.io diagrams and .drawio mxfile XML. Keywords: drawio, draw.io, diagrams.net, mxfile, mxGraphModel, mxCell, architecture diagram, C4 diagram, data flow, visual documentation."
argument-hint: "Describe what to diagram, target audience, and whether to create or update a .drawio file."
user-invocable: true
---
# Draw.io Author Skill

Create valid `.drawio` files that open in diagrams.net, Draw.io desktop, and VS Code Draw.io extensions, while keeping architecture facts accurate and diagrams readable.

## Use This Skill For

- Creating or updating Draw.io `.drawio` files.
- Producing visual or presentation-ready architecture, C4, data-flow, process, or dashboard diagrams.
- Reviewing Draw.io XML structure, shape styles, labels, relationships, and layout risks.
- Converting confirmed diagram intent into editable `mxfile` XML.

## Do Not Use This Skill For

- Simple inline diagrams that should be version-controlled as text; use `mermaid-author` instead.
- Inventing systems, actors, owners, protocols, SLAs, metrics, dates, or architecture decisions.
- Exporting PNG, SVG, or PDF assets unless the user explicitly asks for exported assets.

## Before Creating Or Editing

1. Read the target `.drawio` file before updating it.
2. Read nearby architecture docs, README files, ADRs, and existing diagrams before creating a new diagram.
3. Search for existing `.drawio`, `.mmd`, or Markdown Mermaid diagrams to avoid duplicate views.
4. Reuse existing element names, system boundaries, colors, layout conventions, and terminology.
5. Ask for the minimum missing facts when relationships, ownership, or protocols are unclear.

## Format Selection

Use Draw.io when the diagram needs manual layout, presentation polish, complex grouping, multi-page views, dashboard mockups, or rich shape styling.

Use Mermaid instead when the diagram is small, primarily textual, and intended for inline review in Markdown.

## Required XML Structure

Every Draw.io file must use a valid `mxfile` root with at least one `diagram`, one `mxGraphModel`, and root cells `id="0"` and `id="1"`.

```xml
<mxfile host="Agent" modified="{timestamp}" agent="Agent" version="21.0">
  <diagram id="page-1" name="{Diagram Name}">
    <mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="827" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- diagram content here -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

Rules:

- Use stable, descriptive IDs such as `person-user`, `container-api`, `database-main`, or `rel-api-db`.
- Put top-level vertices and edges under `parent="1"`.
- Put nested elements under their containing boundary or swimlane with `parent="{container-id}"`.
- Include `mxGeometry` for every vertex and edge.
- XML-escape label content: use `&lt;`, `&gt;`, `&amp;`, and `&quot;` where needed.
- Keep XML valid and complete; do not return partial snippets as final `.drawio` files.

## Shape Templates

### People And Actors

```xml
<mxCell id="person-user" value="&lt;b&gt;{User Role}&lt;/b&gt;&lt;br&gt;[Person]&lt;br&gt;{Short description}" style="shape=mxgraph.basic.person2;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=0;fontSize=11;" vertex="1" parent="1">
  <mxGeometry x="40" y="80" width="80" height="100" as="geometry" />
</mxCell>
```

### Internal Systems And Containers

```xml
<mxCell id="container-api" value="&lt;b&gt;{Service Name}&lt;/b&gt;&lt;br&gt;[Container: {Tech}]&lt;br&gt;{Short description}" style="rounded=1;whiteSpace=wrap;fillColor=#1168BD;fontColor=#ffffff;strokeColor=#0B4884;fontSize=11;" vertex="1" parent="1">
  <mxGeometry x="200" y="200" width="200" height="80" as="geometry" />
</mxCell>
```

### External Systems

```xml
<mxCell id="external-source" value="&lt;b&gt;{External System}&lt;/b&gt;&lt;br&gt;[External System]&lt;br&gt;{Short description}" style="rounded=1;whiteSpace=wrap;fillColor=#999999;fontColor=#ffffff;strokeColor=#8A8A8A;fontSize=11;" vertex="1" parent="1">
  <mxGeometry x="500" y="200" width="200" height="80" as="geometry" />
</mxCell>
```

### Databases And Data Stores

```xml
<mxCell id="database-main" value="&lt;b&gt;{Database Name}&lt;/b&gt;&lt;br&gt;[Database]&lt;br&gt;{Short description}" style="shape=mxgraph.flowchart.database;whiteSpace=wrap;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=11;" vertex="1" parent="1">
  <mxGeometry x="200" y="380" width="120" height="80" as="geometry" />
</mxCell>
```

### System Boundaries

```xml
<mxCell id="boundary-system" value="{System Name}" style="swimlane;startSize=20;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;strokeDasharray=8 8;fontSize=13;fontStyle=1;" vertex="1" parent="1">
  <mxGeometry x="160" y="120" width="480" height="340" as="geometry" />
</mxCell>
```

Elements inside the boundary use `parent="boundary-system"`.

### Labeled Relationships

```xml
<mxCell id="rel-api-db" value="{label}&lt;br&gt;[{protocol}]" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;exitX=1;exitY=0.5;entryX=0;entryY=0.5;fontSize=10;" edge="1" source="{source-id}" target="{target-id}" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

Rules:

- Label every edge with the action, data, event, or protocol.
- Set `source` and `target` to existing cell IDs.
- Use orthogonal edges for architecture diagrams unless another style is clearly more readable.

### Title And Legend

```xml
<mxCell id="title" value="&lt;b&gt;{Diagram Title}&lt;/b&gt;&lt;br&gt;{View Type} | {System Name}" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;fontSize=16;" vertex="1" parent="1">
  <mxGeometry x="300" y="20" width="400" height="50" as="geometry" />
</mxCell>
```

```xml
<mxCell id="legend" value="&lt;b&gt;Legend&lt;/b&gt;&lt;br&gt;Internal system: blue&lt;br&gt;External system: gray&lt;br&gt;Person: light blue&lt;br&gt;Database: cylinder" style="text;html=1;strokeColor=#d6b656;fillColor=#fffde7;align=left;verticalAlign=top;spacingLeft=8;fontSize=10;" vertex="1" parent="1">
  <mxGeometry x="20" y="600" width="220" height="100" as="geometry" />
</mxCell>
```

## C4 Style Reference

| Element | Fill | Font | Stroke |
|---|---|---|---|
| Person | `#dae8fc` | `#000000` | `#6c8ebf` |
| Internal system/container | `#1168BD` | `#ffffff` | `#0B4884` |
| External system | `#999999` | `#ffffff` | `#8A8A8A` |
| Database | `#dae8fc` | `#000000` | `#6c8ebf` |
| System boundary | `#f5f5f5` | `#333333` | `#666666` dashed |

## Layout Guidance

- Put actors on the left, system boundaries or internal containers in the center, and external systems on the right when that matches the flow.
- Put databases below or near the services that own or query them.
- Keep related elements aligned and spaced consistently.
- Prefer left-to-right flow for integrations and top-to-bottom flow for layered or hierarchical views.
- Use multiple pages when one canvas becomes too dense.
- Give each page a descriptive `diagram name`.

## Placement And Links

- Follow the target repo's `AGENTS.md`, `CLAUDE.md`, docs README, or existing diagram folder conventions.
- Default fallback path: `docs/architecture/{descriptive-name}.drawio`.
- When adding a standalone diagram, add or update a nearby Markdown link when it helps discoverability.
- Use relative links for internal documentation references.
- Do not add exported assets unless explicitly requested.

## Output Contract

When delivering Draw.io work, include:

- File path created or updated.
- Diagram type and why Draw.io fits.
- How to open it: diagrams.net, Draw.io desktop, or VS Code Draw.io extension.
- Any layout simplifications, workarounds, assumptions, or `TBD` values.

## Quality Checklist

- File is complete valid XML with an `mxfile` root.
- Root cells `id="0"` and `id="1"` exist.
- Every vertex and edge has `mxGeometry`.
- Every edge has existing `source` and `target` IDs.
- Every relationship has a useful label.
- IDs are stable, descriptive, and unique.
- Labels use confirmed repo terminology.
- Colors and shapes are consistent with the selected diagram style.
- Layout is readable and not overcrowded.
- Nearby docs link to the diagram when relevant.
- No speculative systems, owners, protocols, metrics, or dates were introduced.
