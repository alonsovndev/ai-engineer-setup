# Setup and replication

Use this guide to install the portable agent setup on a new machine or share the same setup with a peer.

## Scope

This repository contains reusable agent configuration only:

- Shared instructions. `instructions/AGENTS.md` is canonical; `instructions/CLAUDE.md` is kept for Claude Code compatibility.
- Stack-specific instruction guides under `instructions/stacks/`.
- Skills.
- Agent definitions.
- Command and prompt wrappers.
- Harness adapters that are safe to version.
- Local scripts for linking, unlinking, and validation.

It does not contain auth files, provider tokens, sessions, telemetry, caches, or machine-specific trust state.

## Prerequisites

Install only the harnesses you plan to use:

| Harness | Expected command |
|---|---|
| Codex CLI | `codex` |
| Claude Code | `claude` |
| opencode | `opencode` |
| GitHub Copilot CLI | `copilot` |
| Antigravity CLI | `agy` |

Git is required for normal repository workflows.

## Clone on another machine

Clone the repository to any local path:

```bash
git clone <repository-url> ai-agent-setup
cd ai-agent-setup
```

The clone path does not need to match the original machine. `scripts/install.sh` resolves the local repository root at runtime.

## Install

Run from the repository root:

```bash
./scripts/install.sh
./scripts/verify.sh
```

`install.sh` backs up existing portable config paths before replacing them. Backups use the suffix `.backup-<timestamp>`.

Preview changes before installing with:

```bash
./scripts/install.sh --dry-run
```


Restart opencode after install or config changes because it loads config only at startup.

## Install skills

`skills/` is the portable source of truth for both custom skills and community skills.

Create custom skills directly in this repository:

```text
skills/<skill-name>/SKILL.md
```

Install community skills from [skills.sh](https://skills.sh/) from the repository root, then confirm the new files landed under `skills/`:

```bash
npx skills add <owner/repo@skill>
git status
./scripts/install.sh
./scripts/verify.sh
```

A skill is portable when it appears as `skills/<skill-name>/SKILL.md`. After it is committed and pulled on another machine, run `./scripts/install.sh` and `./scripts/verify.sh` there to expose it through the managed harness paths.

Avoid relying on unversioned global installs for shared setup. If using `npx skills add ... -g`, still verify that the CLI wrote through one of the managed symlinks into this repository's `skills/` directory.

For updates, run the skills update command only when you intend to review and version the resulting changes:

```bash
npx skills update
git diff
./scripts/verify.sh
```

## What install changes

The installer creates symlinks for portable directories and writes one generated opencode config file. For Codex, it manages only `~/.codex/AGENTS.md`, `~/.codex/agents`, and its own per-skill links under `~/.codex/skills`; it leaves `config.toml`, auth, sessions, caches, the Codex-managed `.system` skills, and other Codex state untouched.

See [Symlink map](./symlink-map.md) for the full source-to-target mapping.

The opencode config is generated at `~/.config/opencode/opencode.jsonc` because opencode needs an absolute instructions path for the local clone. The generated file includes a marker comment and should not be committed.

The generated opencode config also sets `skills.paths` to this repository's absolute `skills/` path. Codex discovers the same portable skills through `~/.agents/skills`; its workflow command skills (named after the canonical commands) are linked per skill into `~/.codex/skills` so they do not appear in other harnesses.

## Validate

Run:

```bash
./scripts/verify.sh
```

The verifier checks:

- Harness commands available on `PATH`.
- Required repository files exist.
- Symlinks point to this clone.
- The generated opencode config points to this clone.
- Git aliases `sync`, `resync`, and `feature` are available, reported as warnings if absent.

Missing selected harness commands are reported as issues. Install only the tools you need, then rerun the verifier for those harnesses:

```bash
./scripts/verify.sh --harness codex
./scripts/verify.sh --harness claude
./scripts/verify.sh --harness opencode
./scripts/verify.sh --harness copilot
./scripts/verify.sh --harness antigravity
```

## Git aliases

The repository workflow expects these user-level aliases:

```ini
[alias]
    sync = !git fetch upstream && git merge upstream/$(git branch --show-current) && git push origin HEAD
    resync = !git fetch upstream && git reset --hard upstream/$(git branch --show-current) && git push origin HEAD --force-with-lease
    feature = "!f() { test -n \"$1\" || { echo \"usage: git feature <branch-name>\"; return 1; }; git checkout dev && git resync && git checkout -b \"$1\"; }; f"
```

These aliases are for fork-mode repositories. In direct-mode repositories, use the manual workflow documented in [Git repo flow](./git-repo-flow.md).

## Update an existing setup

Pull the latest repository changes, then rerun install and validation:

```bash
git pull --ff-only
./scripts/install.sh
./scripts/verify.sh
```

Rerunning `install.sh` is safe for paths already managed by this repository. Existing non-managed files are backed up before replacement.

Restart opencode after update so it reloads generated config, instructions, agents, commands, and skills.

## Uninstall

Run:

```bash
./scripts/uninstall.sh
```

`uninstall.sh` removes only symlinks that point into this repository and the generated opencode config created by `install.sh`, including the managed Codex instruction and agent links. It does not automatically restore backups.

## Restore a backup

Backups are written next to the original target path with `.backup-<timestamp>` appended. Restore manually by moving the desired backup back to the original path.

Example:

```bash
mv ~/.claude/AGENTS.md.backup-20260817120000 ~/.claude/AGENTS.md
```

## Known local-only state

Do not copy or commit these files from a machine config directory:

- Auth files and tokens.
- Session stores.
- Cache directories.
- Logs and telemetry.
- Provider credential files.

Use the harness login flow on each machine instead.
