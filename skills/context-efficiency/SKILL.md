---
name: context-efficiency
description: "Use when optimizing responses, plans, handoffs, tool usage, or context management for low token usage without reducing engineering quality. Keywords: token efficiency, concise, terse, low verbosity, caveman mode, response budget, context trimming, compact output, no fluff."
argument-hint: "Describe the task, desired detail level, output budget, and any facts that must not be omitted."
user-invocable: true
---
# Context Efficiency Skill

Reduce token usage while preserving correctness, evidence, risks, and verification status.

## Use This Skill For

- Low-verbosity or token-conscious responses.
- Summarizing tool output, logs, diffs, plans, or handoffs.
- Trimming context before delegating to agents or writing prompts.
- Avoiding repeated explanations across turns.
- Producing compact final responses without hiding failures or uncertainty.

## Do Not Use This Skill For

- Removing necessary evidence, file references, commands, failures, security risks, or verification gaps.
- Replacing clear professional language with broken grammar.
- Compressing user-facing documentation, ADRs, requirements, or runbooks below what the artifact needs.
- Omitting assumptions or `TBD` values to look concise.

## Compression Rules

- Lead with the outcome.
- Prefer bullets over prose for status, changes, findings, and next steps.
- Keep only decision-relevant context: what changed, why it matters, what failed, what remains unknown.
- Summarize command output; include exact command and pass/fail result.
- Reference paths instead of pasting long snippets unless the snippet is the deliverable.
- Do not repeat prior plans, unchanged context, or obvious mechanics.
- Remove hedging when evidence is clear; keep caveats when risk is real.
- Ask one concise question only when blocked.

## Preserve Quality

Always keep:

- File paths and line references for findings or changed artifacts.
- Exact commands run and results.
- Test, build, lint, type-check, or verification gaps.
- Security, data loss, compatibility, migration, and operational risks.
- Assumptions, blockers, and `TBD` values.
- User decisions needed before external systems, destructive actions, commits, pushes, or dependency changes.

## Detail Levels

| Level | Use when | Output shape |
|---|---|---|
| Minimal | Simple completed task or quick answer | 1-3 bullets or one short paragraph |
| Standard | Normal code changes or diagnosis | Outcome, changes, verification, risks |
| Detailed | Reviews, architecture, incidents, failures | Findings first, evidence, impact, fix, verification |

Default to `Minimal` for engineering work unless the user asks for more or less detail.

## Tool And Context Hygiene

- Search narrowly first; broaden only when needed.
- Read targeted files and relevant sections instead of entire unrelated files.
- Batch independent reads/searches in parallel.
- Avoid dumping full logs into chat; summarize and point to saved output when available.
- In handoffs, include only current state, key evidence, pending work, and blockers.

## Final Response Template

Use this compact shape when suitable:

```markdown
Implemented {outcome}.

Changed:
- `{path}` - {short purpose}

Verification:
- `{command}` - passed|failed|not run ({reason})

Risks:
- {only if relevant}
```

## Review Checklist

- Outcome appears first.
- No greetings, filler, or repeated context.
- No obvious code narration.
- Commands and verification status are explicit.
- Important risks and blockers are not compressed away.
- Response is as short as possible without becoming ambiguous.
