---
name: vertical-slicing
description: Use this skill when organizing code by feature slices so frontend and backend changes stay cohesive and loosely coupled.
---

When modules are being created or refactored, use this skill to structure code around end-to-end business capabilities instead of only technical layers.

## When to Use This Skill

Activate this skill when the user:

- Adds a feature that spans multiple concerns (UI/state/data or API/domain/persistence)
- Refactors layer-first folders toward feature-first modules
- Asks how to reduce coupling and merge conflicts across teams
- Requests review of module boundaries, ownership, or cohesion

## How to Apply This Skill

### Step 1: Define the Vertical Slice

- Identify a single business capability (for example: create-order)
- Group the feature entry points, application flow, domain rules, data adapters, and tests in one slice

### Step 2: Keep Dependencies Local

- Keep most dependencies inside the slice
- Move only stable, broadly reusable concerns to shared modules

### Step 3: Design Explicit Slice Contracts

- Expose a small public API per slice (for example: commands, queries, DTOs, hooks, handlers)
- Hide internals to prevent accidental reach-in from other slices

### Step 4: Coordinate Through Contracts, Not Internals

- Use events, application services, or explicit interfaces for slice-to-slice communication
- Avoid direct coupling to internal classes, tables, stores, or component internals across slices

### Step 5: Verify Slice Health

- Ensure most feature changes stay contained to one slice
- Flag repeated cross-slice edits as a sign of weak boundaries

## Guidelines

- Organize by feature first, then by sub-layer inside each feature when needed
- Keep slice names aligned with domain language
- Keep shared utilities minimal, stable, and clearly owned
- Preserve clear ownership so each slice can evolve with low coordination overhead
