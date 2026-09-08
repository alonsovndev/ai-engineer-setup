---
description: "Review UI code for visual polish, animation quality, and responsive behavior"
name: "Review Design"
argument-hint: "Target files/component and whether to focus on visual polish, animation, or responsive behavior"
agent: "frontend-design"
---
Use the `frontend-design` skill to review UI code for visual polish, animation quality, and responsive behavior.

Requirements:
- Treat the skill as the source of truth for visual hierarchy heuristics, animation timing/easing/`prefers-reduced-motion` handling, and responsive breakpoint/touch-target/layout-adaptation rules.
- Component architecture, hooks, state management, and type safety are out of scope; defer those to `react-ui` or `code-review`.
- Report each finding as category, exact file/property/breakpoint, one concrete fix, and severity (blocking or advisory).
- Do not produce an exhaustive inventory unless asked.

Arguments: $ARGUMENTS
