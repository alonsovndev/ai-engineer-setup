# Harness Matrix

This setup keeps reusable content in this repository and exposes it through harness-specific symlinks.

| Capability | Codex CLI | Claude Code | opencode | Copilot CLI | Antigravity CLI |
|---|---|---|---|---|---|
| Global instructions | `~/.codex/AGENTS.md` | `~/.claude/AGENTS.md`, `~/.claude/CLAUDE.md` | `instructions` in `opencode.jsonc` | `~/.copilot/.github/instructions` | `~/.gemini/config/AGENTS.md` |
| Shared skills | `~/.agents/skills` | `~/.claude/skills` | Generated `skills.paths` to repo `skills/` and external skill scan | `~/.copilot/skills` and `~/.agents/skills` | `~/.gemini/config/skills` |
| Agents | `~/.codex/agents` (TOML custom subagents) | `~/.claude/agents` | `~/.config/opencode/agent` | `~/.copilot/agents` | `~/.gemini/config/agents` |
| Commands/prompts | Codex skills `$<command>` | `~/.claude/commands` | `~/.config/opencode/command` | `~/.copilot/.github/prompts` | Skills auto-convert to slash commands |
| Model switching | configured model, profile effort via `-c` | `--model`, `--effort` | `--model` | `--model`, `--effort` | `--model`, `--effort` (its model IDs also encode the level) |
| Per-agent tool limits | `sandbox_mode` in agent TOML | `tools:` frontmatter | `permission:` frontmatter | `tools:` frontmatter | Not available |
| Command argument hints | Skill prompt arguments | `argument-hint:` frontmatter | `Usage:` line in command body | `argument-hint:` frontmatter | No commands directory |
| Command-level guardrails | Workflow skills | Full command set | Full command set | Full prompt set | Skills auto-convert only |

Do not symlink whole harness config roots because they contain local auth, sessions, caches, telemetry, and trust state.

## Standard Workflow Entry Points

| Workflow | Skill | Codex skill | Claude command | opencode command | Copilot prompt | Antigravity skill `/`command |
|---|---|---|---|---|---|---|
| Start feature/hotfix | `git-repo-flow` | `$start-feature` | `/start-feature` | `/start-feature` | `Start Feature` | `git-repo-flow` |
| Sync repo | `git-repo-flow` | `$sync-repo` | `/sync-repo` | `/sync-repo` | `Sync Repo` | `git-repo-flow` |
| Commit changes | `git-commit` | `$commit` | `/commit` | `/commit` | `Commit` | `git-commit` |
| Create PR (feature → dev) | `git-create-pr`, `gh-prs` | `$create-pr` | `/create-pr` | `/create-pr` | `Create PR` | `gh-prs` |
| Promote release (dev → main) | `git-create-pr`, `gh-prs`, `git-repo-flow` | `$promote-release` | `/promote-release` | `/promote-release` | `Promote Release` | `gh-prs` |
| Sync dev from main after a release merge | `git-repo-flow` | `$sync-dev` | `/sync-dev` | `/sync-dev` | `Sync Dev` | `git-repo-flow` |
| Tag release (create vX.Y.Z tag from main) | `git-repo-flow`, `pr-review` | `$tag-release` | `/tag-release` | `/tag-release` | `Tag Release` | `pr-review` |
| Frontend design review | `frontend-design` | `$review-design` | `/review-design` | `/review-design` | `Review Design` | `frontend-design` |
| Refine a raw idea into a requirement | `spec-planning` | `$spec-clarify` | `/spec-clarify` | `/spec-clarify` | `Spec Clarify` | `spec-planning` |
| Write a phased spec to `specs/` | `spec-planning` | `$spec-write` | `/spec-write` | `/spec-write` | `Spec Write` | `spec-planning` |
| Wire AI tooling into a target repo | `ai-repo-setup` | `$setup-ai` | `/setup-ai` | `/setup-ai` | `Setup AI` | `ai-repo-setup` |
| Scaffold a multi-repo project workspace | `workspace-setup` | `$setup-workspace` | `/setup-workspace` | `/setup-workspace` | `Setup Workspace` | `workspace-setup` |
| Post-clone repo bootstrap | `git-repo-setup` | `$setup-repo` | `/setup-repo` | `/setup-repo` | `Setup Repo` | `git-repo-setup` |
| Proactive bug/defect sweep | `bug-finder` | `$find-bugs` | `/find-bugs` | `/find-bugs` | `Find Bugs` | `bug-finder` |
| Sync docs with code changes | `doc-tracker` | `$update-docs` | `/update-docs` | `/update-docs` | `Update Docs` | `doc-tracker` |
| Write or review Markdown | `markdown-author` | `$write-markdown` | `/write-markdown` | `/write-markdown` | `Write Markdown` | `markdown-author` |
| Explain architecture | `clean-architecture-ddd`, `tech-lead` | `$explain-architecture` | `/explain-architecture` | `/explain-architecture` | `Explain Architecture` | `tech-lead` |
| Create Mermaid diagram | `mermaid-author` | `$diagram-mermaid` | `/diagram-mermaid` | `/diagram-mermaid` | `Diagram Mermaid` | `mermaid-author` |
| Create C4 diagram | `diagram-author` | `$diagram-c4` | `/diagram-c4` | `/diagram-c4` | `Diagram C4` | `diagram-author` |
| Create Draw.io diagram | `drawio-author` | `$diagram-drawio` | `/diagram-drawio` | `/diagram-drawio` | `Diagram Drawio` | `drawio-author` |
| Audit a repository | `bug-finder`, `doc-tracker` | `$audit-repo` | `/audit-repo` | `/audit-repo` | `Audit Repo` | `bug-finder` |

The `code-review` agent is available in all harnesses for local post-change review before completion.

Commands and prompts are convenience entry points. Skills remain the source of truth for workflow rules and safety gates. Antigravity CLI has no separate commands directory — shared skills with Markdown frontmatter auto-convert to slash commands (e.g. `/git-repo-flow`).

## Known limitations

Accepted gaps, recorded so they are not rediscovered as bugs.

- **No managed `~/.claude/settings.json`.** opencode gets a generated config that denies `git push`, `git reset --hard`, and `rm -rf` at the harness level; Claude Code has no equivalent managed denylist here, because its `settings.json` also holds personal state (model, theme, MCP permissions) that this repo deliberately does not own. Claude relies on its own permission prompts plus the rules in `instructions/CLAUDE.md`. Add the denies by hand if you want parity.
- **Antigravity agents have no tool or permission scoping.** Its binary carries `name`, `description`, `subagent`, `model`, and `tools` as agent frontmatter keys, so `tools:` is very likely accepted — but it also carries two different tool-name vocabularies (`Read`/`Bash`/`Edit` and `view_file`/`run_command`/`grep_search`), and there is no command that prints the valid set. A wrong list would silently strip a review agent's file access rather than error, so nothing is declared. Its `code-review` and `bug-finder` agents are therefore not read-only, unlike the other four harnesses. Resolve by checking Antigravity's agent documentation for the tool vocabulary, then scoping both agents.
- **Antigravity has no commands directory.** Workflow entry points reach it only through skill auto-conversion, so the extra approval gates written into the commands apply only via each skill's own text.

## Model verification

Codex was checked with `codex --help` on 2026-09-24 (CLI 0.156.1); it keeps the configured model and varies `model_reasoning_effort`. The other harnesses' model IDs were checked against their own CLIs on 2026-09-09 — `claude --help`, `opencode models`, `copilot help config`, and `agy models`. The header of `profiles/model-profiles.jsonc` records the command per harness; re-run them when a harness updates, and change `scripts/run-agent.sh` in the same commit (`verify.sh` compares the two and warns on drift).

Antigravity's IDs carry the reasoning level as a suffix (`-high`, `-medium`, `-low`), so `run-agent.sh` selects the level by choosing the ID rather than also passing `--effort`.

## Parity enforcement

`scripts/test-verify.sh` self-tests the guard below: it copies the repo to a path containing a space and an `@`, then asserts both that a clean tree passes and that each individual breakage is caught.

`scripts/verify.sh` derives the canonical agent set from `agents/claude/*.md` and the canonical command set from `commands/claude/*.md`, then fails if any harness is missing an entry, carries an entry the canonical set does not have, has an agent without a frontmatter `description`, or (for Codex) a custom agent is missing a required TOML field or a workflow skill is missing; or (for Copilot) has an agent absent from the Agent Registry or the performance budget table in `adapters/copilot/instructions/`.

It also rejects a frontmatter `description:` whose unquoted value contains `": "`. YAML reads that as a nested mapping, and the harness drops the agent without an error — this silently hid three agents from Antigravity until it was caught.

## Related docs

- [Setup and replication](./setup-and-replication.md)
- [Symlink map](./symlink-map.md)
- [Git repo flow](./git-repo-flow.md)
- [Model profiles](./model-profiles.md)
- [Troubleshooting](./troubleshooting.md)
