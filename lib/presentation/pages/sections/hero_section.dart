import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onServicesClick;

  const HeroSection({super.key, this.onServicesClick});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('hero-section'),
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
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          image: DecorationImage(
            image: AssetImage(
              'assets/images/hero-bg.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0xEE012440),
              BlendMode.darken,
            ),
          ),
        ),
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            double horizontalPadding = sizingInformation.isDesktop ? 0 : 24;
            double verticalPadding = sizingInformation.isDesktop ? 80 : 40;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: sizingInformation.isDesktop
                      ? MediaQuery.of(context).size.width * 0.6
                      : AppConstants.desktopMaxWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: sizingInformation.isDesktop
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                            'ESTABLISHED 2004',
                            style: GoogleFonts.inter(
                              color: AppTheme.accentColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          )
                          .animate(target: _isVisible ? 1 : 0)
                          .fade(duration: 800.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 800.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 12),
                      Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Expert Finance Solutions\nfor ',
                                ),
                                TextSpan(
                                  text: 'Businesses',
                                  style: GoogleFonts.inter(
                                    color: AppTheme.accentColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: sizingInformation.isDesktop
                                ? TextAlign.left
                                : TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: sizingInformation.isDesktop ? 50 : 34,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                          .animate(target: _isVisible ? 1 : 0)
                          .fade(delay: 100.ms, duration: 800.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 800.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: sizingInformation.isDesktop
                            ? 700
                            : double.infinity,
                        child:
                            Text(
                                  'Professional accounting, tax advisory, and CFO services combining regulatory expertise with intelligent automation.',
                                  textAlign: sizingInformation.isDesktop
                                      ? TextAlign.left
                                      : TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    height: 1.6,
                                  ),
                                )
                                .animate(target: _isVisible ? 1 : 0)
                                .fade(delay: 200.ms, duration: 800.ms)
                                .slideY(
                                  begin: 0.3,
                                  end: 0,
                                  duration: 800.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                            mainAxisAlignment: sizingInformation.isDesktop
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: widget.onServicesClick,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  foregroundColor: AppTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 20,
                                  ),
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text('Explore Services'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () async {
                                  final Uri emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: AppConstants.contactEmail,
                                  );
                                  launchUrl(emailLaunchUri);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white54,
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 20,
                                  ),
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text('Book a Consultation'),
                              ),
                            ],
                          )
                          .animate(target: _isVisible ? 1 : 0)
                          .fade(delay: 400.ms, duration: 800.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 800.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 32),
                      _buildStatsRow(sizingInformation.isMobile)
                          .animate(target: _isVisible ? 1 : 0)
                          .fade(delay: 600.ms, duration: 800.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 800.ms,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildStatItem(20, '+', 'Years of Excellence', false),
          const SizedBox(height: 24),
          _buildStatItem(2000, '+', 'Clients Served', true),
          const SizedBox(height: 24),
          _buildStatItem(500, '+', 'Registrations', false),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildStatItem(20, '+', 'Years of Excellence', false),
        const SizedBox(width: 64),
        _buildStatItem(2000, '+', 'Clients Served', true),
        const SizedBox(width: 64),
        _buildStatItem(500, '+', 'Registrations', false),
      ],
    );
  }

  Widget _buildStatItem(int targetValue, String suffix, String label, bool useComma) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CountUpText(
          targetValue: targetValue,
          suffix: suffix,
          useComma: useComma,
          animate: _isVisible,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

/// Animated count-up text widget that increments from 0 to [targetValue].
class _CountUpText extends StatefulWidget {
  final int targetValue;
  final String suffix;
  final bool useComma;
  final bool animate;

  const _CountUpText({
    required this.targetValue,
    required this.suffix,
    required this.useComma,
    required this.animate,
  });

  @override
  State<_CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<_CountUpText>
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
  void didUpdateWidget(covariant _CountUpText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_hasAnimated) {
      _hasAnimated = true;
      // Small delay so the fade/slide animation starts first
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _controller.forward();
      });
    } else if (!widget.animate) {
      _hasAnimated = false;
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    if (!widget.useComma) return '$value';
    // Add comma formatting (e.g. 2000 → 2,000)
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue =
            (_animation.value * widget.targetValue).round();
        return Text(
          '${_formatNumber(currentValue)}${widget.suffix}',
          style: const TextStyle(
            color: AppTheme.accentColor,
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
