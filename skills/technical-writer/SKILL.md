---
name: technical-writer
description: "Use when drafting, rewriting, or reviewing repository documentation: ADRs, source-system specs, connection and ingestion docs, observability guides, access/runbooks, weekly reports, planning artifacts, reference pages, glossaries, and markdown clarity edits. Keywords: documentation, rewrite, summarize, adr, architecture decision, source system, ingestion, connection, data contract, runbook, observability, standards, consistency, acceptance criteria."
argument-hint: "Describe the document, audience, and objective (draft/rewrite/review)."
user-invocable: true
---
# Technical Writer Skill

Produce clear, implementation-ready documentation that is easy to scan, correct, and maintain.

## Use This Skill For
- Writing new documentation from notes, requirements, tickets, or code context.
- Refactoring existing markdown for clarity, consistency, and structure.
- Producing operational artifacts such as runbooks, onboarding docs, or reference pages.
- Creating decision records (ADRs) and planning summaries with explicit assumptions.

## Do Not Use This Skill For
- Implementing code changes when the primary task is software delivery.
- Inventing missing facts (owners, SLAs, dates, volumes, credentials, URLs, infra decisions).

## Core Principles
1. Accuracy first: only document what is confirmed.
2. Clarity over cleverness: short sentences, explicit terms, direct language.
3. Structure before prose: enforce strong headings and logical flow.
4. Actionability: include acceptance criteria, risks, and open questions.
5. Consistency: align terminology and formatting with repository conventions.

## Documentation Workflow
1. Intake
- Confirm objective, audience, scope, and expected output format.
- Capture known constraints and source-of-truth artifacts.
- Mark unknown values as `TBD`.

2. Context collection
- Read the current target files before editing.
- Reuse existing terminology and link patterns.
- Preserve existing external URLs unless explicitly asked to change them.

3. Outline
- Draft section headers before writing full content.
- Separate confirmed facts from assumptions and options.
- Keep one concern per section.

4. Draft
- Write concise, concrete content.
- Prefer bullets and tables when they improve scanning.
- Add examples only when they reduce ambiguity.

5. Quality pass
- Remove vague language and repetition.
- Validate section order, links, and terminology.
- Ensure every required section is present and meaningful.

6. Delivery
- Summarize what changed.
- List unresolved questions and blockers.
- Provide suggested next steps when useful.

## Writing Standards
- Voice: direct, professional, neutral.
- Tense: present tense by default.
- Headings: specific and descriptive.
- Bullets: one idea per bullet; keep lists concise.
- Tables: use for required fields, mappings, and checklists.
- Links: use relative links for repo files when applicable.
- Terminology: use canonical repo terms consistently.

## Output Contracts By Artifact Type

### ADR
- Context
- Decision
- Alternatives considered (Maximum 2)
- Consequences

### Source-system specification
- Objective and scope
- Source/system context
- Connection requirements
- Ingestion requirements
- Data quality and controls
- Assumptions
- Open questions
- Risks and blockers
- Acceptance criteria

### Runbook / access guide
- Purpose
- Prerequisites
- Step-by-step procedure
- Validation checks
- Failure handling / rollback
- Escalation path

### Weekly report / planning summary
- Highlights
- Completed work
- In progress
- Risks and blockers
- Next actions

## Definition Of Done For Documentation
- The document is structurally complete for its artifact type.
- Content is factual, unambiguous, and internally consistent.
- Unknowns are explicitly marked as `TBD`.
- Assumptions, open questions, and risks are clearly separated.
- Links and references are valid and readable.

## Quick Review Checklist
- Is the audience clear?
- Is scope explicit and bounded?
- Are requirements testable?
- Are terms consistent with existing docs?
- Are open questions and blockers visible?
- Could a new team member execute from this doc without extra context?
