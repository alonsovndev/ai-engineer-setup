---
name: ai-repo-setup
description: "Use when wiring AI-agent tooling (Claude Code, opencode, GitHub Copilot CLI) into a new or existing target repository with frontend, backend, and/or docs areas. Generates project-level AGENTS.md, CLAUDE.md, and .github/copilot-instructions.md that point to the right stack skills and reuse the machine-global ai-engineer-setup install rather than duplicating it. Keywords: AI setup, project onboarding, AGENTS.md, CLAUDE.md, copilot-instructions, opencode, FE/BE/Docs, monorepo instructions."
argument-hint: "Optional target path (default: current repo); optional --fe/--be/--docs stack overrides"
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# AI Repo Setup Skill

Wire project-level AI-agent instructions into a target repo so Claude Code, opencode, and
GitHub Copilot CLI all pick up the right conventions for its frontend, backend, and docs
areas — without duplicating the shared skills/agents/commands already provided by the
machine-global `ai-engineer-setup` install.

This skill only writes instruction files. It never scaffolds application code, CI
workflows, or package manifests.

## Phase 0 — Preconditions

- Refuse to run with `ai-engineer-setup` itself as the target. If the working directory's
  root has `scripts/install.sh`, a `skills/` directory, and its own `AGENTS.md` matching
  this repo's canonical content, stop and explain this command is for *other* repos.
- Best-effort check that the global install is present:
  ```bash
  ls ~/.claude/AGENTS.md ~/.config/opencode/opencode.jsonc ~/.copilot/.github/instructions 2>/dev/null
  ```
  If any are missing, warn the user that skills/agents referenced by the generated files
  won't resolve until `./scripts/install.sh` is run in `ai-engineer-setup` on this
  machine. This is a warning, not a blocker.

## Phase 1 — Discover Target Repo Structure (read-only)

List the target repo's top-level directories and detect each area:

- **Frontend**: `package.json` with a `react`/`vite` dependency, or a `frontend/`,
  `apps/web`, or `client/`-style directory → map to the `react-vite-antd` skill and
  `instructions/stacks/react-vite-antd.md`.
- **Backend**: `pyproject.toml`/`requirements.txt` with `fastapi`, or a `backend/`,
  `apps/api`, or `server/`-style directory → map to the `python-fastapi-ddd` skill and
  `instructions/stacks/python-fastapi-ddd.md`.
- **Docs**: a `docs/` directory → map to the `technical-writer` and `markdown-author`
  skills (add `mermaid-author`/`drawio-author` only if diagrams are present).

Do not modify any files during this phase.

If a detected folder's stack is ambiguous, or the repo is new/empty, ask the user:

- Which folder (if any) holds each of FE/BE/Docs.
- Which stack applies to each — allow "not applicable" (single-purpose repo) and
  "other/custom stack" (mark `TBD`, do not attach a stack skill that doesn't fit; this
  mirrors the global rule "do not apply stack-specific architecture rules unless the
  current repository actually uses that stack").

Never guess a stack assignment silently — confirm or mark `TBD`.

## Phase 2 — Generate/Update Project Instruction Files

Idempotent and merge-aware: every generated file has a *generated* region (rewritten
each run) and a *custom* region preserved verbatim across re-runs, delimited by:

```
<!-- ai-repo-setup:custom:start -->
<!-- Add project-specific rules below this line. Preserved across re-runs. -->
<!-- ai-repo-setup:custom:end -->
```

On re-run: read the existing file, extract whatever sits between the markers, regenerate
the generated portion, then splice the preserved custom block back in unchanged. If a
target file already exists but has no markers (hand-authored before this skill was used),
stop and ask before touching it — never overwrite it silently.

Write these files at the target repo root:

### a. `AGENTS.md` (canonical)

- Repo structure summary: detected/confirmed FE/BE/Docs paths.
- A pointer that global baseline rules load automatically from the machine's
  `ai-engineer-setup` install (`~/.claude/AGENTS.md` / opencode `instructions` / Copilot
  workspace instructions) — this file adds only project-specific rules, it does not
  restate global ones.
- One section per detected/confirmed area naming the stack skill and
  `instructions/stacks/*.md` file to use (or `TBD` if none fits).
- The custom block, empty on first generation.

### b. `CLAUDE.md`

Identical content to `AGENTS.md`, mirroring this repo's own canonical/compat pattern
(`instructions/AGENTS.md` / `instructions/CLAUDE.md`) so Claude Code's project-level file
is populated too.

### c. `.github/copilot-instructions.md`

A condensed Copilot dialect of the same content, following the precedence/budget
conventions already established in
`adapters/copilot/instructions/INSTRUCTION-PRECEDENCE.md` and
`adapters/copilot/instructions/PERFORMANCE-BUDGET.md`. Own custom-block markers. Create
`.github/` if it doesn't exist.

No project-level `opencode.jsonc` is generated by default — opencode reads a project's
root `AGENTS.md` natively, and the machine-global `opencode.jsonc` (from `install.sh`)
already sets `skills.paths`. Only create one if the user explicitly asks for repo-scoped
opencode permission overrides, and confirm before writing it.

## Phase 3 — Report

Report:

- What was created, what was updated, and what was left untouched (custom blocks
  preserved verbatim).
- Which stack was assigned to which folder, and any `TBD` items (undetected or ambiguous
  stack).
- A reminder that opencode needs a restart after config/instruction changes.

## Constraints

- Read-only during discovery; only write files after structure is confirmed or the user
  has answered outstanding questions.
- Never overwrite a custom-marked block.
- Never touch a file that lacks the custom-block markers without asking first.
- Never scaffold application folders, CI workflows, or package manifests.
- Mark unknowns `TBD`; do not invent stack choices or project structure.
