import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxverse_portfolio/presentation/widgets/scroll_visibility_detector.dart';

void main() {
  testWidgets('ScrollVisibilityDetector does not trigger animations off-screen', (WidgetTester tester) async {
    final List<String> logs = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Top widget - on screen
                ScrollVisibilityDetector(
                  detectorKey: const Key('top-widget'),
                  builder: (context, isVisible, child) {
                    logs.add('top-widget: $isVisible');
                    return SizedBox(height: 800, child: child);
                  },
                  child: const Text('Top'),
                ),
                // Bottom widget - off screen (height of viewport is usually 600 in test)
                ScrollVisibilityDetector(
                  detectorKey: const Key('bottom-widget'),
                  builder: (context, isVisible, child) {
                    logs.add('bottom-widget: $isVisible');
                    return SizedBox(height: 800, child: child);
                  },
                  child: const Text('Bottom'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Initial frame
    await tester.pump();
    // Allow the post-frame reveal check to run
    await tester.pump(const Duration(milliseconds: 250));

    // Clear logs to only check states after stabilization
    logs.clear();
    // Pump another frame to apply the rebuild from setState
    await tester.pump();

    // Check if the bottom widget is visible or not.
    // It should NOT be visible.
    final bottomDetectorState = tester.state<ScrollVisibilityDetectorState>(
      find.byWidgetPredicate((w) => w is ScrollVisibilityDetector && w.detectorKey == const Key('bottom-widget')),
    );
    final isBottomVisible = bottomDetectorState.isVisibleForTesting;
    expect(isBottomVisible, isFalse, reason: 'Bottom widget should not trigger visibility when off-screen');
  });

  testWidgets('ScrollVisibilityDetector plays default animation when visible', (WidgetTester tester) async {
    // We will test the default animation (when builder is null)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                ScrollVisibilityDetector(
                  detectorKey: const Key('animated-widget'),
                  duration: const Duration(milliseconds: 500),
                  child: const Text('Animate Me'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Initial frame
    await tester.pump();
    // Allow the post-frame reveal check to run
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(); // trigger build

    // Find the state
    final state = tester.state<ScrollVisibilityDetectorState>(
      find.byWidgetPredicate((w) => w is ScrollVisibilityDetector && w.detectorKey == const Key('animated-widget')),
    );
    expect(state.isVisibleForTesting, isTrue);

    // Wait for the animation to play to completion
    await tester.pumpAndSettle();

    // Verify that the widget has a FadeTransition or Opacity in the tree
    final fadeTransitionFinder = find.descendant(
      of: find.byWidgetPredicate(
        (w) =>
            w is ScrollVisibilityDetector &&
            w.detectorKey == const Key('animated-widget'),
      ),
      matching: find.byType(FadeTransition),
    );
    expect(fadeTransitionFinder, findsOneWidget);

    // Get the opacity value
    final FadeTransition fadeTransition = tester.widget(fadeTransitionFinder);
    expect(fadeTransition.opacity.value, 1.0); // should be fully visible since it triggered and animated
  });

  group('scroll-driven reveal', () {
    const targetKey = Key('target');

    Future<ScrollController> pumpList(
      WidgetTester tester, {
      required bool animateOnce,
    }) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  const SizedBox(height: 2000),
                  ScrollVisibilityDetector(
                    detectorKey: targetKey,
                    animateOnce: animateOnce,
                    child: const SizedBox(height: 100),
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      return controller;
    }

    bool isVisible(WidgetTester tester) => tester
        .state<ScrollVisibilityDetectorState>(find.byKey(targetKey))
        .isVisibleForTesting;

    testWidgets('reveals when scrolled past the reveal line', (tester) async {
      final controller = await pumpList(tester, animateOnce: false);
      expect(isVisible(tester), isFalse);

      controller.jumpTo(1800);
      await tester.pump(); // layout for the new offset
      await tester.pump(); // post-frame pass + rebuild
      expect(isVisible(tester), isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('replays after leaving the viewport by default', (tester) async {
      final controller = await pumpList(tester, animateOnce: false);

      controller.jumpTo(1800);
      await tester.pump();
      await tester.pump();
      expect(isVisible(tester), isTrue);

      controller.jumpTo(0);
      await tester.pump();
      await tester.pump();
      expect(isVisible(tester), isFalse);

      controller.jumpTo(1800);
      await tester.pump();
      await tester.pump();
      expect(isVisible(tester), isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('animateOnce stays revealed after leaving', (tester) async {
      final controller = await pumpList(tester, animateOnce: true);

      controller.jumpTo(1800);
      await tester.pump();
      await tester.pump();
      expect(isVisible(tester), isTrue);

      controller.jumpTo(0);
      await tester.pump();
      await tester.pump();
      expect(isVisible(tester), isTrue);
      await tester.pumpAndSettle();
    });
  });
}
