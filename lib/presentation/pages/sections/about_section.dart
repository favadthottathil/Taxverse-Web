import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';
import '../../providers/content_provider.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();
    if (contentProvider.isLoading) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return VisibilityDetector(
      key: const Key('about-section'),
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
                          child: _buildImage(context)
                              .animate(target: _isVisible ? 1 : 0)
                              .fade(duration: 600.ms)
                              .slideX(
                                begin: -0.1,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                        ),
                        const SizedBox(width: 64),
                        Expanded(
                          child: _buildContent(context)
                              .animate(target: _isVisible ? 1 : 0)
                              .fade(delay: 200.ms, duration: 600.ms)
                              .slideX(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildImage(context)
                          .animate(target: _isVisible ? 1 : 0)
                          .fade(duration: 600.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 48),
                      _buildContent(context)
                          .animate(target: _isVisible ? 1 : 0)
                          .fade(delay: 200.ms, duration: 600.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/finance-workspace.jpg',
          ), // Local target workspace image
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

  Widget _buildContent(BuildContext context) {
    final features = [
      {
        'icon': Icons.workspace_premium_outlined,
        'title': '20+ Years of Expertise',
        'desc':
            'Two decades of delivering trusted financial services across diverse industries.',
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
        // Section label
        Text(
          'WHY TAXVERSE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        // Main heading
        Text(
          'Why Choose Taxverse',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        // Description
        Text(
          'We combine deep regulatory knowledge with modern technology to deliver financial clarity and peace of mind.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            height: 1.6,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 36),
        // Feature grid — 3 rows x 2 columns
        ...List.generate(3, (rowIndex) {
          return Padding(
            padding: EdgeInsets.only(bottom: rowIndex < 2 ? 24 : 0),
            child: Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    features[rowIndex * 2]['icon'] as IconData,
                    features[rowIndex * 2]['title'] as String,
                    features[rowIndex * 2]['desc'] as String,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    features[rowIndex * 2 + 1]['icon'] as IconData,
                    features[rowIndex * 2 + 1]['title'] as String,
                    features[rowIndex * 2 + 1]['desc'] as String,
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
  ) {
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
    );
  }
}
