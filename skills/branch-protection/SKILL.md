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

When the user asks for the standard setup on a repository with no CI/reviewers configured yet, apply this light preset to both `dev` and `main` (protections live on the organization repository, so this applies in both fork-mode and direct-mode): require a pull request before merging, no mandatory approval count, block force pushes, block branch deletion. No required status checks by default.

Do not weaken existing stricter protections unless the user explicitly approves the exact relaxation.

## Strict Preset (opt-in)

Use only when the user explicitly asks for stricter protection, or the repository already has CI and reviewers in place:

| Branch | Required approvals | Required check | Notes |
|---|---:|---|---|
| `dev` | 1 | `continuous-integration/vela/push` | Development integration branch |
| `main` | 2 | `continuous-integration/vela/push` | Production-candidate branch |

The status check name above is specific to repositories already wired to that CI system — confirm the actual check name with the user rather than assuming it applies. Both branches should also require latest push approval, conversation resolution, and linear history in this preset.

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

## Ruleset Mode (recommended)

GitHub Rulesets (`repos/{owner}/{repo}/rulesets`) are the modern replacement for classic per-branch protection. Prefer this mode: a single ruleset can target multiple branches by name (e.g. `refs/heads/main` and `refs/heads/dev`) instead of requiring one API call per branch, and a ruleset can be created even before a targeted branch exists yet.

**Read existing rulesets first** (avoid creating a duplicate):

```bash
gh api repos/<owner>/<repo>/rulesets
```

If a ruleset already covers the target branches, report it and ask before adding another rather than layering on a second one.

**Create** — only after explicit approval, with the exact JSON payload shown for review first:

```bash
gh api --method POST repos/<owner>/<repo>/rulesets --input - <<'JSON'
{
  "name": "protect-main-and-dev",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["refs/heads/main", "refs/heads/dev"], "exclude": [] } },
  "rules": [
    { "type": "pull_request", "parameters": { "required_approving_review_count": 0, "dismiss_stale_reviews_on_push": false, "require_code_owner_review": false, "require_last_push_approval": false, "required_review_thread_resolution": false } },
    { "type": "non_fast_forward" },
    { "type": "deletion" }
  ],
  "bypass_actors": []
}
JSON
```

This payload matches the light **Default Policy** above. For the **Strict Preset**, `required_approving_review_count` cannot vary by branch within one ruleset — either create two rulesets (one scoped to `refs/heads/dev` with `required_approving_review_count: 1`, one scoped to `refs/heads/main` with `2`), or fall back to per-branch classic protection below. Add a `required_status_checks` rule object only when the user confirms an actual check name:

```json
{ "type": "required_status_checks", "parameters": { "strict_required_status_checks_policy": true, "required_status_checks": [{ "context": "<check-name>" }] } }
```

**Update** an existing ruleset instead of creating a duplicate:

```bash
gh api --method PATCH repos/<owner>/<repo>/rulesets/<ruleset_id> --input -
```

Do not apply broad default payloads that erase an existing ruleset's other rules — read it first, then patch only the fields that need to change.

## Legacy Branch Protection API (fallback)

Use this per-branch API only when Rulesets are unavailable (older plans/orgs) or the user explicitly asks for classic protection.

Read current protection, only after user approval:

```bash
gh api repos/<owner>/<repo>/branches/<branch>/protection
```

If the endpoint returns not found, report that protection may not be enabled.

Target behavior:

- Pull request required before merge.
- Mandatory approvals not required unless explicitly requested (or per the Strict Preset above).
- Existing required status checks preserved when present.
- Existing admin enforcement preserved unless explicitly changed.
- Existing push restrictions preserved unless explicitly changed.

Prefer `gh api` with an explicit JSON body saved to a temp file or reviewed inline before execution. Do not apply broad default payloads that erase existing settings.

Before applying, show the exact payload or a concise diff of intended settings and ask for approval.

## Manual Fallback

If CLI access is unavailable, provide steps:

1. Open `https://github.com/<owner>/<repo>/settings/rules` for rulesets, or `https://github.com/<owner>/<repo>/settings/branches` for classic protection.
2. Add or edit the rule/protection for the target branch(es).
3. Enable requiring pull requests before merging.
4. Leave required approvals disabled unless requested.
5. Preserve any existing required checks or restrictions.

## Final Response

Report:

- Repository, target branch(es), and host.
- Mode used: ruleset or legacy classic protection.
- Current protection/ruleset state if read.
- Changes applied or manual steps provided.
- Any settings intentionally preserved or left as `TBD`.
