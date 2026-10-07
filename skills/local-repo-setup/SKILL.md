---
name: local-repo-setup
description: "Use when setting up a public GitHub repository from a semantic local path, initializing git remotes, branch names, README, and safe first push workflow. Keywords: local repo setup, create repository, github.com, semantic path, initialize repo, first push."
argument-hint: "Provide local path, desired visibility, owner/group, repository name, default branch, and whether remote creation/push is approved."
user-invocable: true
allowed-tools: Bash
---

# Local Repo Setup Skill

Set up a `github.com` repository from a semantic local path with safe defaults.

## Safety Rules

- Never create a remote repository, push code, or change remotes without explicit approval.
- Never push commits on `main`, `master`, `dev`, or a detached HEAD — not even with explicit approval. Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch). If a protected branch or a bootstrap push is needed, give the user the exact command to run.
- Never commit or push secrets, `.env` files, credentials, private keys, local caches, session stores, or generated artifacts.
- Never overwrite an existing remote without confirming owner, repository, host, and URL.
- Prefer private repositories unless the user explicitly requests public visibility.

## Semantic Path Heuristic

Infer a repository name from the final path segment only after confirming with the user.

Examples:

| Local path | Suggested repo |
|---|---|
| `/Users/name/CodeRepository/local/ai-agent-setup` | `ai-agent-setup` |
| `/Users/name/CodeRepository/team/service-api` | `service-api` |

Use lowercase kebab-case for repository names unless the organization has a different convention.

## Preflight

Run local checks first:

```bash
pwd
git status --short
git rev-parse --is-inside-work-tree
git remote -v
git branch --show-current
```

Inspect common secret-risk files before first commit or push:

```bash
git status --ignored --short
```

If the repo is new, ensure `.gitignore` covers local state, dependencies, credentials, and build outputs before the first commit.

## Remote Setup

Confirm these fields before changing anything:

- Host: `github.com`.
- Owner or group.
- Repository name.
- Visibility.
- Default branch, usually `main` or `dev` depending on team convention.
- Remote name, usually `origin`.

## Repository Topology Setup

Support two repository topologies:

| Mode | Remote shape | Use when |
|---|---|---|
| Fork mode | `origin` = engineer fork, `upstream` = organization repo | Engineers work from personal forks. |
| Direct mode | `origin` = organization repo, no `upstream` | Engineers branch directly in the org repo. |

## Fork Remote Setup

For fork-based development:

- `origin` must point to the engineer fork.
- `upstream` must point to the organization repository.
- Engineers push feature and hotfix branches to `origin`.
- PRs target `upstream`.

Check current remotes:

```bash
git remote -v
```

Add upstream only after confirming the organization repository URL:

```bash
git remote add upstream https://github.com/<org>/<repo>.git
```

Verify both permanent branches exist upstream:

```bash
git fetch upstream
git ls-remote --heads upstream dev main
```

Create local tracking branches only after approval:

```bash
git checkout -B dev upstream/dev
git checkout -B main upstream/main
```

Then give the user the exact commands to run themselves:

```bash
git push -u origin dev --force-with-lease
git push -u origin main --force-with-lease
```

Never push `dev` or `main` yourself — not even with explicit approval. The `--force-with-lease` operations are destructive for fork branches, which is why they stay user-run.

## Direct Remote Setup

For direct repository development:

- `origin` points to the organization repository.
- No `upstream` is required.
- Engineers push `feature/*` and `hotfix/*` branches to `origin`.
- PRs target `origin:dev` or `origin:main`.

Verify permanent branches:

```bash
git fetch origin
git ls-remote --heads origin dev main
```

If `gh` is available and remote creation is approved:

```bash
gh repo create <owner>/<repo> --private --source . --remote origin
```

Use `--public` only when the user explicitly requests public visibility.

If the repository already exists and adding a remote is approved:

```bash
git remote add origin https://github.com/<owner>/<repo>.git
```

## First Push

Only after explicit approval, and only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch):

```bash
git push -u origin <branch>
```

If the first push targets `main`, `master`, or `dev` (for example a bootstrap default branch), never run it yourself — give the user the exact command to run.

Do not force-push.

## Final Response

Report:

- Local path.
- Repository URL.
- Default branch.
- Remote configuration.
- What was created or left for manual setup.
- Any skipped safety checks and why.
