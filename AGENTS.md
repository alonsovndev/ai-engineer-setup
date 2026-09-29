# Repository Notes

This repo stores portable AI-agent configuration, not application code.

## Canonical Files

- `instructions/AGENTS.md` is the shared global instruction payload; keep `instructions/CLAUDE.md` compatible with it for Claude Code.
- `adapters/opencode/opencode.jsonc` is only a template; `scripts/install.sh` generates `~/.config/opencode/opencode.jsonc` with this clone's absolute `instructions/AGENTS.md` path.
- `profiles/model-profiles.jsonc` is documentation; `scripts/run-agent.sh` has the executable model/profile mappings and must be updated separately.

## Install And Verify

- Install or refresh symlinks with `./scripts/install.sh`, then validate with `./scripts/verify.sh`.
- `scripts/install.sh` backs up existing managed targets as `<target>.backup-<timestamp>` and intentionally does not touch auth, session, cache, telemetry, or credential files.
- `scripts/uninstall.sh` removes only symlinks pointing into this repo and the generated opencode config; it does not restore backups. Codex links are limited to `~/.codex/AGENTS.md`, `~/.codex/agents`, and repo-pointing workflow skill links under `~/.codex/skills`.
- `scripts/verify.sh` checks local commands, required repo files, symlink targets, generated opencode config content, Codex agent/workflow parity, and global git aliases `sync`, `resync`, and `feature`.

## Harness Layout

- Claude Code uses `agents/claude/`, `commands/claude/`, `skills/`, `instructions/AGENTS.md` at `~/.claude/AGENTS.md`, and `instructions/CLAUDE.md` at `~/.claude/CLAUDE.md`.
- opencode uses generated config plus symlinks from `agents/opencode/` to `~/.config/opencode/agent` and `commands/opencode/` to `~/.config/opencode/command`.
- Copilot CLI uses `agents/copilot/`, `commands/copilot-prompts/`, `skills/`, and `adapters/copilot/instructions/`.
- Antigravity CLI uses `agents/antigravity/`, `skills/`, and `instructions/AGENTS.md` at `~/.gemini/config/agents`, `~/.gemini/config/skills`, and `~/.gemini/config/AGENTS.md`.
- Codex CLI uses `agents/codex/` TOML custom agents, Codex workflow skills under `adapters/codex/skills/` named after the canonical commands (linked per skill into `~/.codex/skills`), `~/.codex/AGENTS.md`, and the shared user skills path `~/.agents/skills`.

## Gotchas

- Restart opencode after changing config, agents, commands, or instructions; it does not hot-reload config.
- Do not symlink whole harness config roots because they include machine-local auth, sessions, caches, telemetry, and trust state.
- Do not commit secrets or local harness state; `.gitignore` also excludes token, secret, credential, key, cache, session, log, and backup patterns.
- There are no package manifests or test framework configs in this repo; use `./scripts/verify.sh` as the primary verification step for configuration changes; run `./scripts/test-verify.sh` and `./scripts/test-run-agent.sh` when changing their corresponding guards or launcher behavior.
