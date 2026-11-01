# Code Agent Harness

> A portable development harness for AI coding agents, skills, commands, instructions, and workflows.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Part of [alonsovndev](https://github.com/alonsovndev), the open-source engineering lab by [Alonso Villanueva](https://alonsovndev.com).

Code Agent Harness is an open-source AI coding agent harness for maintaining reusable development configuration across coding-agent platforms. It standardizes AI-assisted development workflows through shared agents, agent skills, commands, instructions, and model profiles, with adapters for Claude Code, Codex CLI, OpenCode, GitHub Copilot CLI, and Antigravity CLI.

Keep your AI developer tools and workflows consistent across machines and teams while adapting configuration to each platform. Shared content stays portable, and platform adapters provide a place to support future coding-agent tools.

This repository tracks reusable instructions, skills, agents, commands, model profiles, scripts, workflows, and platform adapters. It intentionally excludes auth, sessions, telemetry, logs, caches, and machine-specific state.

## Layout

| Path                        | Purpose                                                                                                                                                            |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `instructions/`             | Shared global working rules. `AGENTS.md` is canonical; `CLAUDE.md` is kept for Claude Code compatibility. Stack-specific guides live under `instructions/stacks/`. |
| `skills/`                   | Shared `SKILL.md` packages loaded by supported harnesses.                                                                                                          |
| `agents/claude/`            | Claude Code agent definitions.                                                                                                                                     |
| `agents/copilot/`           | Copilot CLI agent definitions.                                                                                                                                     |
| `agents/opencode/`          | OpenCode agent definitions.                                                                                                                                         |
| `agents/antigravity/`       | Antigravity CLI agent definitions.                                                                                                                                  |
| `agents/codex/`             | Codex custom subagents in TOML format.                                                                                                                               |
| `commands/claude/`          | Claude Code slash commands.                                                                                                                                        |
| `commands/opencode/`        | OpenCode command wrappers.                                                                                                                                         |
| `commands/copilot-prompts/` | Copilot prompt files.                                                                                                                                              |
| `adapters/codex/skills/`    | Codex skill equivalents for shared workflow commands (linked per skill into `~/.codex/skills`, not the shared skills tree).                                            |
| `adapters/`                 | Harness-specific config files that are safe to version.                                                                                                            |
| `profiles/`                 | Model/profile mapping by harness.                                                                                                                                  |
| `scripts/`                  | Local install, uninstall, and validation scripts.                                                                                                                  |

Core agents currently include `code-review`, `product-ba`, `tech-lead`, `python-api`, `react-ui`, `postgresql`, `terraform`, `bug-finder`, and `doc-tracker`.

Core development workflow skills include `git-repo-flow`, `git-commit`, `git-create-pr`, `gh-prs`, `pr-review`, `branch-protection`, `auto-delete-branches`, `local-repo-setup`, `git-repo-setup`, `ai-repo-setup`, `workspace-setup`, `github-actions`, and `spec-planning`.

Stack-specific standards are not loaded as global defaults. Use `python-fastapi-ddd` for FastAPI/DDD work and `react-vite-antd` for React/TypeScript/Vite/Ant Design UI work.

## New Machine Quickstart

Clone the repository and run:

```bash
git clone https://github.com/alonsovndev/code-agent-harness.git
cd code-agent-harness
./scripts/install.sh
```

Choose one or more tools from the terminal menu, or choose **All**. Then run the verification command printed by the installer. Supported selection names are `claude`, `codex`, `opencode`, `copilot`, and `antigravity`.

For scripted installation, specify the selection explicitly:

```bash
./scripts/install.sh --harness claude
./scripts/install.sh --harness codex --harness opencode
./scripts/install.sh --all
```

Noninteractive calls without `--harness` or `--all` exit with usage status `2`; update existing automation that previously relied on installing all tools by default. The installer configures tools; install their CLI applications separately.

`install.sh` backs up existing portable config paths before replacing them with symlinks. It does not touch auth, session, cache, or telemetry files.

Claude Code plugins listed in `plugins/claude-plugins.txt` are installed separately with `./scripts/install-plugins.sh` (it clones marketplaces from GitHub, so `install.sh` does not run it); `verify.sh` only warns when one is missing.

`verify.sh` checks the managed symlinks and enforces parity against `agents/claude/` and `commands/claude/`. Codex custom agents live under `agents/codex/`; each canonical command has a Codex skill equivalent under `adapters/codex/skills/<command>/`, linked per skill into `~/.codex/skills` so it stays out of the shared skills tree the other harnesses load. Add new agents and commands to every supported harness in the same change.

`./scripts/test-install.sh` checks tool selection, terminal menus, dry runs, installation, uninstall, generator-marker compatibility, and clone relocation in temporary directories. Its terminal tests use Python's standard library. `./scripts/test-verify.sh` self-tests verifier parity, and `./scripts/test-run-agent.sh` checks launcher arguments through stub executables without model calls. Run the matching self-test after changing these scripts.

Preview changes before installing with:

```bash
./scripts/install.sh --harness codex --dry-run
```

When OpenCode is selected, restart it after install or config changes because it loads config only at startup.

## Skills

`skills/` is the source of truth for portable skills. Custom skills should be created directly under this directory, and community skills from [skills.sh](https://skills.sh/) should be installed so they land here.

Recommended community skill workflow:

```bash
npx skills add <owner/repo@skill>
git status
./scripts/install.sh
```

Select the tools to refresh and run the printed verification command. If the new skill appears as `skills/<skill-name>/SKILL.md`, it is portable and exposed through the selected tools' managed paths and the shared `~/.agents/skills` link. Review the diff before committing community skills or skill updates.

## Update Existing Install

Run from this repository:

```bash
git pull --ff-only
./scripts/install.sh
```

Select the tools to refresh, then run the printed verification command. Selections are not stored; choose them again on each run. Installation is additive: selecting fewer tools leaves previously configured tools in place. The installer refreshes selected symlinks and regenerates OpenCode's config only when OpenCode is selected.

Use `./scripts/verify.sh --harness codex` to verify one tool, repeat `--harness` for a subset, or use `--all` for every supported tool. Verification without flags still checks all tools.

Existing clone directories can keep their names. If you move or rename your clone, rerun installation and verification from its new location; see [Rename and relocation](docs/setup-and-replication.md#rename-and-relocation).

Deep setup docs:

- [Setup and replication](docs/setup-and-replication.md)
- [Harness matrix](docs/harness-matrix.md)
- [Symlink map](docs/symlink-map.md)
- [Troubleshooting](docs/troubleshooting.md)

## Uninstall

Run `./scripts/uninstall.sh` for the selection menu, or use explicit flags:

```bash
./scripts/uninstall.sh --harness codex --dry-run
./scripts/uninstall.sh --harness codex
./scripts/uninstall.sh --all
```

Selective uninstall keeps unselected configuration and shared `~/.agents/skills` intact. The shared link is removed only by choosing **All** or using `--all`, even if every tool is selected individually. Backups are not restored automatically.

## Safety

- Do not commit auth or local session state from `~/.codex`; the installer only manages `AGENTS.md`, `agents/`, and its own workflow skill links there.
- Do not commit auth files from `~/.claude`, `~/.copilot`, `~/.config/github-copilot`, or provider credential stores.
- Do not symlink whole config roots. Only symlink the portable paths handled by `scripts/install.sh`.
- Restart OpenCode after config changes; it loads config once at startup.

## Git Repo Flow

This harness supports fork-mode and direct-mode workflows for GitHub repositories. See [Git repo flow](docs/git-repo-flow.md) for branch naming, aliases, PR targets, and safety gates.

## Contributing

Contributions to shared configuration and platform adapters are welcome through [pull requests](https://github.com/alonsovndev/code-agent-harness/pulls). Keep changes focused, preserve command and agent parity across supported platforms, and run the relevant checks described above before submitting.
