---
name: branch-protection
description: "Use when configuring GitHub branch protection, especially making main require pull requests before merge without mandatory approvals. Keywords: branch protection, protect main, require pull request, GitHub."
argument-hint: "Provide repository owner/name, branch name, required rules, and whether changing branch protection is approved."
user-invocable: true
allowed-tools: Bash
---

# Branch Protection Skill

Configure GitHub branch protection safely for repositories on `github.com`.

## Default Policy

When the user asks for the standard setup, configure `main` so it requires pull requests before merging without requiring mandatory approvals.

Do not weaken existing stricter protections unless the user explicitly approves the exact relaxation.

For service repositories with `dev` and `main` branches, use this baseline unless the repository has stricter requirements. This applies to both fork-mode and direct-mode repositories because protections live on the organization repository:

| Branch | Required approvals | Required check | Notes |
|---|---:|---|---|
| `dev` | 1 | `continuous-integration/vela/push` | Development integration branch |
| `main` | 2 | `continuous-integration/vela/push` | Production-candidate branch |

Both branches should require pull requests, latest push approval, conversation resolution, linear history, and block force pushes.

## Safety Rules

- Never change branch protection without explicit approval for the named repository and branch.
- Read current protection first when possible.
- Preserve stricter existing settings unless the user asks to change them.
- Never bypass branch protections, force-push, or push directly to protected branches.
- Never expose or request GitHub tokens. Use existing `gh` authentication only.

## Preflight

Run local/read-only checks first:

```bash
git remote -v
git branch --show-current
command -v gh
gh auth status
```

Confirm:

- Repository owner/name.
- Target branch, usually `main`.
- Whether admins should be included.
- Whether approvals, status checks, signed commits, linear history, or restrictions are required.

## Read Current Protection

Use only after user approval to call the GitHub API:

```bash
gh api repos/<owner>/<repo>/branches/<branch>/protection
```

If the endpoint returns not found, report that protection may not be enabled.

## Standard Protection Shape

Target behavior:

- Pull request required before merge.
- Mandatory approvals not required unless explicitly requested.
- Existing required status checks preserved when present.
- Existing admin enforcement preserved unless explicitly changed.
- Existing push restrictions preserved unless explicitly changed.

For `dev`, use one required approval. For `main`, use two required approvals.

## Apply Changes

Prefer `gh api` with an explicit JSON body saved to a temp file or reviewed inline before execution. Do not apply broad default payloads that erase existing settings.

Before applying, show the exact payload or a concise diff of intended settings and ask for approval.

## Manual Fallback

If CLI access is unavailable, provide steps:

1. Open `https://github.com/<owner>/<repo>/settings/branches`.
2. Add or edit protection for `<branch>`.
3. Enable requiring pull requests before merging.
4. Leave required approvals disabled unless requested.
5. Preserve any existing required checks or restrictions.

## Final Response

Report:

- Repository, branch, and host.
- Current protection state if read.
- Changes applied or manual steps provided.
- Any settings intentionally preserved or left as `TBD`.
