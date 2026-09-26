import 'package:flutter/widgets.dart';

/// A form field's [FormFieldState] key paired with the [FocusNode] it uses.
///
/// Forms keep one per field, in visual order, so a failed submit can move
/// keyboard focus to the first invalid field (see [focusFirstInvalid]) instead
/// of leaving focus on the submit button while the error sits out of view.
class FormFieldFocus<T> {
  final GlobalKey<FormFieldState<T>> key = GlobalKey<FormFieldState<T>>();
  final FocusNode node = FocusNode();

  void dispose() => node.dispose();
}

/// Focuses the first field in [fields] (given in visual order) that currently
/// shows a validation error. Call right after `FormState.validate()` fails.
void focusFirstInvalid(Iterable<FormFieldFocus<Object?>> fields) {
  for (final field in fields) {
    if (field.key.currentState?.hasError ?? false) {
      field.node.requestFocus();
      return;
    }
  }
}
