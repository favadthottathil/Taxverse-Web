import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../providers/content_provider.dart';
import '../../widgets/scroll_visibility_detector.dart';

class AboutSection extends StatefulWidget {
  final bool animate;

  const AboutSection({super.key, this.animate = true});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
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

  Widget _buildMap(
      BuildContext context, SizingInformation sizingInformation) {
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
        child: Image.asset(
          'assets/images/business-meeting.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, SizingInformation sizingInformation) {
    final features = [
      {
        'icon': Icons.workspace_premium_outlined,
        'title': '6+ Years of Expertise',
        'desc':
            'Over 6 years of delivering trusted financial services across diverse industries.',
      },
      {
        'icon': Icons.groups_outlined,
        'title': 'Multi-Professional Team',
        'desc':
            'CAs, lawyers, and business consultants working together for holistic solutions.',
      },
      {
        'icon': Icons.public_outlined,
        'title': 'Pan-India & ME Network',
        'desc':
            'Offices and partners across India and the Middle East for seamless service.',
      },
      {
        'icon': Icons.devices_outlined,
        'title': 'Cutting-Edge Technology',
        'desc':
            'Modern tools and cloud platforms for efficient, real-time financial management.',
      },
      {
        'icon': Icons.all_inclusive_outlined,
        'title': 'End-to-End Solutions',
        'desc':
            'From incorporation to IPO — we cover every stage of your business lifecycle.',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'Dedicated Client Support',
        'desc':
            'A named point of contact for every client, ensuring personalized attention.',
      },
    ];

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
                )
                    .riseFade(isVisible: isVisible),
                const SizedBox(height: 12),
                // Main heading
                Text(
                  'Why Choose Taxverse',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF1A1A2E),
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        fontSize: sizingInformation.isDesktop ? 36 : 28,
                      ),
                )
                    .riseFade(isVisible: isVisible, delay: 200.ms),
                const SizedBox(height: 16),
                // Description
                Text(
                  'We combine deep regulatory knowledge with modern technology to deliver financial clarity and peace of mind.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        height: 1.6,
                        color: Colors.grey[600],
                      ),
                )
                    .riseFade(isVisible: isVisible, delay: 400.ms),
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
                  bottom: index < features.length - 1 ? 24 : 0),
              child: _buildFeatureCard(
                context,
                features[index]['icon'] as IconData,
                features[index]['title'] as String,
                features[index]['desc'] as String,
                index,
              ),
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
                      features[firstIndex]['icon'] as IconData,
                      features[firstIndex]['title'] as String,
                      features[firstIndex]['desc'] as String,
                      firstIndex,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildFeatureCard(
                      context,
                      features[secondIndex]['icon'] as IconData,
                      features[secondIndex]['title'] as String,
                      features[secondIndex]['desc'] as String,
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

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    int index,
  ) {
    final delay = (index % 2 * 150).ms;
    return ScrollVisibilityDetector(
      detectorKey: Key('about-feature-card-$index'),
      // Once revealed, stay revealed — a short list like this one shouldn't
      // ever reset back to invisible from a transient near-zero visibility
      // reading (e.g. a fast scroll or a layout hiccup during a parent's own
      // entrance transition), which would otherwise leave it stuck blank.
      animateOnce: true,
      builder: (context, isVisible, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ).riseFade(isVisible: isVisible, delay: delay);
      },
    );
  }
}
