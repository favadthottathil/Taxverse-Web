import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Required, initially-unticked consent checkbox for enquiry forms.
///
/// Built as a [FormField] so `Form.validate()` blocks submission until it is
/// ticked, and only this widget rebuilds when it changes. Give it a
/// `GlobalKey<FormFieldState<bool>>` to `reset()` it after a successful send.
class ConsentCheckbox extends FormField<bool> {
  static const String errorMessage = 'Please accept to continue.';

  /// [focusNode] lets the form move keyboard focus here when validation fails.
  ConsentCheckbox({super.key, FocusNode? focusNode})
    : super(
        initialValue: false,
        validator: (value) => value == true ? null : errorMessage,
        builder: (state) => _ConsentContent(
          checked: state.value ?? false,
          errorText: state.errorText,
          focusNode: focusNode,
          onChanged: state.didChange,
        ),
      );
}

class _ConsentContent extends StatefulWidget {
  final bool checked;
  final String? errorText;
  final FocusNode? focusNode;
  final ValueChanged<bool> onChanged;

  const _ConsentContent({
    required this.checked,
    required this.errorText,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_ConsentContent> createState() => _ConsentContentState();
}

class _ConsentContentState extends State<_ConsentContent> {
  static const TextStyle _textStyle = TextStyle(
    fontFamily: 'Metropolis',
    fontSize: 13,
    height: 1.5,
    color: AppTheme.textSecondary,
  );

  static const TextStyle _linkStyle = TextStyle(
    fontFamily: 'Metropolis',
    fontSize: 13,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: AppTheme.primaryColor,
    decoration: TextDecoration.underline,
  );

  late final TapGestureRecognizer _privacyTap = TapGestureRecognizer()
    ..onTap = () => context.push('/privacy');

  @override
  void dispose() {
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: 24,
              child: Checkbox(
                semanticLabel:
                    'I agree to the Privacy Policy and consent to Taxverse contacting me about my enquiry',
                focusNode: widget.focusNode,
                value: widget.checked,
                onChanged: (value) => widget.onChanged(value ?? false),
                activeColor: AppTheme.primaryColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                side: BorderSide(
                  color: errorText == null
                      ? AppTheme.textSecondary
                      : Colors.red.shade700,
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                // Clicking the label text toggles the box (a larger target);
                // the link keeps its own tap, which wins in the gesture arena.
                child: GestureDetector(
                  onTap: () => widget.onChanged(!widget.checked),
                  child: Text.rich(
                    TextSpan(
                      style: _textStyle,
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: _linkStyle,
                          recognizer: _privacyTap,
                        ),
                        const TextSpan(
                          text:
                              ' and consent to Taxverse contacting me about my enquiry.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 34),
            child: Text(
              errorText,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 12,
                color: Colors.red.shade700,
              ),
            ),
          ),
      ],
    );
  }
}
