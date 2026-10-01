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
Other named working branches, such as `fix/*` and `chore/*`, may also hold commits. Never commit on `main`, `master`, `dev`, or a detached HEAD.

## Push policy

Agents push commits only from named working branches (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch), and only when the user explicitly asks. Never push commits on `main`, `master`, `dev`, or a detached HEAD — not even with explicit approval. When a protected branch needs a push (release back-sync, `dev` bootstrap, release tag), the agent performs the local step and hands the user the exact command to run.

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

`git feature` is user-run only — it calls `git resync`, which performs `reset --hard` and `push --force-with-lease` on `dev`. Agents use the non-pushing manual equivalent instead (`git fetch upstream && git checkout dev && git merge --ff-only upstream/dev && git checkout -b feature/<ticket>-<short-desc>`) and stop to ask the user to run `git feature` when the fast-forward fails.

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

Fork mode, preserving local commits on a working branch:

```bash
git sync
```

Fork mode, disposable local copies of shared branches:

```bash
git resync
```

`git resync` is user-run only, and neither alias is ever run by an agent on a protected branch — both push the current branch.

Direct mode, preserving local commits on a working branch:

```bash
git fetch origin
git merge origin/$(git branch --show-current)
```

For normal sync of `main`, `master`, or `dev`, fetch the owning remote and use `git merge --ff-only <remote>/<branch>`; stop if it cannot fast-forward. Never run `git sync` or create a merge commit on these branches. `git resync` on these branches is user-run only — the agent never pushes them.

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
3. Merge to `main` after required approvals and checks, using a real merge commit rather than squash or rebase, so `dev`'s commits remain ancestors of `main` and can fast-forward back later.
4. Tag `main` with `vX.Y.Z` after final sign-off.

Do not create release tags without explicit approval for the version and target commit.

## Post-release back-sync

Merging a promote-release PR only advances `main` on GitHub — it never advances `dev`. Immediately afterward `dev` will show as behind `main` in GitHub's UI. This is expected, not an error.

Run `/sync-dev` right after a promote-release PR merges to bring `dev` back in line with `main`.

Fork mode, when `dev` can fast-forward:

```bash
git fetch upstream
git merge-base --is-ancestor dev upstream/main
git checkout dev
git merge --ff-only upstream/main
# Agent stops here — user runs: git push origin dev
```

Direct mode, when `dev` can fast-forward:

```bash
git fetch origin
git merge-base --is-ancestor dev origin/main
git checkout dev
git merge --ff-only origin/main
# Agent stops here — user runs: git push origin dev
```

Only run the fast-forward commands when the ancestor check succeeds. Agents never push `dev` — after the local fast-forward, hand the user the exact command (`git push origin dev`). If the `dev` → `main` PR was squashed or rebased, create a named working branch from `upstream/dev` (fork mode) or `origin/dev` (direct mode), merge the corresponding remote `main` into that branch, then open a PR into `dev` with approval. Never create the merge commit directly on `dev` or rebase `dev`.
