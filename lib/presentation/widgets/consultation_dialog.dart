import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme.dart';

class ConsultationDialog extends StatefulWidget {
  const ConsultationDialog({super.key});

  @override
  State<ConsultationDialog> createState() => _ConsultationDialogState();
}

class _ConsultationDialogState extends State<ConsultationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedService;

  final List<String> _services = [
    'Audit & Assurance',
    'Taxation',
    'Accounting & Payroll',
    'Registrations',
    'Consulting & Advisory',
    'IP & Others',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final service = _selectedService ?? 'Not specified';
      final time = _timeController.text.trim();

      final message = 'Hello Taxverse,\n\n'
          'I would like to *Book a Consultation*.\n\n'
          '*Name:* $name\n'
          '*Phone:* $phone\n'
          '*Service:* $service\n'
          '*Preferred Time:* $time\n\n'
          'Looking forward to hearing from you. Thank you!';

      final encodedMessage = Uri.encodeComponent(message);
      final whatsappUrl = 'https://wa.me/918129613322?text=$encodedMessage';

      launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);

      Navigator.of(context).pop();
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                            Text(
                              'Book a Consultation',
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fill in your details and our team will reach out within 24 hours.',
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
                  _buildLabel('Full Name'),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Your name',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please fill out this field.'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  _buildLabel('Phone'),
                  _buildTextField(
                    controller: _phoneController,
                    hintText: '+91 XXXXX XXXXX',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please fill out this field.'
                        : null,
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
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
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
                      validator: (value) =>
                          value == null ? 'Please fill out this field.' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Preferred Time
                  _buildLabel('Preferred Time'),
                  _buildTextField(
                    controller: _timeController,
                    hintText: 'e.g., Weekday mornings',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please fill out this field.'
                        : null,
                  ),
                  const SizedBox(height: 32),

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
                ],
              ),
            ),
          ),
        ),
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
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(
          fontFamily: 'Metropolis', fontSize: 14, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14,
          color: AppTheme.textSecondary.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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
