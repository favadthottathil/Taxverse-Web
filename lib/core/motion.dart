import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shared entrance-motion tokens so every scroll-triggered section animates
/// with the same cohesive "fade + gentle rise" feel — elements fade in and
/// drift up a small amount with a smooth decelerating glide. Nothing flies in
/// from the sides, which keeps the page feeling calm and premium.
class AppMotion {
  const AppMotion._();

  /// Snappy, professional entrance animation duration.
  static const Duration duration = Duration(milliseconds: 400);

  /// Vertical travel as a fraction of the widget height — small so it reads as
  /// a subtle rise rather than a jump.
  static const double rise = 0.08;

  /// Quick start, soft settle. At a short duration this reads as smooth and
  /// premium; it eases out so the element decelerates gently into place.
  static const Curve curve = Curves.easeOutCubic;

  /// How far an element must rise into the viewport before its entrance plays,
  /// as a fraction of viewport height measured up from the bottom edge.
  /// Small offset (0.08) means it starts animating almost immediately as it
  /// enters the screen.
  static const double revealOffset = 0.08;

  /// Delay between staggered siblings (cards, steps, features).
  static Duration stagger(int index) => Duration(milliseconds: 80 * index);
}

/// Builds the shared page-transition route used for every named-route
/// navigation, so moving between pages (e.g. Home -> About Us) feels like
/// part of the same cohesive "fade + gentle rise" motion language as
/// scroll-entrance animations, instead of the platform-default transition.
PageRouteBuilder<T> buildPageRoute<T>(
  RouteSettings settings,
  Widget Function(BuildContext) builder,
) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: AppMotion.duration,
    reverseTransitionDuration: AppMotion.duration,
    pageBuilder: (context, animation, secondaryAnimation) =>
        builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, AppMotion.rise),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

extension EntranceAnimation on Widget {
  /// Plays the shared fade + gentle-rise entrance when [isVisible] flips true
  /// and reverses it when [isVisible] flips false. Use [delay] to stagger
  /// siblings (see [AppMotion.stagger]).
  Widget riseFade({required bool isVisible, Duration delay = Duration.zero}) {
    return animate(target: isVisible ? 1 : 0)
        .fade(delay: delay, duration: AppMotion.duration, curve: AppMotion.curve)
        .slideY(
          begin: AppMotion.rise,
          end: 0,
          delay: delay,
          duration: AppMotion.duration,
          curve: AppMotion.curve,
        );
  }
}
