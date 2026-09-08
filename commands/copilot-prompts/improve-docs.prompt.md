---
description: "Improve documentation quality: format, structure, readability, clarity, and deduplication"
name: "Improve Docs"
argument-hint: "Target docs/file(s) and optional style constraints"
agent: "agent"
---
Improve the provided documentation content with a strict focus on quality and clarity.

Primary goals:
- Improve file formatting and Markdown structure.
- Sort and group ideas into a logical reading flow.
- Increase readability with concise phrasing and scannable sections.
- Clarify ambiguous wording, assumptions, and intent.
- Remove duplicated or near-duplicated content while preserving meaning.

Inputs:
- Use selected text when present.
- If no selection is provided, use the file(s) specified in the prompt arguments.
- Preserve repository-specific conventions and terminology.
- Do not invent missing facts. Mark unknowns as TBD.

Output requirements:
- Return three sections in this exact order:
  1. Revised Documentation
  2. Key Improvements Made
  3. Open Questions (only if needed)
- Do not remove current information; preserve all existing meaning, details, and decisions.
- Keep technical meaning unchanged unless the user explicitly asks for content changes.
- Maintain existing links, headings, and examples unless changing them improves clarity.
- Prefer minimal, high-impact edits over full rewrites.

Quality checks before finalizing:
- No repeated points across sections.
- Heading hierarchy is valid and consistent.
- Lists are parallel and concise.
- Terminology is consistent.
- Grammar and punctuation are corrected.

If multiple files are included, process each file separately and label each output clearly.
