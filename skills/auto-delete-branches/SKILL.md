---
name: auto-delete-branches
description: "Use when configuring GitHub repositories to automatically delete head branches after pull requests are merged. Keywords: auto-delete branches, delete branch after merge, GitHub repo settings."
argument-hint: "Provide repository owner/name or local repo path, target host, and whether changing repo settings is approved."
user-invocable: true
allowed-tools: Bash
---

# Auto Delete Branches Skill

Configure GitHub repositories to automatically delete head branches after pull requests are merged.

## Safety Rules

- Never change repository settings without explicit approval for the named repository.
- Confirm repository owner, repository name, host, and current remote before any API call.
- Never expose or request GitHub tokens. Use existing `gh` authentication only.
- Prefer checking current settings before proposing a change.
- If `gh` is unavailable or unauthenticated, provide manual steps instead of claiming completion.

## Preflight

Run local/read-only checks first:

```bash
git remote -v
git branch --show-current
command -v gh
gh auth status
```

Derive repository metadata from the remote URL when possible. If the remote is ambiguous, ask the user for `owner/repo`.

## Read Current Setting

Use the GitHub API only after the user approves reading repository settings:

```bash
gh api repos/<owner>/<repo> --jq '.delete_branch_on_merge'
```

## Enable Auto Delete

Use only after explicit approval:

```bash
gh api \
  --method PATCH \
  repos/<owner>/<repo> \
  -f delete_branch_on_merge=true
```

Verify after applying:

```bash
gh api repos/<owner>/<repo> --jq '.delete_branch_on_merge'
```

## Manual Fallback

If CLI access is unavailable, provide these steps:

1. Open `https://github.com/<owner>/<repo>/settings`.
2. Locate pull request or merge settings.
3. Enable automatic deletion of head branches after merge.
4. Save changes.

## Final Response

Report:

- Repository and host.
- Previous setting if known.
- Final setting if changed or verified.
- Whether API changes were made or only manual instructions were provided.
