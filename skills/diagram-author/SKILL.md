---
name: diagram-author
description: "Use when choosing or creating architecture diagrams, process flows, dashboard mockups, or other visual documentation. Use Mermaid for simple diagrams and draw.io for complex ones. Keywords: diagram, mermaid, drawio, architecture, flowchart, visualization."
argument-hint: "Describe what to visualize, target audience, and format (Mermaid or draw.io)."
user-invocable: true
---
# Diagram Author Skill

Use this skill when the task is primarily visual documentation: translating existing repo facts into diagrams, choosing the right diagram format, and keeping diagram placement and links consistent.

## When to use

- Create or edit architecture diagrams.
- Create or edit source-system and process diagrams.
- Create or edit dashboard, observability, or mock-up diagrams.
- Add diagram references to nearby Markdown docs when a visual artifact is part of the deliverable.

## Format selection rules

- Use Mermaid for simple or quick diagrams:
  - small architecture overviews
  - lightweight data flows
  - diagrams that are easy to review inline in Markdown
- Use draw.io for complex or large diagrams:
  - multi-system or detailed architectures
  - multi-step flows with many branches
  - dashboard mockups, UI-style layouts, or presentation-ready visuals
  - diagrams that benefit from multiple pages or richer layout control
- For substantial Mermaid authoring, use the `mermaid-author` skill after choosing Mermaid as the right format.
- For substantial draw.io authoring, use the `drawio-author` skill after choosing draw.io as the right format.

## Placement rules for this repo

- Architecture diagrams: `knowledge/diagrams/architecture/`
- Source-specific diagrams: `knowledge/diagrams/source-systems/`
- Observability and dashboard mockups: `knowledge/diagrams/observability/`
- If these folders do not exist, create them using the same naming and keep related Markdown links local to the owning document.
- Preserve existing file and folder names unless explicitly asked to rename.

## Diagram authoring rules

- Base diagrams only on facts already present in the repo context.
- Do not invent systems, interfaces, owners, metrics, timelines, or architecture decisions.
- Prefer clear titles, direct labels, and simple legends when needed.
- Keep diagrams scoped to the document they support; avoid mixing unrelated concerns into one diagram.
- Multi-page draw.io files are acceptable when the subject is too large for a single page.

## Linking rules

- When adding a new diagram, update the nearby Markdown doc to reference it with a relative link when helpful.
- Keep links local to the current section when possible.
- Do not add exported assets unless the task explicitly asks for them.

## Lightweight style guidance

- Use descriptive file names that match the supported topic.
- For Mermaid, keep nodes and labels short and readable in raw source.
- For draw.io, use page names that describe the view clearly.
- Prefer consistency over decoration; the goal is clarity, not visual flourish.

## Quality checklist

- Diagram format matches complexity: Mermaid for simple/quick, draw.io for complex/large.
- Mermaid-specific syntax and rendering rules follow the `mermaid-author` skill.
- Draw.io-specific XML, shape, and layout rules follow the `drawio-author` skill.
- Diagram lives in the correct section folder.
- Nearby docs link to the diagram when relevant.
- Labels and structure reflect repo terminology exactly.
- No speculative content was introduced.
