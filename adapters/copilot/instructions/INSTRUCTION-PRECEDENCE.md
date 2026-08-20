# Instruction Precedence

Use this precedence order when multiple instruction sources are present.

## Priority order (highest to lowest)

1. Repository-specific instructions in the active project.
2. Workspace-global instructions in `.github/instructions/copilot-instructions.md`.
3. Agent-specific instructions in `agents/*.agent.md`.
4. Skill instructions in `skills/*/SKILL.md`.
5. Default model behavior.

## Conflict resolution rules

- If two rules conflict, follow the higher-priority source.
- If priority is equal and conflict remains, choose the safer and less destructive action.
- If unresolved, mark as `TBD` and request clarification.

## Multi-project behavior

- Global rules are defaults, not forced overrides for all repositories.
- Project-specific rules may narrow or strengthen global rules.
- Do not weaken security and secret-handling requirements.

## Documentation requirement

When conflicts are discovered, record:

- Conflicting files
- Decision taken
- Reasoning
- Follow-up action (if any)
