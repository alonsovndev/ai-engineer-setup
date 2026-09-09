# Performance Budget

Use these budgets to control token usage and response depth across orchestration workflows.

## Budget units

- Input budget: maximum context passed into an agent call.
- Output budget: maximum response size returned by the agent.
- Breach handling: behavior when budget is exceeded.

## Default budgets by mode

| Mode | Input budget | Output budget | Intended use |
|---|---:|---:|---|
| `minimal` | 600 tokens | 350 tokens | fast triage, low-risk requests |
| `standard` | 1400 tokens | 800 tokens | normal delivery and planning |
| `detailed` | 2800 tokens | 1600 tokens | release-gate, high-risk reviews |

## Budget by agent

| Agent | Recommended mode | Input cap | Output cap |
|---|---|---:|---:|
| `react-ui` | `standard` | 1800 | 1000 |
| `python-api` | `standard` | 1800 | 1000 |
| `postgresql` | `standard` | 1800 | 1000 |
| `terraform` | `standard` | 1800 | 1000 |
| `clean-architecture` | `standard` | 1900 | 1100 |
| `frontend-design` | `standard` | 1600 | 900 |
| `product-ba` | `standard` | 1500 | 900 |
| `tech-lead` | `standard` | 1900 | 1100 |
| `code-review` | `standard` | 2000 | 1200 |
| `bug-finder` | `standard` | 2000 | 1100 |
| `doc-tracker` | `standard` | 1800 | 1000 |

Use `detailed` only for release-gate or high-risk passes; use `minimal` for triage.

## Rules

1. Pass only delta context between phases.
2. Avoid repeating unchanged sections in handoffs.
3. Use bullet-first outputs unless user asks for deep prose.
4. For large artifacts, summarize in chat and write details to file.
5. Compress repetition before removing evidence.
6. Keep file paths, commands, failures, verification gaps, risks, blockers, and `TBD` values.
7. Summarize logs and tool output; do not paste noisy details unless they are the evidence.

## Breach handling

- If output exceeds cap, return:
  - concise summary
  - top risks/blockers
  - pointer to generated artifact path
- If input exceeds cap, trim in this order:
  1. historical context
  2. repeated rationale
  3. verbose examples
  4. unchanged plans
  5. obvious mechanics

## Validation checklist

- Mode declared (`minimal` / `standard` / `detailed`)
- Input and output fit declared cap
- No repeated unchanged context
- Important evidence was preserved
- Verification status and gaps are explicit
- Unknowns marked `TBD`
