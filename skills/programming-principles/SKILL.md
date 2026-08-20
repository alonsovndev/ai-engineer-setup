---
name: programming-principles
description: "Use when generating, editing, or reviewing code against pragmatic programming principles: SOLID, KISS, DRY, YAGNI, single responsibility, dependency inversion, interface segregation, abstraction tradeoffs, cohesion, coupling, and over-engineering. Keywords: SOLID, KISS, DRY, YAGNI, programming principles, design principles, single responsibility, dependency inversion, abstraction, cohesion, coupling."
argument-hint: "Describe the code change, language, local conventions, and which principle or tradeoff is in question."
user-invocable: true
---
# Programming Principles Skill

Apply SOLID, KISS, DRY, and YAGNI as tradeoff tools. Prefer the simplest design that solves the current problem, preserves behavior, and leaves clear seams for real change.

For the classic creational/structural/behavioral pattern catalog (Factory, Singleton, Strategy, Observer, etc.) and when each one earns its place, use the `design-patterns` skill.

## Use This Skill For

- Reviewing whether code is too complex, too coupled, too duplicated, or prematurely abstracted.
- Deciding whether to extract helpers, interfaces, base classes, services, factories, builders, or strategy objects.
- Applying SOLID principles without turning them into ceremony.
- Balancing DRY against readability and wrong abstractions.
- Keeping generated code simple and maintainable.

## Do Not Use This Skill For

- Forcing patterns into small scripts, prototypes, or code with stable local conventions.
- Refactoring broad areas unrelated to the requested change.
- Adding abstractions only because a principle name can justify them.
- Treating SOLID as more important than clear behavior, tests, security, or local project style.

## Principle Priority

Use this order when principles conflict:

1. Correctness and security.
2. Existing project conventions and public contracts.
3. KISS: simplest understandable solution.
4. YAGNI: no speculative features or extension points.
5. DRY: remove real duplication after the repeated concept is stable.
6. SOLID: improve boundaries when they solve a current coupling, testability, or change problem.

## KISS

- Prefer direct code over clever code.
- Keep control flow flat with guard clauses when it improves readability.
- Use plain data structures and functions before classes or patterns when they are enough.
- Do not introduce framework, architecture, or pattern machinery for a small local problem.
- If a reader needs a long explanation, first try clearer names or simpler structure.

## YAGNI

- Do not add flags, extension points, generic types, providers, strategy registries, or configuration knobs for hypothetical future needs.
- Do not support unrequested formats, transports, storage backends, or workflows.
- Keep APIs narrow until real consumers need more.
- Prefer deleting unused code over preserving it for possible later use.

## DRY

- Remove duplication when the same domain concept or business rule appears in multiple places.
- Accept small duplication when code only looks similar but changes for different reasons.
- Avoid shared helpers that force callers into awkward names, flags, or conditional behavior.
- Extract after the second or third real repetition, not before the first stable use.
- Keep duplicated tests acceptable when they clarify different behaviors.

## SOLID, Pragmatically

| Principle | Apply when | Avoid when |
|---|---|---|
| Single Responsibility | A module changes for unrelated reasons or mixes domain, I/O, formatting, and orchestration | Splitting would create tiny files with no clearer boundary |
| Open/Closed | A stable extension point has multiple real variants | Only one implementation exists and future variants are speculative |
| Liskov Substitution | Subtypes or implementations are consumed through a common contract | Inheritance only exists to share code |
| Interface Segregation | Consumers depend on methods they do not use | A smaller interface adds indirection without reducing coupling |
| Dependency Inversion | Business logic depends on external I/O, frameworks, or concrete adapters | The dependency is local, stable, and not worth abstracting |

## Abstraction Decision Test

Before adding an abstraction, answer yes to at least one:

- Does it protect a real boundary such as database, network, filesystem, queue, UI, or framework?
- Does it make important behavior testable without slow or fragile infrastructure?
- Does it remove repeated domain logic, not just similar syntax?
- Does it isolate a known variant that already exists or is explicitly required?
- Does it make the code easier to read at the call site?

If all answers are no, keep the code local.

## Smell Checklist

- A helper takes boolean flags that change its personality.
- A class exists only to hold one static method.
- An interface has one implementation and no boundary reason.
- A base class shares code but makes behavior harder to follow.
- A generic solution has names like `Manager`, `Processor`, `Handler`, or `Helper` with no domain meaning.
- A refactor changes many files but no behavior, boundary, or testability improves.

## Output Contract

When delivering principle-focused work, include:

- Principle or tradeoff applied.
- Abstraction added, rejected, or removed and why.
- Any duplication intentionally accepted.
- Verification run or delegated to `quality-gates`.
