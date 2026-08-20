# Creational Patterns

## Factory Method / Abstract Factory

**Intent**: delegate object creation to a method or class so callers depend on an interface, not a concrete constructor.

**Use when**:
- The concrete type to construct depends on runtime input (config, request type, tenant), and callers shouldn't know the concrete class.
- Two or more real concrete types already exist behind a shared interface.

**Don't use when**:
- Only one concrete type exists and no second is concretely planned — a plain constructor is enough.
- The "factory" always returns the same type — that's a constructor wrapper, not a Factory.

```ts
interface PaymentProcessor {
  charge(amountCents: number): Promise<void>;
}

function createPaymentProcessor(provider: "stripe" | "paypal"): PaymentProcessor {
  switch (provider) {
    case "stripe": return new StripeProcessor();
    case "paypal": return new PaypalProcessor();
  }
}
```

In a DDD/hexagonal codebase, this is the composition root's job — see `clean-architecture-ddd`'s Dependency Injection And Composition Root section rather than scattering factories through business logic.

## Builder

**Intent**: construct a complex object step by step, avoiding a constructor with many optional parameters.

**Use when**:
- An object has several optional fields, or valid construction requires ordered steps.
- The result should be immutable once built.

**Don't use when**:
- The object has 2-3 fields — pass them as a plain argument object/dict instead.
- The language already supports named/default parameters or object literals cleanly (TypeScript object literals, Python `kwargs`/`dataclass`) — a Builder class adds ceremony those already replace.

```ts
class RequestBuilder {
  private headers: Record<string, string> = {};
  private body?: unknown;

  withHeader(key: string, value: string): this {
    this.headers[key] = value;
    return this;
  }

  withBody(body: unknown): this {
    this.body = body;
    return this;
  }

  build(): Request {
    return new Request({ headers: this.headers, body: this.body });
  }
}
```

## Singleton

**Intent**: guarantee exactly one instance of a type and provide a single access point to it.

**Use when**:
- Something genuinely must be process-wide and stateful: a connection pool, a shared cache, a logger sink.
- The stack doesn't already give this to you for free.

**Don't use when** (most of the time):
- Python and JavaScript modules are already singletons — a module-level instance created at import time does the job with no class ceremony.
- It's being used to smuggle global mutable state past dependency injection. This makes tests slow and order-dependent and hides real dependencies — prefer constructor injection of the shared instance (see `clean-architecture-ddd`'s Composition Root) over a `getInstance()` static accessor.

```ts
class ConnectionPool {
  private static instance: ConnectionPool;
  private constructor(private readonly config: PoolConfig) {}

  static getInstance(config: PoolConfig): ConnectionPool {
    if (!ConnectionPool.instance) {
      ConnectionPool.instance = new ConnectionPool(config);
    }
    return ConnectionPool.instance;
  }
}
```

Python equivalent — usually just a module-level instance, no class needed:

```python
# pool.py
_pool = ConnectionPool(config)  # created once at import time

def get_pool() -> ConnectionPool:
    return _pool
```
