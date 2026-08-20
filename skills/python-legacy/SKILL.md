---
name: python-legacy
description: "Use when reading and understanding legacy Python codebases: architecture mapping, dependency triage, hotspot detection, compatibility risks, and documentation-first findings. Keywords: python legacy, monolith, dependency audit, runtime, migration, technical debt, reverse engineering."
argument-hint: "Describe the repository or module, Python version context (if known), and analysis goal."
user-invocable: true
---
# Python Legacy Skill

Use this skill to quickly understand legacy Python projects and produce a concise, evidence-based analysis plan.

## Use This Skill For
- Mapping unfamiliar Python codebases before changes.
- Identifying runtime, packaging, and dependency risks.
- Finding legacy hotspots and modernization candidates.
- Producing implementation-ready analysis notes without writing production code.

## Do Not Use This Skill For
- Implementing refactors or feature changes directly.
- Inventing missing facts such as owners, SLAs, versions, or deployment details.

## Lightweight Analysis Checklist
1. Define analysis scope
- Confirm target area: repository, package, or module.
- Capture objective and boundaries.
- Mark unknowns as `TBD`.

2. Locate entry points and execution flow
- Identify likely entry points: CLI scripts, app bootstraps, workers, schedulers.
- Map top-level package boundaries and key execution paths.
- Note dynamic import patterns and reflection-heavy flows.

3. Confirm runtime and packaging context
- Record Python version signals: CI configs, runtime files, metadata.
- Identify package/build style: requirements files, setup.py, pyproject.toml, poetry, pipenv.
- Flag Python 2 compatibility artifacts and mixed-version risks.

4. Triage dependencies and framework usage
- Inventory core dependencies and ecosystem age risks.
- Highlight pinned, unpinned, or conflicting constraints.
- Note framework footprints (web, async, task queues, ORM, data stack).

5. Find legacy hotspots
- Locate high-change or high-complexity modules.
- Identify tight coupling, global state, implicit side effects, and hidden I/O.
- Flag fragile seams: monkey patching, metaprogramming, and import-time behavior.

6. Capture quality and testability signals
- Note current test shape: unit, integration, contract, or minimal coverage.
- Record lint/type tooling presence (for example, ruff, flake8, mypy, pyright).
- Identify safe characterization-test candidates before refactor.

7. Summarize risks and next actions
- Rank top risks by impact and confidence.
- Propose smallest safe next analysis step.
- Keep recommendations incremental and reversible.

## Output Contract
When delivering results, provide:
- Objective and scope
- Codebase map (entry points, key modules, dependencies)
- Legacy hotspots and risk summary
- Assumptions and `TBD` unknowns
- Recommended next analysis steps

## Quality Checklist
- Findings are traceable to observed project artifacts.
- Unknowns are explicitly marked as `TBD`.
- Risk statements include impact and confidence.
- Recommendations are small, testable, and sequence-friendly.
- Output remains analysis-focused and avoids implementation work.
