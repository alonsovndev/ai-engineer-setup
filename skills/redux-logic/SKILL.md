---
name: redux-logic
description: "Use when designing, implementing, or reviewing Redux Toolkit state for client-owned data, reducers, selectors, RTK Query API slices, and store organization. Keywords: redux, redux-toolkit, rtk, rtk-query, slice, reducer, selector, store, dispatch, middleware."
argument-hint: "Describe the state shape, feature slice, or API integration. Specify whether it's new state, a refactor, or a review."
user-invocable: true
---
# Redux / Redux Toolkit Skill

Use this skill only when the repository already uses Redux or Redux Toolkit. Do not introduce Redux into a project that manages state with local hooks, Context, or TanStack Query unless the user explicitly requests it.

For general SOLID/KISS/DRY/YAGNI tradeoffs, also apply the shared `programming-principles` skill. For test placement and coverage strategy, also apply `test-strategy`. For client-side security concerns, also apply `secure-code-generation`.

## Required Checks

- Confirm the project uses Redux Toolkit (`@reduxjs/toolkit`) from `package.json` and existing store configuration.
- Follow existing local structure when it conflicts with this guide unless the user explicitly asks for a migration.
- Read the existing store configuration, root reducer, and middleware setup before adding new slices.

## Slice Design

- One feature slice per domain concern (e.g., `authSlice`, `cartSlice`, `uiSlice`).
- Slices live in `src/features/<feature>/store/` or `src/store/slices/` depending on project layout.
- Keep slice state minimal; do not duplicate server data that belongs in RTK Query or another data-fetching layer.
- Initial state is a typed constant, not an inline object.
- Reducers are pure functions; no side effects, no async logic.

## Selectors

- Export memoized selectors via `createSelector` (Reselect) for derived state.
- Do not compute derived values in components; compute them in selectors.
- Keep selectors close to the slice they read from; cross-slice selectors go in a shared `selectors.ts`.
- Avoid deep chaining of selectors; prefer flat, composable selectors.

## RTK Query

- Use RTK Query for server state (REST, GraphQL, WebSocket); use slices only for client-owned UI state.
- One `apiSlice` per logical backend or microservice boundary.
- Define `tagTypes` explicitly; use `providesTags` and `invalidatesTags` for cache invalidation.
- Do not manually dispatch query results into slice state.
- Use `onQueryStarted` for side effects (optimistic updates, analytics) — not in reducers.

## Store Configuration

- Single store created via `configureStore`; do not use legacy `createStore`.
- Middleware: include Redux Toolkit defaults; add custom middleware only when needed.
- Do not add `redux-thunk` manually — it is included by default in RTK.
- DevTools are enabled in development only.

## TypeScript

- State shape has an explicit `interface` or `type`.
- `createSlice` uses `Slice<State>` with typed `initialState`.
- `RootState` and `AppDispatch` are inferred from the store, not manually typed.
- Typed hooks (`useAppDispatch`, `useAppSelector`) are exported from the store file.
- No `any` in action payloads, selectors, or middleware.

## Anti-Patterns to Flag

- Storing server data in slices when RTK Query is available.
- Dispatching inside reducers or selectors.
- Large, untyped `any` payloads in actions.
- Manual `combineReducers` when `configureStore` handles it.
- Subscribing to the store directly instead of using `useSelector`/hooks.
- Multiple stores in a single app (unless micro-frontend isolation requires it).

## Testing Conventions

- Test reducers with plain function calls — no mocks needed.
- Test selectors with representative state trees.
- Test RTK Query endpoints with `setupApiStore` from `@reduxjs/toolkit/query`.
- Do not mock the entire store; test slices in isolation.
