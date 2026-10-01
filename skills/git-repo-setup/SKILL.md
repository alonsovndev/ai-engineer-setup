---
name: git-repo-setup
description: "Use for post-clone repository bootstrap: creating a dev branch from main when it doesn't exist, and scaffolding baseline hygiene files (README, .gitignore, LICENSE, CONTRIBUTING) that don't exist yet. Branch protection/rulesets are out of scope for this skill — use the branch-protection skill directly if needed. Keywords: post-clone setup, dev branch, repo bootstrap, README, gitignore, license, contributing."
argument-hint: "Repo path (default: current directory), license choice or skip, whether branch changes are approved"
user-invocable: true
allowed-tools: Bash, Read, Write, Edit
---

# Git Repo Setup Skill

Bootstrap a freshly cloned repository: make sure `dev` exists, and scaffold any missing
baseline hygiene files. This skill delegates branch/PR conventions to `git-repo-flow`
rather than duplicating them. Branch protection/rulesets are intentionally out of scope —
set those up manually, or use the `branch-protection` skill directly.

## Preflight

Run read-only checks first:

```bash
git remote -v
git branch --show-current
command -v gh
gh auth status
```

Detect fork mode (`origin` + `upstream`) or direct mode (`origin` only) using the
`git-repo-flow` skill's detection rules. Then check which permanent branches already
exist on the relevant remote (`upstream` in fork mode, `origin` in direct mode):

```bash
git fetch <remote>
git ls-remote --heads <remote> dev main
```

If `main` itself doesn't exist, stop and ask — this skill only creates `dev` from an
existing `main`, it does not invent a `main` branch.

## Step 1 — Create `dev` from `main` if missing

If `dev` is already present, skip this step and report it as already set up.

If `dev` is missing, confirm with the user before writing anything, then:

```bash
git fetch <remote>
git checkout -B dev <remote>/main
```

Then give the user the exact command to run themselves: `git push -u <remote> dev`.
Never push `dev` yourself — not even with explicit approval.

## Step 2 — Scaffold repo hygiene files

Create-only: check each file for existence first and only generate the ones missing.
Never overwrite an existing file, even partially.

```bash
test -f README.md && echo exists || echo missing
test -f .gitignore && echo exists || echo missing
test -f LICENSE && echo exists || echo missing
test -f CONTRIBUTING.md && echo exists || echo missing
```

- **`README.md`** (if missing): a minimal skeleton — title, one-line description
  placeholder, and `TBD` sections for setup/usage. Do not invent project details you
  don't know; mark them `TBD`.
- **`.gitignore`** (if missing): a baseline matched to detected stack(s) — check for
  `package.json` (Node/JS baseline: `node_modules/`, build output, `.env`), a Python
  project (`pyproject.toml`/`requirements.txt`: `__pycache__/`, `.venv/`, build/dist
  artifacts), plus common OS/editor noise (`.DS_Store`, `.idea/`, `.vscode/` if not
  intentionally tracked). If no stack is detected, use a generic OS/editor-only baseline.
- **`LICENSE`** (if missing): ask which license to use (MIT, Apache-2.0, proprietary/
  all-rights-reserved, or skip) — never assume a default, this is the user's call every
  run.
- **`CONTRIBUTING.md`** (if missing): summarize the branch/PR conventions from
  `git-repo-flow` (detected topology, branch naming, PR targets) so it matches what this
  repo actually does, not a generic template.

If a target file exists, report it as already present and move on — do not ask whether
to overwrite it.

## Final Response

Report:

- Whether `dev` already existed or was created (and the push command handed to the user).
- Which hygiene files were created vs. already existed.
- Any `TBD` items (license choice deferred, undetected stack, etc.).
- A reminder that branch protection/rulesets are not configured by this skill — set them
  up manually, or use the `branch-protection` skill directly.

## Constraints

- Never overwrite an existing README/.gitignore/LICENSE/CONTRIBUTING.
- Never push branches yourself — a `dev` bootstrap push is always handed to the user as the exact command to run.
- Do not configure branch protection or rulesets — out of scope for this skill.
- Mark unknowns `TBD`; do not invent license choice, org name, or project details.
