import 'package:flutter/material.dart';

/// Smoother, momentum-based scrolling for the web app.
///
/// The default web scroll physics ([ClampingScrollPhysics]) apply mouse
/// wheel deltas instantly with no inertia, which feels stiff. Bouncing
/// physics add deceleration and a subtle overscroll effect, closer to
/// native trackpad/touch scrolling.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}
