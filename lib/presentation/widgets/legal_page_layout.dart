import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../pages/sections/footer_section.dart';
import 'header_nav.dart';

/// Shared page shell for long-form legal pages (privacy policy, terms):
/// header, hero banner, a readable single-column body and the footer.
class LegalPageLayout extends StatefulWidget {
  final String title;
  final String lastUpdated;
  final List<Widget> children;

  const LegalPageLayout({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.children,
  });

  @override
  State<LegalPageLayout> createState() => _LegalPageLayoutState();
}

class _LegalPageLayoutState extends State<LegalPageLayout> {
  final ScrollController _scrollController = ScrollController();

  void _handleNavigate(String section) {
    if (section.startsWith('SERVICES|')) {
      Navigator.pushNamed(context, '/services',
          arguments: section.split('|')[1]);
      return;
    }
    switch (section) {
      case 'HOME':
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        break;
      case 'ABOUT US':
        Navigator.pushReplacementNamed(context, '/about');
        break;
      case 'SERVICES':
        Navigator.pushReplacementNamed(context, '/services');
        break;
      case 'CONTACT US':
      case 'Contact Us':
        Navigator.pushReplacementNamed(context, '/contact');
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          HeaderNav(onNavigate: _handleNavigate, activeRoute: ''),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _LegalHeroBanner(
                    title: widget.title,
                    lastUpdated: widget.lastUpdated,
                  ),
                  _LegalBody(children: widget.children),
                  FooterSection(onNavigate: _handleNavigate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalHeroBanner extends StatelessWidget {
  final String title;
  final String lastUpdated;

  const _LegalHeroBanner({required this.title, required this.lastUpdated});

  static const TextStyle _eyebrowStyle = TextStyle(
    fontFamily: 'Metropolis',
    color: AppTheme.accentColor,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
  );

  static const TextStyle _updatedStyle = TextStyle(
    fontFamily: 'Metropolis',
    color: Color(0xCCFFFFFF),
    fontSize: 15,
    height: 1.6,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                final isDesktop = sizingInformation.isDesktop;
                return Column(
                  crossAxisAlignment: isDesktop
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    const Text('LEGAL', style: _eyebrowStyle),
                    const SizedBox(height: 12),
                    Semantics(
                      header: true,
                      headingLevel: 1,
                      child: Text(
                        title,
                        textAlign:
                            isDesktop ? TextAlign.left : TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          color: Colors.white,
                          fontSize: isDesktop ? 42 : 30,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Last updated: $lastUpdated', style: _updatedStyle),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalBody extends StatelessWidget {
  final List<Widget> children;

  const _LegalBody({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          // Long-form text reads best at a narrower measure than the grid.
          constraints: const BoxConstraints(maxWidth: 860),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

/// Text styles shared by the legal page content widgets.
abstract final class LegalText {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Metropolis',
    color: AppTheme.primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Metropolis',
    color: AppTheme.textSecondary,
    fontSize: 15,
    height: 1.7,
  );
}

/// Introductory paragraph shown above the first numbered section.
class LegalIntro extends StatelessWidget {
  final String text;

  const LegalIntro(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Text(text, style: LegalText.body),
    );
  }
}

/// A titled block of paragraphs and bullets. [trailing] lets a caller append
/// a widget that can't be built as a const string (e.g. a derived address).
class LegalSection extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
  final String? footnote;
  final Widget? trailing;
  final bool isLast;

  const LegalSection({
    super.key,
    required this.title,
    this.paragraphs = const [],
    this.bullets = const [],
    this.footnote,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text(title, style: LegalText.heading),
          ),
          const SizedBox(height: 12),
          for (final paragraph in paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(paragraph, style: LegalText.body),
            ),
          for (final bullet in bullets) LegalBullet(bullet),
          ?trailing,
          if (footnote != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(footnote!, style: LegalText.body),
            ),
        ],
      ),
    );
  }
}

class LegalBullet extends StatelessWidget {
  final String text;

  const LegalBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10, right: 12),
            child: SizedBox.square(
              dimension: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(child: Text(text, style: LegalText.body)),
        ],
      ),
    );
  }
}

/// "Contact Us" closing section shared by every legal page. Not const-able as
/// a whole because the single-line address is derived from [AppConstants].
class LegalContactSection extends StatelessWidget {
  final String number;

  const LegalContactSection({super.key, required this.number});

  static final String _singleLineAddress =
      AppConstants.address.replaceAll('\n', ', ');

  @override
  Widget build(BuildContext context) {
    return LegalSection(
      title: '$number. Contact Us',
      paragraphs: const [
        'For questions about this page, or to exercise your rights, contact Taxverse Business Consultancy:',
      ],
      bullets: const [
        'Email: ${AppConstants.contactEmail}',
        'Phone: ${AppConstants.contactPhone}',
      ],
      trailing: LegalBullet('Address: $_singleLineAddress'),
      isLast: true,
    );
  }
}
