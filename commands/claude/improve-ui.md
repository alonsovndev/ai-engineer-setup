---
description: "Audit and refine an existing React/Vite/AntD UI so it feels intentionally designed — not like a generic AI-generated SaaS app — using the `improve-ui` skill and `frontend-design` agent."
argument-hint: "Target page, feature, or component area to refine, plus any focus areas such as typography, color, or layout"
---

Audit and refine an existing React/Vite/Ant Design UI so it feels intentionally designed, using the `ui-refinement` skill and `frontend-design` agent. The core objective is avoiding generic AI-generated UI patterns.

## How To Use This Command

- `/improve-ui` — full workflow on the target page/feature: inspect, audit, detect generic AI patterns, define a design direction, then implement after approval.
- `/improve-ui --focus <area>` — narrow the audit and refinement to typography, color, layout, or responsive behavior.
- `/improve-ui --audit` — stop after the design audit and prioritized plan; report findings without editing.

## Required Skill

Use the `ui-refinement` skill before starting. Treat it as the source of truth for:

- The 12-phase workflow: inspect, audit, AI-genericity detection, design direction, prioritized plan, implement, responsive, accessibility, interaction, final genericity review, code quality, verification.
- The approval gate: after the implementation plan, present the design direction and P0/P1/P2 plan, then stop until explicitly approved.

It cross-references `frontend-design` (polish, animation, responsive rules), `react-vite-antd` and `antd-v6-patterns` (component conventions), and `component-design` (composition and accessibility).

## Scope

This command improves an existing UI while preserving functionality, information architecture, and technical architecture. It does not redesign from scratch, change business logic, or introduce new UI frameworks. For findings-only review without edits, use `/review-design` instead. Component architecture, hooks, and state management are out of scope — defer those to the `react-ui` agent.
