import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxverse_portfolio/presentation/pages/sections/footer_section.dart';

void main() {
  for (final width in [1280.0, 390.0]) {
    testWidgets('footer shows social profile links at ${width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FooterSection(animate: false)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final label in [
        'Taxverse on Instagram',
        'Taxverse on Facebook',
        'Taxverse on LinkedIn',
      ]) {
        expect(find.byTooltip(label), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
