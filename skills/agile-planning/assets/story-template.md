# Story Template — Spec Ingestion

Copy this template to create a planning story that matches the patterns under `docs/spec/07-planning/stories/`. In this repo, stories are written as implementation-ready operational work items rather than classic `As a [role]...` user stories.

## Required Fields

### Title

Use the same title shape already established in the story library.

**Common story format**: `<Source> - <Action>`

Examples:

- `<Source> - Analyze and Gather Data Source Ingestion Requirements`
- `<Source> - Submit and Track Minerva Intake Request`

**Source-type story format**: `<Source> - [Type] <Action>`

Examples:

- `<Source> - [JDBC] Review Access and Credentials`
- `<Source> - [API] Ingest Data into Lakehouse Raw`
- `<Source> - [Kafka] Create & Register the Topic Schema for Data Ingestion`
- `<Source> - [Flat File] Ingest Data into Lakehouse Raw`
- `<Source> - [HIST] Ingest Historical Data into Lakehouse Raw`

### Epic Link

Reference the parent epic for the source or capability initiative.

Example: `Minerva: Create the FDP for RMS Delacon Data`

### Story Points

Estimate effort using Fibonacci sequence: `1`, `2`, `3`, `5`, `8`, `13`, `21`

- **1 point**: trivial change; fully understood
- **2 points**: small update; low risk
- **3 points**: moderate task; some unknowns
- **5 points**: multi-step work item
- **8 points**: complex story with coordination or validation effort
- **13+ points**: split into smaller stories if possible

### Priority

Set one of: `Critical`, `High`, `Medium`, `Low`

### Description

Write a short operational description of the work to be completed. Keep it focused on ingestion setup, validation, access, or delivery steps.

Use this structure when helpful:

```markdown
Implement or validate the ingestion work required for <Source> so the data can be landed, governed, and made available in `LH Raw`, `clean`, or `MIF` as applicable.
```

### Important

Preserve the standard escalation note when applicable:

```markdown
In case any requirements or clarifications are needed from stakeholders or the client side, reach out the leaders for guidance and approvals.
```

### Acceptance Criteria

Write 3-7 testable completion outcomes. Match the pattern already used in the planning files: short, operational, and verifiable.

Example:

```markdown
- Prerequisites for API ingestion are met.
- API connectivity, authentication method, and required network/security prerequisites are validated.
- Ingestion configuration is created and deployed to extract data into the appropriate `LH Raw` location.
- Schema alignment and required data quality validations are completed.
- Documentation for ingestion setup and validation results is created and shared.
```

### Tasks

Use checkbox tasks for execution steps. These are implementation steps, not acceptance criteria.

Example:

```markdown
- [ ] Ensure prerequisites such as connectivity, credentials, entitlements, and Lakehouse permissions are set up.
- [ ] Configure the ingestion process for the source.
- [ ] Create and submit the required Pull Request.
- [ ] Validate the ingestion result in the target Lakehouse location.
- [ ] Document validation results and address any discovered issues.
- [ ] Add or update source-system documentation in the spec ingestion artifacts repository when findings, improvements, or critical information are identified: [minerva-ingestion-artifacts](https://github.com/<org>/minerva-ingestion-artifacts)
```

## Optional Fields

### Validation Checklist

Use when the story needs a lightweight review list, such as raw-to-clean validation, schema checks, PII review, or reconciliation steps.

### References

List supporting repos, dashboards, forms, docs, or utilities.

Examples:

- `Minerva Intake Form`
- `Minerva Intake & Discovery Dashboard`
- `mif-ingest-to-lakehouse-infra-dev`
- `confluent-minerva-dev`
- `CIT Utility`
- [minerva-ingestion-artifacts](https://github.com/<org>/minerva-ingestion-artifacts)

### Assignee

Set to a person or `unassigned`.

## Canonical Structure

Use this section order unless a simpler story does not need all sections:

```markdown
## <Source> - [Type] <Action>

### Description

...

### Important

...

### Acceptance Criteria

...

### Validation Checklist

...

### Tasks

...

### References

...
```

---

## Example (Filled)

**Title**: `<Source> - [API] Ingest Data into Lakehouse Raw`

**Epic Link**: `Minerva: Create the FDP for RMS Delacon Data`

**Story Points**: `5`

**Priority**: `High`

**Description**:

```markdown
Implement the ingestion of source data from API sources into the Lakehouse, ensuring proper setup of connectivity, authentication, extraction configuration, and schema alignment for reliable data integration into the `LH Raw` layer.
```

**Acceptance Criteria**:

```markdown
- Prerequisites for API ingestion are met.
- API connectivity, authentication method, and required network/security prerequisites are validated.
- Endpoints, request parameters, pagination approach, and extraction frequency are identified and documented.
- Ingestion configuration is created and deployed to extract data from the API into the appropriate Lakehouse Raw location.
- Schema alignment and required data quality validations are completed.
- Documentation for ingestion setup, assumptions, and validation results is created and shared.
```

**Tasks**:

```markdown
- [ ] Ensure prerequisites such as API connectivity, credentials, entitlements, and Lakehouse permissions are set up.
- [ ] Review API extraction requirements.
- [ ] Confirm endpoints, request parameters, pagination method, rate limits, and extraction cadence.
- [ ] Configure the ingestion process for the API source.
- [ ] Create and submit a Pull Request with the required ingestion configuration to the appropriate repository.
- [ ] Validate that data appears in the expected Lakehouse Raw location.
- [ ] Document validation results and address any discovered issues.
- [ ] Add or update source-system documentation in the spec ingestion artifacts repository when findings, improvements, or critical information are identified: [minerva-ingestion-artifacts](https://github.com/<org>/minerva-ingestion-artifacts)
```

**References**:

```markdown
- [minerva-ingestion-artifacts](https://github.com/<org>/minerva-ingestion-artifacts)
```

---

## Quick Tips

- Use the existing stories in `docs/spec/07-planning/stories/` as the source of truth for naming and section structure.
- Prefer operational language over abstract product language.
- Keep acceptance criteria outcome-based and tasks action-based.
- Include a documentation update task when findings, improvements, or critical information should be captured in this repository.
- Reuse the standard `Important` note when stakeholder clarification is expected.
- Mark unknowns as `TBD` instead of guessing.
