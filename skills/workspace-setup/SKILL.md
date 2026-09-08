---
name: workspace-setup
description: "Use when scaffolding a project workspace folder that holds several sibling git repos (frontend, backend, docs) already cloned/added by the user, plus a workspace-root AGENTS.md and a shared specs/ folder for cross-repo plans. Discovers and classifies existing sub-repos; never clones, inits, or modifies them. Keywords: workspace setup, project folder, multi-repo, FE/BE/Docs sibling repos, AGENTS.md, specs folder."
argument-hint: "Optional workspace path (default: current directory)"
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Workspace Setup Skill

Scaffold a **project workspace** folder — a parent directory holding several sibling git
repos (frontend, backend, docs) that the user has already cloned or created — with a
workspace-root `AGENTS.md`/`CLAUDE.md` overview and a shared `specs/` folder for plans
that span more than one sub-repo.

This skill only discovers what already exists and writes workspace-root instruction
files. It never clones, `git init`s, or otherwise modifies any sub-repo — the user
provisions BE/FE/docs repos themselves before running this command.

## Phase 0 — Preconditions

- Refuse to run with `ai-engineer-setup` itself as the target. If the working
  directory's root has `scripts/install.sh`, a `skills/` directory, and its own
  `AGENTS.md` matching this repo's canonical content, stop and explain this command is
  for *other* workspaces.
- Confirm the target directory exists (default: current directory).

## Phase 1 — Discover Sibling Repos (read-only)

List the workspace root's immediate subdirectories. A subdirectory containing `.git`
(folder or file, e.g. worktrees) is a sub-repo.

Classify each sub-repo using the same heuristics as the `ai-repo-setup` skill's Phase 1:

- **Frontend**: `package.json` with a `react`/`vite` dependency, or a `frontend/`,
  `apps/web`, or `client/`-style name → map to the `react-vite-antd` skill and
  `instructions/stacks/react-vite-antd.md`.
- **Backend**: `pyproject.toml`/`requirements.txt` with `fastapi`, or a `backend/`,
  `apps/api`, or `server/`-style name → map to the `python-fastapi-ddd` skill and
  `instructions/stacks/python-fastapi-ddd.md`.
- **Docs**: a repo named `docs` or dominated by markdown content → map to the
  `technical-writer` and `markdown-author` skills.

Do not modify any files during this phase.

If a sub-repo's stack is ambiguous, or it doesn't match any pattern, ask the user to
label it (FE/BE/Docs/Other/skip) — never guess silently.

Subdirectories without `.git` are noted as "not yet a repo" — informational only; this
skill never clones or inits anything on the user's behalf.

If a workspace-root `AGENTS.md` or `CLAUDE.md` already exists without the custom-block
markers (see Phase 2), stop and ask before touching it.

## Phase 2 — Generate/Update Workspace Files

Idempotent and merge-aware, mirroring `ai-repo-setup`: every generated file has a
*generated* region (rewritten each run) and a *custom* region preserved verbatim across
re-runs, delimited by:

```
<!-- workspace-setup:custom:start -->
<!-- Add workspace-specific rules below this line. Preserved across re-runs. -->
<!-- workspace-setup:custom:end -->
```

On re-run: read the existing file, extract whatever sits between the markers, regenerate
the generated portion, then splice the preserved custom block back in unchanged. If a
target file already exists but has no markers, stop and ask before touching it.

Write these at the workspace root:

### a. `AGENTS.md` (canonical)

- A short "Project Workspace" heading explaining this folder holds sibling repos, not
  application code itself.
- A list of detected sub-repos: folder name, role (FE/BE/Docs/Other/`TBD`), and the
  matched stack skill (or `TBD`).
- A note that each sub-repo keeps its **own** `AGENTS.md`/`CLAUDE.md`, generated
  separately by running `/setup-ai` *inside* that sub-repo — this command does not
  do that automatically.
- A pointer to `specs/` as the shared, cross-repo planning folder for plans spanning
  multiple sub-repos, written via `/spec-clarify` + `/spec-write` run from the
  workspace root.
- A pointer that global baseline rules load automatically from the machine's
  `ai-engineer-setup` install — this file adds only workspace-specific rules.
- The custom block, empty on first generation.

### b. `CLAUDE.md`

Identical content to `AGENTS.md`, mirroring this repo's own canonical/compat pattern.

No `.github/copilot-instructions.md` and no per-sub-repo files are generated — out of
scope for this command.

### c. `specs/` folder

If `specs/` or `specs/.gitignore` is missing, create `specs/.gitignore` with:

```
*
!.gitignore
```

This is the same convention the `spec-planning` skill uses, applied upfront so the
workspace layout is complete immediately rather than waiting for the first
`/spec-write` run.

## Phase 3 — Report

Report:

- Detected sub-repos and how each was classified, and any left `TBD`.
- Any subdirectories found without `.git` (informational only).
- What was created, updated, or left untouched at the workspace root (custom blocks
  preserved verbatim).
- A reminder to run `/setup-ai` inside each sub-repo separately for its own
  AGENTS.md/CLAUDE.md, and to use `/spec-clarify` + `/spec-write` from the workspace
  root for cross-repo plans.

## Constraints

- Read-only during discovery; only write files after sub-repos are classified or the
  user has answered outstanding questions.
- Never clone, `git init`, or otherwise create or modify a sub-repo.
- Never overwrite a custom-marked block.
- Never touch a file that lacks the custom-block markers without asking first.
- Mark unknowns `TBD`; do not invent sub-repo roles or stacks.
