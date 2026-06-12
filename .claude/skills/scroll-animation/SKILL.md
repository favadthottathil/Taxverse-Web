---
name: scroll-animation
description: Use when adding or modifying scroll-triggered entrance animations on a page/section in this Flutter web app — explains ScrollVisibilityDetector, AppMotion tokens, and the riseFade extension.
---

# Scroll-triggered entrance animations

This project uses a shared "fade + gentle rise" entrance animation that plays
when an element scrolls into view. Every section should use this same pattern
for visual consistency — don't invent new animation styles or durations.

## Core pieces

- [lib/core/motion.dart](../../../lib/core/motion.dart) — `AppMotion` tokens
  (duration, curve, rise distance, reveal offset, stagger helper) and the
  `riseFade()` extension on `Widget`.
- [lib/presentation/widgets/scroll_visibility_detector.dart](../../../lib/presentation/widgets/scroll_visibility_detector.dart)
  — `ScrollVisibilityDetector` widget that wraps `VisibilityDetector` and
  exposes `isVisible` once the element crosses the reveal line.

## Pattern

Wrap the content that should animate in a `ScrollVisibilityDetector` with a
`builder`, then call `.riseFade(isVisible: isVisible, delay: ...)` on each
child widget:

```dart
ScrollVisibilityDetector(
  detectorKey: const Key('my-section-header-detector'),
  builder: (context, isVisible, child) {
    return Column(
      children: [
        Text('LABEL', style: ...).riseFade(isVisible: isVisible),
        Text('Heading', style: ...)
            .riseFade(isVisible: isVisible, delay: 200.ms),
        Text('Description', style: ...)
            .riseFade(isVisible: isVisible, delay: 400.ms),
      ],
    );
  },
)
```

For repeated items (cards, grid items, list rows), give each instance a
unique `detectorKey` and stagger the delay by index:

```dart
ScrollVisibilityDetector(
  detectorKey: Key('item-$index'),
  builder: (context, isVisible, child) {
    return MyCard(...).riseFade(isVisible: isVisible, delay: (index * 80).ms);
  },
)
```

`AppMotion.stagger(index)` (150ms steps) is also available for staggering —
use whichever stagger increment matches the density of nearby usages.

## Rules / gotchas

- **`detectorKey` must be unique per instance**, especially for widgets that
  can be mounted on multiple routes simultaneously (e.g. a footer present on
  every page during route transitions). `ScrollVisibilityDetector` already
  generates its own internal `UniqueKey` for the `VisibilityDetector`
  registry, but give your own `detectorKey` a descriptive, unique name anyway
  (e.g. `'industries-header-detector'`, `'industry-item-$index'`).
- **Don't change `AppMotion.duration`, `AppMotion.curve`, or `AppMotion.rise`**
  per-section — they're shared tokens so all sections feel cohesive. If a
  specific animation genuinely needs different timing, add a new named
  constant to `AppMotion` rather than hardcoding values inline.
- **Reveal triggering is position-based, not area-based** (`AppMotion.revealOffset`,
  default 0.2 = 20% of viewport height up from the bottom). This is
  intentional — area-based triggers fire as soon as a small element's edge
  touches the bottom of the screen, finishing the animation before the user's
  eye gets there. Don't "fix" this by switching to `visibleFraction` thresholds.
- By default (`animateOnce: false`), the animation **replays** when the user
  scrolls back up past the element and it leaves the viewport, then scrolls
  down again. Pass `animateOnce: true` only if a section should animate only
  the first time.
- If you need a custom animation shape (not fade+rise), use the `builder`
  parameter and build your own `.animate(target: isVisible ? 1 : 0)` chain —
  but check with the user first since this breaks visual consistency with
  other sections.

## Testing

[test/scroll_visibility_test.dart](../../../test/scroll_visibility_test.dart)
covers `ScrollVisibilityDetector`'s visibility/reveal-zone logic. Use
`isVisibleForTesting` (annotated `@visibleForTesting`) to assert animation
state in widget tests.
