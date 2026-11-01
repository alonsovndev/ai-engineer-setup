# Git repo flow

Code Agent Harness uses a trunk-based GitHub flow: every change reaches `main` through a single squash-merged pull request. There is no `dev` branch, no promote-release PR, and no back-sync.

## Repository topologies

| Topology | Remote shape | PR target |
|---|---|---|
| Fork mode | `origin` = engineer fork, `upstream` = organization repo | `upstream:main` |
| Direct mode | `origin` = organization repo, no `upstream` | `origin:main` |

Detection rules:

- If `upstream` exists and differs from `origin`, use fork mode.
- If only `origin` exists, use direct mode.
- If `origin` and `upstream` point to the same repository, stop and choose the intended topology.
- If no remote exists, set up the repository topology before starting work.

## Branch roles

| Branch | Purpose |
|---|---|
| `main` | Trunk. Always releasable; production tags are cut here. |
| `feature/*`, `fix/*`, `chore/*`, `hotfix/*` | Working branches, opened as PRs into `main` and deleted after merge. |

## Branch naming

Use `<type>/<short-desc>` where `<type>` is `feature`, `fix`, `chore`, or `hotfix` (urgent production fix) and `<short-desc>` is kebab-case. When a ticket exists it may prefix the description: `<type>/<ticket>-<short-desc>`. Never commit on `main`, `master`, or a detached HEAD.

## Push policy

Agents push commits only from named working branches (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch), and only when the user explicitly asks — or when the create-PR flow has been invoked, which pre-approves committing the current changes (with logical splits), pushing the working branch, and creating the PR without further approval prompts. Never push commits on `main`, `master`, or a detached HEAD — not even with explicit approval, and not within the create-PR flow. When a protected branch needs a push (release tag, `main` fast-forward), the agent performs the local step and hands the user the exact command to run.

## Required preflight

Run read-only checks before changing branches or syncing:

```bash
git status --short
git branch --show-current
git remote -v
git log --oneline -10
```

Stop before syncing or creating a branch if the working tree is dirty.

## Fork-mode workflow

Fork mode can use the `git feature` alias:

```bash
git feature <type>/<short-desc>
```

The alias is expected to:

1. Check out local `main`.
2. Run `git resync` to align local and fork `main` with `upstream/main`.
3. Create the working branch from refreshed `main`.

`git feature` is user-run only — it calls `git resync`, which performs `reset --hard` and `push --force-with-lease` on `main`. Agents use the non-pushing manual equivalent instead (`git fetch upstream && git checkout main && git merge --ff-only upstream/main && git checkout -b <type>/<short-desc>`) and stop to ask the user to run `git feature` when the fast-forward fails.

## Direct-mode workflow

Do not use `git feature` in direct mode unless a direct-mode-specific alias exists.

Use:

```bash
git fetch origin
git checkout main
git pull --ff-only origin main
git checkout -b <type>/<short-desc>
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

For normal sync of `main` or `master`, fetch the owning remote and use `git merge --ff-only <remote>/<branch>`; stop if it cannot fast-forward. Never run `git sync` or create a merge commit on these branches. `git resync` on these branches is user-run only — the agent never pushes them.

Bring a working branch up to date with `main` (the main case in trunk-based flow; `git sync` only fits branches that exist on `upstream`):

```bash
git fetch <upstream-or-origin>
git merge <upstream-or-origin>/main
```

Rebase onto `<remote>/main` instead only when the branch has not been pushed or shared.

Direct mode, fast-forward only for shared branches:

```bash
git fetch origin
git pull --ff-only origin $(git branch --show-current)
```

Do not use hard reset or force-push on a working branch that contains unmerged work.

## Pull requests

Every working branch targets `main`:

| Branch type | Fork mode target | Direct mode target |
|---|---|---|
| `feature/*`, `fix/*`, `chore/*`, `hotfix/*` | `upstream:main` | `origin:main` |

PRs are squash-merged, so the PR title becomes the commit on `main`. Use a Conventional Commit title:

```text
type(scope): imperative summary
```

Example:

```text
feat(api): add publication-outcomes POST endpoint
```

Put ticket or issue references in the PR body (`Closes #42`), not the title.

Recommended repository settings (set by the user, not the agent): allow squash merging only with the PR title as the default commit message, and enable "Automatically delete head branches". See the `branch-protection` and `auto-delete-branches` skills.

## Release flow

1. Merge the PR into `main` with a squash merge.
2. After final sign-off, run `/tag-release` to create `vX.Y.Z` on `main`. The agent creates the tag locally and hands over `git push <remote> vX.Y.Z`.

Do not create release tags without explicit approval for the version and target commit. Hotfixes use the same path: a `hotfix/<short-desc>` branch from `main`, a PR into `main`, then a new tag.

## After a PR merges

GitHub deletes the head branch. Locally, fast-forward `main` and remove the merged branch:

```bash
git fetch <remote>
git checkout main
git merge --ff-only <remote>/main
git branch -d <type>/<short-desc>
```

Squash merges rewrite history, so `git branch -d` may refuse a branch that is already merged. Confirm the PR shows as merged, then force-delete with `git branch -D` only with the user's approval.
