# Animation

Use motion to explain state, relationship, or hierarchy, or for one authored moment the surface has earned. Decoration without purpose is animation debt.

## Find the job

Inspect the existing motion language, interaction states, and performance budget before adding anything. Animate only where motion would:

- acknowledge an action;
- make a state change or spatial relationship legible;
- preserve continuity through navigation or layout change;
- direct attention at a meaningful moment.

Don't animate a static area merely because it exists. A generic fade-and-rise, hover lift, or scroll reveal on every section is not a thesis — it's decoration.

## Choose properties by meaning

`transform` and `opacity` are reliable foundations, not the entire palette. Choose properties for what the transition communicates:

- **Continuity/relationship** — shared-element motion, FLIP-style transforms, view transitions.
- **Focus/depth** — bounded blur, filter, or shadow changes.
- **Reveal/composition** — masks, clip paths, controlled occlusion.
- **State/feedback** — the smallest change that makes cause and result unmistakable.

Don't stack techniques for spectacle. One strong idea, carried through consistently, is usually enough. Sibling stagger is appropriate when a list appears as a list — cap the total delay, and don't reinterpret every scrolled section as a staggered list.

## Timing and easing

| Duration | Typical use |
|---|---|
| 100–150 ms | immediate feedback |
| 150–300 ms | routine state change |
| 300–500 ms | layout, overlay, or view transition |
| 500–800 ms | a deliberately authored focal entrance |

Exit faster than entrance. Use natural deceleration (`cubic-bezier(0.16, 1, 0.3, 1)`) for confident arrivals; don't reach for bounce or elastic curves by reflex. Long feedback reads as latency.

## Implementation

- Use CSS transitions and keyframes for declarative state and bounded sequences.
- Use the Web Animations API (or the project's existing motion library) for interruption, sequencing, or dynamic values.
- Use View Transitions or shared-element techniques when continuity across states is the point.
- Use scroll-driven motion only when the scroll relationship itself carries meaning, with a robust fallback.
- Don't add a dependency for an effect the existing stack can already express.

Keep content visible in the default state so a failed script doesn't hide the page. Avoid animating layout-driving properties (`width`, `height`, `top`, `left`, margins) — use transforms, FLIP, or grid techniques instead. Bound blur/filter/shadow/canvas work to isolated regions. Apply `will-change` only during the known animation window, then remove it. Measure on target devices rather than assuming `transform` alone means fast.

## Accessibility and control

Every animation needs a `prefers-reduced-motion` path with an intentional alternative:

```css
@media (prefers-reduced-motion: reduce) {
  .animated-element {
    animation: none;
    transition: opacity 150ms ease; /* keep meaningful feedback, drop spatial movement */
  }
}
```

Reduced motion means fewer and gentler animations, not disabling all motion — feedback that confirms an action should stay legible. Respect autoplay/sound preferences; any nonessential loop must stop when offscreen or hidden.

## Verify

- Every animation explains feedback, state, or relationship — removing it should lose meaning, not just decoration.
- Interruption and repeated use behave correctly (no stacked/queued animations from rapid re-triggers).
- Desktop, mobile, and keyboard-driven interactions remain usable.
- The `prefers-reduced-motion` path reduces movement without erasing meaningful feedback.
- Expensive effects stay smooth on the target device, not just in a fast dev environment.
