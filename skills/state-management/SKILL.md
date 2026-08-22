---
name: state-management
description: Use this skill when selecting, implementing, or refactoring frontend state patterns for local UI, shared client state, and server data.
---

When state complexity grows, use this skill to keep data flow explicit, predictable, and maintainable.

## When to Use This Skill

Activate this skill when the user:

- Asks how to manage local vs global state
- Introduces server data caching and synchronization concerns
- Requests reducer/store refactors
- Reports bugs caused by stale, duplicated, or inconsistent state

## How to Apply This Skill

### Step 1: Classify State Types

- Separate local UI state from shared application state
- Distinguish server state from client-owned state

### Step 2: Choose State Boundaries

- Keep state close to usage unless sharing is required
- Avoid global state for transient component-only concerns

### Step 3: Define Update Model

- Keep updates predictable and side effects explicit
- Compute derived state rather than storing duplicates

### Step 4: Validate Behavior

- Add tests for reducers/selectors and critical transitions
- Verify loading, retry, and error flows for remote data

## Guidelines

- Prefer simple patterns before introducing heavy abstractions
- Make ownership and lifecycle of state clear
- Prevent hidden coupling between distant components
- Keep state transitions easy to trace during debugging
