---
name: markdown-author
description: "Use when creating, rewriting, or reviewing Markdown documentation for readability, consistency, and formatting quality. Keywords: markdown, headings, lists, tables, links, anchors, internal references, inline code, code blocks, docs formatting, style guide, lint, readability."
argument-hint: "Describe the document type and desired output (draft/rewrite/review)."
user-invocable: true
---
# Markdown Author Skill

Create clean, scannable, and consistent Markdown that follows repository standards, common Markdown best practices, and common markdownlint-style formatting rules.

## Use This Skill For

- Writing new Markdown documentation from notes or requirements.
- Refactoring existing Markdown for clarity and structure.
- Standardizing headings, lists, links, anchors, internal references, tables, inline code, and code blocks.
- Reviewing Markdown for formatting issues before delivery.

## Do Not Use This Skill For

- Changing technical meaning or requirements without confirmation.
- Inventing facts to fill missing content.

## Markdown Guidelines

### Document Structure

- Start with exactly one clear H1 title.
- Place a short purpose statement or summary paragraph immediately after the H1.
- Use headings in strict order (H1 -> H2 -> H3); never skip levels.
- Do not end headings with a colon (`:`).
- Every heading must be followed by content before the next heading.
- Keep sections focused on one topic.
- Prefer short sections with clear labels.

### Headings and Text

- Use sentence-case headings unless repo conventions require otherwise.
- Keep paragraphs concise.
- Use bold sparingly for emphasis on key terms only.

### Lists

- Use bullets for unordered items and numbered lists for sequences.
- Keep one idea per bullet.
- Avoid deep nesting when possible.
- Use consistent punctuation style within a list.
- Do not mix ordered and unordered items in the same list.
- Avoid single-item lists; use prose instead.

### Links

- Use descriptive link text; avoid vague labels such as "click here", "here", or "this".
- Prefer relative links for internal repository references.
- Before adding an internal link, confirm the target file, heading anchor, or section exists.
- Use inline code for file paths and literal identifiers in link text when that improves clarity, for example [`README.md`](../../README.md).
- Preserve existing external URLs unless explicitly requested to change them.
- Keep link style consistent within a document; do not mix reference-style and inline links without a reason.
- Add a `## References`, `## Related`, or equivalent section only when the links materially help the reader.
- Remove duplicate links that point to the same target with the same purpose.

### Inline Code And Code Blocks

- Use inline code for file paths, directories, commands, package names, function names, class names, environment variables, field names, flags, literal values, and configuration keys.
- Do not use inline code for ordinary emphasis; use prose or bold text sparingly.
- Use fenced code blocks with language tags when possible.
- Keep snippets minimal and task-focused.
- Avoid mixing explanation text inside code fences.

### Tables

- Use tables for structured field-value data and comparisons.
- Keep column names short and descriptive.
- Avoid very wide tables; split when readability suffers.
- Always include a header row and separator row.
- Use compact separator rows such as `|---|---|` unless repository conventions require alignment spaces.

### Mechanical Formatting

- Leave exactly one blank line around headings, paragraphs, lists, tables, and fenced code blocks.
- Do not leave consecutive blank lines.
- Do not leave trailing spaces at the end of any line.
- End each Markdown file with a single newline.
- Keep indentation consistent: nested list content uses spaces, not tabs.
- Do not use raw HTML unless Markdown cannot express the required structure.

### Callouts and Notes

- Use short note sections only when required for warnings or constraints.
- Keep warnings concrete and actionable.

## Documentation Workflow

1. Confirm objective, audience, and expected artifact type.
2. Read nearby docs to match repository terminology, heading style, link style, and table style.
3. Draft concise content with consistent Markdown formatting.
4. Validate links, internal references, heading order, list consistency, tables, inline code, and code fences.
5. Run a final mechanical pass for blank lines, trailing spaces, final newline, and duplicate references.
6. Run the repository Markdown formatter or linter when one is configured or already available.
7. Run a final readability pass to remove repetition and noise.

## Quality Checklist

- Exactly one H1 exists, and heading hierarchy is valid and consistent.
- No heading ends with a colon (`:`), and every heading has content below it.
- Lists use consistent style and indentation.
- Internal links and heading anchors point to existing targets.
- External links are preserved unless a change was requested.
- Duplicate or redundant links are removed.
- Inline code is used for paths, commands, env vars, field names, options, literals, and identifiers.
- Code blocks use language tags where applicable.
- Tables have header and separator rows and are aligned with the content purpose.
- Blank lines, trailing spaces, and final newline are clean.
- Repository Markdown lint or formatter warnings are resolved when tooling is available.
- No duplicated sections or obvious filler text.
- Unknown values are marked as `TBD`.

## Output Contract

When delivering Markdown work, include:

- Objective
- Files updated
- Formatting improvements made
- Content assumptions and `TBD` fields
- Open questions (if any)

## Definition Of Done

- Markdown is structurally consistent and easy to scan.
- Formatting follows this skill and repository conventions.
- Content remains accurate after formatting/refactor changes.
