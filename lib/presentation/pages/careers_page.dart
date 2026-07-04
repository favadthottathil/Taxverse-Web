import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../widgets/header_nav.dart';
import 'sections/footer_section.dart';

class CareersPage extends StatefulWidget {
  const CareersPage({super.key});

  @override
  State<CareersPage> createState() => _CareersPageState();
}

class _CareersPageState extends State<CareersPage> {
  final ScrollController _scrollController = ScrollController();

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
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutQuart,
        );
        break;
      case 'CONTACT US':
      case 'Contact Us':
        Navigator.pushReplacementNamed(context, '/contact');
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
            activeRoute: 'CAREERS',
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const _CareersHeroBanner(),
                  const _WhyWorkWithUsSection(),
                  const _OpenPositionsSection(),
                  const _GetInTouchSection(),
                  FooterSection(onNavigate: _handleNavigate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// ─── HERO BANNER ────────────────────────────────────────────────────────────────
class _CareersHeroBanner extends StatelessWidget {
  const _CareersHeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isDesktop = sizingInformation.isDesktop;
          return Align(
            alignment: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: isDesktop
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Text(
                      'CAREERS',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppTheme.accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    )
                        .animate()
                        .fade(duration: 1600.ms)
                        .slideY(begin: 0.2, end: 0, duration: 1600.ms),
                    const SizedBox(height: 12),
                    Text(
                      'Build Your Career with Taxverse',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: Colors.white,
                        fontSize: isDesktop ? 42 : 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    )
                        .animate()
                        .fade(delay: 100.ms, duration: 1600.ms)
                        .slideY(begin: 0.2, end: 0, duration: 1600.ms),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: isDesktop ? 600 : double.infinity,
                      child: Text(
                        'Join a team of professionals dedicated to excellence in finance and business services.',
                        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: isDesktop ? 16 : 15,
                          height: 1.6,
                        ),
                      )
                          .animate()
                          .fade(delay: 200.ms, duration: 1600.ms)
                          .slideY(begin: 0.2, end: 0, duration: 1600.ms),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── WHY WORK WITH US ───────────────────────────────────────────────────────────
class _WhyWorkWithUsSection extends StatefulWidget {
  const _WhyWorkWithUsSection();

  @override
  State<_WhyWorkWithUsSection> createState() => _WhyWorkWithUsSectionState();
}

class _WhyWorkWithUsSectionState extends State<_WhyWorkWithUsSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('why-work-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF8FAFC),
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
            child: Column(
              children: [
                Text(
                  'WHY CHOOSE US',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: AppTheme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(duration: 1600.ms),
                const SizedBox(height: 12),
                Text(
                  'Why Work With Us',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: AppTheme.primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                )
                    .animate(target: _isVisible ? 1 : 0)
                    .fade(delay: 100.ms, duration: 1600.ms),
                const SizedBox(height: 48),
                ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    if (sizingInformation.isDesktop) {
                      return Row(
                        children: [
                          Expanded(
                              child: _buildCard(
                                  Icons.school_outlined,
                                  'Learning Culture',
                                  'Continuous learning through workshops, certifications, and on-the-job training programs.',
                                  0)),
                          const SizedBox(width: 24),
                          Expanded(
                              child: _buildCard(
                                  Icons.groups_outlined,
                                  'Expert Mentors',
                                  'Work alongside experienced CAs and industry leaders who guide your professional growth.',
                                  1)),
                          const SizedBox(width: 24),
                          Expanded(
                              child: _buildCard(
                                  Icons.trending_up_outlined,
                                  'Growth Path',
                                  'Clear career progression with regular performance reviews and advancement opportunities.',
                                  2)),
                          const SizedBox(width: 24),
                          Expanded(
                              child: _buildCard(
                                  Icons.laptop_mac_outlined,
                                  'Modern Workplace',
                                  'State-of-the-art office with the latest tools, technology, and flexible work arrangements.',
                                  3)),
                        ],
                      );
                    }
                    if (sizingInformation.isTablet) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: _buildCard(
                                      Icons.school_outlined,
                                      'Learning Culture',
                                      'Continuous learning through workshops, certifications, and on-the-job training programs.',
                                      0)),
                              const SizedBox(width: 24),
                              Expanded(
                                  child: _buildCard(
                                      Icons.groups_outlined,
                                      'Expert Mentors',
                                      'Work alongside experienced CAs and industry leaders who guide your professional growth.',
                                      1)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: _buildCard(
                                      Icons.trending_up_outlined,
                                      'Growth Path',
                                      'Clear career progression with regular performance reviews and advancement opportunities.',
                                      2)),
                              const SizedBox(width: 24),
                              Expanded(
                                  child: _buildCard(
                                      Icons.laptop_mac_outlined,
                                      'Modern Workplace',
                                      'State-of-the-art office with the latest tools, technology, and flexible work arrangements.',
                                      3)),
                            ],
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildCard(
                            Icons.school_outlined,
                            'Learning Culture',
                            'Continuous learning through workshops, certifications, and on-the-job training programs.',
                            0),
                        const SizedBox(height: 16),
                        _buildCard(
                            Icons.groups_outlined,
                            'Expert Mentors',
                            'Work alongside experienced CAs and industry leaders who guide your professional growth.',
                            1),
                        const SizedBox(height: 16),
                        _buildCard(
                            Icons.trending_up_outlined,
                            'Growth Path',
                            'Clear career progression with regular performance reviews and advancement opportunities.',
                            2),
                        const SizedBox(height: 16),
                        _buildCard(
                            Icons.laptop_mac_outlined,
                            'Modern Workplace',
                            'State-of-the-art office with the latest tools, technology, and flexible work arrangements.',
                            3),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      IconData icon, String title, String description, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
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
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppTheme.accentColor),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    )
        .animate(target: _isVisible ? 1 : 0)
        .fade(
            delay: Duration(milliseconds: 200 + (index * 150)),
            duration: 1600.ms)
        .slideY(
            begin: 0.15,
            end: 0,
            delay: Duration(milliseconds: 200 + (index * 150)),
            duration: 1600.ms);
  }
}

// ─── OPEN POSITIONS ─────────────────────────────────────────────────────────────
class _OpenPositionsSection extends StatefulWidget {
  const _OpenPositionsSection();

  @override
  State<_OpenPositionsSection> createState() => _OpenPositionsSectionState();
}

class _OpenPositionsSectionState extends State<_OpenPositionsSection> {
  bool _isVisible = false;

  final List<Map<String, String>> _positions = [
    {
      'title': 'CA, CS, CMA Articleship / Internship',
      'location': 'Calicut, Kerala',
      'type': 'Full-time',
      'category': 'Audit & Finance',
      'date': 'Open Year-Round',
    },
    {
      'title': 'Managers, Senior & Junior Accountants, Team Leaders',
      'location': 'Calicut, Kerala',
      'type': 'Full-time',
      'category': 'Accounts',
      'date': 'Immediate',
    },
    {
      'title': 'Accounts Executive',
      'location': 'Calicut, Kerala',
      'type': 'Full-time',
      'category': 'Finance & Accounts',
      'date': 'Immediate',
    },
    {
      'title': 'CA, CS, CMA Final or Qualified, LLB and MBAs',
      'location': 'Calicut, Kerala',
      'type': 'Full-time',
      'category': 'Key Positions',
      'date': 'Immediate',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('open-positions-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
            child: Column(
              children: [
                Text(
                  'OPPORTUNITIES',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: AppTheme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(duration: 1600.ms),
                const SizedBox(height: 12),
                Text(
                  'Current Openings',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: AppTheme.primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                )
                    .animate(target: _isVisible ? 1 : 0)
                    .fade(delay: 100.ms, duration: 1600.ms),
                const SizedBox(height: 48),
                ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    int crossAxisCount = sizingInformation.isMobile ? 1 : 2;

                    List<Widget> rows = [];
                    for (var i = 0;
                        i < _positions.length;
                        i += crossAxisCount) {
                      int end = (i + crossAxisCount < _positions.length)
                          ? i + crossAxisCount
                          : _positions.length;
                      List<Map<String, String>> rowItems =
                          _positions.sublist(i, end);

                      rows.add(
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...rowItems.asMap().entries.map((entry) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _buildJobCard(
                                        entry.value, i + entry.key),
                                  ),
                                );
                              }),
                              ...List.generate(
                                crossAxisCount - rowItems.length,
                                (_) => Expanded(
                                    child: Container(
                                        margin: const EdgeInsets.all(8.0))),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(children: rows);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, String> position, int index) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            position['title']!,
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(Icons.location_on_outlined, position['location']!),
              _buildTag(Icons.access_time_outlined, position['type']!),
              _buildTag(Icons.category_outlined, position['category']!),
              _buildTag(Icons.calendar_today_outlined, position['date']!),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: AppConstants.contactEmail,
                  queryParameters: {
                    'subject': 'Application: ${position['title']}',
                  },
                );
                launchUrl(emailUri);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Apply Now',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(target: _isVisible ? 1 : 0)
        .fade(
            delay: Duration(milliseconds: 200 + (index * 150)),
            duration: 1600.ms)
        .slideY(
            begin: 0.15,
            end: 0,
            delay: Duration(milliseconds: 200 + (index * 150)),
            duration: 1600.ms);
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── GET IN TOUCH ───────────────────────────────────────────────────────────────
class _GetInTouchSection extends StatelessWidget {
  const _GetInTouchSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              return Container(
                padding: EdgeInsets.all(sizingInformation.isMobile ? 24 : 40),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                  'Don\'t see the right position?',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Send your CV to us and we\'ll reach out when we have the perfect match for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined,
                        color: AppTheme.accentColor, size: 20),
                    const SizedBox(width: 8),
                    SelectableText(
                      AppConstants.contactEmail,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppTheme.accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_outlined,
                        color: AppTheme.accentColor, size: 20),
                    const SizedBox(width: 8),
                    SelectableText(
                      AppConstants.contactPhone,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppTheme.accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                  ],
                ),
              )
                  .animate()
                  .fade(duration: 1600.ms)
                  .slideY(begin: 0.1, end: 0, duration: 1600.ms);
            },
          ),
        ),
      ),
    );
  }
}
