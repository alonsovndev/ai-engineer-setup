---
name: component-design
description: Use this skill when creating, refactoring, or reviewing UI components, their APIs, composition, and accessibility behavior.
---

When UI components are built or revised, use this skill to keep contracts clear, reusable, and accessible.

## When to Use This Skill

Activate this skill when the user:

- Requests a new component or component refactor
- Asks for reusable or design-system-aligned UI patterns
- Needs better component composition and prop design
- Wants to improve accessibility and interaction behavior

## How to Apply This Skill

### Step 1: Define Component Contract

- Identify inputs (props), outputs (events/callbacks), and states
- Keep the public API minimal and explicit

### Step 2: Design Composition Boundaries

- Separate presentational and stateful concerns where beneficial
- Prefer composition patterns over deep prop drilling

### Step 3: Cover User-Facing States

- Include loading, empty, error, and success states as needed
- Validate keyboard navigation and semantic accessibility

### Step 4: Add Confidence Checks

- Add component tests for critical interactions and rendering rules
- Verify responsive behavior for common breakpoints

## Guidelines

- Optimize for readability and long-term reuse
- Avoid hidden side effects in render logic
- Keep styling and behavior coupling intentional
- Document assumptions when component behavior is non-obvious
