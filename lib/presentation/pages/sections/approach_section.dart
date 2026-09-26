import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../widgets/scroll_visibility_detector.dart';
import '../../widgets/switching_asset_image.dart';
import '../../../core/theme.dart';

class ApproachSection extends StatefulWidget {
  final bool animate;

  const ApproachSection({super.key, this.animate = true});

  @override
  State<ApproachSection> createState() => _ApproachSectionState();
}

class _Step {
  final IconData icon;
  final String title;
  final String desc;
  final String imageAsset;
  final String imageAlt;

  const _Step(this.icon, this.title, this.desc, this.imageAsset, this.imageAlt);
}

const _steps = <_Step>[
  _Step(
    Icons.track_changes_outlined,
    'Understand Your Goals',
    'We begin with a deep-dive consultation to understand your business, challenges, and growth ambitions.',
    'assets/images/approach-1.jpg',
    'A colleague presenting ideas on sticky notes to a team seated around a table with laptops',
  ),
  _Step(
    Icons.verified_outlined,
    'Build Compliance & Confidence',
    'Our experts structure your finances for full regulatory compliance while minimising tax liabilities.',
    'assets/images/approach-2.jpg',
    'Tax forms, a phone calculator and a pen laid out on a table',
  ),
  _Step(
    Icons.trending_up_outlined,
    'Drive Sustainable Growth',
    'With clear reporting and strategic advisory, we help you scale with clarity and confidence.',
    'assets/images/approach-3.jpg',
    'Candlestick chart with moving average lines on a dark screen, showing a market trend',
  ),
];

class _ApproachSectionState extends State<ApproachSection> {
  /// Index of the step whose image is shown. A notifier so hover/tap only
  /// rebuilds the image and the step icons, not the whole section.
  final ValueNotifier<int> _selected = ValueNotifier<int>(0);

  bool _precached = false;

  /// Warms the image cache the first time the image is revealed, so the other
  /// images swap in without a placeholder flash but aren't all fetched and
  /// decoded at page load while the user is still at the hero.
  void _precacheOnReveal(bool isVisible) {
    if (!isVisible || _precached) return;
    _precached = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SwitchingAssetImage.precacheAll(context, [
        for (final step in _steps) step.imageAsset,
      ]);
    });
  }

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9FB),
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.desktopMaxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left – text content
                      Expanded(
                        child: _buildContent(context, sizingInformation),
                      ),
                      const SizedBox(width: 64),
                      // Right – image
                      Expanded(
                        child: ScrollVisibilityDetector(
                          detectorKey: const Key(
                            'approach-image-desktop-detector',
                          ),
                          builder: (context, isVisible, child) {
                            _precacheOnReveal(isVisible);
                            return child.riseFade(
                              isVisible: isVisible,
                              delay: 200.ms,
                            );
                          },
                          child: _buildImage(context, sizingInformation),
                        ),
                      ),
                    ],
                  );
                }

                // Mobile / Tablet – stacked
                return Column(
                  children: [
                    _buildContent(context, sizingInformation),
                    const SizedBox(height: 48),
                    ScrollVisibilityDetector(
                      detectorKey: const Key('approach-image-mobile-detector'),
                      builder: (context, isVisible, child) {
                        _precacheOnReveal(isVisible);
                        return child.riseFade(
                          isVisible: isVisible,
                          delay: 200.ms,
                        );
                      },
                      child: _buildImage(context, sizingInformation),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollVisibilityDetector(
          detectorKey: const Key('approach-header-detector'),
          builder: (context, isVisible, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section label
                Text(
                  'OUR APPROACH',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).riseFade(isVisible: isVisible),
                const SizedBox(height: 12),
                // Heading
                Text(
                  'How We Work With You',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    fontSize: sizingInformation.isDesktop ? 36 : 28,
                  ),
                ).riseFade(isVisible: isVisible, delay: 200.ms),
                const SizedBox(height: 16),
                // Description
                Text(
                  'Every engagement follows a structured methodology designed to deliver measurable outcomes and lasting partnerships.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.6,
                    color: AppTheme.textSecondary,
                  ),
                ).riseFade(isVisible: isVisible, delay: 400.ms),
              ],
            );
          },
        ),
        const SizedBox(height: 36),
        // Steps
        ...List.generate(_steps.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _steps.length - 1 ? 28 : 0,
            ),
            child: _buildStep(context, _steps[index], index),
          );
        }),
      ],
    );
  }

  Widget _buildStep(BuildContext context, _Step step, int index) {
    return ScrollVisibilityDetector(
      detectorKey: Key('approach-step-$index'),
      builder: (context, isVisible, child) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _selected.value = index,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _selected.value = index,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _selected,
                  builder: (context, selected, _) {
                    final primary = Theme.of(context).primaryColor;
                    final active = selected == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: active
                            ? primary
                            : primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primary.withValues(alpha: active ? 1 : 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        step.icon,
                        size: 22,
                        color: active ? Colors.white : primary,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.desc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).riseFade(isVisible: isVisible);
      },
    );
  }

  Widget _buildImage(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return Container(
      height: sizingInformation.isDesktop
          ? 500
          : sizingInformation.isTablet
          ? 380
          : 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder<int>(
          valueListenable: _selected,
          builder: (context, index, _) {
            final step = _steps[index];
            return SwitchingAssetImage(
              asset: step.imageAsset,
              semanticLabel: step.imageAlt,
              fallbackIcon: step.icon,
            );
          },
        ),
      ),
    );
  }
}
