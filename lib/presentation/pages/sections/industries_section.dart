import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';

class IndustriesSection extends StatefulWidget {
  const IndustriesSection({super.key});

  @override
  State<IndustriesSection> createState() => _IndustriesSectionState();
}

class _IndustriesSectionState extends State<IndustriesSection> {
  bool _isVisible = false;

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
    return VisibilityDetector(
      key: const Key('industries-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
        } else if (info.visibleFraction == 0 && _isVisible) {
          setState(() => _isVisible = false);
        }
      },
      child: Container(
        color: const Color(0xFFF7F8FA),
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.desktopMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Section label
                  Text(
                    'INDUSTRIES',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  )
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(duration: 500.ms),
                  const SizedBox(height: 12),
                  // Heading
                  Text(
                    'Industries We Serve',
                    style:
                        Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: const Color(0xFF1A1A2E),
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                  )
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(delay: 100.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
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
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 56),
                  // Industry icons grid
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.isDesktop) {
                        // Desktop: single row of 8
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _industries.asMap().entries.map((entry) {
                            return _buildIndustryItem(
                              context,
                              entry.value,
                              entry.key,
                            );
                          }).toList(),
                        );
                      }
                      // Mobile/Tablet: 2 rows of 4
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _industries
                                .sublist(0, 4)
                                .asMap()
                                .entries
                                .map((entry) {
                              return _buildIndustryItem(
                                context,
                                entry.value,
                                entry.key,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _industries
                                .sublist(4)
                                .asMap()
                                .entries
                                .map((entry) {
                              return _buildIndustryItem(
                                context,
                                entry.value,
                                entry.key + 4,
                              );
                            }).toList(),
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
    )
        .animate(target: _isVisible ? 1 : 0)
        .fade(delay: (300 + index * 80).ms, duration: 500.ms)
        .slideY(
          begin: 0.15,
          end: 0,
          delay: (300 + index * 80).ms,
          curve: Curves.easeOutCubic,
        );
  }
}
