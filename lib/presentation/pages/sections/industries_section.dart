import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../widgets/scroll_visibility_detector.dart';

class IndustriesSection extends StatefulWidget {
  final bool animate;

  const IndustriesSection({super.key, this.animate = true});

  @override
  State<IndustriesSection> createState() => _IndustriesSectionState();
}

class _IndustriesSectionState extends State<IndustriesSection> {

  static const List<Map<String, dynamic>> _industries = [
    {
      'icon': Icons.precision_manufacturing_outlined,
      'label': 'Manufacturing',
      'color': Color(0xFF3B82F6), // blue
      'bgColor': Color(0xFFEFF6FF),
    },
    {
      'icon': Icons.apartment_outlined,
      'label': 'Real Estate',
      'color': Color(0xFFF97316), // orange
      'bgColor': Color(0xFFFFF7ED),
    },
    {
      'icon': Icons.inventory_2_outlined,
      'label': 'FMCG',
      'color': Color(0xFF0D9488), // teal
      'bgColor': Color(0xFFF0FDFA),
    },
    {
      'icon': Icons.computer_outlined,
      'label': 'IT & Software',
      'color': Color(0xFF8B5CF6), // purple
      'bgColor': Color(0xFFF5F3FF),
    },
    {
      'icon': Icons.favorite_outline,
      'label': 'Healthcare',
      'color': Color(0xFFEF4444), // red/pink
      'bgColor': Color(0xFFFEF2F2),
    },
    {
      'icon': Icons.rocket_launch_outlined,
      'label': 'Startups',
      'color': Color(0xFFF97316), // orange
      'bgColor': Color(0xFFFFF7ED),
    },
    {
      'icon': Icons.volunteer_activism_outlined,
      'label': 'NGOs',
      'color': Color(0xFF10B981), // green
      'bgColor': Color(0xFFECFDF5),
    },
    {
      'icon': Icons.account_balance_outlined,
      'label': 'Government',
      'color': Color(0xFF475569), // slate/dark
      'bgColor': Color(0xFFF1F5F9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFF7F8FA),
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
                  return Column(
                    children: [
                      ScrollVisibilityDetector(
                        detectorKey: const Key('industries-header-detector'),
                        builder: (context, isVisible, child) {
                          return Column(
                            children: [
                              // Section label
                              Text(
                                'INDUSTRIES',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2.0,
                                    ),
                              ).riseFade(isVisible: isVisible),
                              const SizedBox(height: 12),
                              // Heading
                              Text(
                                'Industries We Serve',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: const Color(0xFF1A1A2E),
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      fontSize:
                                          sizingInformation.isDesktop ? 36 : 28,
                                    ),
                              )
                                  .riseFade(isVisible: isVisible, delay: 200.ms),
                              const SizedBox(height: 16),
                              // Description
                              Text(
                                'Trusted by businesses across sectors — from early-stage startups to\nestablished enterprises.',
                                textAlign: TextAlign.center,
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
                      const SizedBox(height: 56),
                      // Industry icons grid — column count is fixed per
                      // breakpoint (2 mobile / 4 tablet / 8 desktop) and each
                      // item's width is derived from the actual available
                      // width, so it always lands on exactly that many
                      // columns instead of however many happen to fit.
                      LayoutBuilder(builder: (context, constraints) {
                        final columns = sizingInformation.isDesktop
                            ? 8
                            : sizingInformation.isTablet
                                ? 4
                                : 2;
                        const spacing = 16.0;
                        final itemWidth =
                            (constraints.maxWidth - spacing * (columns - 1)) /
                                columns;
                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: spacing,
                          runSpacing: 32,
                          children: _industries.asMap().entries.map((entry) {
                            return SizedBox(
                              width: itemWidth,
                              child: _buildIndustryItem(
                                context,
                                entry.value,
                                entry.key,
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildIndustryItem(
    BuildContext context,
    Map<String, dynamic> industry,
    int index,
  ) {
    final icon = industry['icon'] as IconData;
    final label = industry['label'] as String;
    final color = industry['color'] as Color;
    final bgColor = industry['bgColor'] as Color;
    final delay = (index * 80).ms;

    return ScrollVisibilityDetector(
      detectorKey: Key('industry-item-$index'),
      builder: (context, isVisible, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
            ),
          ],
        ).riseFade(isVisible: isVisible, delay: delay);
      },
    );
  }
}
