import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../providers/content_provider.dart';
import '../../../domain/entities/testimonial_entity.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TestimonialsSection extends StatefulWidget {
  final bool animate;

  const TestimonialsSection({super.key, this.animate = true});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  int _totalPages = 1;
  bool _isAnimating = false;
  bool _isVisible = false;

  // Use AnimationController for smooth, reliable cross-fade transitions
  // instead of PageView which has issues in Flutter web production builds.
  late AnimationController _animationController;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;

  int _displayedPage = 0; // The page currently shown on screen
  int _nextPage = 0; // The page we are transitioning to
  bool _showNext = false; // Toggle between current and next during animation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideOutAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-0.05, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _slideInAnimation =
        Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _displayedPage = _nextPage;
            _currentPage = _nextPage;
            _showNext = false;
            _isAnimating = false;
          });
          _animationController.reset();
        }
      }
    });
  }



  void _startAutoScroll(int totalPages) {
    _totalPages = totalPages;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || _isAnimating) return;
      final next = (_currentPage + 1) % _totalPages;
      _animateToPage(next);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _animateToPage(int page) {
    if (_isAnimating || page == _currentPage) return;
    setState(() {
      _nextPage = page;
      _showNext = true;
      _isAnimating = true;
    });
    _animationController.forward();
  }

  void _goToPage(int page) {
    _animateToPage(page);
    // Reset timer so it doesn't immediately advance
    _startAutoScroll(_totalPages);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _animationController.dispose();
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

    if (_isVisible && _autoScrollTimer == null && testimonials.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _autoScrollTimer == null) {
          _startAutoScroll(_getPageCount(context, testimonials));
        }
      });
    }

    return VisibilityDetector(
      key: const Key('testimonials-section-detector'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.05) {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
            });
            if (testimonials.isNotEmpty) {
              _startAutoScroll(_getPageCount(context, testimonials));
            }
          }
        } else if (info.visibleFraction == 0) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
            _stopAutoScroll();
          }
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
                  ).riseFade(isVisible: _isVisible),
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
                      .riseFade(isVisible: _isVisible, delay: 100.ms),
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
                  )
                      .riseFade(isVisible: _isVisible, delay: 200.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getPageCount(
    BuildContext context,
    List<TestimonialEntity> testimonials,
  ) {
    final width = MediaQuery.of(context).size.width;
    // Must match the `sizingInformation.isDesktop` threshold used by the
    // ResponsiveBuilder above (desktop breakpoint = 1024, set in main.dart),
    // otherwise this and the rendered carousel disagree on cardsPerPage in
    // the 900-1024px tablet window and the page/dot state desyncs.
    final cardsPerPage = width >= 1024 ? 2 : 1;
    return (testimonials.length / cardsPerPage).ceil();
  }

  Widget _buildPageContent(
    BuildContext context,
    List<TestimonialEntity> testimonials,
    int cardsPerPage,
    int pageIndex,
  ) {
    final startIndex = pageIndex * cardsPerPage;
    final endIndex = (startIndex + cardsPerPage).clamp(0, testimonials.length);
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
          // Custom cross-fade carousel - reliable in web production
          MouseRegion(
            onEnter: (_) => _stopAutoScroll(),
            onExit: (_) => _startAutoScroll(totalPages),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                if (!_showNext) {
                  // Static state — just show the current page
                  return _buildPageContent(
                    context,
                    testimonials,
                    cardsPerPage,
                    _displayedPage,
                  );
                }
                // Animating — show fade-out old + fade-in new
                return Stack(
                  children: [
                    // Old page fading/sliding out
                    SlideTransition(
                      position: _slideOutAnimation,
                      child: FadeTransition(
                        opacity: _fadeOutAnimation,
                        child: _buildPageContent(
                          context,
                          testimonials,
                          cardsPerPage,
                          _displayedPage,
                        ),
                      ),
                    ),
                    // New page fading/sliding in
                    SlideTransition(
                      position: _slideInAnimation,
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: _buildPageContent(
                          context,
                          testimonials,
                          cardsPerPage,
                          _nextPage,
                        ),
                      ),
                    ),
                  ],
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
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
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
              color:
                  enabled ? const Color(0xFF1A1A2E) : const Color(0xFFBBBBBB),
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
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
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
