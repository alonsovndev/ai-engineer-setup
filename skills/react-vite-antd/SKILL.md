---
name: react-vite-antd
description: "Use when working on React UI code with TypeScript, Vite, and Ant Design (antd). Covers component structure, hooks, TanStack Query/state management, AntD theming/forms/statics, Vite config and env vars, and Vitest/RTL testing. Keywords: react, typescript, vite, antd, ant design, tsx, hooks, react-query, frontend, ui component."
argument-hint: "Describe the component/feature, whether it's new UI, a refactor, or a review, and any existing patterns to preserve."
user-invocable: true
---
# React / Vite / Ant Design Skill

Use this skill only when the repository actually uses React with TypeScript, Vite, and Ant Design (`antd`).

For general SOLID/KISS/DRY/YAGNI tradeoffs, also apply the shared `programming-principles` skill. For test placement and coverage strategy, also apply `test-strategy`; use `tdd` when the user explicitly wants test-first development. For XSS, injection, and other client-side security concerns, also apply `secure-code-generation`. For animation, motion, and responsive-layout guidance, also apply the `frontend-design` skill.

Before editing, read the project files first and then apply the stack guide at `../../instructions/stacks/react-vite-antd.md` when it matches the repository. Do not impose that guide on Next.js, Vue, Svelte, plain JavaScript, other component libraries (MUI, Chakra), or legacy projects with established local conventions.

## Required Checks

- Confirm the active stack from project files such as `package.json` (react, antd, vite deps), `vite.config.ts`, `tsconfig.json`, and existing `.tsx` components.
- Follow existing local structure when it conflicts with the guide unless the user explicitly asks for a migration.
- Keep components functional, typed, and focused on one concern; extract a hook when a component mixes data fetching, form state, and rendering.
- Use AntD components and theme tokens instead of hand-built equivalents or ad hoc CSS overrides.
- Run the repository's available checks before completion, such as `tsc --noEmit`, lint, Vitest, and `vite build`.

## Component And State Checklist

- Props have an explicit `interface`/`type`; no `any`.
- Server/remote data goes through TanStack Query, not duplicated into local state.
- Context is used for small, focused cross-cutting concerns; no single "god context."
- Forms use `Form.useForm()` with declarative `rules`, not hand-rolled validation state.
- `message`/`notification`/`modal` come from `App.useApp()`, not the deprecated static AntD API.

## Testing Conventions

- Use Vitest and React Testing Library; test rendered behavior, not internal state.
- Mock network calls with MSW.
- Cover non-trivial custom hooks with `renderHook`.

## Cross-Reference Skills

When the task scope goes beyond stack integration, pull in the specialized skill that matches:

| Task | Skill |
|---|---|
| Deep AntD component API, tokens, Pro/X, SSR, a11y, `@ant-design/cli` lookup | `ant-design` |
| Vite config, plugins, build/SSR, environment API, Rolldown migration | `vite` |
| React/Next.js performance: rendering, re-renders, async, bundle, server rules | `vercel-react-best-practices` |
| Animation, motion, responsive layout, visual hierarchy | `frontend-design` |
| State management selection, local vs server data patterns | `state-management` |
| Redux Toolkit reducers, selectors, RTK Query | `redux-logic` |
| Client-side security (XSS, injection, CSP) | `secure-code-generation` |
| Test placement, fixtures, coverage strategy | `test-strategy` |

## Reference

Canonical standards: `../../instructions/stacks/react-vite-antd.md`.
