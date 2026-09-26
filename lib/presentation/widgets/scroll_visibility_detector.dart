import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/motion.dart';

/// A widget that detects when its child scrolls into view and plays a
/// slide-and-fade entrance animation. Alternatively, you can use the builder
/// parameter to define custom animations.
///
/// Visibility is position-based (see [AppMotion.revealOffset]) and driven by
/// the enclosing [Scrollable]'s position. All detectors under one scroll
/// position share a single listener and a single post-frame pass per scroll
/// frame, so the cost doesn't grow with a listener/timer per instance.
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

/// One per [ScrollPosition]: owns the only scroll listener and re-evaluates
/// every tracked detector after the frame in which the position moved.
class _RevealCoordinator {
  static final Expando<_RevealCoordinator> _byPosition =
      Expando<_RevealCoordinator>();

  static _RevealCoordinator of(ScrollPosition position) =>
      _byPosition[position] ??= _RevealCoordinator._(position);

  _RevealCoordinator._(this._position);

  final ScrollPosition _position;
  final List<ScrollVisibilityDetectorState> _members = [];
  bool _passScheduled = false;

  void add(ScrollVisibilityDetectorState member) {
    if (_members.isEmpty) _position.addListener(schedulePass);
    _members.add(member);
  }

  void remove(ScrollVisibilityDetectorState member) {
    if (!_members.remove(member) || _members.isNotEmpty) return;
    _release();
  }

  void _release() {
    _position.removeListener(schedulePass);
    _byPosition[_position] = null;
  }

  /// Geometry is only valid once layout for the new offset has run, so the
  /// pass runs post-frame; the flag coalesces many scroll notifications into
  /// one pass.
  void schedulePass() {
    if (_passScheduled) return;
    _passScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _passScheduled = false;
      _runPass();
    });
  }

  void _runPass() {
    // Backwards so finished members can be removed in place. Evaluating only
    // calls setState (never dispose), so the list is stable during the loop.
    for (var i = _members.length - 1; i >= 0; i--) {
      final member = _members[i];
      if (member.evaluate()) {
        member.tracked = false;
        _members.removeAt(i);
      }
    }
    if (_members.isEmpty) _release();
  }
}

class ScrollVisibilityDetectorState extends State<ScrollVisibilityDetector> {
  bool _isVisible = false;
  ScrollPosition? _position;

  /// Whether this state is registered with its position's coordinator.
  /// Managed by [_RevealCoordinator] once registered.
  bool tracked = false;

  @visibleForTesting
  bool get isVisibleForTesting => _isVisible;

  /// Distance of the "reveal line" from the top of the viewport: a horizontal
  /// line [AppMotion.revealOffset] of the viewport height up from the bottom
  /// edge.
  ///
  /// We trigger on the element's POSITION rather than the fraction of its area
  /// that's visible. Area-based triggering fires the moment a small element's
  /// first pixels touch the bottom of the screen, so a quick entrance finishes
  /// before the user's eye gets there and the element appears un-animated.
  /// Requiring the top to rise past the reveal line means it animates while
  /// actually in view.
  ///
  /// Returns true when this detector needs no further tracking (revealed and
  /// [ScrollVisibilityDetector.animateOnce]).
  bool evaluate() {
    if (!mounted) return true;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return false;
    }

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;

    if (!_isVisible) {
      // Reveal only once the element is genuinely in view (on screen AND past
      // the reveal line), so the user actually watches it animate.
      if (bottom > 0 && top <= viewportHeight * (1 - AppMotion.revealOffset)) {
        setState(() => _isVisible = true);
      }
    } else if (!widget.animateOnce && (bottom <= 0 || top >= viewportHeight)) {
      // Reset only when fully gone, so scrolling back replays the entrance.
      setState(() => _isVisible = false);
    }
    return _isVisible && widget.animateOnce;
  }

  @override
  void initState() {
    super.initState();
    // Check right after the first layout so above-the-fold content reveals
    // without waiting for a scroll.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || evaluate()) return;
      _track();
    });
  }

  void _track() {
    final position = _position;
    if (tracked || position == null) return;
    tracked = true;
    _RevealCoordinator.of(position).add(this);
  }

  void _untrack() {
    final position = _position;
    if (!tracked || position == null) return;
    tracked = false;
    _RevealCoordinator.of(position).remove(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribing to the viewport size means a resize (or the mobile browser
    // chrome collapsing) re-runs the reveal check even with no scroll.
    MediaQuery.sizeOf(context);

    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _position) {
      final wasTracked = tracked;
      _untrack();
      _position = newPosition;
      if (wasTracked) _track();
    }
    if (tracked) _RevealCoordinator.of(_position!).schedulePass();
  }

  @override
  void dispose() {
    _untrack();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child ?? const SizedBox.shrink();
    final builder = widget.builder;
    if (builder != null) return builder(context, _isVisible, child);

    return child
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
        );
  }
}
