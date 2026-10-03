import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../providers/content_provider.dart';
import '../../widgets/tap_target.dart';
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
  bool _isHovered = false;

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

  /// Keeps the auto-advance timer in step with reality: it runs only while the
  /// section is on screen and the pointer isn't over the carousel. Every
  /// trigger (visibility, hover, manual navigation) funnels through here so no
  /// path can start the timer while it should be stopped. [restart] resets the
  /// interval, e.g. after the user navigates manually.
  void _syncAutoScroll({bool restart = false}) {
    if (!_isVisible || _isHovered) {
      _autoScrollTimer?.cancel();
      _autoScrollTimer = null;
      return;
    }
    if (_autoScrollTimer != null && !restart) return;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted || _isAnimating || _totalPages < 2) return;
      _animateToPage((_currentPage + 1) % _totalPages);
    });
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
    _syncAutoScroll(restart: true);
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

    return VisibilityDetector(
      key: const Key('testimonials-section-detector'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.05) {
          if (!_isVisible) {
            setState(() => _isVisible = true);
            _syncAutoScroll();
          }
        } else if (info.visibleFraction == 0) {
          if (_isVisible) {
            setState(() => _isVisible = false);
            _syncAutoScroll();
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
                  Semantics(
                    header: true,
                    headingLevel: 2,
                    child: Text(
                      'What Our Clients Say',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF1A1A2E),
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ).riseFade(isVisible: _isVisible, delay: 100.ms),
                  const SizedBox(height: 56),
                  // Carousel with arrows
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      final cardsPerPage = sizingInformation.isDesktop ? 2 : 1;
                      final totalPages = (testimonials.length / cardsPerPage)
                          .ceil();
                      // Read by the auto-advance timer; kept current across
                      // breakpoint changes (1 vs 2 cards per page).
                      _totalPages = totalPages;

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
                  ).riseFade(isVisible: _isVisible, delay: 200.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    List<TestimonialEntity> testimonials,
    int cardsPerPage,
    int requestedPage,
  ) {
    // The page index survives a breakpoint change (2 cards/page -> 1 or vice
    // versa), so clamp it to the current page count to avoid a bad sublist.
    final lastPage = ((testimonials.length / cardsPerPage).ceil() - 1).clamp(
      0,
      testimonials.length,
    );
    final pageIndex = requestedPage > lastPage ? lastPage : requestedPage;
    final startIndex = pageIndex * cardsPerPage;
    final endIndex = (startIndex + cardsPerPage).clamp(0, testimonials.length);
    final pageItems = testimonials.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < cardsPerPage; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < cardsPerPage - 1 ? 24 : 0),
                // Empty slot on a short last page keeps card widths uniform.
                child: i < pageItems.length
                    ? _buildTestimonialCard(context, pageItems[i])
                    : const SizedBox.shrink(),
              ),
            ),
        ],
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
      height: 380,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Custom cross-fade carousel - reliable in web production
          MouseRegion(
            onEnter: (_) {
              _isHovered = true;
              _syncAutoScroll();
            },
            onExit: (_) {
              _isHovered = false;
              _syncAutoScroll();
            },
            // The transitions below listen to the controller themselves, so
            // the (expensive, shadowed) card pages are built once per state
            // change instead of on every animation frame. setState runs when
            // a transition starts and when it ends, which is all that swaps
            // this subtree.
            child: !_showNext
                // Static state — just show the current page
                ? _buildPageContent(
                    context,
                    testimonials,
                    cardsPerPage,
                    _displayedPage,
                  )
                // Animating — show fade-out old + fade-in new
                : Stack(
                    children: [
                      // Old page fading/sliding out
                      SlideTransition(
                        position: _slideOutAnimation,
                        child: FadeTransition(
                          opacity: _fadeOutAnimation,
                          child: RepaintBoundary(
                            child: _buildPageContent(
                              context,
                              testimonials,
                              cardsPerPage,
                              _displayedPage,
                            ),
                          ),
                        ),
                      ),
                      // New page fading/sliding in
                      SlideTransition(
                        position: _slideInAnimation,
                        child: FadeTransition(
                          opacity: _fadeInAnimation,
                          child: RepaintBoundary(
                            child: _buildPageContent(
                              context,
                              testimonials,
                              cardsPerPage,
                              _nextPage,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                tooltip: 'Previous testimonials',
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
                tooltip: 'Next testimonials',
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
    required String tooltip,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        // The tooltip doubles as the control's accessible name.
        child: Tooltip(
          message: tooltip,
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
                color: enabled
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFFBBBBBB),
              ),
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
        return TapTarget(
          onTap: () => _goToPage(index),
          semanticLabel: 'Testimonials page ${index + 1} of $totalPages',
          selected: isActive,
          borderRadius: BorderRadius.circular(6),
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
                  : const Color(0xFF8391A5),
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
          // Purely decorative glyph: hidden from screen readers, and exempt
          // from contrast requirements.
          ExcludeSemantics(
            child: Text(
              '\u201C\u201D',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: AppTheme.highlightColor.withValues(alpha: 0.7),
                height: 0.8,
              ),
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
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showFullTestimonial(context, testimonial),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Read more'),
          ),
          const SizedBox(height: 12),
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
              if (testimonial.designation.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  testimonial.designation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showFullTestimonial(
    BuildContext context,
    TestimonialEntity testimonial,
  ) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrollable: true,
        contentPadding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '“${testimonial.text}”',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                testimonial.author,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              if (testimonial.designation.isNotEmpty)
                Text(
                  testimonial.designation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
