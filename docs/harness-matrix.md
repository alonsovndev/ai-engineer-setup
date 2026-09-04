# Harness Matrix

This setup keeps reusable content in this repository and exposes it through harness-specific symlinks.

| Capability | Claude Code | opencode | Copilot CLI | Antigravity CLI |
|---|---|---|---|---|
| Global instructions | `~/.claude/AGENTS.md`, `~/.claude/CLAUDE.md` | `instructions` in `opencode.jsonc` | `~/.copilot/.github/instructions` | `~/.gemini/config/AGENTS.md` |
| Shared skills | `~/.claude/skills` | Generated `skills.paths` to repo `skills/` and external skill scan | `~/.copilot/skills` and `~/.agents/skills` | `~/.gemini/config/skills` |
| Agents | `~/.claude/agents` | `~/.config/opencode/agent` | `~/.copilot/agents` | `~/.gemini/config/agents` |
| Commands/prompts | `~/.claude/commands` | `~/.config/opencode/command` | `~/.copilot/.github/prompts` | Skills auto-convert to slash commands |
| Model switching | `--model`, `--effort` | `--model` | `--model`, `--effort` | `--model` |

Do not symlink whole harness config roots because they contain local auth, sessions, caches, telemetry, and trust state.

## Standard Workflow Entry Points

| Workflow | Skill | Claude command | opencode command | Copilot prompt | Antigravity skill `/`command |
|---|---|---|---|---|---|
| Start feature/hotfix | `git-repo-flow` | `/git-start-feature` | `/git-start-feature` | `Git Start Feature` | `git-repo-flow` |
| Sync repo | `git-repo-flow` | `/git-sync-repo` | `/git-sync-repo` | `Git Sync Repo` | `git-repo-flow` |
| Commit changes | `git-commit` | `/git-commit-changes` | `/git-commit-changes` | `Git Commit Changes` | `git-commit` |
| Create PR | `create-pr`, `gh-prs` | `/git-create-pr` | `/git-create-pr` | `Git Create PR` | `gh-prs` |
| Release readiness | `git-repo-flow`, `pr-review` | `/git-release-check` | `/git-release-check` | `Git Release Check` | `pr-review` |
| Frontend design review | `frontend-design` | `/design-review` | `/design-review` | `Design Review` | `frontend-design` |
| Refine a raw idea into a requirement | `spec-planning` | `/spec-plan` | `/spec-plan` | `Spec Plan` | `spec-planning` |
| Write a phased spec to `specs/` | `spec-planning` | `/spec-write-plan` | `/spec-write-plan` | `Spec Write Plan` | `spec-planning` |
| Wire AI tooling into a target repo | `ai-repo-setup` | `/ai-repo-setup` | `/ai-repo-setup` | `AI Repo Setup` | `ai-repo-setup` |
| Scaffold a multi-repo project workspace | `workspace-setup` | `/workspace-setup` | `/workspace-setup` | `Workspace Setup` | `workspace-setup` |
| Post-clone repo bootstrap (dev branch, hygiene files) | `git-repo-setup` | `/git-repo-setup` | `/git-repo-setup` | `Git Repo Setup` | `git-repo-setup` |

The `code-review` agent is available in all harnesses for local post-change review before completion.

Commands and prompts are convenience entry points. Skills remain the source of truth for workflow rules and safety gates. Antigravity CLI has no separate commands directory — shared skills with Markdown frontmatter auto-convert to slash commands (e.g. `/git-repo-flow`).

## Related docs

- [Setup and replication](./setup-and-replication.md)
- [Symlink map](./symlink-map.md)
- [Git repo flow](./git-repo-flow.md)
- [Model profiles](./model-profiles.md)
- [Troubleshooting](./troubleshooting.md)
