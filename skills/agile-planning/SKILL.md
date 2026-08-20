---
name: agile-planning
description: "Use when planning team work using agile/scrum methodology: creating epics, stories, bugs, and work items with acceptance criteria and estimates. Keywords: agile, scrum, epic, story, backlog, planning, acceptance criteria."
argument-hint: "Describe the initiative, work item type, and scope (epic/story/bug)."
user-invocable: true
---

# Agile Planning Workflow

Structure and prioritize team work using scrum methodology — creating well-defined epics, user stories, and bugs with clear acceptance criteria, effort estimates, and sprint alignment.

## When to Use

- Creating a new epic or initiative
- Breaking down work into sprint-sized user stories
- Logging bugs with reproducible steps
- Defining acceptance criteria and effort estimates
- Refining backlog items before sprint planning
- Preparing inputs for scrum ceremonies (planning, refinement, review, retro)

## Work Item Hierarchy

```
Initiative / Theme
  └── Epic          (multi-sprint; 3+ months or 5+ stories)
        └── Story   (completable in one sprint; 1–8 pts)
        └── Bug     (defect or unintended behavior)
```

## Core Workflow

### 1. Identify the Work Item Type

| Type | Scope | Used for |
|------|-------|----------|
| **Epic** | 3+ months / multiple sprints | Major features, platform initiatives, onboarding a new source system |
| **Story** | 1 sprint (1–8 pts) | User-facing features, technical improvements, integrations |
| **Bug** | Any size | Defects, regressions, unintended behaviors |

### 2. Gather Information

Answer these questions before writing the work item:

1. **What** is the work? (One-line summary)
2. **How** will success be measured? (Acceptance criteria)
3. **Effort**: Rough estimate in story points

For bugs, also capture:
- What is the expected behavior?
- What is the actual (broken) behavior?
- Steps to reproduce
- Severity and user impact
- Environment (dev / test / prod)

### 3. Write the Work Item

Use the templates below to structure the work item:

- [Epic Template](./assets/epic-template.md)
- [Story Template](./assets/story-template.md)
- [Bug Template](./assets/bug-template.md)

Populate all required fields. Mark unknowns as `TBD` — do not guess.

### 4. Define Acceptance Criteria

Write clear, testable acceptance criteria using a **verb + observable outcome** format.

```
✓ Ingestion job runs on schedule and completes without errors
✓ Raw records land in LH Raw within 15 minutes of source availability
✓ Failed rows are written to the dead-letter path and an alert fires
✓ Re-run from a given date produces identical output (idempotent)
```

Rules:
- 3–5 criteria per story; more means the story is too large
- Each criterion must be independently verifiable
- Avoid vague language ("works correctly", "is fast") — specify observable outcomes

### 5. Estimate Effort (Story Points)

Use the Fibonacci sequence. Assign `TBD` when team input is required.

| Points | Scope |
|--------|-------|
| 1 | Trivial; < 2 hours; fully understood |
| 2 | Small; 2–4 hours; well-defined |
| 3 | Moderate; < 1 day; some unknowns |
| 5 | Multi-step; 1–2 days; moderate complexity |
| 8 | Complex; 3–5 days; dependencies or risk |

### 6. Link and Organize

Always link work items in the hierarchy:
- **Epic Link**: Every story must reference its parent epic
- **Blocks / Is Blocked By**: Document inter-story dependencies explicitly
- **Related To**: Connected work that shares context but is independent

### 7. Definition of Ready

A story is ready for sprint entry when:
- [ ] Story has a clear title and description
- [ ] Acceptance criteria written (3–5 testable)
- [ ] Story points estimated (not `TBD`)
- [ ] Epic link set
- [ ] Blocking dependencies identified or confirmed clear
- [ ] No open ambiguities that would prevent a developer from starting


## Quick Checklists

### Before Creating an Epic

- [ ] Name is specific and action-oriented
- [ ] Business value and success metrics are defined
- [ ] Estimated duration spans multiple sprints or 5+ stories
- [ ] Child stories or initial breakdown is outlined

### Before Creating a Story

- [ ] Story has a clear title and description
- [ ] 3–5 testable acceptance criteria written
- [ ] Story points estimated
- [ ] Epic link set
- [ ] Dependencies documented (`Blocks` / `Is Blocked By`)
- [ ] Assignee set or left `unassigned` for backlog

### Before Creating a Bug

- [ ] Title is a short factual description (no "Error:" prefix)
- [ ] Severity assigned (Critical / High / Medium / Low)
- [ ] Steps to reproduce provided
- [ ] Expected vs. actual behavior documented
- [ ] Environment (dev / test / prod) specified
- [ ] Affected source system or pipeline linked

## Common Pitfalls

| Mistake | Impact | Fix |
|---------|--------|-----|
| Vague story titles | Scope creep; hard to estimate | Write concise, specific titles that summarize the work clearly |
| Missing acceptance criteria | Unclear done definition; rework | Write 3–5 testable criteria before sprint entry |
| Stories > 8 points | Sprint fails; morale drops | Break into smaller stories; spike first if uncertain |
| Missing epic link | Orphaned work; lost traceability | Every story must link to a parent epic |
| Undocumented dependencies | Blocked mid-sprint | Identify blockers during refinement |
| Incomplete bug info | Can't reproduce; stuck in backlog | Always include repro steps, env, severity |
| Estimating bugs at 0 | Invisible work; capacity overrun | Assign at least 1 point per bug |

## Templates

- [Epic Template](./assets/epic-template.md)
- [Story Template](./assets/story-template.md)
- [Bug Template](./assets/bug-template.md)
