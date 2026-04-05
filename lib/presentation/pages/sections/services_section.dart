import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../providers/content_provider.dart';
import '../../../domain/entities/service_entity.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  bool _isVisible = false;
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
    return VisibilityDetector(
      key: const Key('services-section'),
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
                  // "WHAT WE DO" label
                  Text(
                    'WHAT WE DO',
                    style: GoogleFonts.inter(
                      color: AppTheme.accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  )
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                  const SizedBox(height: 16),
                  // "Our Core Services" heading
                  Text(
                    'Our Core Services',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: AppTheme.primaryColor,
                      fontSize: 42,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                  const SizedBox(height: 20),
                  // Subtitle
                  SizedBox(
                    width: 700,
                    child: Text(
                      'From startup registration to enterprise-level audits — we deliver end-to-end financial solutions tailored to your business stage.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                  )
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(delay: 100.ms, duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                  const SizedBox(height: 60),
                  // Service cards
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.isMobile) {
                        // Mobile: vertical list
                        return Column(
                          children: List.generate(services.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildServiceCard(
                                context,
                                services[index],
                                index,
                              )
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fade(
                                    delay: (200 + (index * 100)).ms,
                                    duration: 600.ms,
                                  )
                                  .slideY(
                                    begin: 0.2,
                                    end: 0,
                                    curve: Curves.easeOutCubic,
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
                            return _buildServiceCard(
                              context,
                              services[index],
                              index,
                            )
                                .animate(target: _isVisible ? 1 : 0)
                                .fade(
                                  delay: (200 + (index * 100)).ms,
                                  duration: 600.ms,
                                )
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  curve: Curves.easeOutCubic,
                                );
                          },
                        );
                      }

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(services.length, (index) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 8,
                                  right: index == services.length - 1 ? 0 : 8,
                                ),
                                child: _buildServiceCard(
                                  context,
                                  services[index],
                                  index,
                                )
                                    .animate(target: _isVisible ? 1 : 0)
                                    .fade(
                                      delay: (200 + (index * 100)).ms,
                                      duration: 600.ms,
                                    )
                                    .slideY(
                                      begin: 0.2,
                                      end: 0,
                                      curve: Curves.easeOutCubic,
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
            color: isHovered
                ? AppTheme.accentColor.withValues(alpha: 0.3)
                : const Color(0xFFE8ECF0),
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
                color: isHovered
                    ? AppTheme.accentColor.withValues(alpha: 0.12)
                    : const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  service.icon,
                  color: isHovered
                      ? AppTheme.accentColor
                      : AppTheme.primaryColor.withValues(alpha: 0.7),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              service.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
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
                style: GoogleFonts.inter(
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
