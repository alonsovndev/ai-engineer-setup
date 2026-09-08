Review UI code for visual polish, animation quality, and responsive behavior using the `frontend-design` skill and agent.

## How To Use This Command

- `/review-design` — review the current diff or the component the user points to for visual polish, animation, and responsive behavior together.
- `/review-design --animation` — focus only on motion: timing, easing, purpose, `prefers-reduced-motion`.
- `/review-design --responsive` — focus only on breakpoints, fluid sizing, touch targets, and layout adaptation.
- `/review-design --full` — review the whole page/feature, not just the diff.

## Required Skill

Use the `frontend-design` skill before reviewing. Treat it as the source of truth for:

- Visual hierarchy and polish heuristics.
- Animation property choice, timing/easing table, and `prefers-reduced-motion` handling.
- Responsive breakpoint strategy, fluid sizing, input-method detection, and layout-adaptation patterns.

## Scope

This command reviews visual design, motion, and responsive layout only. Component architecture, hooks correctness, state management, and type safety are out of scope — defer those to the `react-ui` agent (React/Vite/AntD projects) or the general `code-review` skill.

## After Reviewing

Report each finding as:

1. Category (visual hierarchy, animation, or responsive).
2. Exact file/component and, where relevant, the specific CSS property or breakpoint.
3. One concrete fix — not a list of alternatives.
4. Severity: **blocking** (breaks mobile usability, ignores `prefers-reduced-motion`, or makes core functionality touch-inaccessible) or **advisory** (polish/consistency issue).

Do not produce an exhaustive inventory unless asked — one finding, one fix.
