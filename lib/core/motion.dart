import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

/// Shared entrance-motion tokens so every scroll-triggered section animates
/// with the same cohesive "fade + gentle rise" feel — elements fade in and
/// drift up a small amount with a smooth decelerating glide. Nothing flies in
/// from the sides, which keeps the page feeling calm and premium.
class AppMotion {
  const AppMotion._();

  /// Snappy, professional entrance animation duration.
  static const Duration duration = Duration(milliseconds: 700);

  /// Full-page route transition. Much shorter than [duration]: the whole page
  /// is composited through a fade layer while it runs, so a long transition
  /// keeps that expensive layer alive (and the new page's first frames
  /// competing with it) for longer.
  static const Duration pageDuration = Duration(milliseconds: 280);

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
  static Duration stagger(int index) => Duration(milliseconds: 120 * index);

  /// True when entrance motion should be skipped: the user asked the OS/browser
  /// to reduce motion (`prefers-reduced-motion`), or assistive technology is
  /// active. In the latter case content that is faded to zero opacity is also
  /// dropped from the semantics tree, so it must be shown up front or screen
  /// readers would never reach anything below the fold.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);
}

/// Builds the shared page-transition page used for every go_router route,
/// so moving between pages (e.g. Home -> About Us) feels like part of the
/// same cohesive "fade + gentle rise" motion language as scroll-entrance
/// animations, instead of the platform-default transition.
CustomTransitionPage<T> buildTransitionPage<T>(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.pageDuration,
    reverseTransitionDuration: AppMotion.pageDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.disableAnimationsOf(context)) return child;
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
  ///
  /// Skipped entirely (content is simply shown) when [AppMotion.reduced].
  Widget riseFade({required bool isVisible, Duration delay = Duration.zero}) {
    return Builder(
      builder: (context) {
        if (AppMotion.reduced(context)) return this;
        return animate(target: isVisible ? 1 : 0)
            .fade(
              delay: delay,
              duration: AppMotion.duration,
              curve: AppMotion.curve,
            )
            .slideY(
              begin: AppMotion.rise,
              end: 0,
              delay: delay,
              duration: AppMotion.duration,
              curve: AppMotion.curve,
            );
      },
    );
  }
}
