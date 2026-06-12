import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:taxverse_portfolio/presentation/widgets/scroll_visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

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
    // Allow the 200ms timer in ScrollVisibilityDetector to fire
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
    // Allow the 200ms timer in ScrollVisibilityDetector to fire
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
}

// Add a getter/extension or field for testing in scroll_visibility_detector.dart if needed, or we can check the logs/UI.
