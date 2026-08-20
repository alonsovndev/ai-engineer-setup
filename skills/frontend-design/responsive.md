# Responsive Design

Adapting to a new context (screen size, device, input method) is rethinking the experience for that context, not scaling pixels. Screen size alone doesn't tell you the input method — a laptop can have a touchscreen, a tablet can have a keyboard.

## Mobile-first

Write base styles for mobile, then layer complexity with `min-width` queries. Desktop-first (`max-width`) makes mobile load unnecessary styles first.

## Breakpoints: content-driven

Don't chase device sizes; let content tell you where to break. Start narrow, stretch until the design breaks, add a breakpoint there. Three breakpoints usually suffice (640, 768, 1024px). Use `clamp()` for fluid values that don't need a breakpoint at all:

```css
.heading {
  font-size: clamp(1.5rem, 4vw + 1rem, 3rem);
}
```

## Detect input method, not just screen size

```css
/* Fine pointer (mouse, trackpad) */
@media (pointer: fine) {
  .button { padding: 8px 16px; }
}

/* Coarse pointer (touch, stylus) — larger target */
@media (pointer: coarse) {
  .button { padding: 12px 20px; }
}

/* Device supports hover */
@media (hover: hover) {
  .card:hover { transform: translateY(-2px); }
}

/* No hover (touch) — use :active instead */
@media (hover: none) {
  .card:active { /* ... */ }
}
```

Don't rely on hover for functionality — touch users can't hover. Touch targets: 44×44px minimum, with more spacing between interactive elements than a mouse-driven layout needs.

## Safe areas

```css
body {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
}
.footer {
  padding-bottom: max(1rem, env(safe-area-inset-bottom));
}
```

Requires `viewport-fit=cover` in the viewport meta tag:
```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
```

## Responsive images

`srcset` with width descriptors for resolution switching:

```html
<img
  src="hero-800.jpg"
  srcset="hero-400.jpg 400w, hero-800.jpg 800w, hero-1200.jpg 1200w"
  sizes="(max-width: 768px) 100vw, 50vw"
  alt="Hero image"
>
```

`<picture>` for art direction (different crops, not just resolutions):

```html
<picture>
  <source media="(min-width: 768px)" srcset="wide.jpg">
  <source media="(max-width: 767px)" srcset="tall.jpg">
  <img src="fallback.jpg" alt="...">
</picture>
```

## Layout adaptation patterns

- **Navigation**: hamburger + drawer on mobile, horizontal compact on tablet, full with labels on desktop.
- **Tables**: transform to cards on mobile (`display: block` + `data-label` attributes) rather than horizontal-scrolling a dense table.
- **Progressive disclosure**: `<details>`/`<summary>` for content that can collapse on mobile instead of always rendering everything.

## What to avoid

- Desktop-first CSS, or device detection instead of feature detection.
- Separate mobile/desktop codebases.
- Ignoring tablet and landscape orientation.
- Assuming all mobile devices are powerful, or all desktop devices lack touch — some do.
- Hiding core functionality on mobile because it "doesn't fit" — if it matters, make it work.
- Different information architecture per breakpoint — confusing, and breaks platform expectations.

## Testing

DevTools device emulation is useful for layout but misses real touch interactions, actual CPU/memory constraints, network latency, and font-rendering differences. Test on at least one real iPhone, one real Android device, and a tablet if the project targets one — cheap Android phones reveal performance issues simulators won't show.
