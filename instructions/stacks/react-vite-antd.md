# React / TypeScript / Vite / Ant Design Standards

Use these standards only for projects that actually use React with TypeScript, Vite, and Ant Design (`antd`).

Do not impose this structure on plain JavaScript projects, other frameworks (Next.js, Vue, Svelte), other component libraries (MUI, Chakra), legacy projects that follow another established architecture, or repositories with conflicting local conventions.

## Project Structure

Feature-first layout:

```text
src/
  app/
    App.tsx            # root component: providers + router
    routes/             # route definitions, lazy-loaded page components
    providers/           # ConfigProvider (AntD theme), QueryClientProvider, error boundaries
  features/<feature>/
    components/          # feature-scoped presentational/container components
    hooks/                # feature-scoped hooks (data fetching, local logic)
    api/                   # HTTP client calls and TanStack Query hooks for this feature
    types.ts                # feature-local types/interfaces
    index.ts                 # public exports for the feature
  shared/
    components/          # cross-feature reusable components
    hooks/                 # cross-feature reusable hooks
    lib/                    # framework-agnostic utilities, formatters, constants
    styles/                  # global styles, AntD theme tokens
  main.tsx              # ReactDOM root, StrictMode, provider wiring
index.html
vite.config.ts
tsconfig.json
```

## TypeScript Conventions

- Enable `strict` mode in `tsconfig.json`; do not weaken it to unblock a single file.
- Never use `any`; use `unknown` plus a type guard, or a precise type/interface.
- Define explicit `interface Props { ... }` for every component; do not infer prop shapes implicitly.
- Prefer `type` for unions/intersections and `interface` for object shapes that may be extended.
- Avoid non-null assertions (`!`); handle the `undefined`/`null` case explicitly.
- Configure path aliases (e.g. `@/features`, `@/shared`) identically in both `tsconfig.json` (`paths`) and `vite.config.ts` (`resolve.alias`).

## Component Conventions

- Functional components with hooks only; no class components.
- One component per file; file name matches the component name.
- Keep components focused: presentational components render props, container/feature components own data fetching and pass data down.
- Extract a custom hook when a component mixes more than one concern (data fetching, form state, subscriptions).
- Colocate a component's styles, tests, and stories with the component file.

## State Management

- Local UI state: `useState` or `useReducer`.
- Server/remote state: TanStack Query (`@tanstack/react-query`); do not duplicate server data into local component state or a global store.
- Cross-cutting UI state (theme, auth session, feature flags): React Context, kept small and split by concern.
- Only introduce a dedicated client-state library (e.g. Zustand) when Context causes real prop-drilling or re-render problems the project has already hit; do not add one speculatively.
- Do not reach for Redux unless the repository already uses it.

## Ant Design Conventions

- Wrap the app root in a single `ConfigProvider` carrying theme tokens (`theme.token`); do not scatter inline style overrides across components.
- Use the AntD `App` component (`import { App } from 'antd'`) and its context hook (`App.useApp()`) for `message`, `notification`, and `modal` instead of the deprecated static `message.success(...)` calls, so they pick up theme/context correctly.
- Prefer AntD components (`Table`, `Form`, `Modal`, `Select`, `DatePicker`) over hand-built equivalents; do not re-implement what AntD already provides.
- Use `Form.useForm()` plus declarative `rules` for validation; do not hand-roll validation state that duplicates `Form` behavior.
- Import components individually (`import { Button } from 'antd'`); do not import the entire library namespace.
- Override visual details through theme tokens or the component's `styles`/`classNames` props; avoid `!important` CSS overrides on AntD internals.
- Virtualize `Table`/`List` when rendering large datasets (AntD's built-in virtual scroll or `rc-virtual-list`).

## Vite Conventions

- Use `@vitejs/plugin-react` (or `@vitejs/plugin-react-swc` for faster builds) in `vite.config.ts`.
- Read environment variables through `import.meta.env`; only variables prefixed `VITE_` are exposed to client code.
- Never put secrets in `VITE_`-prefixed variables; they are bundled into client output.
- Code-split routes with `React.lazy` and dynamic `import()`; wrap route outlets in `Suspense` with a loading fallback.
- Keep `vite.config.ts` aliases in sync with `tsconfig.json` `paths`.

## Testing Conventions

- Use Vitest as the test runner and React Testing Library for component tests.
- Test behavior and rendered output, not internal state or implementation details.
- Mock network calls with MSW (Mock Service Worker) rather than mocking the HTTP client directly.
- Name test files `*.test.tsx`/`*.test.ts` colocated with the source file.
- Cover custom hooks with `renderHook` from React Testing Library when they contain non-trivial logic.

## Linting, Formatting, And Accessibility

- Use ESLint with `typescript-eslint` and `eslint-plugin-react-hooks`; do not disable `react-hooks/exhaustive-deps` without a documented reason.
- Use Prettier for formatting; do not hand-format to work around a missing config.
- Every interactive element has an accessible name (label, `aria-label`, or visible text); do not rely on placeholder text alone.
- Preserve keyboard navigation and focus order; do not trap focus outside of intentional modal/dialog behavior (AntD `Modal`/`Drawer` handle this by default).

## Performance

- Reach for `useMemo`/`useCallback` only when a measured re-render or expensive computation justifies it; do not memoize by default.
- Lazy-load route-level and heavy/rarely-used components (charts, rich text editors).
- Keep bundle size in check: check `vite build` output for unexpectedly large chunks before merging a dependency addition.
