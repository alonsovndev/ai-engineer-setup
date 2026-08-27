# ai-agent-setup

Portable AI coding-agent setup for Claude Code, opencode, and GitHub Copilot CLI.

This repository tracks only reusable instructions, skills, agents, commands, model profiles, and harness adapters. It intentionally excludes auth, sessions, telemetry, logs, caches, and machine-specific state.

## Layout

| Path | Purpose |
|---|---|
| `instructions/` | Shared global working rules. `AGENTS.md` is canonical; `CLAUDE.md` is kept for Claude Code compatibility. Stack-specific guides live under `instructions/stacks/`. |
| `skills/` | Shared `SKILL.md` packages loaded by supported harnesses. |
| `agents/claude/` | Claude Code agent definitions. |
| `agents/copilot/` | Copilot CLI agent definitions. |
| `agents/opencode/` | opencode agent definitions. |
| `commands/claude/` | Claude Code slash commands. |
| `commands/opencode/` | opencode command wrappers. |
| `commands/copilot-prompts/` | Copilot prompt files. |
| `adapters/` | Harness-specific config files that are safe to version. |
| `profiles/` | Model/profile mapping by harness. |
| `scripts/` | Local install, uninstall, and validation scripts. |

Core agents currently include `code-review`, `product-ba`, `tech-lead`, `python-api`, `react-ui`, `postgresql`, and `terraform`.

Core development workflow skills include `git-repo-flow`, `git-commit`, `create-pr`, `gh-prs`, `pr-review`, `branch-protection`, `auto-delete-branches`, `local-repo-setup`, `git-repo-setup`, `ai-repo-setup`, `github-actions`, and `spec-planning`.

Stack-specific standards are not loaded as global defaults. Use `python-fastapi-ddd` for FastAPI/DDD work and `react-vite-antd` for React/TypeScript/Vite/Ant Design UI work.

## New Machine Quickstart

Run from this repository:

```bash
./scripts/install.sh
./scripts/verify.sh
```

`install.sh` backs up existing portable config paths before replacing them with symlinks. It does not touch auth, session, cache, or telemetry files.

Preview changes before installing with:

```bash
./scripts/install.sh --dry-run
```


Restart opencode after install or config changes because it loads config only at startup.

## Skills

`skills/` is the source of truth for portable skills. Custom skills should be created directly under this directory, and community skills from [skills.sh](https://skills.sh/) should be installed so they land here.

Recommended community skill workflow:

```bash
npx skills add <owner/repo@skill>
git status
./scripts/install.sh
./scripts/verify.sh
```

If the new skill appears as `skills/<skill-name>/SKILL.md`, it is portable and exposed through the managed symlinks for Claude Code, GitHub Copilot CLI, shared agent paths, and opencode's generated `skills.paths` config. Review the diff before committing community skills or skill updates.

## Update Existing Install

Run from this repository:

```bash
git pull --ff-only
./scripts/install.sh
./scripts/verify.sh
```

Rerunning `install.sh` refreshes managed symlinks and regenerates opencode's machine-local config for this clone.

Deep setup docs:

- [Setup and replication](docs/setup-and-replication.md)
- [Harness matrix](docs/harness-matrix.md)
- [Symlink map](docs/symlink-map.md)
- [Troubleshooting](docs/troubleshooting.md)

## Safety

- Do not commit auth files from `~/.claude`, `~/.copilot`, `~/.config/github-copilot`, or provider credential stores.
- Do not symlink whole config roots. Only symlink the portable paths handled by `scripts/install.sh`.
- Restart opencode after config changes; it loads config once at startup.

## Git Repo Flow

This setup supports fork-mode and direct-mode workflows for GitHub repositories. See [Git repo flow](docs/git-repo-flow.md) for branch naming, aliases, PR targets, and safety gates.
