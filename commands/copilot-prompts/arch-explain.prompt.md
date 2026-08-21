---
description: "Generate a clear, audience-tailored architecture explanation for the current project"
name: "Arch Explain"
argument-hint: "Audience (manager, security, engineer, all) and optional topic focus"
agent: "tech-lead"
---
Generate an architecture explanation tailored to the specified audience.

Requirements:
- Read the project's architecture documentation first: `AGENTS.md`, `CLAUDE.md`, `README.md`, or an `architecture/` docs folder.
- Read any existing architecture diagrams and ADRs for context.
- If no architecture docs exist, ask the user to describe the system before generating.

Audience profiles:
- **Manager**: Plain language, no acronyms, focus on outcomes and risk. What problem the system solves, key risks, what success looks like. Avoid service names, SQL terms, infrastructure details.
- **Security**: Precise, technical, structured. Data classification, trust boundaries, auth model, data access boundaries, audit trail, secrets separation.
- **Engineer**: Direct, technical. Service responsibilities, API contracts, coordination patterns, idempotency, failure modes, CI/CD, observability.
- **All**: Generate all three as sections in one document.

Output structure:
1. System purpose (one sentence)
2. System summary (2-3 sentences)
3. Audience-specific sections
4. Open questions / next steps

Save in `docs/architecture/arch-overview-{audience}.md` unless the project has a canonical location. If the user wants it for email or Confluence, output to terminal instead.

Arguments: $ARGUMENTS
