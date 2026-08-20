# Structural Patterns

## Adapter

**Intent**: convert one interface into another that calling code already expects, without changing either side.

**Use when**: integrating a third-party library, legacy code, or external API whose interface doesn't match what your domain/application layer expects.

**Don't use when**: you control both interfaces — change one of them instead of adding a translation layer.

```ts
// Third-party SDK exposes `send(payload: string)`; our app expects `EmailSender.deliver(message: Email)`.
class SdkEmailAdapter implements EmailSender {
  constructor(private readonly sdk: ThirdPartySdk) {}

  deliver(message: Email): Promise<void> {
    return this.sdk.send(JSON.stringify(message));
  }
}
```

This is exactly what a hexagonal-architecture adapter is — see `clean-architecture-ddd`'s Infrastructure layer.

## Decorator

**Intent**: attach behavior to an object dynamically by wrapping it in another object with the same interface.

**Use when**: cross-cutting behavior (logging, caching, retry, auth check) needs to wrap an existing implementation without modifying it, and more than one combination of behaviors is realistic.

**Don't use when**:
- Only one behavior is ever added — inline it in the original function/class.
- A chain of 4+ decorators makes call order and behavior hard to trace — consider a middleware pipeline or an explicit composition function instead.

```ts
interface Repository<T> {
  findById(id: string): Promise<T | null>;
}

class CachingRepository<T> implements Repository<T> {
  constructor(private readonly inner: Repository<T>, private readonly cache: Cache) {}

  async findById(id: string): Promise<T | null> {
    const cached = await this.cache.get(id);
    if (cached) return cached;
    const result = await this.inner.findById(id);
    if (result) await this.cache.set(id, result);
    return result;
  }
}
```

## Facade

**Intent**: provide a single simplified interface over a set of complex subsystems.

**Use when**: callers currently need to know about and coordinate several classes/services just to perform one coherent operation.

**Don't use when**: the subsystem is already simple, or the facade just forwards one call to one object with no coordination — that's an unnecessary layer, not a Facade.

```ts
class CheckoutFacade {
  constructor(
    private readonly cart: CartService,
    private readonly payments: PaymentService,
    private readonly shipping: ShippingService,
  ) {}

  async completeOrder(cartId: string): Promise<Order> {
    const cart = await this.cart.getCart(cartId);
    const payment = await this.payments.charge(cart.total);
    const shipment = await this.shipping.schedule(cart.items);
    return new Order(cart, payment, shipment);
  }
}
```

This overlaps with what a use case/application service already does in `clean-architecture-ddd` — in a hexagonal codebase the use case *is* the facade; don't add a second layer on top of it.

## Proxy

**Intent**: stand in for another object to control access to it (lazy loading, access control, remote calls).

**Use when**: you need to defer expensive construction, check permissions before delegating, or represent a remote/out-of-process object locally.

**Don't use when**: the access-control or laziness need is imagined rather than real — most code should call the real object directly.

```ts
class LazyImageProxy implements Image {
  private real?: RealImage;
  constructor(private readonly path: string) {}

  render(): void {
    if (!this.real) this.real = new RealImage(this.path); // expensive load deferred until first use
    this.real.render();
  }
}
```
