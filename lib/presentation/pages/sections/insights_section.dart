import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/constants.dart';

class InsightsSection extends StatefulWidget {
  const InsightsSection({super.key});

  @override
  State<InsightsSection> createState() => _InsightsSectionState();
}

class _InsightsSectionState extends State<InsightsSection> {
  bool _isVisible = false;

  // Featured article (large card, left)
  static const Map<String, String> _featured = {
    'image': 'assets/images/article-gst.png',
    'category': 'GST UPDATES',
    'title': 'GST Compliance 2026: Key Changes Every Business Must Know',
    'excerpt':
        'The GST Council has introduced sweeping reforms for FY 2025–26. From revised e-invoicing thresholds to new HSN code requirements, here\'s what your business needs to prepare for.',
    'date': '15 February 2026',
  };

  // Side articles (smaller cards, right)
  static const List<Map<String, String>> _sideArticles = [
    {
      'image': 'assets/images/article-budget.png',
      'category': 'BUDGET ANALYSIS',
      'title': 'Union Budget 2026–27: Impact on MSMEs and Startups',
      'excerpt':
          'The Finance Minister\'s latest budget brings significant tax relief for startups and MSMEs. A detailed analysis of provisions that could reshape India\'s entrepreneurial ecosystem.',
      'date': '10 Feb',
      'readTime': '7 min read',
    },
    {
      'image': 'assets/images/article-audit.png',
      'category': 'AUDIT & COMPLIANCE',
      'title': 'Statutory Audit Checklist 2026: Preparing Your Books Right',
      'excerpt':
          'With audit season approaching, companies must ensure their financial records are in order. This comprehensive checklist covers everything from documentation to digital compliance.',
      'date': '5 Feb',
      'readTime': '8 min read',
    },
    {
      'image': 'assets/images/article-msme.png',
      'category': 'BUSINESS ADVISORY',
      'title': 'MSME Registration and Benefits: A Complete 2026 Guide',
      'excerpt':
          'Udyam registration has been simplified further. Learn about the new classification criteria, exclusive government schemes, and how to leverage MSME status for maximum advantage.',
      'date': '28 Jan',
      'readTime': '7 min read',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('insights-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
        } else if (info.visibleFraction == 0 && _isVisible) {
          setState(() => _isVisible = false);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  _buildHeader(context)
                      .animate(target: _isVisible ? 1 : 0)
                      .fade(duration: 500.ms),
                  const SizedBox(height: 48),
                  // Articles layout
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.isDesktop) {
                        return _buildDesktopLayout(context);
                      }
                      return _buildMobileLayout(context);
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INSIGHTS & UPDATES',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Latest from Our Experts',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: const Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        // View All Articles button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1A1A2E), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All Articles',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: Color(0xFF1A1A2E),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Desktop layout: featured card left, 3 side cards right ──

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured article – left
        Expanded(
          flex: 5,
          child: _buildFeaturedCard(context)
              .animate(target: _isVisible ? 1 : 0)
              .fade(delay: 150.ms, duration: 600.ms)
              .slideX(
                begin: -0.08,
                end: 0,
                curve: Curves.easeOutCubic,
              ),
        ),
        const SizedBox(width: 32),
        // Side articles – right
        Expanded(
          flex: 5,
          child: Column(
            children: _sideArticles.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < _sideArticles.length - 1 ? 24 : 0,
                ),
                child: _buildSideCard(context, entry.value)
                    .animate(target: _isVisible ? 1 : 0)
                    .fade(
                      delay: (250 + entry.key * 120).ms,
                      duration: 600.ms,
                    )
                    .slideX(
                      begin: 0.08,
                      end: 0,
                      delay: (250 + entry.key * 120).ms,
                      curve: Curves.easeOutCubic,
                    ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Mobile layout: stacked ──

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildFeaturedCard(context)
            .animate(target: _isVisible ? 1 : 0)
            .fade(delay: 150.ms, duration: 600.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 24),
        ..._sideArticles.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: entry.key < _sideArticles.length - 1 ? 24 : 0,
            ),
            child: _buildSideCard(context, entry.value)
                .animate(target: _isVisible ? 1 : 0)
                .fade(delay: (250 + entry.key * 120).ms, duration: 600.ms)
                .slideY(
                  begin: 0.08,
                  end: 0,
                  delay: (250 + entry.key * 120).ms,
                  curve: Curves.easeOutCubic,
                ),
          );
        }),
      ],
    );
  }

  // ── Featured card (large) ──

  Widget _buildFeaturedCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              image: AssetImage(_featured['image']!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Category tag
        Text(
          _featured['category']!,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        // Title
        Text(
          _featured['title']!,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        // Excerpt
        Text(
          _featured['excerpt']!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        // Bottom row: date + read article link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  _featured['date']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'Read Article',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Side card (compact horizontal) ──

  Widget _buildSideCard(BuildContext context, Map<String, String> article) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.asset(
              article['image']!,
              width: 180,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    article['category']!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    article['title']!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Excerpt
                  Text(
                    article['excerpt']!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Date + read time
                  Row(
                    children: [
                      Text(
                        article['date']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        article['readTime']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
