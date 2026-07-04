import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/constants.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../widgets/header_nav.dart';
import '../widgets/scroll_visibility_detector.dart';
import 'sections/footer_section.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ScrollController _scrollController = ScrollController();

  void _handleNavigate(String section) {
    if (section.startsWith('SERVICES|')) {
      Navigator.pushNamed(context, '/services',
          arguments: section.split('|')[1]);
      return;
    }
    switch (section) {
      case 'HOME':
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 'ABOUT US':
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutQuart,
        );
        break;
      case 'SERVICES':
        Navigator.pushReplacementNamed(context, '/services');
        break;
      // case 'CAREERS':
      //   Navigator.pushReplacementNamed(context, '/careers');
      //   break;
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
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isDesktop = sizingInformation.isDesktop;
          return Align(
            alignment:
                isDesktop ? Alignment.centerLeft : Alignment.topCenter,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ScrollVisibilityDetector(
                  detectorKey: const Key('about-hero-detector'),
                  animateOnce: true,
                  builder: (context, isVisible, child) {
                    return Column(
                      crossAxisAlignment: isDesktop
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ABOUT US',
                          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            color: AppTheme.accentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                          ),
                        ).riseFade(isVisible: isVisible),
                        const SizedBox(height: 12),
                        Text(
                          'Our Story of Excellence',
                          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            color: Colors.white,
                            fontSize: isDesktop ? 42 : 30,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(1)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: isDesktop ? 600 : double.infinity,
                          child: Text(
                            'Over 6 years of trust, expertise, and unwavering commitment to our clients\' success.',
                            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: isDesktop ? 16 : 15,
                              height: 1.6,
                            ),
                          ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(2)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
          child: ScrollVisibilityDetector(
            detectorKey: const Key('building-trust-section'),
            builder: (context, isVisible, child) {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isMobile) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildTextContent(isVisible)),
                        const SizedBox(width: 64),
                        Expanded(
                            flex: 4,
                            child: _buildStatsGrid(isVisible, sizingInformation)),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextContent(isVisible),
                      const SizedBox(height: 40),
                      _buildStatsGrid(isVisible, sizingInformation),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(bool isVisible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SINCE 2004',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ).riseFade(isVisible: isVisible),
        const SizedBox(height: 12),
        Text(
          'Building Trust Through Expertise',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.primaryColor,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(1)),
        const SizedBox(height: 24),
        Text(
          'Founded in 2004, Taxverse has grown from a single-office practice into a multi-professional firm with a network spanning India and the Middle East.',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(2)),
        const SizedBox(height: 20),
        Text(
          'Our journey has been defined by an unwavering commitment to professional excellence, ethical practice, and client-centric service. Over the past 6+ years, we have served 2,000+ clients across diverse industries.',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(3)),
        const SizedBox(height: 20),
        Text(
          'Today, Taxverse stands as a trusted name in chartered accountancy, offering comprehensive services in audit, taxation, accounting, registrations, and business consulting.',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(4)),
      ],
    );
  }

  Widget _buildStatsGrid(
      bool isVisible, SizingInformation sizingInformation) {
    return Container(
      padding: EdgeInsets.all(sizingInformation.isMobile ? 20 : 32),
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
                  value: 6,
                  suffix: '+',
                  label: 'Years',
                  animate: isVisible,
                  delay: 400,
                  valueFontSize: sizingInformation.isMobile ? 28 : 36,
                ),
              ),
              Expanded(
                child: _AnimatedStatItem(
                  value: 2000,
                  suffix: '+',
                  label: 'Clients',
                  animate: isVisible,
                  useComma: true,
                  delay: 600,
                  valueFontSize: sizingInformation.isMobile ? 28 : 36,
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
                  animate: isVisible,
                  delay: 800,
                  valueFontSize: sizingInformation.isMobile ? 28 : 36,
                ),
              ),
              Expanded(
                child: _AnimatedStatItem(
                  value: 50,
                  suffix: '+',
                  label: 'Professionals',
                  animate: isVisible,
                  delay: 1000,
                  valueFontSize: sizingInformation.isMobile ? 28 : 36,
                ),
              ),
            ],
          ),
        ],
      ),
    ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(2));
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
  final double valueFontSize;

  const _AnimatedStatItem({
    required this.value,
    required this.suffix,
    required this.label,
    required this.animate,
    this.useComma = false,
    this.delay = 0,
    this.valueFontSize = 36,
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
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: AppTheme.primaryColor,
                fontSize: widget.valueFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Metropolis',
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F5F9),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ScrollVisibilityDetector(
            detectorKey: const Key('meet-founder-section'),
            builder: (context, isVisible, child) {
              return Column(
                children: [
                  Text(
                    'LEADERSHIP',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ).riseFade(isVisible: isVisible),
                  const SizedBox(height: 12),
                  Text(
                    'Meet Our Founder',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      color: AppTheme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(1)),
                  const SizedBox(height: 40),
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      return Container(
                        padding: EdgeInsets.all(
                            sizingInformation.isMobile ? 20 : 32),
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
                        child: !sizingInformation.isMobile
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildAvatar(),
                                  const SizedBox(width: 32),
                                  Expanded(child: _buildFounderInfo()),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildAvatar(),
                                  const SizedBox(height: 24),
                                  _buildFounderInfo(),
                                ],
                              ),
                      );
                    },
                  ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(2)),
                ],
              );
            },
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
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Founder & Managing Partner',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'FCA, LLB, DISA, B.Com',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'With over 25 years of distinguished experience in chartered accountancy and law, Riju Chandrasekhar founded Taxverse with a vision to deliver world-class financial services rooted in integrity and innovation. Under his leadership, the firm has grown into a multi-professional practice serving clients across India and the Middle East.',
          style: TextStyle(
            fontFamily: 'Metropolis',
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
          child: ScrollVisibilityDetector(
            detectorKey: const Key('core-values-header-detector'),
            builder: (context, isVisible, child) {
              return Column(
                children: [
                  Text(
                    'PHILOSOPHY',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ).riseFade(isVisible: isVisible),
                  const SizedBox(height: 12),
                  Text(
                    'Our Core Values',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      color: AppTheme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(1)),
                  const SizedBox(height: 48),
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (!sizingInformation.isMobile) {
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(
      IconData icon, String title, String description, int index) {
    return ScrollVisibilityDetector(
      detectorKey: Key('core-value-$index'),
      builder: (context, isVisible, child) {
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
                color: AppTheme.primaryColor,
              ),
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
        ).riseFade(isVisible: isVisible, delay: AppMotion.stagger(index));
      },
    );
  }
}
