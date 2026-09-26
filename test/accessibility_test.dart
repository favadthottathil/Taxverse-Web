import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxverse_portfolio/presentation/widgets/consent_checkbox.dart';
import 'package:taxverse_portfolio/presentation/widgets/consultation_dialog.dart';
import 'package:taxverse_portfolio/presentation/widgets/tap_target.dart';

void main() {
  dialogKeyboardTests();

  testWidgets('TapTarget is keyboard-activatable and exposes semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TapTarget(
            onTap: () => taps++,
            isLink: true,
            semanticLabel: 'Go home',
            child: const Text('HOME'),
          ),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(TapTarget)),
      matchesSemantics(
        label: 'Go home',
        isLink: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);

    await tester.tap(find.text('HOME'));
    expect(taps, 2);
    handle.dispose();
  });

  testWidgets('ConsentCheckbox blocks form validation until ticked', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final consentKey = GlobalKey<FormFieldState<bool>>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: ConsentCheckbox(key: consentKey),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text(ConsentCheckbox.errorMessage), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text(ConsentCheckbox.errorMessage), findsNothing);

    consentKey.currentState!.reset();
    await tester.pump();
    expect(formKey.currentState!.validate(), isFalse);
  });
}

void _tallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _pumpDialog(WidgetTester tester) async {
  _tallViewport(tester);
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: ConsultationDialog())),
  );
  await tester.pump();
}

bool _hasFocus(WidgetTester tester, Finder field) => tester
    .widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    )
    .focusNode
    .hasFocus;

void dialogKeyboardTests() {
  testWidgets('dialog autofocuses the first field', (tester) async {
    await _pumpDialog(tester);
    expect(_hasFocus(tester, find.byType(TextFormField).at(0)), isTrue);
  });

  testWidgets('failed submit focuses the first invalid field', (tester) async {
    await _pumpDialog(tester);
    // Move focus away from the name field first.
    await tester.tap(find.text('Submit Request'));
    await tester.pump();
    expect(_hasFocus(tester, find.byType(TextFormField).at(0)), isTrue);

    // Name + phone valid, so the next failure should land on the time field.
    await tester.enterText(find.byType(TextFormField).at(0), 'Asha');
    await tester.enterText(find.byType(TextFormField).at(1), '+91 85900 80509');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Taxation').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit Request'));
    await tester.pump();
    expect(_hasFocus(tester, find.byType(TextFormField).at(2)), isTrue);
  });

  testWidgets(
    'Enter in the last field attempts to submit and focuses consent',
    (tester) async {
      await _pumpDialog(tester);
      await tester.enterText(find.byType(TextFormField).at(0), 'Asha');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '+91 85900 80509',
      );
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Taxation').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(2), 'Mornings');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Consent is the only invalid field, so it shows its error and has focus.
      expect(find.text(ConsentCheckbox.errorMessage), findsOneWidget);
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.focusNode!.hasFocus, isTrue);
    },
  );
}
