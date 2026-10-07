---
name: git-repo-flow
description: "Use when starting feature work, syncing repositories, creating feature or hotfix branches, preparing dev/main pull requests, or explaining fork/direct git flows. Keywords: git workflow, fork workflow, direct repo, git feature, git sync, git resync, origin upstream dev main, feature branch, hotfix branch, release tag, dev behind main, post-release back-sync, sync dev."
argument-hint: "Provide repository path, desired branch name, target base branch, and whether sync/resync/push actions are approved."
user-invocable: true
allowed-tools: Bash
---

# Git Repo Flow Skill

Standardize development work for GitHub repositories that use either fork-based or direct-repository development.

## Repository Topologies

| Mode | Remote shape | Feature source | PR target |
|---|---|---|---|
| Fork mode | `origin` = engineer fork, `upstream` = organization repo | `origin:feature/*` | `upstream:dev` |
| Direct mode | `origin` = organization repo, no `upstream` | `origin:feature/*` | `origin:dev` |

Detection rules:

- If `upstream` exists and differs from `origin`, use fork mode.
- If only `origin` exists, use direct mode.
- If `origin` and `upstream` point to the same repository, stop and ask which topology to use.
- If no remote or ambiguous remotes exist, stop and ask for the repository topology.

## Branch Model

- `dev` is the long-running development and integration branch.
- `main` is the production-candidate branch.
- `feature/<ticket>-<short-desc>` branches target `dev`.
- `hotfix/<ticket>-<short-desc>` branches target `main`.
- Other named working branches, such as `fix/*` and `chore/*`, may also hold commits.
- Production deploys are promoted by release tags `vX.Y.Z` from `main`.

## Safety Rules

- Never stage or commit on `main`, `master`, `dev`, or a detached HEAD. Check the branch first, then create or switch to any named working branch before making a commit.
- Never push commits on `main`, `master`, `dev`, or a detached HEAD — not even with explicit approval. Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch), and only when the user explicitly asks or the create-PR flow has been invoked — that invocation pre-approves committing the current changes, pushing the working branch, and creating the PR. If a protected branch needs a push, do the local step and give the user the exact command to run.
- Never add AI or tool co-author trailers (e.g., `Co-authored-by: ...`) to commit messages.
- Never run `git resync` yourself — it performs `reset --hard` and `push --force-with-lease`, so it is user-run only. Never run `git sync` while on a protected branch — it pushes the current branch; on a protected branch, the user runs these aliases themselves.
- Never run `git feature` yourself — it runs `git resync` on `dev`. The user may run it when topology is fork mode, the worktree is clean, and the branch name is confirmed; otherwise use the non-pushing manual workflow below.
- In direct mode, do not use `git feature`; use the manual direct-mode feature workflow unless a direct-mode alias exists.
- Never push directly to `dev` or `main` — not even when the user explicitly confirms a release, sync, or hotfix operation. Do the local step (merge, fast-forward, tag) and give the user the exact push command to run.
- Never force-push a feature branch unless the user explicitly approves and the target branch is not protected.
- Never create release tags without explicit approval for the version and target commit.
- Never bypass hooks, branch protections, PR reviews, or CI checks.
- Never push a `dev` back-sync merge or fast-forward — hand the push command to the user — and never force-push or hard-reset `dev` while back-syncing it from `main`.

## Required Preflight

Run read-only checks first:

```bash
git status --short
git branch --show-current
git remote -v
git log --oneline -10
```

Classify the repository topology before recommending commands.

## Start Feature Workflow

Fork mode alias:

```bash
git feature feature/<ticket>-<short-desc>
```

This alias is expected to:

1. Check out local `dev`.
2. Run `git resync` to align local/fork `dev` with `upstream/dev`.
3. Create the feature branch from refreshed `dev`.

Because `git resync` hard-resets and force-pushes `dev`, never run `git feature` yourself — ask the user to run it. Use the non-pushing fork-mode manual workflow instead:

```bash
git fetch upstream
git checkout dev
git merge --ff-only upstream/dev
git checkout -b feature/<ticket>-<short-desc>
```

If the `--ff-only` merge fails (local/fork `dev` diverged from `upstream/dev`), stop and ask the user to run `git feature` or `git resync` themselves.

Direct mode manual workflow:

```bash
git fetch origin
git checkout dev
git pull --ff-only origin dev
git checkout -b feature/<ticket>-<short-desc>
```

If the working tree is dirty, stop before syncing or creating a branch.

## Keeping Branches Current

Fork mode preserving local commits on a working branch:

```bash
git sync
```

Fork mode hard reset for disposable local copies of shared branches:

```bash
git resync
```

Never run `git sync` or `git resync` while on `main`, `master`, or `dev` — both aliases push the current branch. On a protected branch, use the local fast-forward sync below and let the user handle any push. `git resync` on a protected branch is user-run only, even for disposable local/fork copies of shared branches.

Direct mode preserving local commits on a working branch:

```bash
git fetch origin
git merge origin/$(git branch --show-current)
```

For normal sync of `main`, `master`, or `dev`, fetch the owning remote and use `git merge --ff-only <remote>/<branch>`; stop if it cannot fast-forward. Never run `git sync` or create a merge commit on these branches. `git resync` on these branches is user-run only — the agent never pushes them.

Direct mode fast-forward only for shared branches:

```bash
git fetch origin
git pull --ff-only origin $(git branch --show-current)
```

Do not use hard reset or force-push on a feature branch that contains unmerged work.

## PR Target Rules

| Branch type | Fork mode target | Direct mode target |
|---|---|---|
| `feature/*` | `upstream:dev` | `origin:dev` |
| `hotfix/*` | `upstream:main` | `origin:main` |
| `dev` release candidate | `upstream:main` | `origin:main` |

PR title format for feature work:

```text
[TICKET] imperative summary
```

Example:

```text
[PPWR-42] add publication-outcomes POST endpoint
```

## Release Flow

Normal production release:

1. Merge feature PRs into `dev`.
2. Open PR from `dev` to `main`.
3. Merge to `main` after required approvals and checks, using a real merge commit rather than squash or rebase, so `dev`'s commits remain ancestors of `main` and `dev` can fast-forward during back-sync.
4. Tag `main` with `vX.Y.Z` after final sign-off.

Do not tag an unreleased candidate unless the user confirms the candidate is safe.

## Post-Release Back-Sync (dev ← main)

Merging the `dev` → `main` PR only advances `main` on GitHub — it never advances `dev`. Immediately afterward, `dev` will show as behind `main`. This is expected Git behavior, not an error; use the `sync-dev` command to fix it.

Detection:

```bash
git fetch upstream   # fork mode
git fetch origin     # direct mode
git merge-base --is-ancestor dev upstream/main   # fork mode
git merge-base --is-ancestor dev origin/main     # direct mode
```

If the command exits `0`, the `dev` → `main` PR was merged as a real merge commit and `dev`'s commits are already ancestors of `main` — fast-forward is safe.

Fork mode, fast-forward case:

```bash
git checkout dev
git merge --ff-only upstream/main
```

Then give the user the exact command to run: `git push origin dev`. Never push `dev` yourself.

Fork mode, non-fast-forward case (the `dev` → `main` PR was squashed or rebased):

```bash
git checkout -b <working-branch> upstream/dev
git merge --no-ff upstream/main -m "Merge main into dev after release"
# Push the working branch only with approval, then open a PR into upstream/dev.
```

Direct mode, fast-forward case:

```bash
git checkout dev
git merge --ff-only origin/main
```

Then give the user the exact command to run: `git push origin dev`. Never push `dev` yourself.

Direct mode, non-fast-forward case:

```bash
git checkout -b <working-branch> origin/dev
git merge --no-ff origin/main -m "Merge main into dev after release"
# Push the working branch only with approval, then open a PR into origin/dev.
```

Never create a merge commit directly on `dev` or rebase it onto `main` — `dev` may already be pushed and shared. Never force-push or hard-reset `dev` during back-sync. Require explicit approval before pushing a back-sync working branch or creating a back-sync PR (outside the pre-approved create-PR flow); never push `dev` yourself — give the user the exact command.

## Final Response

Report:

- Detected topology: fork mode, direct mode, or ambiguous.
- Current branch and target branch.
- Remote shape: `origin` and optional `upstream`.
- Commands run or intentionally skipped.
- Whether any destructive command was approved.
- Next action: commit, push, PR, or release tag.
