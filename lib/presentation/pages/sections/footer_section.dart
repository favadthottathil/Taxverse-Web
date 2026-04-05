import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';

class FooterSection extends StatefulWidget {
  final Function(String)? onNavigate;

  const FooterSection({super.key, this.onNavigate});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('footer-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        } else if (info.visibleFraction == 0 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      },
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : AppTheme.primaryColor,
        padding: const EdgeInsets.only(top: 80, bottom: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.desktopMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.isDesktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildCompanyInfo(context)
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fade(duration: 600.ms)
                                  .slideY(begin: 0.1, end: 0),
                            ),
                            const SizedBox(width: 48),
                            Expanded(
                              child: _buildQuickLinks(context)
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fade(delay: 100.ms, duration: 600.ms)
                                  .slideY(begin: 0.1, end: 0),
                            ),
                            const SizedBox(width: 48),
                            Expanded(
                              child: _buildContactInfo(context)
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fade(delay: 200.ms, duration: 600.ms)
                                  .slideY(begin: 0.1, end: 0),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCompanyInfo(context)
                              .animate(target: _isVisible ? 1 : 0)
                              .fade(duration: 600.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 48),
                          _buildQuickLinks(context)
                              .animate(target: _isVisible ? 1 : 0)
                              .fade(delay: 100.ms, duration: 600.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 48),
                          _buildContactInfo(context)
                              .animate(target: _isVisible ? 1 : 0)
                              .fade(delay: 200.ms, duration: 600.ms)
                              .slideY(begin: 0.1, end: 0),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 64),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 24),
                  Text(
                    '© ${2026} Taxverse. All Rights Reserved.',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Taxverse provides top-tier finance, tax, and legal consultancy to help you streamline and grow your business with cost-effective, reliable solutions.',
          style: TextStyle(color: Colors.white70, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildLinkItem('HOME'),
        _buildLinkItem('ABOUT US'),
        _buildLinkItem('SERVICES'),
        _buildLinkItem('CAREERS'),
        _buildLinkItem('CONTACT US'),
      ],
    );
  }

  Widget _buildLinkItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: widget.onNavigate != null
            ? () => widget.onNavigate!(title)
            : null,
        child: Text(title, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildContactItem(Icons.location_on, AppConstants.address),
        _buildContactItem(
          Icons.phone,
          AppConstants.contactPhone,
          url: 'tel:${AppConstants.contactPhone.replaceAll(' ', '')}',
        ),
        _buildContactItem(
          Icons.email,
          AppConstants.contactEmail,
          url: 'mailto:${AppConstants.contactEmail}',
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, {String? url}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: url != null ? () => _launchUrl(url) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.highlightColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: url != null ? Colors.white : Colors.white70,
                  height: 1.4,
                  decoration: url != null
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }
}
