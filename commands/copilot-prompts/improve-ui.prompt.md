---
description: "Audit and refine an existing React/Vite/AntD UI so it feels intentionally designed, not like a generic AI-generated SaaS app"
name: "Improve UI"
argument-hint: "Target page, feature, or component area to refine, plus any focus areas such as typography, color, or layout"
agent: "frontend-design"
---
Use the `ui-refinement` skill to audit and refine an existing React/Vite/Ant Design UI so it feels intentionally designed. The core objective is avoiding generic AI-generated UI patterns.

Requirements:
- Treat the skill as the source of truth for the 12-phase workflow: inspect, audit, AI-genericity detection, design direction, prioritized plan, implement, responsive, accessibility, interaction, final genericity review, code quality, verification.
- Observe the approval gate: after the implementation plan, present the design direction and P0/P1/P2 plan, then stop until explicitly approved.
- Preserve existing functionality, information architecture, and technical architecture; do not redesign from scratch or change business logic.
- For findings-only review without edits, use `/review-design` instead; component architecture, hooks, and state management are out of scope.

Arguments: $ARGUMENTS
