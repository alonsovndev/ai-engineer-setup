---
name: gh-prs
description: "Use when reading pull requests, creating pull requests, inspecting PR comments or reviews, and working with GitHub CLI. Keywords: gh pr, GitHub PR, pull request, PR comments, PR reviews."
argument-hint: "Provide repo, branch, PR number or URL, base branch, and whether GitHub API/CLI actions are approved."
user-invocable: true
allowed-tools: Bash
---

# GitHub PR Skill

Read, create, and inspect pull requests using GitHub CLI.

## Safety Rules

- Never create, edit, comment on, close, merge, or push for a PR without explicit approval.
- Never include secrets, tokens, credentials, private config, or `.env` values in PR text or comments.
- Never claim a PR was created or updated unless the command succeeded.
- Prefer read-only commands before write commands.
- If `gh` is missing or unauthenticated, provide manual instructions.

## Preflight

Run local checks first:

```bash
git status --short
git branch --show-current
git remote -v
command -v gh
gh auth status
```

Detect repository topology:

- Fork mode: `origin` is the engineer fork and `upstream` is the organization repository.
- Direct mode: `origin` is the organization repository and there is no `upstream`.
- Feature PRs target `dev`.
- Hotfix and release PRs target `main`.

For branch PR creation, inspect included changes:

```bash
git log --oneline <base>..HEAD
git diff --stat <base>...HEAD
```

## Read PRs

Read-only examples:

```bash
gh pr list --repo <owner>/<repo>
gh pr view <number> --repo <owner>/<repo> --json url,title,state,baseRefName,headRefName,body
gh pr checks <number> --repo <owner>/<repo>
```

## Inspect PR Comments And Reviews

Use read-only API calls after approval for GitHub access:

```bash
gh api repos/<owner>/<repo>/issues/<number>/comments
gh api repos/<owner>/<repo>/pulls/<number>/reviews
gh api repos/<owner>/<repo>/pulls/<number>/comments
```

Summarize comments by theme, blocker, owner, and required action. Do not resolve, reply, or dismiss comments without approval.

## Create PR

Only after explicit approval to push and create the PR:

```bash
git push -u origin <branch>
gh pr create --repo <owner>/<repo> --base <base> --head <branch> --title "<title>" --body-file <body-file>
```

Fork feature PR example:

```bash
gh pr create \
  --repo <org>/<repo> \
  --base dev \
  --head <user>:feature/<ticket>-<short-desc> \
  --title "[TICKET] imperative summary" \
  --body-file <body-file>
```

Direct feature PR example:

```bash
gh pr create \
  --repo <org>/<repo> \
  --base dev \
  --head feature/<ticket>-<short-desc> \
  --title "[TICKET] imperative summary" \
  --body-file <body-file>
```

Release PR example:

```bash
gh pr create \
  --repo <org>/<repo> \
  --base main \
  --head dev \
  --title "release: promote dev to main" \
  --body-file <body-file>
```

Prefer `--body-file` over inline body text.

## PR Body Template

```markdown
## Summary

- {what changed}

## Verification

- {command and result, or Not run: reason}

## Risk

- {risk or None identified}

## Related

- {issue links if provided}
```

## Manual Fallback

If `gh` is not available:

- Provide compare URL: `https://github.com/<owner>/<repo>/compare/<base>...<branch>`.
- Provide PR title and body.
- State clearly that the PR was not created.

## Final Response

Report:

- PR URL if created or found.
- Branch and base.
- Verification status.
- Any skipped action and why.
