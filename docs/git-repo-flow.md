# Git repo flow

This setup supports the standard GitHub development flows used by the repository skills and commands.

## Repository topologies

| Topology | Remote shape | Feature PR target |
|---|---|---|
| Fork mode | `origin` = engineer fork, `upstream` = organization repo | `upstream:dev` |
| Direct mode | `origin` = organization repo, no `upstream` | `origin:dev` |

Detection rules:

- If `upstream` exists and differs from `origin`, use fork mode.
- If only `origin` exists, use direct mode.
- If `origin` and `upstream` point to the same repository, stop and choose the intended topology.
- If no remote exists, set up the repository topology before starting feature work.

## Branch roles

| Branch | Purpose |
|---|---|
| `dev` | Development and integration branch. |
| `main` | Production-candidate branch. |
| `feature/*` | Normal changes, opened as PRs into `dev`. |
| `hotfix/*` | Urgent production fixes, opened as PRs into `main`. |

## Branch naming

Use these patterns:

- `feature/<ticket>-<short-desc>` for normal work.
- `hotfix/<ticket>-<short-desc>` for urgent production fixes.

If no ticket exists, use a short kebab-case description after the branch type.

## Required preflight

Run read-only checks before changing branches or syncing:

```bash
git status --short
git branch --show-current
git remote -v
git log --oneline -10
```

Stop before syncing or creating a branch if the working tree is dirty.

## Fork-mode feature workflow

Fork mode can use the `git feature` alias:

```bash
git feature feature/<ticket>-<short-desc>
```

The alias is expected to:

1. Check out local `dev`.
2. Run `git resync` to align local and fork `dev` with `upstream/dev`.
3. Create the feature branch from refreshed `dev`.

`git feature` requires explicit approval before an agent runs it because it calls `git resync`, which performs `reset --hard` and `push --force-with-lease`.

## Direct-mode feature workflow

Do not use `git feature` in direct mode unless a direct-mode-specific alias exists.

Use:

```bash
git fetch origin
git checkout dev
git pull --ff-only origin dev
git checkout -b feature/<ticket>-<short-desc>
```

## Keeping branches current

Fork mode, preserving local commits:

```bash
git sync
```

Fork mode, disposable local copies of shared branches:

```bash
git resync
```

Direct mode, preserving local commits:

```bash
git fetch origin
git merge origin/$(git branch --show-current)
```

Direct mode, fast-forward only for shared branches:

```bash
git fetch origin
git pull --ff-only origin $(git branch --show-current)
```

Do not use hard reset or force-push on a feature branch that contains unmerged work.

## PR targets

| Branch type | Fork mode target | Direct mode target |
|---|---|---|
| `feature/*` | `upstream:dev` | `origin:dev` |
| `hotfix/*` | `upstream:main` | `origin:main` |
| `dev` release candidate | `upstream:main` | `origin:main` |

Feature PR title format:

```text
[TICKET] imperative summary
```

Example:

```text
[PPWR-42] add publication-outcomes POST endpoint
```

## Release flow

Normal production release:

1. Merge feature PRs into `dev`.
2. Open a PR from `dev` to `main`.
3. Merge to `main` after required approvals and checks.
4. Tag `main` with `vX.Y.Z` after final sign-off.

Do not create release tags without explicit approval for the version and target commit.
