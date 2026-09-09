# Harness Matrix

This setup keeps reusable content in this repository and exposes it through harness-specific symlinks.

| Capability | Claude Code | opencode | Copilot CLI | Antigravity CLI |
|---|---|---|---|---|
| Global instructions | `~/.claude/AGENTS.md`, `~/.claude/CLAUDE.md` | `instructions` in `opencode.jsonc` | `~/.copilot/.github/instructions` | `~/.gemini/config/AGENTS.md` |
| Shared skills | `~/.claude/skills` | Generated `skills.paths` to repo `skills/` and external skill scan | `~/.copilot/skills` and `~/.agents/skills` | `~/.gemini/config/skills` |
| Agents | `~/.claude/agents` | `~/.config/opencode/agent` | `~/.copilot/agents` | `~/.gemini/config/agents` |
| Commands/prompts | `~/.claude/commands` | `~/.config/opencode/command` | `~/.copilot/.github/prompts` | Skills auto-convert to slash commands |
| Model switching | `--model`, `--effort` | `--model` | `--model`, `--effort` | `--model` |
| Per-agent tool limits | `tools:` frontmatter | `permission:` frontmatter | `tools:` frontmatter | Not available |
| Command argument hints | `argument-hint:` frontmatter | `Usage:` line in command body | `argument-hint:` frontmatter | No commands directory |
| Command-level guardrails | Full command set | Full command set | Full prompt set | Skills auto-convert only |

Do not symlink whole harness config roots because they contain local auth, sessions, caches, telemetry, and trust state.

## Standard Workflow Entry Points

| Workflow | Skill | Claude command | opencode command | Copilot prompt | Antigravity skill `/`command |
|---|---|---|---|---|---|
| Start feature/hotfix | `git-repo-flow` | `/start-feature` | `/start-feature` | `Start Feature` | `git-repo-flow` |
| Sync repo | `git-repo-flow` | `/sync-repo` | `/sync-repo` | `Sync Repo` | `git-repo-flow` |
| Commit changes | `git-commit` | `/commit` | `/commit` | `Commit` | `git-commit` |
| Create PR (feature → dev) | `git-create-pr`, `gh-prs` | `/create-pr` | `/create-pr` | `Create PR` | `gh-prs` |
| Promote release (dev → main) | `git-create-pr`, `gh-prs`, `git-repo-flow` | `/promote-release` | `/promote-release` | `Promote Release` | `gh-prs` |
| Tag release (create vX.Y.Z tag from main) | `git-repo-flow`, `pr-review` | `/tag-release` | `/tag-release` | `Tag Release` | `pr-review` |
| Frontend design review | `frontend-design` | `/review-design` | `/review-design` | `Review Design` | `frontend-design` |
| Refine a raw idea into a requirement | `spec-planning` | `/spec-clarify` | `/spec-clarify` | `Spec Clarify` | `spec-planning` |
| Write a phased spec to `specs/` | `spec-planning` | `/spec-write` | `/spec-write` | `Spec Write` | `spec-planning` |
| Wire AI tooling into a target repo | `ai-repo-setup` | `/setup-ai` | `/setup-ai` | `Setup AI` | `ai-repo-setup` |
| Scaffold a multi-repo project workspace | `workspace-setup` | `/setup-workspace` | `/setup-workspace` | `Setup Workspace` | `workspace-setup` |
| Post-clone repo bootstrap (dev branch, hygiene files) | `git-repo-setup` | `/setup-repo` | `/setup-repo` | `Setup Repo` | `git-repo-setup` |
| Proactive bug/defect sweep | `bug-finder` | `/find-bugs` | `/find-bugs` | `Find Bugs` | `bug-finder` |
| Sync docs with code changes | `doc-tracker` | `/update-docs` | `/update-docs` | `Update Docs` | `doc-tracker` |

The `code-review` agent is available in all harnesses for local post-change review before completion.

Commands and prompts are convenience entry points. Skills remain the source of truth for workflow rules and safety gates. Antigravity CLI has no separate commands directory — shared skills with Markdown frontmatter auto-convert to slash commands (e.g. `/git-repo-flow`).

## Known limitations

Accepted gaps, recorded so they are not rediscovered as bugs.

- **No managed `~/.claude/settings.json`.** opencode gets a generated config that denies `git push`, `git reset --hard`, and `rm -rf` at the harness level; Claude Code has no equivalent managed denylist here, because its `settings.json` also holds personal state (model, theme, MCP permissions) that this repo deliberately does not own. Claude relies on its own permission prompts plus the rules in `instructions/CLAUDE.md`. Add the denies by hand if you want parity.
- **Antigravity agents have no tool or permission scoping.** The supported frontmatter keys beyond `name`, `description`, and `subagent` are unconfirmed, so nothing is declared rather than guessing. Its `code-review` and `bug-finder` agents are therefore not read-only, unlike the other three harnesses.
- **Antigravity has no commands directory.** Workflow entry points reach it only through skill auto-conversion, so the extra approval gates written into the commands apply only via each skill's own text.
- **Copilot and Antigravity model IDs are unverified.** See the header of `profiles/model-profiles.jsonc` for the re-check command per harness.

## Parity enforcement

`scripts/verify.sh` derives the canonical agent set from `agents/claude/*.md` and the canonical command set from `commands/claude/*.md`, then fails if any harness is missing an entry, carries an entry the canonical set does not have, has an agent without a frontmatter `description`, or (for Copilot) has an agent absent from the Agent Registry in `adapters/copilot/instructions/copilot-instructions.md`.

## Related docs

- [Setup and replication](./setup-and-replication.md)
- [Symlink map](./symlink-map.md)
- [Git repo flow](./git-repo-flow.md)
- [Model profiles](./model-profiles.md)
- [Troubleshooting](./troubleshooting.md)
