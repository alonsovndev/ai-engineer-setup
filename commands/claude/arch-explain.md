Generate a clear, audience-tailored architecture explanation for the current project.

## How to use this command

- `/arch-explain` — ask user for audience, then generate
- `/arch-explain --audience manager` — executive/business stakeholder narrative
- `/arch-explain --audience security` — security review narrative (data flows, trust boundaries, auth)
- `/arch-explain --audience engineer` — technical deep-dive for developers
- `/arch-explain --audience all` — generate all three as sections in one document
- `/arch-explain --topic {area}` — focus on a specific area (e.g., integrations, data-model, auth, audit)

## Before generating

Read the project's architecture documentation:
- Look for `AGENTS.md`, `CLAUDE.md`, `README.md`, or an `architecture/` docs folder
- Read any existing architecture diagrams and ADRs for context
- If no architecture docs exist, ask the user to describe the system's purpose, services, and key constraints

## Audience Profiles

### Manager / Business Stakeholder
Tone: plain language, no acronyms without definition, focus on outcomes and risk.
Cover:
- What problem this system solves (one clear sentence)
- What the system does in one short paragraph
- Key risks mitigated and why this design was chosen
- Team and timeline context (if known)
- What success looks like
Avoid: service names, SQL terms, infrastructure details, version numbers

### Security Reviewer
Tone: precise, technical, structured — bullet points and tables preferred.
Cover:
- Data classification: what data flows through the system and its sensitivity level
- Trust boundaries: what is internal vs external
- Auth model: service-to-service authentication, external API credentials, secret management
- Data access boundaries: which services own which data stores — state this explicitly
- Audit trail: where audit/event records are stored and what they capture
- Data retention and history strategy (e.g., versioning, immutability)
- What is NOT in scope: no PII, no user-facing auth, etc. (derive from project docs)
- Secrets separation: internal vs external credentials must not be shared

### Engineer / Developer
Tone: direct, technical, assume familiarity with distributed systems.
Cover:
- Service responsibilities and boundaries
- API contracts and data access rules (who owns which store)
- Coordination pattern: pull-based polling vs push/events — and why
- Idempotency guarantees and retry semantics
- Failure modes and overlap/concurrency protection
- Data versioning or history strategy
- CI/CD pipeline ownership and migration rules
- Observability: how to trace a request/batch across services

## Output structure

```markdown
# Architecture Overview: {System Name}

## Purpose

{One-sentence system purpose}

## System Summary

{2-3 sentence overview of what it does and why it's designed this way}

## {Audience-specific sections}

## Open Questions / Next Steps
```

For `--audience all`, add an H2 per audience.

## Save location

Check the project's CLAUDE.md or docs README for the canonical architecture folder.
Default fallback: `docs/architecture/arch-overview-{audience}.md`

If the user wants it for email or Confluence instead, output to the terminal directly.

## After generating

State: file saved (or terminal-only), audience targeted, and any gaps where assumptions were made.
