import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/validators.dart';
import 'consent_checkbox.dart';
import 'form_field_focus.dart';

class ConsultationDialog extends StatefulWidget {
  const ConsultationDialog({super.key});

  @override
  State<ConsultationDialog> createState() => _ConsultationDialogState();
}

class _ConsultationDialogState extends State<ConsultationDialog>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedService;
  bool _launchFailed = false;

  // One per field, in visual order, so a failed submit can focus the first error.
  final _nameField = FormFieldFocus<String>();
  final _phoneField = FormFieldFocus<String>();
  final _serviceField = FormFieldFocus<String>();
  final _timeField = FormFieldFocus<String>();
  final _consentField = FormFieldFocus<bool>();

  static const String _requiredMessage = 'Please fill out this field.';

  final List<String> _services = [
    'Audit & Assurance',
    'Taxation',
    'Accounting & Payroll',
    'Registrations',
    'Consulting & Advisory',
    'IP & Others',
    'Other',
  ];

  // The dialog's own padding animates over 100ms when the keyboard opens, so
  // the focused field is re-revealed only after the viewport has settled.
  static const _keyboardSettleDelay = Duration(milliseconds: 150);
  Timer? _revealTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  /// The soft keyboard opens *after* a field is focused, so the framework's
  /// focus-time scroll-into-view runs against the still-full-height viewport
  /// and the field ends up hidden behind the keyboard. Re-reveal it once the
  /// insets change.
  @override
  void didChangeMetrics() {
    _revealTimer?.cancel();
    _revealTimer = Timer(_keyboardSettleDelay, _revealFocusedField);
  }

  void _revealFocusedField() {
    if (!mounted) return;
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext == null || !focusedContext.mounted) return;
    Scrollable.ensureVisible(
      focusedContext,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: 0.3,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _revealTimer?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    _nameField.dispose();
    _phoneField.dispose();
    _serviceField.dispose();
    _timeField.dispose();
    _consentField.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      focusFirstInvalid([
        _nameField,
        _phoneField,
        _serviceField,
        _timeField,
        _consentField,
      ]);
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final service = _selectedService ?? 'Not specified';
    final time = _timeController.text.trim();

    final message =
        'Hello Taxverse,\n\n'
        'I would like to *Book a Consultation*.\n\n'
        '*Name:* $name\n'
        '*Phone:* $phone\n'
        '*Service:* $service\n'
        '*Preferred Time:* $time\n\n'
        'Looking forward to hearing from you. Thank you!';

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl =
        'https://wa.me/${AppConstants.whatsappNumber}?text=$encodedMessage';

    final launched = await launchUrl(
      Uri.parse(whatsappUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted) return;
    if (launched) {
      Navigator.of(context).pop();
    } else {
      // Keep the dialog (and what the user typed) so they can retry.
      setState(() => _launchFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        label: 'Book a Consultation',
        explicitChildNodes: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              // Lets the browser autofill name / phone as one group.
              child: AutofillGroup(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Semantics(
                                  header: true,
                                  child: Text(
                                    'Book a Consultation',
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Fill in your details and our team will get back to you as soon as possible.',
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Close',
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Full Name
                      _labelled(
                        'Full Name',
                        _buildTextField(
                          field: _nameField,
                          controller: _nameController,
                          autofocus: true,
                          autofillHints: const [AutofillHints.name],
                          hintText: 'Your name',
                          maxLength: Validators.maxNameLength,
                          validator: (value) =>
                              Validators.required(value, _requiredMessage),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone
                      _labelled(
                        'Phone',
                        _buildTextField(
                          field: _phoneField,
                          controller: _phoneController,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          hintText: '+91 XXXXX XXXXX',
                          keyboardType: TextInputType.phone,
                          maxLength: Validators.maxPhoneLength,
                          validator: (value) => Validators.phone(
                            value,
                            emptyMessage: _requiredMessage,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Service
                      _buildLabel('Service'),
                      Theme(
                        data: Theme.of(context).copyWith(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: DropdownButtonFormField<String>(
                          key: _serviceField.key,
                          focusNode: _serviceField.node,
                          isExpanded: true,
                          focusColor: Colors.transparent,
                          initialValue: _selectedService,
                          hint: Text(
                            'Select a service',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppTheme.textSecondary,
                          ),
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF7C8BA1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF7C8BA1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: _services.map((service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: _HoverDropdownItem(text: service),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return _services.map<Widget>((String item) {
                              return Text(
                                item,
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 14,
                                  color: AppTheme.textPrimary,
                                ),
                              );
                            }).toList();
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedService = value;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please fill out this field.'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Preferred Time
                      _labelled(
                        'Preferred Time',
                        _buildTextField(
                          field: _timeField,
                          controller: _timeController,
                          // Last text field: Enter submits the form.
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          hintText: 'e.g., Weekday mornings',
                          maxLength: Validators.maxShortTextLength,
                          validator: (value) =>
                              Validators.required(value, _requiredMessage),
                        ),
                      ),
                      const SizedBox(height: 24),

                      ConsentCheckbox(
                        key: _consentField.key,
                        focusNode: _consentField.node,
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme
                                .accentColor, // Updated to use the theme's accent color
                            foregroundColor: AppTheme.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Submit Request',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (_launchFailed) ...[
                        const SizedBox(height: 12),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            'Could not open WhatsApp. Please try again or call us.',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 13,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Pairs a visible [label] with its [field] as one semantics node so screen
  /// readers announce the label when the input is focused.
  Widget _labelled(String label, Widget field) {
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildLabel(label), field],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required FormFieldFocus<String> field,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required int maxLength,
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
    Iterable<String>? autofillHints,
    ValueChanged<String>? onSubmitted,
    bool autofocus = false,
  }) {
    return TextFormField(
      key: field.key,
      focusNode: field.node,
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmitted,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      validator: validator,
      style: TextStyle(
        fontFamily: 'Metropolis',
        fontSize: 14,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14,
          color: AppTheme.textSecondary.withValues(alpha: 0.85),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7C8BA1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7C8BA1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _HoverDropdownItem extends StatefulWidget {
  final String text;

  const _HoverDropdownItem({required this.text});

  @override
  State<_HoverDropdownItem> createState() => _HoverDropdownItemState();
}

class _HoverDropdownItemState extends State<_HoverDropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 14,
            color: _isHovered ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}
