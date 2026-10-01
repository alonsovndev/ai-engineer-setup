---
name: ui-refinement
description: "Use when auditing and refining an existing React/Vite/Ant Design UI so it feels intentionally designed — preserving functionality, information architecture, and technical architecture. Covers design audit, generic-AI-pattern detection, design direction, prioritized implementation, and verification. Keywords: improve ui, refine ui, design audit, generic ai ui, impeccable, visual hierarchy, polish existing ui, saas look."
argument-hint: "Target page, feature, or component area to refine, plus any focus areas such as typography, color, or layout."
user-invocable: true
---
# Improve UI

Use this skill to review **and improve** an existing UI while preserving the product's identity, information architecture, functionality, and technical architecture. The objective is to make the interface feel intentionally designed by a strong product team — not like a generic AI-generated SaaS application.

This skill is the implementing counterpart to `review-design`/`frontend-design`, which only report findings without editing. It is React/Vite/Ant Design focused; on other stacks apply only the stack-agnostic phases and defer detail to the `frontend-design` skill.

**Approval gate:** after the implementation plan (Phase 5), stop and present the design direction and prioritized plan. Do not edit files until the user approves.

## Related Skills

- `frontend-design` — source of truth for visual polish, animation timing/easing and `prefers-reduced-motion`, and responsive breakpoint/touch-target rules (Phases 7–9).
- `react-vite-antd` and `antd-v6-patterns` — component structure, AntD theming/tokens, and v6 API conventions (Phase 6).
- `component-design` — component composition and accessibility behavior.

## Core Principles

1. Preserve existing functionality.
2. Preserve the existing information architecture unless there is a strong UX reason to change it.
3. Do not redesign the application from scratch; prefer refinement over replacement.
4. Use visual hierarchy intentionally.
5. Favor clarity, consistency, rhythm, and purposeful composition.
6. Avoid unnecessary decoration and generic AI-generated UI patterns.
7. Reuse existing components before creating new ones; keep the implementation maintainable and consistent with the existing architecture.

## Phase 1 — Inspect Before Changing

Do not modify files during this phase. Inspect `package.json`, Vite configuration, entry points, routing, layout/page/shared components, Ant Design and theme configuration, CSS/design tokens, typography, and any screenshots or visual references.

Identify the existing design language: primary and secondary colors, typography system, spacing system, border-radius and shadow patterns, component and layout conventions, responsive breakpoints, reusable components, and existing AntD customization.

## Phase 2 — Design Audit

Evaluate the target against these dimensions:

- **Visual hierarchy** — Is the most important information visually dominant? Are primary actions obvious and secondary actions subordinate? Is heading hierarchy clear, is content grouped logically, and do too many elements compete for attention?
- **Typography** — Heading scale, body readability, weights, line heights, letter spacing, density, and contrast between primary/secondary/supporting information. Typography should create hierarchy, not decoration. Avoid huge headings, all-caps, excessive bold, and tiny secondary text.
- **Layout & composition** — Alignment, grid structure, content width, vertical/horizontal rhythm, whitespace, density, section transitions, visual balance. Not every piece of content needs a card: use open layouts, dividers, typography, background changes, grouping, and whitespace when they communicate hierarchy better.
- **Color** — Brand color, backgrounds, surfaces, text, borders, semantic colors, contrast. Color should communicate hierarchy and meaning. Avoid random gradients, excessive accents, decorative color, and multiple competing primaries.
- **Components** — Are components reusable, consistent, appropriately abstracted, and visually coherent — or repetitive and over-customized? Prefer existing AntD components; do not introduce another UI framework or duplicate existing components.

## Phase 3 — Detect Generic AI UI

Run an explicit AI-design smell test. Flag unnecessary use of: excessive rounded cards, pills, badges, and shadows; glassmorphism; gradient backgrounds and gradient text; floating decorative blobs; giant hero sections; repetitive card grids and 3-column layouts; centering everything; every section getting identical visual treatment; decorative icons without semantic purpose; excessive border-radius, whitespace, and muted gray text; "Premium SaaS" clichés; artificial visual complexity; components all carrying identical visual weight.

Do not remove these patterns automatically — first determine whether each serves a legitimate design purpose. The goal is intentionality, not minimalism.

## Phase 4 — Define the Design Direction

Before implementing anything, state concisely:

- **Product personality** — 3–5 words (e.g. "precise, editorial, technical, confident").
- **Visual hierarchy** — primary visual anchor, secondary/supporting information, primary action, secondary actions.
- **Layout strategy** — content width, grid usage, section spacing, density, alignment.
- **Typography strategy** — display/headline, section headings, body, supporting text, labels.
- **Surface strategy** — when to use cards, borders, dividers, backgrounds, shadows, open layouts.

## Phase 5 — Implementation Plan

Prioritize the changes:

- **P0 — high impact**: hierarchy, usability, navigation, readability, composition, primary actions.
- **P1 — visual refinement**: spacing, typography, color, borders, surfaces, component consistency.
- **P2 — polish**: hover states, transitions, micro-interactions, icon alignment, small details.

Do not spend time on P2 while P0 issues remain.

## Approval Gate

Present the design direction and the P0/P1/P2 plan to the user, then stop. Only proceed after explicit approval. Scope the approved work as planned; do not silently expand it.

## Phase 6 — Implement

- **React** — functional components, hooks, existing project patterns, state management, and routing. No unnecessary architectural changes.
- **TypeScript** — maintain strict typing; no `any`, unnecessary assertions, or duplicated types.
- **Vite** — do not modify configuration unless required.
- **Ant Design** — prefer existing AntD components (Button, Typography, Space, Flex, Grid, Card, Form, Input, Select, Table, Tag, Badge, Modal, Drawer, Dropdown, Tooltip, Empty, Result) and the theme/token system. Do not recreate AntD components.
- **CSS** — follow the project's existing styling strategy (CSS Modules per component unless genuinely global). Prefer design tokens over scattered magic numbers.

## Phase 7 — Responsive Review

Review at ~375px, ~430px, ~768px, ~1280px, and ~1440px+: navigation, typography, tables, forms, cards, buttons, spacing, overflow, horizontal scrolling, content width, and touch targets. Do not simply stack everything vertically on mobile — preserve hierarchy and usability. Apply the `frontend-design` responsive rules (content-driven breakpoints, input-method detection).

## Phase 8 — Accessibility

Check semantic HTML, keyboard navigation, focus states, color contrast, button/form labels, error/loading/empty states, and screen-reader-friendly semantics. Do not rely exclusively on color to communicate meaning. Apply `component-design` accessibility behavior.

## Phase 9 — Interaction Design

Review hover, focus, active, loading, disabled, error, empty, and success states. Interactions should communicate state, not decorate. Use animation sparingly and prefer subtle transitions, per the `frontend-design` animation rules (including `prefers-reduced-motion`).

## Phase 10 — Final Genericity Review

After implementation, ask: *"If I removed the product name and logo, would this interface look like a generic AI-generated SaaS template?"* If yes, identify exactly which visual patterns cause that impression and improve them — repetitive cards, generic hero sections, excessive rounded corners, gradients, shadows, generic dashboard layouts, pills, weak typography hierarchy, excessive whitespace, lack of personality.

Do not add decoration to be "unique". Distinctiveness comes from composition, typography, spacing, hierarchy, information density, interaction design, and brand identity.

## Phase 11 — Code Quality Review

After the visual changes, check for duplicated CSS or components, unnecessary abstractions, dead styles, unused imports/variables, unnecessary dependencies, broken TypeScript types, console errors, and accessibility or responsive regressions. Follow KISS, DRY, YAGNI, SOLID; do not over-engineer the UI.

## Phase 12 — Verification

Run the project's actual checks from `package.json` — at minimum lint, type-check, build, and relevant tests where the scripts exist. Do not invent scripts. Fix issues introduced by these changes; report anything that could not be verified.

## Final Report

Provide: **Design audit** (biggest problems found), **Changes made**, **Generic AI patterns removed or reduced**, **Design decisions** (the important intentional ones), **Technical changes**, **Verification** (lint/type-check/build/tests, with anything unverified flagged), and **Remaining opportunities** (only meaningful improvements intentionally left for future work — never a full redesign).

## Never

- Replace the design system, Ant Design, or working components without reason, or add another component library.
- Introduce Tailwind just for styling convenience.
- Add gradients, animations, rounded corners, cards, pills, or decorative elements because they look "modern".
- Center everything, maximize whitespace to look "premium", or introduce arbitrary colors and typography.
- Change business logic while performing a visual review.

The objective is: **clarity + hierarchy + personality + usability + consistency** — make the existing product feel more intentional, distinctive, and professionally designed while remaining recognizably the same product. Do not optimize for "modern".
