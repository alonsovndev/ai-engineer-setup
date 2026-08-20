---
name: design-patterns
description: "Use when choosing, implementing, or reviewing classic object-oriented design patterns: Factory Method, Abstract Factory, Builder, Singleton, Adapter, Decorator, Facade, Proxy, Strategy, Observer, Command, Template Method. Covers intent, structure, a minimal example, and when NOT to reach for one. Keywords: design patterns, gang of four, GoF, factory pattern, singleton pattern, builder pattern, adapter pattern, decorator pattern, facade pattern, proxy pattern, strategy pattern, observer pattern, command pattern, template method."
argument-hint: "Describe the problem you're solving, the language/stack, and which pattern (if any) you're considering or reviewing."
user-invocable: true
---
# Design Patterns

Patterns are named solutions to recurring problems, not a vocabulary to reach for by default. Before adding one, run it through `programming-principles`' Abstraction Decision Test and `code-generation-style`'s Simplicity And Abstraction section — a pattern only earns its place when it clears those same bars.

This skill covers the general object-oriented catalog. For DDD/hexagonal-specific patterns (Repository, Use Case, DTO/Mapper, Composition Root), use `clean-architecture-ddd` instead — don't duplicate those here.

## Before Reaching For A Pattern

- Does a second real variant already exist, or is it purely hypothetical? One implementation behind an interface is not a pattern yet.
- Would inlining the logic be simpler to read than the pattern's indirection?
- Does the language already give you this for free? Python and JS modules are already singletons; first-class functions often replace a Strategy class.
- Are you naming the pattern to justify the abstraction, or does the abstraction solve a problem that already exists?

If every answer points to "not yet," keep the code local and revisit when the second real case shows up.

## Creational Patterns

See [creational.md](creational.md) — Factory Method, Abstract Factory, Builder, Singleton.

## Structural Patterns

See [structural.md](structural.md) — Adapter, Decorator, Facade, Proxy.

## Behavioral Patterns

See [behavioral.md](behavioral.md) — Strategy, Observer, Command, Template Method.

## Reporting

When reviewing pattern usage: name the pattern in play (or its absence), state whether it's justified — cite the real variant, boundary, or testability need it protects — or premature, and give one concrete fix (extract it, inline it, or replace it with a language-native feature). One finding, one fix.
