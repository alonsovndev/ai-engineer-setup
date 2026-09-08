---
name: spec-planning
description: "Use when turning a raw idea or requirement into a clarified, delegation-ready implementation plan: asking a small set of clarifying questions, then writing a phased plan file under specs/. Keywords: spec, spec plan, requirement clarification, phased plan, specs folder, delegate to peers, handoff."
argument-hint: "Raw idea or requirement text, or (for the write step) nothing if already refined in this conversation."
user-invocable: true
allowed-tools: Read, Write, Bash, Glob, Grep
---

# Spec Planning Skill

Two-step workflow for turning a raw idea into an execution-ready spec: refine, then write. Backs the `/spec-clarify` and `/spec-write` commands across Claude Code, opencode, and Copilot CLI.

## Step 1: Refine (backs `/spec-clarify`)

1. Read the raw idea from the command arguments. If empty, ask the user for it.
2. Optionally skim `README.md`, `AGENTS.md`, or `CLAUDE.md` at the project root for grounding context — only if it helps sharpen the questions.
3. Ask **at most 5** targeted clarifying questions. Only ask what would actually change scope, constraints, or acceptance criteria:
   - Scope boundary — what's explicitly in vs. out
   - Target users/consumers of the change
   - Non-negotiable constraints (stack, deadline, compatibility, budget)
   - Success/acceptance criteria
   - Priority or urgency, if it affects sequencing
4. Skip any question already answered in the raw idea text. Do not ask about implementation details the agent can reasonably infer or decide.
5. End with a structured **Refined Requirement** recap:
   - Objective
   - Scope (in / out)
   - Constraints
   - Non-functional requirements
   - Assumptions (mark unknowns `TBD` — never invent owners, dates, SLAs, or commitments)
   - Acceptance criteria
   - Open risks
6. Do not write any files in this step. Tell the user to run `/spec-write` next.

## Step 2: Write Plan (backs `/spec-write`)

1. Use the Refined Requirement already produced in this conversation. If none exists yet and the command was given raw text directly, run Step 1 first using that text as the raw idea.
2. Ensure the `specs/` folder convention exists at the current project's repo root:
   - If `specs/` or `specs/.gitignore` is missing, create `specs/.gitignore` with:
     ```
     *
     !.gitignore
     ```
     This tracks the `specs/` folder (via its own `.gitignore`) while every other file inside it stays untracked and local-only.
3. Derive the filename: `specs/<YYYY-MM-DD>-<slug>.md`, where `<slug>` is the kebab-case form of the Objective and the date comes from the local system clock (e.g. `date +%Y-%m-%d`).
4. If a file with that name already exists, ask the user before overwriting rather than doing it silently.
5. Write the file using the Spec Plan Template below.
6. Report the file path, the number of phases, and remind the user `specs/` is local-only — its contents are not committed.

## Spec Plan Template

```markdown
# {Objective title}

**Status**: Draft
**Date**: {YYYY-MM-DD}

## Raw Idea

{Verbatim raw idea/requirement text as first provided}

## Refined Requirement

**Objective**: {one sentence}

**Scope**
- In: {...}
- Out: {...}

**Constraints**: {...}

**Non-functional requirements**: {...}

**Assumptions**: {...; mark unknowns TBD}

**Acceptance criteria**:
- {testable outcome}

**Open risks**: {...}

## Implementation Phases

### Phase {N}: {Title}

**Suggested owner**: {an existing agent from orchestration/router.md's domain table (e.g. react-ui, python-api, postgresql, terraform, clean-architecture, product-ba, tech-lead, code-review), or "human peer engineer" / "any AI coding agent" when no specific agent fits}

**Depends on**: {previous phase(s), or "none"}

**Task**: {one sentence objective for this phase}

**Context**:
- Files: {paths or patterns this phase touches}
- Stack: {language, framework, key libraries, if relevant}

**Constraints**: {non-negotiable limits for this phase}

**Inputs**: {assumptions, existing patterns to follow, related files to read first}

**Expected output**: {exact deliverable format: code changes, findings list, diagrams, docs, tests}

**Done criteria**: {measurable finish conditions for this phase}

{Repeat per phase.}

## Delegation Notes

Each phase above is self-contained and can be handed to a different agent, subagent, or teammate without re-reading this whole document.

- If this project has `orchestration/router.md` and `orchestration/handoff-contract.md`, route each phase's Suggested Owner through those files' rules.
- Otherwise, paste a single phase block (Task through Done Criteria) directly to any AI coding agent or human teammate — it is written to be self-sufficient.
```

## Safety Rules

- Never invent stakeholders, owners, dates, SLAs, or commitments — mark them `TBD`.
- Never commit anything under `specs/` except its `.gitignore`; the folder is local scratch space for planning, not shipped documentation.
- Never overwrite an existing spec file silently.
- Preserve the raw idea verbatim in the output file — refinement should clarify, not erase, the original ask.
