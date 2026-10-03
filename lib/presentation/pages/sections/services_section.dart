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

class ServicesSection extends StatelessWidget {
  final bool animate;

  const ServicesSection({super.key, this.animate = true});

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
                ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    final isDesktop = sizingInformation.isDesktop;
                    return ScrollVisibilityDetector(
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
                            ).riseFade(isVisible: isVisible),
                            const SizedBox(height: 16),
                            // "Our Core Services" heading
                            Semantics(
                              header: true,
                              headingLevel: 2,
                              child: Text(
                                'Our Core Services',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  color: AppTheme.primaryColor,
                                  fontSize: isDesktop ? 42 : 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ).riseFade(isVisible: isVisible),
                            const SizedBox(height: 20),
                            // Subtitle
                            SizedBox(
                              width: isDesktop ? 700 : double.infinity,
                              child: Text(
                                'From tax compliance and accounting to financial advisory, we provide reliable solutions to keep your business compliant, organized, and ready for growth.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  color: AppTheme.textSecondary,
                                  fontSize: isDesktop ? 16 : 15,
                                  fontWeight: FontWeight.w400,
                                  height: 1.6,
                                ),
                              ),
                            ).riseFade(isVisible: isVisible, delay: 200.ms),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 60),
                // Service cards
                ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    if (sizingInformation.isMobile) {
                      // Mobile: 2-column grid of compact tiles. Rows size to
                      // their content (a fixed aspect ratio clipped/overflowed
                      // the title and description on narrow phones).
                      final rowCount = (services.length + 1) ~/ 2;
                      return Column(
                        children: List.generate(rowCount, (row) {
                          return Padding(
                            padding: EdgeInsets.only(top: row == 0 ? 0 : 16),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (var col = 0; col < 2; col++) ...[
                                    if (col == 1) const SizedBox(width: 16),
                                    Expanded(
                                      child: row * 2 + col < services.length
                                          ? _buildMobileCard(
                                              services[row * 2 + col],
                                              row * 2 + col,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ],
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
                                isVisible: isVisible,
                                delay: delay,
                              );
                            },
                            child: _ServiceCard(service: services[index]),
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
                                detectorKey: Key(
                                  'services-card-desktop-$index',
                                ),
                                builder: (context, isVisible, child) {
                                  return child.riseFade(
                                    isVisible: isVisible,
                                    delay: delay,
                                  );
                                },
                                child: _ServiceCard(service: services[index]),
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

  Widget _buildMobileCard(ServiceEntity service, int index) {
    final delay = (200 + (index * 100)).ms;
    return ScrollVisibilityDetector(
      detectorKey: Key('services-card-mobile-$index'),
      builder: (context, isVisible, child) {
        return child.riseFade(isVisible: isVisible, delay: delay);
      },
      child: _ServiceCard(service: service, compact: true),
    );
  }
}

/// Owns its own hover state so a hover repaints just this card instead of
/// rebuilding the whole section (grid, detectors and all sibling cards).
class _ServiceCard extends StatefulWidget {
  final ServiceEntity service;
  final bool compact;

  const _ServiceCard({required this.service, this.compact = false});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  static const _restingShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];
  static const _hoveredShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      spreadRadius: -2,
      offset: Offset(0, 8),
    ),
  ];

  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered != value) setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final compact = widget.compact;
    final isHovered = _isHovered;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -4.0 : 0.0, 0),
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 20)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered ? _hoveredShadow : _restingShadow,
          border: Border.all(
            color: isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
            width: isHovered ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: compact ? 44 : 52,
              height: compact ? 44 : 52,
              decoration: BoxDecoration(
                color: isHovered
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(
                  service.icon,
                  color: isHovered ? Colors.white : AppTheme.primaryColor,
                  size: compact ? 18 : 22,
                ),
              ),
            ),
            SizedBox(height: compact ? 12 : 20),
            Text(
              service.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: AppTheme.primaryColor,
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            SizedBox(height: compact ? 6 : 10),
            Text(
              service.description,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: AppTheme.textSecondary,
                fontSize: compact ? 11.5 : 13,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
