import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../widgets/header_nav.dart';
import 'sections/footer_section.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ScrollController _scrollController = ScrollController();

  void _handleNavigate(String section) {
    switch (section) {
      case 'HOME':
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 'ABOUT US':
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        break;
      case 'SERVICES':
        Navigator.pushReplacementNamed(context, '/services');
        break;
      case 'CAREERS':
        Navigator.pushReplacementNamed(context, '/careers');
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          HeaderNav(
            onNavigate: _handleNavigate,
            activeRoute: 'ABOUT US',
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const _AboutHeroBanner(),
                  const _BuildingTrustSection(),
                  const _MeetFounderSection(),
                  const _CoreValuesSection(),
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
class _AboutHeroBanner extends StatelessWidget {
  const _AboutHeroBanner();

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
                  'ABOUT US',
                  style: GoogleFonts.inter(
                    color: AppTheme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0, duration: 600.ms),
                const SizedBox(height: 12),
                Text(
                  'Our Story of Excellence',
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
                    'Two decades of trust, expertise, and unwavering commitment to our clients\' success.',
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

// ─── BUILDING TRUST SECTION ─────────────────────────────────────────────────────
class _BuildingTrustSection extends StatefulWidget {
  const _BuildingTrustSection();

  @override
  State<_BuildingTrustSection> createState() => _BuildingTrustSectionState();
}

class _BuildingTrustSectionState extends State<_BuildingTrustSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('building-trust-section'),
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
            constraints: const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _buildTextContent()),
                      const SizedBox(width: 64),
                      Expanded(flex: 4, child: _buildStatsGrid()),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextContent(),
                    const SizedBox(height: 40),
                    _buildStatsGrid(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SINCE 2004',
          style: GoogleFonts.inter(
            color: AppTheme.accentColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ).animate(target: _isVisible ? 1 : 0).fade(duration: 600.ms),
        const SizedBox(height: 12),
        Text(
          'Building Trust Through Expertise',
          style: GoogleFonts.inter(
            color: AppTheme.primaryColor,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ).animate(target: _isVisible ? 1 : 0).fade(delay: 100.ms, duration: 600.ms),
        const SizedBox(height: 24),
        Text(
          'Founded in 2004, Taxverse has grown from a single-office practice into a multi-professional firm with a network spanning India and the Middle East.',
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ).animate(target: _isVisible ? 1 : 0).fade(delay: 200.ms, duration: 600.ms),
        const SizedBox(height: 20),
        Text(
          'Our journey has been defined by an unwavering commitment to professional excellence, ethical practice, and client-centric service. Over two decades, we have served 2,000+ clients across diverse industries.',
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ).animate(target: _isVisible ? 1 : 0).fade(delay: 300.ms, duration: 600.ms),
        const SizedBox(height: 20),
        Text(
          'Today, Taxverse stands as a trusted name in chartered accountancy, offering comprehensive services in audit, taxation, accounting, registrations, and business consulting.',
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ).animate(target: _isVisible ? 1 : 0).fade(delay: 400.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AnimatedStatItem(
                  value: 20,
                  suffix: '+',
                  label: 'Years',
                  animate: _isVisible,
                  delay: 400,
                ),
              ),
              Expanded(
                child: _AnimatedStatItem(
                  value: 2000,
                  suffix: '+',
                  label: 'Clients',
                  animate: _isVisible,
                  useComma: true,
                  delay: 600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _AnimatedStatItem(
                  value: 500,
                  suffix: '+',
                  label: 'Registrations',
                  animate: _isVisible,
                  delay: 800,
                ),
              ),
              Expanded(
                child: _AnimatedStatItem(
                  value: 50,
                  suffix: '+',
                  label: 'Professionals',
                  animate: _isVisible,
                  delay: 1000,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(target: _isVisible ? 1 : 0).fade(delay: 300.ms, duration: 600.ms).slideX(begin: 0.1, end: 0, duration: 600.ms);
  }
}

// ─── ANIMATED STAT ITEM ─────────────────────────────────────────────────────────
class _AnimatedStatItem extends StatefulWidget {
  final int value;
  final String suffix;
  final String label;
  final bool animate;
  final bool useComma;
  final int delay;

  const _AnimatedStatItem({
    required this.value,
    required this.suffix,
    required this.label,
    required this.animate,
    this.useComma = false,
    this.delay = 0,
  });

  @override
  State<_AnimatedStatItem> createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<_AnimatedStatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedStatItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    if (!widget.useComma) return '$value';
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = (_animation.value * widget.value).round();
        return Column(
          children: [
            Text(
              '${_formatNumber(currentValue)}${widget.suffix}',
              style: GoogleFonts.inter(
                color: AppTheme.accentColor,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── MEET OUR FOUNDER SECTION ──────────────────────────────────────────────────
class _MeetFounderSection extends StatefulWidget {
  const _MeetFounderSection();

  @override
  State<_MeetFounderSection> createState() => _MeetFounderSectionState();
}

class _MeetFounderSectionState extends State<_MeetFounderSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('meet-founder-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Text(
                  'LEADERSHIP',
                  style: GoogleFonts.inter(
                    color: AppTheme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(duration: 600.ms),
                const SizedBox(height: 12),
                Text(
                  'Meet Our Founder',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(delay: 100.ms, duration: 600.ms),
                const SizedBox(height: 40),
                Container(
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
                  child: ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.isDesktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAvatar(),
                            const SizedBox(width: 32),
                            Expanded(child: _buildFounderInfo()),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _buildAvatar(),
                          const SizedBox(height: 24),
                          _buildFounderInfo(),
                        ],
                      );
                    },
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1, end: 0, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.school_outlined,
        size: 48,
        color: AppTheme.textSecondary.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildFounderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riju Chandrasekhar',
          style: GoogleFonts.inter(
            color: AppTheme.primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Founder & Managing Partner',
          style: GoogleFonts.inter(
            color: AppTheme.accentColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'FCA, LLB, DISA, B.Com',
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'With over 25 years of distinguished experience in chartered accountancy and law, Riju Chandrasekhar founded Taxverse with a vision to deliver world-class financial services rooted in integrity and innovation. Under his leadership, the firm has grown into a multi-professional practice serving clients across India and the Middle East.',
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

// ─── CORE VALUES SECTION ────────────────────────────────────────────────────────
class _CoreValuesSection extends StatefulWidget {
  const _CoreValuesSection();

  @override
  State<_CoreValuesSection> createState() => _CoreValuesSectionState();
}

class _CoreValuesSectionState extends State<_CoreValuesSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('core-values-section'),
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
            constraints: const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
            child: Column(
              children: [
                Text(
                  'PHILOSOPHY',
                  style: GoogleFonts.inter(
                    color: AppTheme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(duration: 600.ms),
                const SizedBox(height: 12),
                Text(
                  'Our Core Values',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ).animate(target: _isVisible ? 1 : 0).fade(delay: 100.ms, duration: 600.ms),
                const SizedBox(height: 48),
                ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    if (sizingInformation.isDesktop) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildValueCard(
                              Icons.shield_outlined,
                              'Integrity',
                              'We uphold the highest standards of professional ethics in everything we do.',
                              0,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildValueCard(
                              Icons.emoji_events_outlined,
                              'Excellence',
                              'Delivering exceptional quality and value to every client, every time.',
                              1,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildValueCard(
                              Icons.lightbulb_outlined,
                              'Innovation',
                              'Embracing technology and modern practices to stay ahead of the curve.',
                              2,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildValueCard(
                          Icons.shield_outlined,
                          'Integrity',
                          'We uphold the highest standards of professional ethics in everything we do.',
                          0,
                        ),
                        const SizedBox(height: 16),
                        _buildValueCard(
                          Icons.emoji_events_outlined,
                          'Excellence',
                          'Delivering exceptional quality and value to every client, every time.',
                          1,
                        ),
                        const SizedBox(height: 16),
                        _buildValueCard(
                          Icons.lightbulb_outlined,
                          'Innovation',
                          'Embracing technology and modern practices to stay ahead of the curve.',
                          2,
                        ),
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

  Widget _buildValueCard(IconData icon, String title, String description, int index) {
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
          Icon(
            icon,
            size: 36,
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate(target: _isVisible ? 1 : 0)
        .fade(delay: Duration(milliseconds: 200 + (index * 150)), duration: 600.ms)
        .slideY(begin: 0.15, end: 0, delay: Duration(milliseconds: 200 + (index * 150)), duration: 600.ms);
  }
}
