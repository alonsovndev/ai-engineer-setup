# Behavioral Patterns

## Strategy

**Intent**: make an algorithm's variant swappable at runtime behind a shared interface.

**Use when**: two or more real, interchangeable algorithms/behaviors are selected at runtime (pricing rules, sorting comparators, auth schemes).

**Don't use when**:
- Only one implementation exists and no second is concretely planned — see `programming-principles`' warning against "strategy registries... for hypothetical future needs."
- A plain function reference or lambda would do the job. In languages with first-class functions (JS/TS, Python), a Strategy "class" with one method is often just a function wearing a costume.

```ts
type PricingStrategy = (basePrice: number, quantity: number) => number;

const bulkDiscount: PricingStrategy = (base, qty) => (qty >= 10 ? base * qty * 0.9 : base * qty);
const standardPricing: PricingStrategy = (base, qty) => base * qty;

function checkout(strategy: PricingStrategy, base: number, qty: number): number {
  return strategy(base, qty);
}
```

## Observer

**Intent**: notify a set of dependents automatically when a subject's state changes, without the subject knowing their concrete types.

**Use when**: multiple, independent parts of the system need to react to an event without the source coupling to each of them directly (domain events, UI state changes, pub/sub).

**Don't use when**: there's exactly one listener — call it directly instead of routing through an event/subscription mechanism. A long observer chain makes "what runs when X happens" hard to trace; keep the list of subscribers discoverable, not scattered across the codebase.

```ts
class OrderPlaced extends EventEmitter {}

const orderPlaced = new OrderPlaced();
orderPlaced.on("placed", (order) => sendConfirmationEmail(order));
orderPlaced.on("placed", (order) => updateInventory(order));

orderPlaced.emit("placed", order);
```

In DDD terms this is a domain event — see `clean-architecture-ddd`'s guidance to "treat domain events as facts that happened, not commands to do work."

## Command

**Intent**: encapsulate a request (action plus parameters) as an object so it can be queued, logged, undone, or passed around.

**Use when**: you need to queue or schedule actions, support undo/redo, or log/replay requests as discrete units.

**Don't use when**: the action can just be called directly — wrapping every function call in a Command object with no queuing/undo/logging need is ceremony.

```ts
interface Command {
  execute(): void;
  undo(): void;
}

class MoveShapeCommand implements Command {
  constructor(private readonly shape: Shape, private readonly dx: number, private readonly dy: number) {}
  execute(): void { this.shape.move(this.dx, this.dy); }
  undo(): void { this.shape.move(-this.dx, -this.dy); }
}
```

## Template Method

**Intent**: define the skeleton of an algorithm in a base method, letting subclasses override specific steps without changing the overall structure.

**Use when**: several concrete variants share the same overall sequence of steps but differ in one or two specific steps, proven by two or more real implementations.

**Don't use when**: only one implementation exists, or composition (passing the varying step in as a function/strategy) would be clearer than inheritance — prefer composition over inheritance by default.

```ts
abstract class DataImporter {
  async run(source: string): Promise<void> {
    const raw = await this.fetch(source);
    const parsed = this.parse(raw);
    await this.save(parsed);
  }

  protected abstract fetch(source: string): Promise<string>;
  protected abstract parse(raw: string): unknown[];
  protected async save(records: unknown[]): Promise<void> { /* shared default */ }
}
```
