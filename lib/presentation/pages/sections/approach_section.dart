import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../widgets/scroll_visibility_detector.dart';

class ApproachSection extends StatefulWidget {
  final bool animate;

  const ApproachSection({super.key, this.animate = true});

  @override
  State<ApproachSection> createState() => _ApproachSectionState();
}

class _ApproachSectionState extends State<ApproachSection> {

  static const _steps = [
    {
      'icon': Icons.track_changes_outlined,
      'title': 'Understand Your Goals',
      'desc':
          'We begin with a deep-dive consultation to understand your business, challenges, and growth ambitions.',
    },
    {
      'icon': Icons.verified_outlined,
      'title': 'Build Compliance & Confidence',
      'desc':
          'Our experts structure your finances for full regulatory compliance while minimising tax liabilities.',
    },
    {
      'icon': Icons.trending_up_outlined,
      'title': 'Drive Sustainable Growth',
      'desc':
          'With clear reporting and strategic advisory, we help you scale with clarity and confidence.',
    },
  ];

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
                            detectorKey: const Key('approach-image-desktop-detector'),
                            builder: (context, isVisible, child) {
                              return child.riseFade(
                                  isVisible: isVisible, delay: 200.ms);
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
                          return child.riseFade(
                              isVisible: isVisible, delay: 200.ms);
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
      BuildContext context, SizingInformation sizingInformation) {
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
                        color: Colors.grey[600],
                      ),
                ).riseFade(isVisible: isVisible, delay: 400.ms),
              ],
            );
          },
        ),
        const SizedBox(height: 36),
        // Steps
        ..._steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _steps.length - 1 ? 28 : 0,
            ),
            child: _buildStep(
              context,
              step['icon'] as IconData,
              step['title'] as String,
              step['desc'] as String,
              index,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    int index,
  ) {
    return ScrollVisibilityDetector(
      detectorKey: Key('approach-step-$index'),
      builder: (context, isVisible, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(icon, size: 22, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ).riseFade(isVisible: isVisible);
      },
    );
  }

  Widget _buildImage(
      BuildContext context, SizingInformation sizingInformation) {
    return Container(
      height: sizingInformation.isDesktop
          ? 500
          : sizingInformation.isTablet
              ? 380
              : 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/business-meeting.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}
