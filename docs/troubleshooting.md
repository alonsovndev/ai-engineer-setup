# Troubleshooting

Use this guide when setup validation fails or a harness does not load the expected agents, skills, or instructions.

## Verify reports missing commands

`scripts/verify.sh` checks selected harness commands on `PATH`. With no options, it checks `claude`, `opencode`, and `copilot`.

Install the missing harness or verify only the harnesses you use:

```bash
./scripts/verify.sh --harness claude
./scripts/verify.sh --harness opencode
./scripts/verify.sh --harness copilot
```

## Verify reports a missing or wrong symlink

Run from the repository root:

```bash
./scripts/install.sh
./scripts/verify.sh
```

If the target path already existed, `install.sh` creates a `.backup-<timestamp>` copy before replacing it.

## opencode does not load the shared instructions

Rerun setup so the generated config points to the current clone path:

```bash
./scripts/install.sh
```

Then restart opencode. It loads config at startup and does not hot-reload config changes.

## opencode does not load shared skills

Rerun setup so the generated config points `skills.paths` to this clone's `skills/` directory:

```bash
./scripts/install.sh
./scripts/verify.sh
```

Then restart opencode. Running sessions keep using the already-loaded config.

## opencode config points to an old clone

The generated file is `~/.config/opencode/opencode.jsonc`.

Run:

```bash
./scripts/install.sh
./scripts/verify.sh
```

The installer backs up the old generated file and writes a new one with the current repository path.

## Git alias checks fail

The workflow expects `sync`, `resync`, and `feature` aliases for fork-mode repositories.

Add them to the global git config only if your team uses the documented fork workflow. See [Setup and replication](./setup-and-replication.md#git-aliases).

For direct-mode repositories, use the manual workflow in [Git repo flow](./git-repo-flow.md).

## Copilot instruction links are project-specific

The Copilot global instructions may reference project-level knowledge documents. If a target project does not have those files, treat the references as optional project context and rely on the global rules in this repository.

## Restore previous config

Backups are not restored automatically.

Move the desired backup back to the original path:

```bash
mv <target>.backup-<timestamp> <target>
```

Only restore files you recognize. Do not restore auth, session, cache, or telemetry files into this repository.
