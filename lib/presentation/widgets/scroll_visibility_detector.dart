import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/motion.dart';

/// A widget that detects when its child is visible on the screen and plays a
/// slide-and-fade entrance animation. Alternatively, you can use the builder
/// parameter to define custom animations.
class ScrollVisibilityDetector extends StatefulWidget {
  final Key detectorKey;
  final Widget? child;
  final bool animateOnce;
  final Duration duration;
  final Duration delay;
  final Widget Function(BuildContext context, bool isVisible, Widget child)?
  builder;

  // `detectorKey` doubles as the widget's real Flutter `key` so Flutter
  // reconciles each instance by its intended identity instead of by its
  // position in the parent's children list. Without this, a list whose
  // shape changes across rebuilds (e.g. a ResponsiveBuilder branch swap, or
  // a hot reload during development) can hand a child's slot to the wrong
  // State object, leaving `_isVisible` stuck at false for that position —
  // the item silently never animates in.
  const ScrollVisibilityDetector({
    required this.detectorKey,
    this.child,
    this.animateOnce = false,
    this.duration = AppMotion.duration,
    this.delay = Duration.zero,
    this.builder,
  }) : super(key: detectorKey);

  @override
  State<ScrollVisibilityDetector> createState() =>
      ScrollVisibilityDetectorState();
}

class ScrollVisibilityDetectorState extends State<ScrollVisibilityDetector>
    with WidgetsBindingObserver {
  // VisibilityDetector identifies subscribers by key in a process-wide
  // registry. Reusing a constant `detectorKey` across multiple routes (e.g. the
  // footer, which is mounted on every page) makes two detectors collide while
  // both the outgoing and incoming pages are mounted during a route transition,
  // so callbacks overwrite each other and the entrance animation can misfire.
  // A per-instance key (stable across rebuilds, unique across instances) keeps
  // every detector globally unique regardless of what `detectorKey` callers pass.
  final Key _visibilityKey = UniqueKey();

  bool _isVisible = false;
  bool _canTrigger = false;
  Timer? _pollTimer;
  Timer? _pollTimeoutTimer;
  ScrollPosition? _scrollPosition;

  @visibleForTesting
  bool get isVisibleForTesting => _isVisible;

  /// Whether the element has climbed above the "reveal line" — a horizontal line
  /// [AppMotion.revealOffset] of the viewport height up from the bottom edge.
  ///
  /// We trigger on the element's POSITION rather than the fraction of its area
  /// that's visible. Area-based triggering fires the moment a small element's
  /// first pixels touch the bottom of the screen, so a quick entrance finishes
  /// before the user's eye gets there and the element appears un-animated.
  /// Requiring the top to rise past the reveal line means it animates while
  /// actually in view.
  bool _hasEnteredRevealZone() {
    if (!mounted) return false;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return false;

    try {
      final top = renderBox.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.sizeOf(context).height;
      return top <= screenHeight * (1 - AppMotion.revealOffset);
    } catch (e) {
      return false;
    }
  }

  void _evaluate(double visibleFraction) {
    if (!mounted || !_canTrigger) return;

    if (!_isVisible) {
      // Reveal only once the element is genuinely in view (on screen AND past
      // the reveal line), so the user actually watches it animate.
      if (visibleFraction > 0 && _hasEnteredRevealZone()) {
        setState(() => _isVisible = true);
      }
    } else if (!widget.animateOnce && visibleFraction < 0.01) {
      // Reset only when fully gone, so scrolling back replays the entrance.
      setState(() => _isVisible = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Use post-frame callback so the geometry is checked immediately after layout,
    // avoiding artificial delay.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _canTrigger = true;
        if (_hasEnteredRevealZone()) {
          _isVisible = true;
        }
      });
      _startPollingIfNeeded();
    });
  }

  // Safety net for mobile web: VisibilityDetector recomputes on a post-frame
  // callback, but some mobile browsers handle momentum/rubber-band scrolling
  // natively without promptly scheduling a Flutter frame, so a detector far
  // below the fold can sit unchecked until an unrelated interaction finally
  // triggers one. On a long section with many stacked detectors (e.g. the
  // About page's map + 6 feature cards), that reads as content staying
  // permanently blank instead of appearing on scroll. Polling briefly after
  // mount closes that gap without depending on any particular event firing.
  void _startPollingIfNeeded() {
    if (_isVisible || !mounted) return;
    _pollTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted || _isVisible) {
        timer.cancel();
        return;
      }
      if (_hasEnteredRevealZone()) {
        setState(() => _isVisible = true);
        timer.cancel();
      }
    });
    // Stop polling after a few seconds regardless — by then the user has
    // almost certainly scrolled or interacted enough to trigger a real frame,
    // and we don't want an indefinite timer per off-screen detector. Stored
    // so dispose() can cancel it too, otherwise it fires (harmlessly, but
    // untracked) after the widget is gone.
    _pollTimeoutTimer = Timer(const Duration(seconds: 6), () {
      _pollTimer?.cancel();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to the enclosing Scrollable's position directly. This is the
    // authoritative, synchronous signal for "the page moved" — unlike
    // VisibilityDetector's own callback (which is a best-effort recomputation
    // that can lag behind on mobile web when momentum scrolling doesn't
    // promptly schedule a Flutter frame), a ScrollPosition listener fires on
    // every scroll delta Flutter actually processes, closing the gap that let
    // far-below-the-fold content (e.g. a map image followed by six feature
    // cards) stay unrevealed until an unrelated interaction nudged it awake.
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _scrollPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!mounted || _isVisible || !_canTrigger) return;
    if (_hasEnteredRevealZone()) {
      setState(() => _isVisible = true);
    }
  }

  @override
  void didChangeMetrics() {
    // On mobile web, the browser chrome (address bar) is often still full-size
    // at first paint and only collapses once the user starts scrolling. That
    // shrinks/grows the reported viewport height *after* our initState reveal
    // check already ran, which can leave an above-the-fold element wrongly
    // marked not-yet-visible until some unrelated scroll event happens to
    // re-trigger VisibilityDetector's own callback. Re-checking here (metrics
    // changes fire independently of VisibilityDetector) closes that gap so
    // the entrance plays as soon as the real viewport size is known, not on
    // the next incidental scroll.
    if (!_isVisible && _canTrigger) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_hasEnteredRevealZone()) {
          setState(() => _isVisible = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pollTimeoutTimer?.cancel();
    _scrollPosition?.removeListener(_onScroll);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) => _evaluate(info.visibleFraction),
      child: widget.builder != null
          ? widget.builder!(
              context, _isVisible, widget.child ?? const SizedBox.shrink())
          : (widget.child ?? const SizedBox.shrink())
                .animate(target: _isVisible ? 1 : 0)
                .fade(
                  duration: widget.duration,
                  delay: widget.delay,
                  curve: AppMotion.curve,
                )
                .slideY(
                  begin: AppMotion.rise,
                  end: 0,
                  duration: widget.duration,
                  delay: widget.delay,
                  curve: AppMotion.curve,
                ),
    );
  }
}
