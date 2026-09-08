---
description: "Generate, improve, or review Mermaid diagrams"
name: "Diagram Mermaid"
argument-hint: "Diagram type (flowchart, sequence, c4context, c4container, c4component, er, state, gantt) and embed vs standalone"
agent: "tech-lead"
---
Generate, improve, or review Mermaid diagrams using the `mermaid-author` skill.

Requirements:
- Use the `mermaid-author` skill before writing, editing, or reviewing Mermaid.
- Treat that skill as the source of truth for diagram type selection, Mermaid syntax, renderer compatibility, C4/flowchart/sequence/ER/state/Gantt conventions, labels, arrows, links, and quality checks.

How to use:
- Generate a new diagram — ask what to diagram and what type, then generate. Embeds in a Markdown file by default; use `--standalone` for a `.mmd` file.
- Review without changing — analyze Mermaid syntax, labels, scope, and rendering risks.

Save location: Check the project's `AGENTS.md`, `CLAUDE.md`, docs README, or existing diagram folders for the canonical architecture location. Default fallback: `docs/architecture/`.

After generating, state: file path, diagram type, where it renders (GitHub Markdown, VS Code Mermaid Preview, Mermaid Live), and any simplifications or assumptions.

Arguments: $ARGUMENTS
