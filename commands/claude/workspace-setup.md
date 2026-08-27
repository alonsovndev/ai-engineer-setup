Scaffold a project workspace folder holding sibling BE/FE/docs repos.

Use the `workspace-setup` skill.

Arguments: $ARGUMENTS

Required behavior:

- Refuse to run with `ai-engineer-setup` itself as the target workspace.
- Discover the workspace's immediate subdirectories read-only first. A subdirectory with
  `.git` is a sub-repo; classify it FE/BE/Docs using the same heuristics as
  `ai-repo-setup` (package.json+react/vite, pyproject.toml/requirements.txt+fastapi,
  docs-heavy). Ask the user only when a sub-repo's role is ambiguous — never guess
  silently, and allow "Other" or "skip" per sub-repo.
- Never clone, `git init`, or otherwise create or modify a sub-repo — the user
  provisions BE/FE/docs repos themselves before running this command.
- Generate/update `AGENTS.md` and `CLAUDE.md` at the workspace root listing each detected
  sub-repo and its role/stack skill, noting each sub-repo keeps its own
  AGENTS.md/CLAUDE.md (generated separately via `/ai-repo-setup` run inside it, not by
  this command). Each file has a generated region and a custom region delimited by
  `<!-- workspace-setup:custom:start -->` / `<!-- workspace-setup:custom:end -->`
  markers; preserve the custom region verbatim on re-run, and stop to ask before
  touching either file if it already exists without markers.
- Ensure `specs/` exists at the workspace root as the shared cross-repo planning folder
  (same `specs/.gitignore` convention as `spec-planning`), for use with `/spec-plan` and
  `/spec-write-plan`.
- Do not generate `.github/copilot-instructions.md` or any per-sub-repo file — this
  command only scaffolds the workspace root.
- Report detected sub-repos and their classification, any `TBD` items, any
  not-yet-a-repo subdirectories, and what was created/updated/left untouched.
