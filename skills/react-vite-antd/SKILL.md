---
name: react-vite-antd
description: "Use when working on React UI code with TypeScript, Vite, and Ant Design (antd). Covers component structure, hooks, TanStack Query/state management, AntD theming/forms/statics, Vite config and env vars, and Vitest/RTL testing. Keywords: react, typescript, vite, antd, ant design, tsx, hooks, react-query, frontend, ui component."
argument-hint: "Describe the component/feature, whether it's new UI, a refactor, or a review, and any existing patterns to preserve."
user-invocable: true
---
# React / Vite / Ant Design Skill

Use this skill only when the repository actually uses React with TypeScript, Vite, and Ant Design (`antd`).

For general SOLID/KISS/DRY/YAGNI tradeoffs, also apply the shared `programming-principles` skill. For test placement and coverage strategy, also apply `test-strategy`; use `tdd` when the user explicitly wants test-first development. For XSS, injection, and other client-side security concerns, also apply `secure-code-generation`.

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

## Reference

Canonical standards: `../../instructions/stacks/react-vite-antd.md`.
