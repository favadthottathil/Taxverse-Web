import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../providers/content_provider.dart';
import '../../../domain/entities/service_entity.dart';
import '../../widgets/scroll_visibility_detector.dart';

class ServicesSection extends StatefulWidget {
  final bool animate;

  const ServicesSection({super.key, this.animate = true});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();
    final services = contentProvider.services;

    if (contentProvider.isLoading) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
        color: const Color(0xFFF7F8FA),
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.desktopMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ScrollVisibilityDetector(
                    detectorKey: const Key('services-header-detector'),
                    builder: (context, isVisible, child) {
                      return Column(
                        children: [
                          // "WHAT WE DO" label
                          Text(
                            'WHAT WE DO',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              color: AppTheme.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          )
                              .riseFade(isVisible: isVisible),
                          const SizedBox(height: 16),
                          // "Our Core Services" heading
                          Text(
                            'Our Core Services',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              color: AppTheme.primaryColor,
                              fontSize: 42,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              .riseFade(isVisible: isVisible),
                          const SizedBox(height: 20),
                          // Subtitle
                          SizedBox(
                            width: 700,
                            child: Text(
                              'From startup registration to enterprise-level audits — we deliver end-to-end financial solutions tailored to your business stage.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                color: AppTheme.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                              ),
                            ),
                          )
                              .riseFade(isVisible: isVisible, delay: 200.ms),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 60),
                  // Service cards
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.isMobile) {
                        // Mobile: vertical list
                        return Column(
                          children: List.generate(services.length, (index) {
                            final delay = (200 + (index * 100)).ms;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ScrollVisibilityDetector(
                                detectorKey: Key('services-card-mobile-$index'),
                                builder: (context, isVisible, child) {
                                  return child.riseFade(
                                      isVisible: isVisible, delay: delay);
                                },
                                child: _buildServiceCard(
                                  context,
                                  services[index],
                                  index,
                                ),
                              ),
                            );
                          }),
                        );
                      }

                      if (sizingInformation.isTablet) {
                        // Tablet: 3-column grid
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final delay = (200 + (index * 100)).ms;
                            return ScrollVisibilityDetector(
                              detectorKey: Key('services-card-tablet-$index'),
                              builder: (context, isVisible, child) {
                                return child.riseFade(
                                    isVisible: isVisible, delay: delay);
                              },
                              child: _buildServiceCard(
                                context,
                                services[index],
                                index,
                              ),
                            );
                          },
                        );
                      }

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(services.length, (index) {
                            final delay = (200 + (index * 100)).ms;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 8,
                                  right: index == services.length - 1 ? 0 : 8,
                                ),
                                child: ScrollVisibilityDetector(
                                  detectorKey: Key('services-card-desktop-$index'),
                                  builder: (context, isVisible, child) {
                                    return child.riseFade(
                                        isVisible: isVisible, delay: delay);
                                  },
                                  child: _buildServiceCard(
                                    context,
                                    services[index],
                                    index,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildServiceCard(
    BuildContext context,
    ServiceEntity service,
    int index,
  ) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -4.0 : 0.0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    spreadRadius: -2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
            width: isHovered ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color:
                    isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(
                  service.icon,
                  color: isHovered ? Colors.white : AppTheme.primaryColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              service.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: AppTheme.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Expanded(
              child: Text(
                service.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
