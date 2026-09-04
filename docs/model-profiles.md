# Model profiles

This setup uses shared profile names so each harness can be started with the same intent.

## Profiles

| Profile | Intended use |
|---|---|
| `deep` | Architecture, hard debugging, critical reviews. |
| `balanced` | Daily coding, review, and documentation work. |
| `fast` | Small edits, quick docs, and low-risk checks. |

## Source files

| File | Purpose |
|---|---|
| `profiles/model-profiles.jsonc` | Human-readable profile reference by harness. |
| `scripts/run-agent.sh` | Executable launcher that maps profile names to harness CLI flags. |

Keep these files aligned when changing model names or effort levels. `run-agent.sh` does not read `model-profiles.jsonc` at runtime.

## Launcher usage

Run from this repository:

```bash
./scripts/run-agent.sh --harness claude --profile balanced --mode work
./scripts/run-agent.sh --harness opencode --profile fast --mode plan
./scripts/run-agent.sh --harness copilot --profile deep --mode auto
./scripts/run-agent.sh --harness antigravity --profile balanced --mode plan
```

Modes are harness-specific wrappers:

| Mode | Purpose |
|---|---|
| `work` | Normal interactive work mode. |
| `plan` | Planning or read-only mode where supported. |
| `auto` | Higher-autonomy mode where supported. |

For Antigravity CLI, `plan` maps to `--mode=plan` and `auto` maps to `--mode=accept-edits` (the CLI has no `auto` mode; `accept-edits` is the closest autonomy level). Antigravity custom agents are selected interactively via `/agents`, so `run-agent.sh --agent` is not supported for this harness.

The launcher does not bypass permissions by default.
