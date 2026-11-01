# Setup and replication

Use this guide to install Code Agent Harness on a new machine or share its reusable AI coding-agent configuration with a peer.

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
| OpenCode | `opencode` |
| GitHub Copilot CLI | `copilot` |
| Antigravity CLI | `agy` |

Install tool applications separately; the harness installer manages configuration only. Git is required for normal repository workflows.

## Clone on another machine

Clone the repository to any local path:

```bash
git clone https://github.com/alonsovndev/code-agent-harness.git
cd code-agent-harness
```

The clone path does not need to match the original machine. `scripts/install.sh` resolves the local repository root at runtime.

## Install

Run from the repository root:

```bash
./scripts/install.sh
```

In a terminal, choose one or multiple whitespace-separated menu numbers, **All**, or **Cancel**. Invalid input prompts again; cancellation and closed input make no changes. Run the verification command printed for your selection after installation.

Use explicit flags for a single tool, a subset, or all tools:

```bash
./scripts/install.sh --harness claude
./scripts/install.sh --harness codex --harness opencode
./scripts/install.sh --all
```

Supported identifiers are `claude`, `codex`, `opencode`, `copilot`, and `antigravity`. Repeated selections are deduplicated, and `--all` includes every tool even when combined with `--harness`.

Noninteractive runs require `--harness` or `--all`, including dry runs. Calls without a selection exit with status `2` before making changes. Existing automation that previously used a bare `install.sh` or `uninstall.sh` must add a selection. Use `--help` for usage without opening the menu.

`install.sh` backs up existing portable config paths before replacing them. Backups use the suffix `.backup-<timestamp>`.

Preview changes before installing with:

```bash
./scripts/install.sh --harness codex --dry-run
```

When OpenCode is selected, restart it after install or config changes because it loads config only at startup.

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
```

Select the tools to refresh and run the printed verification command. A skill is portable when it appears as `skills/<skill-name>/SKILL.md`. After it is committed and pulled on another machine, repeat installation and verification there to expose it through the selected tools' managed paths.

Avoid relying on unversioned global installs for shared setup. If using `npx skills add ... -g`, still verify that the CLI wrote through one of the managed symlinks into this repository's `skills/` directory.

For updates, run the skills update command only when you intend to review and version the resulting changes:

```bash
npx skills update
git diff
./scripts/verify.sh
```

## Install Claude Code plugins

Claude Code plugins are tracked in `plugins/claude-plugins.txt` (one `<marketplace-github-repo> <plugin>@<marketplace-name>` per line). `./scripts/install.sh` does not install them because it makes no network calls; run the plugin installer separately:

```bash
./scripts/install-plugins.sh --dry-run
./scripts/install-plugins.sh
```

It clones each marketplace from GitHub and installs the plugin at user scope, skipping anything already installed. `./scripts/verify.sh` only warns when a listed plugin is missing. Plugin-specific setup stays manual, for example `/seo setup` after installing `claude-seo`.

To add a plugin, append a line to the manifest and rerun the script. To remove one, delete the line and run `claude plugin uninstall <plugin>@<marketplace>`; the script never uninstalls.

## What install changes

The installer creates symlinks for selected tools and writes the generated OpenCode config only when OpenCode is selected. It also refreshes the shared `~/.agents/skills` link on every installation; other compatible tools may discover shared skills through it. Unselected tools' dedicated configuration is unchanged. For Codex, the installer manages only `~/.codex/AGENTS.md`, `~/.codex/agents`, and its own per-skill links under `~/.codex/skills`; it leaves `config.toml`, auth, sessions, caches, the Codex-managed `.system` skills, and other Codex state untouched.

See [Symlink map](./symlink-map.md) for the full source-to-target mapping.

The OpenCode config is generated at `~/.config/opencode/opencode.jsonc` because OpenCode needs an absolute instructions path for the local clone. The generated file includes a marker comment and should not be committed.

The generated OpenCode config also sets `skills.paths` to this repository's absolute `skills/` path. Codex discovers the same portable skills through `~/.agents/skills`; its workflow command skills (named after the canonical commands) are linked per skill into `~/.codex/skills` so they do not appear in other harnesses.

The installer also links `instructions/AGENTS.md` to `~/.config/opencode/AGENTS.md` so OpenCode's auto-loaded global instructions cannot drift from the canonical file.

## Validate

Run:

```bash
./scripts/verify.sh
```

Without flags, verification checks all supported tools; this default is unchanged. For a partial install, use the matching `--harness` flags printed by the installer. Repeat `--harness` to validate multiple tools, or use `--all` explicitly for every tool.

The verifier checks:

- Harness commands available on `PATH`.
- Required repository files exist.
- Symlinks point to this clone.
- The generated OpenCode config points to this clone.
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

`git sync`, `git resync`, and `git feature` all push the current branch, so agents never run them on a protected branch (`main`, `master`, `dev`) — run them yourself when needed; see the [push policy](./git-repo-flow.md#push-policy).

## Update an existing setup

Pull the latest repository changes, then rerun install and validation:

```bash
git pull --ff-only
./scripts/install.sh
```

Reselect the tools to refresh and run the printed verification command. Selections are not stored. Installation is additive: selecting fewer tools does not remove previously installed configuration. Rerunning `install.sh` is safe for paths already managed by this repository. Existing non-managed files are backed up before replacement.

If OpenCode was selected, restart it after update so it reloads generated config, instructions, agents, commands, and skills.

## Rename and relocation

Existing clones can keep their directory names. The installer resolves the repository root at runtime; command names, skill identifiers, configuration keys, and managed destination paths are unchanged by the rebrand.

Existing OpenCode configs with the legacy installer marker remain valid when their paths point to the current clone. Rerunning `install.sh --harness opencode` backs up the old config and writes the new `code-agent-harness` marker. Uninstall continues to recognize both current and historical managed configs.

If you move or rename a clone, its absolute symlinks and generated configuration still point to the previous location. From the new repository root, refresh every previously configured tool. For an all-tools installation:

```bash
./scripts/install.sh --all --dry-run
./scripts/install.sh --all
./scripts/verify.sh --all
```

For a subset, replace `--all` with the matching `--harness` flags on all three commands.

Restart your coding-agent tools afterward so they reload instructions, skills, and configuration. Moving the directory is optional.

### Manual GitHub actions

The repository contents prepare for the rename; installation does not change GitHub settings or git remotes.

1. Rename the GitHub repository to `alonsovndev/code-agent-harness`.
2. Set the About description to: "A portable development harness for AI coding agents, skills, commands, instructions, and workflows."
3. Set the topics to `ai-agents`, `coding-agents`, `developer-tools`, `claude-code`, `codex`, `opencode`, `github-copilot`, `ai-development`, `agentic-workflows`, and `agent-harness`.
4. After the GitHub rename, update each clone's remote:

   ```bash
   git remote set-url origin https://github.com/alonsovndev/code-agent-harness.git
   ```

5. Update external documentation or bookmarks and confirm repository and pull-request links resolve under the new name.

## Uninstall

Run:

```bash
./scripts/uninstall.sh
```

Choose tools from the terminal menu, or use the same explicit selection flags as installation:

```bash
./scripts/uninstall.sh --harness codex --dry-run
./scripts/uninstall.sh --harness codex --harness opencode
./scripts/uninstall.sh --all
```

`uninstall.sh` removes only selected symlinks that point into this repository and, when OpenCode is selected, its recognized generated config. It leaves unselected tools' configuration and non-managed files intact. Dry runs show planned removals without writing or deleting anything. Backups are not restored automatically.

Selective uninstall retains `~/.agents/skills` so other tools can continue using shared skills. Only choosing **All** or passing `--all` removes that shared link; selecting every tool individually still retains it.

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
