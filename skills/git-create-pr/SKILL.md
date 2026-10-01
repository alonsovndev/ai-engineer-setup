---
name: git-create-pr
description: "Use when creating GitHub pull requests, drafting PR titles/bodies, preparing branches for review, or when the user says create PR, open PR, pull request, merge request, or review request. Handles committing current changes with logical splits, pushing the branch, PR body generation, and GitHub CLI fallback guidance. Invoking this skill pre-approves committing, pushing, and PR creation. Keywords: create pr, open pr, pull request, merge request, review request, PR body, PR template."
argument-hint: "Provide target branch/base branch, PR goal, issue links, and PR details."
user-invocable: true
allowed-tools: Bash
---

# Create PR Skill

Create safe, review-ready GitHub pull requests from the current repository state.

## Use This Skill For

- Creating a GitHub pull request from the current branch.
- Drafting a PR title and body from commits and diffs.
- Preparing a branch for review before opening a PR.
- Updating an existing PR description when the branch already has a PR.
- Producing manual GitHub UI instructions when GitHub CLI is unavailable.

## Safety Rules

- The create-pr invocation itself pre-approves: committing the current changes (with logical splits), pushing the working branch, and creating the PR. Do not ask for approval again inside this flow.
- Outside this flow, never create a PR from `main` or `master` unless the user explicitly confirms this is intentional.
- Refuse to start the flow on `main`, `master`, `dev`, or a detached HEAD — tell the user to run the start-feature command first. Any other named working branch is allowed.
- Never push commits on `main`, `master`, `dev`, or a detached HEAD — not even with explicit approval or inside this flow.
- Stop and ask before committing only when changes cannot be grouped confidently, or secrets are detected — then never stage secrets.
- Still gated inside the flow: force-push (explicit approval), PR edits, comments, and merges (explicit approval).
- Never bypass hooks, CI, branch protections, or review rules.
- Never commit, stage, or amend changes beyond the current working set without the user explicitly asking.
- Never include secrets, tokens, credentials, `.env` contents, private URLs, or sensitive config in a PR body.
- Do not call GitHub APIs beyond this flow (edit PRs, comment, trigger workflows) without explicit user approval.

## Preflight Checks

Run read-only checks first:

```bash
git status --short
git branch --show-current
git remote -v
git log --oneline -10
```

If a base branch is known, inspect what will be included:

```bash
git diff --stat <base>...HEAD
git log --oneline <base>..HEAD
```

If the repository has a PR template, read it before drafting:

```bash
ls .github
```

Use `gh` only when installed and authenticated. Check locally without creating anything:

```bash
command -v gh
gh auth status
```

## Commit Current Changes First

The create-pr invocation counts as an explicit request to commit the current changes. Commit them before opening the PR:

- Refuse to start on `main`, `master`, `dev`, or a detached HEAD; tell the user to run the start-feature command first.
- Split many or mixed changes into logical commits following the `git-commit` skill (Conventional Commits, one logical change per commit). Split silently — do not ask for approval per split.
- Stop and ask only when changes cannot be grouped confidently or secrets are detected; never stage secrets, credentials, `.env` files, or sensitive configuration.
- Do not amend, skip hooks, or push protected branches; pushing the working branch is pre-approved and happens in the PR step below.

## Branch Readiness

Before opening a PR, confirm:

- Current branch is not `main` or `master`.
- Working tree is clean, or uncommitted changes are intentionally excluded.
- Branch has at least one commit not present on the base branch.
- Base branch is explicit or can be inferred safely from tracking/default branch.
- Remote branch exists, or the flow pushes it (pre-approved by the invocation).
- Tests/build/lint status is known or clearly marked as not run.

## Topology-Aware Defaults

Detect repository topology before choosing PR defaults:

- Fork mode: `origin` is the engineer fork and `upstream` is the organization repository.
- Direct mode: `origin` is the organization repository and there is no `upstream`.

Defaults:

| Branch type | Fork mode | Direct mode |
|---|---|---|
| `feature/*` | target upstream `dev` | target origin `dev` |
| `hotfix/*` | target upstream `main` | target origin `main` |
| release PR | upstream `dev` to upstream `main` | origin `dev` to origin `main` |

In fork mode, the PR head should be the fork branch (`<user>:<branch>`), not a direct upstream branch, unless the user explicitly says otherwise.

Run these checks before drafting the PR:

```bash
git remote -v
git branch --show-current
git log --oneline <base>..HEAD
git diff --stat <base>...HEAD
```

If branch type and base branch conflict, stop and ask for confirmation.

## PR Content

Draft PR content from actual changes only. Do not invent work, tests, issue numbers, reviewers, owners, risks, or deployment details.

Use the canonical template at `assets/pr-body-template.md` (also used by the `gh-prs` skill, so PR bodies stay consistent regardless of which skill created them). Read it before drafting and fill in each section from real changes.

If no verification was run, state that directly. Do not imply tests passed.

## Creating The PR With GitHub CLI

These steps are pre-approved by the create-pr invocation — run them without asking again. Still gated: force-push, PR edits, PR comments, and PR merges require explicit approval.

Push the branch when needed:

```bash
git push -u origin <branch>
```

Create the PR:

```bash
gh pr create --base <base> --head <branch> --title "<title>" --body-file <body-file>
```

For fork-mode PRs, target the upstream repository explicitly:

```bash
gh pr create \
  --repo <org>/<repo> \
  --base dev \
  --head <user>:feature/<ticket>-<short-desc> \
  --title "[TICKET] imperative summary" \
  --body-file <body-file>
```

For direct repository PRs:

```bash
gh pr create \
  --repo <org>/<repo> \
  --base dev \
  --head feature/<ticket>-<short-desc> \
  --title "[TICKET] imperative summary" \
  --body-file <body-file>
```

Prefer `--body-file` over inline bodies to avoid shell quoting issues.

For draft PRs:

```bash
gh pr create --draft --base <base> --head <branch> --title "<title>" --body-file <body-file>
```

Return the PR URL after creation.

## Manual Fallback

If `gh` is unavailable, unauthenticated, or the user does not approve API actions, provide:

- Branch name.
- Base branch.
- Compare URL if remote information is available.
- PR title.
- PR body.
- Clear note that the PR was not created.

Do not tell the user a PR exists unless it was actually created or found.

## Existing PRs

Before creating a duplicate, check if a PR already exists for the branch when `gh` is available (read access is pre-approved inside this flow):

```bash
gh pr status
gh pr view --json url,title,state,baseRefName,headRefName
```

If a PR exists, ask whether to update the existing PR body or leave it unchanged.

## Final Response

When complete, report:

- Whether the PR was created — PR URL, number, and title. Never claim a PR exists unless the command succeeded.
- Base ← head branches, and topology (fork or direct mode).
- Commits included: list each commit subject created or already on the branch.
- A short summary of what the PR changes and why.
- Verification status (tests, lint, checks run or explicitly not run).
- Any skipped safety step and reason.
