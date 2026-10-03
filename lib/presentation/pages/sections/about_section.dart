import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../providers/content_provider.dart';
import '../../widgets/scroll_visibility_detector.dart';
import '../../widgets/switching_asset_image.dart';
import '../../../core/theme.dart';

class AboutSection extends StatefulWidget {
  final bool animate;

  const AboutSection({super.key, this.animate = true});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _Feature {
  final IconData icon;
  final String title;
  final String desc;
  final String imageAsset;
  final String imageAlt;

  const _Feature(
    this.icon,
    this.title,
    this.desc,
    this.imageAsset,
    this.imageAlt,
  );
}

const _features = <_Feature>[
  _Feature(
    Icons.workspace_premium_outlined,
    '5+ Years of Expertise',
    'Established in 2021, delivering financial services across diverse industries.',
    'assets/images/about-1.webp',
    'Two colleagues reviewing handwritten notes and figures on paper beside open laptops',
  ),
  _Feature(
    Icons.groups_outlined,
    'Multi-Professional Team',
    'CAs, lawyers, and business consultants working together for holistic solutions.',
    'assets/images/about-2.webp',
    'A team of professionals working on laptops around a wooden table',
  ),
  _Feature(
    Icons.public_outlined,
    'Pan-India Network',
    'Offices and partners across India for seamless service.',
    'assets/images/about-3.webp',
    'Earth at night seen from space, with city lights glowing across a wide region',
  ),
  _Feature(
    Icons.devices_outlined,
    'Cutting-Edge Technology',
    'Modern tools and cloud platforms for efficient, real-time financial management.',
    'assets/images/about-4.webp',
    'Laptop screen showing an analytics dashboard with charts of load time, bounce rate and sessions',
  ),
  _Feature(
    Icons.all_inclusive_outlined,
    'End-to-End Solutions',
    'From incorporation to execution — we cover every stage of your business lifecycle.',
    'assets/images/about-5.webp',
    'A person signing a document with a pen at a desk',
  ),
  _Feature(
    Icons.support_agent_outlined,
    'Dedicated Client Support',
    'A named point of contact for every client, ensuring personalized attention.',
    'assets/images/about-6.webp',
    'Two people at a counter using a card reader and a payment terminal',
  ),
];

class _AboutSectionState extends State<AboutSection> {
  /// Index of the feature whose image is shown. A notifier so hover/tap only
  /// rebuilds the image and the card highlights, not the whole section.
  final ValueNotifier<int> _selected = ValueNotifier<int>(0);

  bool _precached = false;

  /// Warms the image cache the first time the section is revealed, so the
  /// other images swap in without a placeholder flash but aren't all fetched
  /// and decoded at page load while the user is still at the hero.
  void _precacheOnReveal(bool isVisible) {
    if (!isVisible || _precached) return;
    _precached = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SwitchingAssetImage.precacheAll(context, [
        for (final feature in _features) feature.imageAsset,
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
    final contentProvider = context.watch<ContentProvider>();
    if (contentProvider.isLoading) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
                      Expanded(
                        child: ScrollVisibilityDetector(
                          detectorKey: const Key('about-map-desktop-detector'),
                          builder: (context, isVisible, child) {
                            _precacheOnReveal(isVisible);
                            return child.riseFade(isVisible: isVisible);
                          },
                          child: _buildMap(context, sizingInformation),
                        ),
                      ),
                      const SizedBox(width: 64),
                      Expanded(
                        child: _buildContent(context, sizingInformation),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    ScrollVisibilityDetector(
                      detectorKey: const Key('about-map-mobile-detector'),
                      builder: (context, isVisible, child) {
                        _precacheOnReveal(isVisible);
                        return child.riseFade(isVisible: isVisible);
                      },
                      child: _buildMap(context, sizingInformation),
                    ),
                    const SizedBox(height: 48),
                    _buildContent(context, sizingInformation),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, SizingInformation sizingInformation) {
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
            final feature = _features[index];
            return SwitchingAssetImage(
              asset: feature.imageAsset,
              semanticLabel: feature.imageAlt,
              fallbackIcon: feature.icon,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    const features = _features;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollVisibilityDetector(
          detectorKey: const Key('about-header-detector'),
          builder: (context, isVisible, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section label
                Text(
                  'WHY TAXVERSE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ).riseFade(isVisible: isVisible),
                const SizedBox(height: 12),
                // Main heading
                Semantics(
                  header: true,
                  headingLevel: 2,
                  child: Text(
                    'Why Choose Taxverse',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      fontSize: sizingInformation.isDesktop ? 36 : 28,
                    ),
                  ),
                ).riseFade(isVisible: isVisible, delay: 200.ms),
                const SizedBox(height: 16),
                // Description
                Text(
                  'We combine deep regulatory knowledge with modern technology to deliver financial clarity and peace of mind.',
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
        // Feature grid — 2 columns on desktop/tablet, single column on
        // narrow phones where a 2-up split would squeeze icon + text.
        if (sizingInformation.isMobile)
          ...List.generate(features.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < features.length - 1 ? 24 : 0,
              ),
              child: _buildFeatureCard(context, features[index], index),
            );
          })
        else
          ...List.generate(3, (rowIndex) {
            final firstIndex = rowIndex * 2;
            final secondIndex = rowIndex * 2 + 1;
            return Padding(
              padding: EdgeInsets.only(bottom: rowIndex < 2 ? 24 : 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      context,
                      features[firstIndex],
                      firstIndex,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildFeatureCard(
                      context,
                      features[secondIndex],
                      secondIndex,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, _Feature feature, int index) {
    final delay = (index % 2 * 150).ms;
    return ScrollVisibilityDetector(
      detectorKey: Key('about-feature-card-$index'),
      // Once revealed, stay revealed — a short list like this one shouldn't
      // ever reset back to invisible from a transient near-zero visibility
      // reading (e.g. a fast scroll or a layout hiccup during a parent's own
      // entrance transition), which would otherwise leave it stuck blank.
      animateOnce: true,
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: active
                            ? primary
                            : primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature.icon,
                        size: 22,
                        color: active ? Colors.white : primary,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature.desc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
        ).riseFade(isVisible: isVisible, delay: delay);
      },
    );
  }
}
