import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../widgets/header_nav.dart';
import 'sections/footer_section.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedService = 'Select a service';

  final List<String> _services = [
    'Select a service',
    'Audit & Assurance',
    'Taxation',
    'Accounting & Payroll',
    'Registrations',
    'Consulting & Advisory',
    'IP & Others',
    'Other',
  ];

  void _handleNavigate(String section) {
    switch (section) {
      case 'HOME':
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 'ABOUT US':
        Navigator.pushReplacementNamed(context, '/about');
        break;
      case 'SERVICES':
        Navigator.pushReplacementNamed(context, '/services');
        break;
      case 'CAREERS':
        Navigator.pushReplacementNamed(context, '/careers');
        break;
      case 'CONTACT US':
      case 'Contact Us':
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderNav(
            onNavigate: _handleNavigate,
            activeRoute: 'CONTACT US',
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const _ContactHeroBanner(),
                  _buildContactContent(),
                  FooterSection(onNavigate: _handleNavigate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactContent() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              if (sizingInformation.isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildContactForm()),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: _buildContactInfo()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildContactForm(),
                  const SizedBox(height: 48),
                  _buildContactInfo(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Us a Message',
              style: GoogleFonts.inter(
                color: AppTheme.primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill out the form below and we\'ll get back to you shortly.',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField('Full Name', _nameController, Icons.person_outlined),
            const SizedBox(height: 20),
            _buildTextField('Email Address', _emailController, Icons.email_outlined),
            const SizedBox(height: 20),
            _buildTextField('Phone Number', _phoneController, Icons.phone_outlined),
            const SizedBox(height: 20),
            _buildDropdown(),
            const SizedBox(height: 20),
            _buildMessageField(),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Thank you! We\'ll get back to you soon.',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _messageController.clear();
                    setState(() {
                      _selectedService = 'Select a service';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Send Message',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 600.ms).slideX(begin: -0.05, end: 0, duration: 600.ms);
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14),
        prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
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
          borderSide: BorderSide(color: AppTheme.accentColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedService,
      onChanged: (value) {
        setState(() {
          _selectedService = value!;
        });
      },
      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryColor),
      icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
      decoration: InputDecoration(
        labelText: 'Service Interest',
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14),
        prefixIcon: Icon(Icons.business_center_outlined, color: AppTheme.textSecondary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
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
          borderSide: BorderSide(color: AppTheme.accentColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: _services.map((service) {
        return DropdownMenuItem<String>(
          value: service,
          child: Text(service),
        );
      }).toList(),
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a message';
        }
        return null;
      },
      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryColor),
      decoration: InputDecoration(
        labelText: 'Your Message',
        alignLabelWithHint: true,
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
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
          borderSide: BorderSide(color: AppTheme.accentColor),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          Icons.location_on_outlined,
          'Our Office',
          AppConstants.address,
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          Icons.email_outlined,
          'Email Us',
          AppConstants.contactEmail,
          onTap: () => launchUrl(Uri(scheme: 'mailto', path: AppConstants.contactEmail)),
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          Icons.phone_outlined,
          'Call Us',
          AppConstants.contactPhone,
          onTap: () => launchUrl(Uri(scheme: 'tel', path: AppConstants.contactPhone.replaceAll(' ', ''))),
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          Icons.access_time_outlined,
          'Business Hours',
          'Monday - Saturday: 9:30 AM - 6:00 PM\nSunday: Closed',
        ),
      ],
    ).animate().fade(delay: 200.ms, duration: 600.ms).slideX(begin: 0.05, end: 0, duration: 600.ms);
  }

  Widget _buildInfoCard(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.accentColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: onTap != null ? AppTheme.accentColor : AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

// ─── HERO BANNER ────────────────────────────────────────────────────────────────
class _ContactHeroBanner extends StatelessWidget {
  const _ContactHeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONTACT',
                  style: GoogleFonts.inter(
                    color: AppTheme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0, duration: 600.ms),
                const SizedBox(height: 12),
                Text(
                  'Get In Touch',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ).animate().fade(delay: 100.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, duration: 600.ms),
                const SizedBox(height: 16),
                SizedBox(
                  width: 600,
                  child: Text(
                    'Have a question or ready to get started? Reach out to our team today.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ).animate().fade(delay: 200.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, duration: 600.ms),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
