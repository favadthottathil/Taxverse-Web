import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../providers/content_provider.dart';
import '../../../domain/entities/testimonial_entity.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  bool _isVisible = false;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _startAutoScroll(int totalPages) {
    _totalPages = totalPages;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _totalPages;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.decelerate,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    // Reset timer so it doesn't immediately advance
    _startAutoScroll(_totalPages);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();
    final testimonials = contentProvider.testimonials;

    if (contentProvider.isLoading) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return VisibilityDetector(
      key: const Key('testimonials-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
          _startAutoScroll(_getPageCount(context, testimonials));
        } else if (info.visibleFraction == 0 && _isVisible) {
          setState(() => _isVisible = false);
          _stopAutoScroll();
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface,
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
                    'TESTIMONIALS',
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
                    'What Our Clients Say',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                  const SizedBox(height: 56),
                  // Carousel with arrows
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      final cardsPerPage =
                          sizingInformation.isDesktop ? 2 : 1;
                      final totalPages =
                          (testimonials.length / cardsPerPage).ceil();

                      return Column(
                        children: [
                          _buildCarousel(
                            context,
                            testimonials,
                            cardsPerPage,
                            totalPages,
                          ),
                          const SizedBox(height: 36),
                          // Dot indicators
                          _buildDotIndicators(context, totalPages),
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

  int _getPageCount(BuildContext context, List<TestimonialEntity> testimonials) {
    final width = MediaQuery.of(context).size.width;
    final cardsPerPage = width >= 900 ? 2 : 1;
    return (testimonials.length / cardsPerPage).ceil();
  }

  Widget _buildPageContent(
    BuildContext context,
    List<TestimonialEntity> testimonials,
    int cardsPerPage,
    int pageIndex,
  ) {
    final startIndex = pageIndex * cardsPerPage;
    final endIndex =
        (startIndex + cardsPerPage).clamp(0, testimonials.length);
    final pageItems = testimonials.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: pageItems.asMap().entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: entry.key < pageItems.length - 1 ? 24 : 0,
              ),
              child: _buildTestimonialCard(context, entry.value),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCarousel(
    BuildContext context,
    List<TestimonialEntity> testimonials,
    int cardsPerPage,
    int totalPages,
  ) {
    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Slide transition carousel
          MouseRegion(
            onEnter: (_) => _stopAutoScroll(),
            onExit: (_) => _startAutoScroll(totalPages),
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, pageIndex) {
                return _buildPageContent(
                  context,
                  testimonials,
                  cardsPerPage,
                  pageIndex,
                );
              },
            ),
          ),
          // Left arrow
          Positioned(
            left: -20,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildArrowButton(
                icon: Icons.chevron_left,
                onTap: () {
                  if (_currentPage > 0) _goToPage(_currentPage - 1);
                },
                enabled: _currentPage > 0,
              ),
            ),
          ),
          // Right arrow
          Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildArrowButton(
                icon: Icons.chevron_right,
                onTap: () {
                  if (_currentPage < totalPages - 1) {
                    _goToPage(_currentPage + 1);
                  }
                },
                enabled: _currentPage < totalPages - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 22,
              color: enabled
                  ? const Color(0xFF1A1A2E)
                  : const Color(0xFFBBBBBB),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicators(BuildContext context, int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == _currentPage;
        return GestureDetector(
          onTap: () => _goToPage(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 28 : 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isActive
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFD1D5DB),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTestimonialCard(
    BuildContext context,
    TestimonialEntity testimonial,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quote icon
          Text(
            '\u201C\u201D',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AppTheme.highlightColor.withValues(alpha: 0.7),
              height: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          // Testimonial text
          Expanded(
            child: Text(
              '\u201C${testimonial.text}\u201D',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.7,
                color: const Color(0xFF4B5563),
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          // Author info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                testimonial.author,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                testimonial.designation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
