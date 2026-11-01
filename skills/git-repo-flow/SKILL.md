---
name: git-repo-flow
description: "Use when starting feature work, syncing repositories, creating feature, fix, chore, or hotfix branches, preparing pull requests into main, tagging releases, or explaining fork/direct git flows. Keywords: git workflow, trunk-based, fork workflow, direct repo, git feature, git sync, git resync, origin upstream main, feature branch, hotfix branch, squash merge, release tag."
argument-hint: "Provide repository path, desired branch name, and whether sync/resync/push actions are approved."
user-invocable: true
allowed-tools: Bash
---

# Git Repo Flow Skill

Standardize development work for GitHub repositories that use either fork-based or direct-repository development. The flow is trunk-based: every change reaches `main` through one squash-merged PR.

## Repository Topologies

| Mode | Remote shape | Branch source | PR target |
|---|---|---|---|
| Fork mode | `origin` = engineer fork, `upstream` = organization repo | `origin:<type>/*` | `upstream:main` |
| Direct mode | `origin` = organization repo, no `upstream` | `origin:<type>/*` | `origin:main` |

Detection rules:

- If `upstream` exists and differs from `origin`, use fork mode.
- If only `origin` exists, use direct mode.
- If `origin` and `upstream` point to the same repository, stop and ask which topology to use.
- If no remote or ambiguous remotes exist, stop and ask for the repository topology.

## Branch Model

- `main` is the only long-running branch. It is always releasable.
- Working branches are `<type>/<short-desc>` with `<type>` one of `feature`, `fix`, `chore`, or `hotfix` (urgent production fix). `<short-desc>` is kebab-case; a ticket may prefix it: `<type>/<ticket>-<short-desc>`.
- Every working branch branches from fresh `main` and targets `main`.
- PRs are squash-merged and the head branch is deleted after merge.
- Production releases are tags `vX.Y.Z` created on `main`.

## Safety Rules

- Never stage or commit on `main`, `master`, or a detached HEAD. Check the branch first, then create or switch to any named working branch before making a commit.
- Never push commits on `main`, `master`, or a detached HEAD — not even with explicit approval. Push only from a named working branch (`feature/*`, `fix/*`, `hotfix/*`, `chore/*`, or another named branch), and only when the user explicitly asks or the create-PR flow has been invoked — that invocation pre-approves committing the current changes, pushing the working branch, and creating the PR. If a protected branch needs a push, do the local step and give the user the exact command to run.
- Never add AI or tool co-author trailers (e.g., `Co-authored-by: ...`) to commit messages.
- Never run `git resync` yourself — it performs `reset --hard` and `push --force-with-lease`, so it is user-run only. Never run `git sync` while on a protected branch — it pushes the current branch; on a protected branch, the user runs these aliases themselves.
- Never run `git feature` yourself — it runs `git resync` on `main`. The user may run it when topology is fork mode, the worktree is clean, and the branch name is confirmed; otherwise use the non-pushing manual workflow below.
- In direct mode, do not use `git feature`; use the manual direct-mode workflow unless a direct-mode alias exists.
- Never push directly to `main` — not even when the user explicitly confirms a release or hotfix. Do the local step (fast-forward, tag) and give the user the exact push command to run.
- Never force-push a working branch unless the user explicitly approves and the target branch is not protected.
- Never create release tags without explicit approval for the version and target commit.
- Never bypass hooks, branch protections, PR reviews, or CI checks.

## Required Preflight

Run read-only checks first:

```bash
git status --short
git branch --show-current
git remote -v
git log --oneline -10
```

Classify the repository topology before recommending commands.

## Start Work Workflow

Fork mode alias:

```bash
git feature <type>/<short-desc>
```

This alias is expected to:

1. Check out local `main`.
2. Run `git resync` to align local/fork `main` with `upstream/main`.
3. Create the working branch from refreshed `main`.

Because `git resync` hard-resets and force-pushes `main`, never run `git feature` yourself — ask the user to run it. Use the non-pushing fork-mode manual workflow instead:

```bash
git fetch upstream
git checkout main
git merge --ff-only upstream/main
git checkout -b <type>/<short-desc>
```

If the `--ff-only` merge fails (local/fork `main` diverged from `upstream/main`), stop and ask the user to run `git feature` or `git resync` themselves.

Direct mode manual workflow:

```bash
git fetch origin
git checkout main
git pull --ff-only origin main
git checkout -b <type>/<short-desc>
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

Never run `git sync` or `git resync` while on `main` or `master` — both aliases push the current branch. On a protected branch, use the local fast-forward sync below and let the user handle any push. `git resync` on a protected branch is user-run only, even for disposable local/fork copies of shared branches.

Direct mode preserving local commits on a working branch:

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

Direct mode fast-forward only for shared branches:

```bash
git fetch origin
git pull --ff-only origin $(git branch --show-current)
```

Do not use hard reset or force-push on a working branch that contains unmerged work.

## PR Rules

Every working branch targets `main`:

| Mode | Target |
|---|---|
| Fork mode | `upstream:main` |
| Direct mode | `origin:main` |

PR title is a Conventional Commit, because squash merge turns it into the commit on `main`:

```text
type(scope): imperative summary
```

Example:

```text
feat(api): add publication-outcomes POST endpoint
```

Reference tickets or issues in the PR body (`Closes #42`), not the title.

## Release Flow

1. Merge the PR into `main` with a squash merge. No promote PR and no back-sync are needed — there is no second branch to keep aligned.
2. After sign-off, run the `tag-release` command to create `vX.Y.Z` on `main`. Give the user the exact `git push <remote> vX.Y.Z` command; never push the tag yourself.

Hotfixes follow the same path: a `hotfix/<short-desc>` branch from `main`, a PR into `main`, then a new tag.

Do not tag an unreleased commit unless the user confirms it is safe.

## After a PR Merges

The head branch is deleted on GitHub. Locally, fast-forward `main` and delete the merged branch:

```bash
git fetch <remote>
git checkout main
git merge --ff-only <remote>/main
git branch -d <type>/<short-desc>
```

Squash merges rewrite history, so `git branch -d` may refuse a branch that is already merged; confirm the PR shows as merged, then use `git branch -D` only with the user's approval.

## Final Response

Report:

- Detected topology: fork mode, direct mode, or ambiguous.
- Current branch and target branch.
- Remote shape: `origin` and optional `upstream`.
- Commands run or intentionally skipped.
- Whether any destructive command was approved.
- Next action: commit, push, PR, or release tag.
