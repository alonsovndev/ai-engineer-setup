# Harness Matrix

This setup keeps reusable content in this repository and exposes it through harness-specific symlinks.

| Capability | Claude Code | opencode | Copilot CLI |
|---|---|---|---|
| Global instructions | `~/.claude/AGENTS.md`, `~/.claude/CLAUDE.md` | `instructions` in `opencode.jsonc` | `~/.copilot/.github/instructions` |
| Shared skills | `~/.claude/skills` | Generated `skills.paths` to repo `skills/` and external skill scan | `~/.copilot/skills` and `~/.agents/skills` |
| Agents | `~/.claude/agents` | `~/.config/opencode/agent` | `~/.copilot/agents` |
| Commands/prompts | `~/.claude/commands` | `~/.config/opencode/command` | `~/.copilot/.github/prompts` |
| Model switching | `--model`, `--effort` | `--model` | `--model`, `--effort` |

Do not symlink whole harness config roots because they contain local auth, sessions, caches, telemetry, and trust state.

## Standard Workflow Entry Points

| Workflow | Skill | Claude command | opencode command | Copilot prompt |
|---|---|---|---|---|
| Start feature/hotfix | `git-repo-flow` | `/git-start-feature` | `/git-start-feature` | `Git Start Feature` |
| Sync repo | `git-repo-flow` | `/git-sync-repo` | `/git-sync-repo` | `Git Sync Repo` |
| Commit changes | `git-commit` | `/git-commit-changes` | `/git-commit-changes` | `Git Commit Changes` |
| Create PR | `create-pr`, `gh-prs` | `/git-create-pr` | `/git-create-pr` | `Git Create PR` |
| Release readiness | `git-repo-flow`, `pr-review` | `/git-release-check` | `/git-release-check` | `Git Release Check` |
| Frontend design review | `frontend-design` | `/design-review` | `/design-review` | `Design Review` |
| Refine a raw idea into a requirement | `spec-planning` | `/spec-plan` | `/spec-plan` | `Spec Plan` |
| Write a phased spec to `specs/` | `spec-planning` | `/spec-write-plan` | `/spec-write-plan` | `Spec Write Plan` |

The `code-review` agent is available in all harnesses for local post-change review before completion.

Commands and prompts are convenience entry points. Skills remain the source of truth for workflow rules and safety gates.

## Related docs

- [Setup and replication](./setup-and-replication.md)
- [Symlink map](./symlink-map.md)
- [Git repo flow](./git-repo-flow.md)
- [Model profiles](./model-profiles.md)
- [Troubleshooting](./troubleshooting.md)
