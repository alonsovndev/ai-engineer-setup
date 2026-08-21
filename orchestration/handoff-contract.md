# Handoff Contract

Format for delegating work to subagents. Keep handoffs concise and self-contained.

## Handoff Format

```
## Task
{One sentence objective}

## Context
- Feature: {feature name or ticket}
- Files: {paths or patterns to focus on}
- Stack: {language, framework, key libraries}

## Constraints
- {Non-negotiable limits: no new dependencies, preserve API compatibility, etc.}
- {Architecture rules: layer boundaries, dependency direction, etc.}

## Inputs
- {Assumptions, existing patterns to follow, related files to read first}

## Expected Output
- {Exact format: findings list, code changes, diagrams, test files, etc.}

## Done Criteria
- {Measurable finish conditions: all tests pass, no blocking findings, gates green, etc.}
```

## Delegation Rules

1. **One subagent at a time**: Serial handoffs. Wait for results before delegating to the next.
2. **Include context, not repetition**: Reference files and patterns; don't re-explain what the subagent already knows from its own instructions.
3. **Specify output format**: Tell the subagent exactly what format you need (findings, code, tests, diagrams).
4. **Preserve scope**: Don't expand the subagent's task beyond what was requested.
5. **Collect results**: After each handoff, summarize findings and decide whether to proceed, fix, or delegate further.

## Common Handoff Patterns

### Requirements → Architecture → Implementation → Review

```
1. product-ba: "Define acceptance criteria for {feature}"
2. tech-lead (if needed): "Plan architecture for {feature} given {constraints}"
3. clean-architecture (if needed): "Validate layer boundaries for {feature}"
4. Domain subagent (react-ui / python-api / postgresql): "Implement/review {specific files}"
5. code-review: "Review all changes for correctness, security, and completeness"
```

### Bug Fix

```
1. code-review or domain subagent: "Investigate {bug} in {files}"
2. Domain subagent: "Fix {bug} with minimal change"
3. code-review: "Verify fix and check for regressions"
```

### API Change

```
1. api-design skill: "Review/define contract for {endpoint}"
2. Domain subagent: "Implement {endpoint} following contract"
3. postgresql (if data changes): "Review schema/migration for {tables}"
4. code-review: "Verify contract compliance, security, and tests"
```

## Platform Compatibility

- **opencode**: Subagents in `agents/opencode/*.md`. Use the `task` tool for delegation.
- **Claude Code**: Subagents in `agents/claude/*.md`. Use Claude's subagent mechanism.
- **Copilot CLI**: Agents in `agents/copilot/*.agent.md`. Use Copilot's agent invocation.

The handoff format is platform-agnostic — the same structure works across all three. Only the invocation mechanism differs.
