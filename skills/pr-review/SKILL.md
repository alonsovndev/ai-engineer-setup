---
name: pr-review
description: "Use when reviewing pull requests for correctness, security, regressions, missing tests, architecture/convention violations, and actionable feedback. Keywords: PR review, pull request review, review comments, code review, GitHub review."
argument-hint: "Provide PR number/URL, base branch, review focus, and whether GitHub CLI access is approved."
user-invocable: true
allowed-tools: Bash
---

# PR Review Skill

Review pull requests with a findings-first, risk-focused code review style.

## Review Priorities

Prioritize in this order:

1. Correctness bugs and behavioral regressions.
2. Security, secrets, access-control, and data exposure risks.
3. Missing or inadequate tests for changed behavior.
4. Architecture, layering, migration, and operational risks.
5. Maintainability issues that materially affect future changes.

Avoid style-only comments unless they hide a correctness or maintenance risk.

## Safety Rules

- Use read-only commands by default.
- Never post review comments, approve, request changes, dismiss reviews, or update PRs without explicit approval.
- Never expose secrets, tokens, credentials, private config, or `.env` contents in review output.
- Do not claim checks passed unless you ran or inspected them.
- Do not invent intent, ownership, issue links, or test results.

## Inputs

Use whichever source is available:

- Local branch diff.
- PR number or URL.
- Patch/diff pasted by the user.
- `gh` read-only output from `github.com`.

## Local Review Workflow

```bash
git status --short
git branch --show-current
git log --oneline <base>..HEAD
git diff --stat <base>...HEAD
git diff <base>...HEAD
```

If `gh` access is approved:

```bash
gh pr view <number> --repo <owner>/<repo> --json title,body,baseRefName,headRefName,files,commits,reviews,comments
gh pr diff <number> --repo <owner>/<repo>
gh pr checks <number> --repo <owner>/<repo>
```

## Output Format

Start with findings. Do not lead with a summary.

```markdown
## Findings

- **blocking** `path/file.ext:line` - {issue}. {why it matters}. Fix: {one concrete fix}.
- **advisory** `path/file.ext:line` - {issue}. {why it matters}. Fix: {one concrete fix}.

## Open Questions

- {question if needed}

## Verification

- {checks inspected or run}

## Summary

- {brief change summary only after findings}
```

If there are no findings, say so explicitly and mention residual risks or unverified checks.

## Severity

- `critical`: security vulnerability, data loss, production outage, or irreversible change.
- `blocking`: likely bug, broken behavior, unsafe migration, or missing required test.
- `advisory`: maintainability, clarity, or risk-reduction improvement.

## Review Comment Posting

Only post comments after user approval and after showing the exact comments to be posted.
