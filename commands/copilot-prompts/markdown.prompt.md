---
description: "Write, improve, or review Markdown documentation"
name: "Markdown"
argument-hint: "Action (new, improve, review) and document type (adr, runbook, spec, readme)"
agent: "tech-lead"
---
Write, improve, or review Markdown documentation using the `markdown-author` skill.

Requirements:
- Use the `markdown-author` skill before writing, editing, or reviewing Markdown.
- Treat that skill as the source of truth for heading hierarchy, code block formatting, links, anchors, lists, tables, and trailing space checks.

Document types:
- **ADR**: Architecture Decision Record with status, context, decision, consequences, alternatives.
- **Runbook**: Operational procedure with trigger, prerequisites, steps, verification, rollback, escalation.
- **Spec**: Feature or integration specification with goal, scope, design, data contract, error handling, testing.
- **README**: Service or folder documentation with description, what it does, how to run, configuration, related links.

How to use:
- Create a new document — ask what to create, then generate using the appropriate template.
- Improve an existing file — refactor for clarity, structure, links, and formatting.
- Review without changing — flag issues without modifying the file.

Save location: Check the project's `AGENTS.md` or docs README for canonical structure. When in doubt, ask the user where to save.

After generating, state: file path, document type, formatting checks completed, and any `{placeholder}` or `TBD` sections.

Arguments: $ARGUMENTS
