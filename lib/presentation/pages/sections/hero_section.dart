import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../widgets/consultation_dialog.dart';
import '../../widgets/scroll_visibility_detector.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onServicesClick;
  final ScrollController? scrollController;
  final bool animate;

  const HeroSection({
    super.key,
    this.onServicesClick,
    this.scrollController,
    this.animate = true,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController != null && widget.scrollController!.hasClients) {
      final offset = widget.scrollController!.offset;
      if (offset >= 0 && offset < MediaQuery.of(context).size.height) {
        setState(() {
          _scrollOffset = offset;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        color: AppTheme.backgroundColor,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xEE034A3C),
                  BlendMode.darken,
                ),
                child: Align(
                  alignment: Alignment(
                      0, -1.0 + (_scrollOffset / 800).clamp(0.0, 2.0)),
                  child: Image.asset(
                    'assets/images/hero-bg.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    // Fades the photo in once decoded instead of a hard pop-in,
                    // so the hero doesn't visibly "snap" once the asset loads.
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: AppMotion.duration,
                        curve: AppMotion.curve,
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ),
            ResponsiveBuilder(
          builder: (context, sizingInformation) {
            double horizontalPadding = sizingInformation.isDesktop ? 0 : 24;
            double verticalPadding = sizingInformation.isDesktop ? 80 : 40;
            double topPadding = verticalPadding + 80; // Space for the floating navbar

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: sizingInformation.isDesktop
                      ? MediaQuery.of(context).size.width * 0.6
                      : AppConstants.desktopMaxWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: topPadding,
                    bottom: verticalPadding,
                  ),
                  child: ScrollVisibilityDetector(
                    detectorKey: const Key('hero-content-detector'),
                    builder: (context, isVisible, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESTABLISHED 2020',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              color: AppTheme.accentColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          ).riseFade(isVisible: isVisible),
                          const SizedBox(height: 12),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Expert Finance Solutions\nfor ',
                                ),
                                TextSpan(
                                  text: 'Businesses',
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    color: AppTheme.accentColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              color: Colors.white,
                              fontSize: sizingInformation.isDesktop
                                  ? 50
                                  : sizingInformation.isTablet
                                      ? 42
                                      : 34,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ).riseFade(isVisible: isVisible, delay: 200.ms),
                          const SizedBox(height: 16),
                          SizedBox(
                            width:
                                sizingInformation.isDesktop ? 700 : double.infinity,
                            child: Text(
                              'Professional accounting, tax advisory, and CFO services combining regulatory expertise with intelligent automation.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  height: 1.6,
                                ),
                              ).riseFade(isVisible: isVisible, delay: 400.ms),
                            ),
                            const SizedBox(height: 28),
                            Flex(
                              direction: sizingInformation.isMobile
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: sizingInformation.isMobile
                                  ? CrossAxisAlignment.stretch
                                  : CrossAxisAlignment.center,
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
                                    textStyle: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text('Explore Services'),
                                ),
                                const SizedBox(height: 16, width: 16),
                                OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ConsultationDialog(),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.accentColor,
                                    side: const BorderSide(
                                      color: AppTheme.accentColor,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 20,
                                    ),
                                    textStyle: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text('Book a Consultation'),
                                ),
                              ],
                            ).riseFade(isVisible: isVisible, delay: 600.ms),
                            const SizedBox(height: 32),
                            ScrollVisibilityDetector(
                              detectorKey: const Key('hero-stats-detector'),
                              builder: (context, statsVisible, child) {
                                return _buildStatsRow(
                                  sizingInformation.isMobile,
                                  statsVisible,
                                ).riseFade(isVisible: statsVisible, delay: 200.ms);
                              },
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
          ],
        ),
    );
  }

  Widget _buildStatsRow(bool isMobile, bool isVisible) {
    if (isMobile) {
      // Equal thirds so long labels ("Years of Excellence") wrap within
      // their own column instead of forcing the row wider than the screen.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildStatItem(6, '+', 'Years of Excellence', false,
                isVisible, const Duration(milliseconds: 400),
                fontSize: 26),
          ),
          Expanded(
            child: _buildStatItem(2000, '+', 'Clients Served', true,
                isVisible, const Duration(milliseconds: 600),
                fontSize: 26),
          ),
          Expanded(
            child: _buildStatItem(500, '+', 'Registrations', false,
                isVisible, const Duration(milliseconds: 800),
                fontSize: 26),
          ),
        ],
      );
    }
    return Wrap(
      spacing: 48,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        _buildStatItem(6, '+', 'Years of Excellence', false, isVisible, const Duration(milliseconds: 400)),
        _buildStatItem(2000, '+', 'Clients Served', true, isVisible, const Duration(milliseconds: 600)),
        _buildStatItem(500, '+', 'Registrations', false, isVisible, const Duration(milliseconds: 800)),
      ],
    );
  }

  Widget _buildStatItem(int targetValue, String suffix, String label,
      bool useComma, bool isVisible, Duration delay,
      {double fontSize = 40}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FittedBox guarantees the number never wraps mid-digit even if a
        // narrow column (e.g. a third of the screen on mobile) makes
        // [fontSize] a hair too big for a given device.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: _CountUpText(
            targetValue: targetValue,
            suffix: suffix,
            useComma: useComma,
            animate: isVisible,
            delay: delay,
            fontSize: fontSize,
          ),
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
  final Duration delay;
  final double fontSize;

  const _CountUpText({
    required this.targetValue,
    required this.suffix,
    required this.useComma,
    required this.animate,
    required this.delay,
    this.fontSize = 40,
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
      Future.delayed(widget.delay, () {
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
        final currentValue = (_animation.value * widget.targetValue).round();
        return Text(
          '${_formatNumber(currentValue)}${widget.suffix}',
          style: TextStyle(
            color: AppTheme.accentColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
