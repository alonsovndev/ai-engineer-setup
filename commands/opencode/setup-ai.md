---
description: Wire AI-agent tooling into a target repo with frontend, backend, and/or docs areas.
agent: build
---

Wire AI-agent tooling into a target repo with frontend, backend, and/or docs areas.

Use the `ai-repo-setup` skill.

Arguments: $ARGUMENTS

Required behavior:

- Refuse to run with `ai-engineer-setup` itself as the target repo.
- Best-effort check that the global install is present (`~/.claude/AGENTS.md`,
  `~/.config/opencode/opencode.jsonc`, `~/.copilot/.github/instructions`); warn, don't
  block, if it's missing.
- Discover the target repo's frontend/backend/docs areas read-only first (package.json,
  pyproject.toml/requirements.txt, directory names, `docs/`). Ask the user only when a
  folder's stack is ambiguous or the repo is new/empty — never guess silently, and allow
  "not applicable" or "other/custom stack" (mark `TBD`) per area.
- Generate/update `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md` at the
  target repo root. Each file has a generated region and a custom region delimited by
  `<!-- ai-repo-setup:custom:start -->` / `<!-- ai-repo-setup:custom:end -->` markers;
  preserve the custom region verbatim on re-run, and stop to ask before touching any of
  these files if it already exists without markers.
- Point each detected area at the matching stack skill (`react-vite-antd`,
  `python-fastapi-ddd`, `technical-writer`/`markdown-author`) and its
  `instructions/stacks/*.md` file — do not attach a stack skill that doesn't fit.
- Do not generate a project-level `opencode.jsonc` unless the user explicitly asks for
  repo-scoped opencode permission overrides.
- Do not scaffold application folders, CI workflows, or package manifests — this command
  only wires instruction files.
- Report what was created, updated, or left untouched (custom blocks preserved), the
  stack assigned per area, any `TBD` items, and remind the user opencode needs a restart
  after config/instruction changes.
