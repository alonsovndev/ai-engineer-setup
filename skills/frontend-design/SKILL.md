---
name: frontend-design
description: "Use when evaluating or improving visual design polish, animation/motion, or responsive layout in frontend UI work. Covers visual hierarchy, typography, restraint, motion timing and easing, breakpoints, fluid sizing, and touch/pointer adaptation. Keywords: frontend design, ui polish, impeccable, visual hierarchy, animation, motion, transitions, responsive, breakpoints, mobile-first, accessibility."
argument-hint: "Describe the UI, component, or page under design, and whether the concern is visual polish, animation, or responsive behavior."
user-invocable: true
---
# Frontend Design

Use this skill for visual design quality, motion, and responsive layout — on any frontend stack, not just React. It does not cover component architecture, hooks, or state management; use `react-vite-antd` and the `react-ui` agent for that when the project is React/Vite/AntD. For general code-quality tradeoffs, also apply `programming-principles`; for accessibility beyond what's covered here, also apply `secure-code-generation` for XSS/injection concerns specific to rendering user content.

Read the project's existing design language (tokens, component library, spacing scale) before proposing new visual choices. Match complexity to the existing vision rather than introducing a new one uninvited.

## Visual Polish

- Make deliberate, specific choices for palette, typography, and layout — avoid the generic defaults that any similar brief would produce (warm-cream-with-serif, near-black-with-one-accent, hairline-rule broadsheet). If the project already has a design language, follow it; only introduce a new one when asked.
- Typography carries personality: pair display and body faces deliberately, set an intentional type scale, and don't let type be a neutral delivery vehicle.
- Structural devices (numbering, dividers, eyebrows) should encode something true about the content, not decorate it — a numbered list only makes sense when order is meaningful.
- Spend boldness in one place. Keep everything else quiet and disciplined; cut decoration that doesn't serve the content.
- Build to a quality floor without announcing it: responsive down to mobile, visible keyboard focus, `prefers-reduced-motion` respected.
- Watch CSS selector specificity when editing styles — type-based selectors (`.section`) and element-based selectors can silently cancel each other out, especially on padding/margin between sections.

## Animation

See [animation.md](animation.md) for property choice, timing/easing, implementation guidance, and `prefers-reduced-motion` handling. Summary: animate to explain state, relationship, or hierarchy — not as decoration. Prefer `transform`/`opacity`; keep feedback under 300ms and reserve longer durations for layout/entrance moments; always ship a reduced-motion path.

## Responsive Design

See [responsive.md](responsive.md) for breakpoint strategy, fluid sizing, input-method detection, and layout-adaptation patterns. Summary: write mobile-first with `min-width` queries, let content dictate breakpoints, detect input method via `pointer`/`hover` media queries rather than screen size alone, and test on real devices — not just DevTools emulation.

## Reporting

When reviewing existing UI rather than building new, report each finding as: what's wrong, where (file/component), and one concrete fix — not a list of alternatives. Flag severity: **blocking** (breaks accessibility, ships unusable-on-mobile, or ignores `prefers-reduced-motion`) or **advisory** (polish/consistency issue that doesn't break usability).
