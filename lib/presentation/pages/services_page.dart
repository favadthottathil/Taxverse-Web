import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/constants.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../widgets/header_nav.dart';
import '../widgets/scroll_visibility_detector.dart';
import 'sections/footer_section.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  static const String _allServices = 'All Services';

  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = _allServices;
  bool _routeArgsApplied = false;

  // Rows are derived from (category, column count); cache so a rebuild for any
  // other reason (hover, resize within a breakpoint) doesn't recompute them.
  String? _entriesCategory;
  int _entriesColumns = 0;
  List<_ListEntry> _entries = const [];

  static const List<String> _categories = [
    'All Services',
    'Audit & Assurance',
    'Taxation',
    'Accounting & Payroll',
    'Registrations',
    'Consulting & Advisory',
    'IP & Others',
  ];

  static const Map<String, _CategoryData> _categoryData = {
    'Audit & Assurance': _CategoryData(
      icon: Icons.shield_outlined,
      services: [
        _ServiceItem(
          'Statutory Audit',
          'Comprehensive statutory audit services ensuring compliance with applicable laws and regulations.',
        ),
        _ServiceItem(
          'Internal Audit',
          'Systematic evaluation of internal controls and risk management processes.',
        ),
        _ServiceItem(
          'Tax Audit',
          'Expert tax audit services under Section 44AB of the Income Tax Act.',
        ),
        _ServiceItem(
          'Stock Audit',
          'Thorough verification of inventory and stock records for financial accuracy.',
        ),
        _ServiceItem(
          'Management Audit',
          'Evaluation of management effectiveness and organizational performance.',
        ),
      ],
    ),
    'Taxation': _CategoryData(
      icon: Icons.description_outlined,
      services: [
        _ServiceItem(
          'Income Tax Returns (Individuals)',
          'Professional ITR filing services for salaried and non-salaried individuals.',
        ),
        _ServiceItem(
          'Income Tax Returns (Business)',
          'Expert business tax return preparation and filing services.',
        ),
        _ServiceItem(
          'TDS Filing & Compliance',
          'End-to-end TDS deduction, filing, and compliance management.',
        ),
        _ServiceItem(
          'GST Returns & Filing',
          'Complete GST return filing including GSTR-1, GSTR-3B, and annual returns.',
        ),
        _ServiceItem(
          'GST Audit',
          'Thorough GST audit services ensuring compliance with GST regulations.',
        ),
        _ServiceItem(
          'Tax Planning & Advisory',
          'Strategic tax planning to optimize your tax liability legally.',
        ),
        _ServiceItem(
          'Tax Notices & Litigation',
          'Expert representation in tax disputes and litigation matters.',
        ),
      ],
    ),
    'Accounting & Payroll': _CategoryData(
      icon: Icons.calculate_outlined,
      services: [
        _ServiceItem(
          'Bookkeeping Services',
          'Accurate and timely bookkeeping to keep your financials in order.',
        ),
        _ServiceItem(
          'Outsourced Accounting',
          'Complete accounting function outsourcing for growing businesses.',
        ),
        _ServiceItem(
          'Payroll Processing',
          'End-to-end payroll management including compliance and reporting.',
        ),
        _ServiceItem(
          'MIS Reporting',
          'Custom management information system reports for better decision-making.',
        ),
        _ServiceItem(
          'Financial Statement Preparation',
          'Professional preparation of balance sheets, P&L, and cash flow statements.',
        ),
      ],
    ),
    'Registrations': _CategoryData(
      icon: Icons.article_outlined,
      services: [
        _ServiceItem(
          'Company Incorporation (Pvt Ltd)',
          'End-to-end private limited company registration and compliance setup.',
        ),
        _ServiceItem(
          'LLP Registration',
          'Complete Limited Liability Partnership formation and filing services.',
        ),
        _ServiceItem(
          'One Person Company',
          'OPC registration for solo entrepreneurs with limited liability protection.',
        ),
        _ServiceItem(
          'Public Limited Company',
          'Registration and compliance services for public limited companies.',
        ),
        _ServiceItem(
          'Partnership Firm',
          'Partnership deed drafting and firm registration services.',
        ),
        _ServiceItem(
          'GST Registration',
          'Complete GST registration and compliance setup for businesses.',
        ),
        _ServiceItem(
          'GST for Foreigners',
          'Specialized GST registration services for foreign entities operating in India.',
        ),
        _ServiceItem(
          'TAN Registration',
          'Tax Account Number registration for TDS deduction compliance.',
        ),
        _ServiceItem(
          'FSSAI Registration',
          'Food safety license and registration for food businesses.',
        ),
        _ServiceItem(
          'Import-Export Code',
          'IEC registration for businesses engaged in international trade.',
        ),
        _ServiceItem(
          'Trade License',
          'Municipal trade license acquisition for business operations.',
        ),
        _ServiceItem(
          'MSME/Udyam Registration',
          'Udyam registration for micro, small, and medium enterprises.',
        ),
        _ServiceItem(
          'Startup India Registration',
          'DPIIT recognition and benefits for eligible startups.',
        ),
        _ServiceItem(
          '12A & 80G Registration (NGO)',
          'Tax exemption registration for non-profit organizations.',
        ),
      ],
    ),
    'Consulting & Advisory': _CategoryData(
      icon: Icons.business_center_outlined,
      services: [
        _ServiceItem(
          'Business Setup Advisory',
          'Expert guidance on business structure, jurisdiction, and setup strategy.',
        ),
        _ServiceItem(
          'Project Financing',
          'Comprehensive project financing solutions and documentation support.',
        ),
        _ServiceItem(
          'Virtual CFO Services',
          'Strategic financial leadership without the cost of a full-time CFO.',
        ),
        _ServiceItem(
          'Business Valuation',
          'Professional business valuation services for M&A, funding, and compliance.',
        ),
        _ServiceItem(
          'Company Law Advisory',
          'Expert advisory on Companies Act compliance and corporate governance.',
        ),
      ],
    ),
    'IP & Others': _CategoryData(
      icon: Icons.verified_outlined,
      services: [
        _ServiceItem(
          'Trademark Registration',
          'Complete trademark search, filing, and registration services.',
        ),
        _ServiceItem(
          'Copyright Registration',
          'Protection of original creative works through copyright registration.',
        ),
        _ServiceItem(
          'Patent Filing',
          'Patent application drafting, filing, and prosecution services.',
        ),
        _ServiceItem(
          'ISO Certification',
          'ISO quality management system certification assistance.',
        ),
        _ServiceItem(
          'ROC Filings & Compliance',
          'Annual ROC filings and ongoing corporate compliance management.',
        ),
      ],
    ),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Apply the route argument once. Depending on the ModalRoute re-fires this
    // whenever the route's state changes (e.g. a dialog opens on top), which
    // would otherwise reset the tab the user picked.
    if (_routeArgsApplied) return;
    _routeArgsApplied = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && _categories.contains(args)) {
      _selectedCategory = args;
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutQuart,
    );
  }

  void _selectCategory(String category) {
    if (category == _selectedCategory) return;
    setState(() => _selectedCategory = category);
  }

  void _handleNavigate(String section) {
    if (section.startsWith('SERVICES|')) {
      final category = section.split('|')[1];
      if (_categories.contains(category)) {
        _selectCategory(category);
        _scrollToTop();
      }
      return;
    }

    switch (section) {
      case 'HOME':
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        break;
      case 'ABOUT US':
        Navigator.pushReplacementNamed(context, '/about');
        break;
      case 'SERVICES':
        _scrollToTop();
        break;
      // case 'CAREERS':
      //   Navigator.pushReplacementNamed(context, '/careers');
      //   break;
      case 'CONTACT US':
      case 'Contact Us':
        Navigator.pushReplacementNamed(context, '/contact');
        break;
    }
  }

  /// Flattens the selected category (or all of them) into header + card-row
  /// entries so the list can be built lazily, one row at a time.
  List<_ListEntry> _entriesFor(String category, int columns) {
    if (category == _entriesCategory && columns == _entriesColumns) {
      return _entries;
    }

    final Iterable<String> names = category == _allServices
        ? _categoryData.keys
        : _categoryData.containsKey(category)
        ? [category]
        : const [];

    final entries = <_ListEntry>[];
    for (final name in names) {
      final data = _categoryData[name]!;
      entries.add(_HeaderEntry(name, data.icon, isFirst: entries.isEmpty));
      final services = data.services;
      for (var i = 0; i < services.length; i += columns) {
        final end = i + columns < services.length
            ? i + columns
            : services.length;
        entries.add(_RowEntry(name, i, services.sublist(i, end)));
      }
    }

    _entriesCategory = category;
    _entriesColumns = columns;
    return _entries = entries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderNav(onNavigate: _handleNavigate, activeRoute: 'SERVICES'),
          Expanded(
            child: ResponsiveBuilder(
              builder: (context, sizingInfo) {
                final columns = sizingInfo.isDesktop
                    ? 3
                    : sizingInfo.isTablet
                    ? 2
                    : 1;
                final entries = _entriesFor(_selectedCategory, columns);

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverToBoxAdapter(child: _ServicesHeroBanner()),
                    SliverToBoxAdapter(
                      child: _ContentFrame(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: _CategoryTabs(
                            categories: _categories,
                            selected: _selectedCategory,
                            onSelected: _selectCategory,
                          ),
                        ),
                      ),
                    ),
                    // Keyed so switching category or column count starts a
                    // fresh list (and fresh entrance animations).
                    SliverList.builder(
                      key: ValueKey('$_selectedCategory-$columns'),
                      itemCount: entries.length,
                      itemBuilder: (context, index) => _KeepAlive(
                        child: _ContentFrame(
                          child: switch (entries[index]) {
                            _HeaderEntry entry => _CategoryHeader(entry: entry),
                            _RowEntry entry => _ServiceRow(
                              entry: entry,
                              columns: columns,
                            ),
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 48)),
                    SliverToBoxAdapter(
                      child: FooterSection(onNavigate: _handleNavigate),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

sealed class _ListEntry {
  const _ListEntry();
}

class _HeaderEntry extends _ListEntry {
  final String name;
  final IconData icon;
  final bool isFirst;

  const _HeaderEntry(this.name, this.icon, {required this.isFirst});
}

class _RowEntry extends _ListEntry {
  final String category;

  /// Index of the row's first service within [category]; keeps detector keys
  /// unique across rows.
  final int startIndex;
  final List<_ServiceItem> items;

  const _RowEntry(this.category, this.startIndex, this.items);
}

class _CategoryData {
  final IconData icon;
  final List<_ServiceItem> services;
  const _CategoryData({required this.icon, required this.services});
}

class _ServiceItem {
  final String title;
  final String description;
  const _ServiceItem(this.title, this.description);
}

/// Centers content in the shared max-width column with the page gutter.
class _ContentFrame extends StatelessWidget {
  final Widget child;

  const _ContentFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.desktopMaxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

/// Keeps a lazily built row alive once created, so scrolling back to it never
/// replays its entrance animation.
class _KeepAlive extends StatefulWidget {
  final Widget child;

  const _KeepAlive({required this.child});

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryTabs({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollVisibilityDetector(
      detectorKey: const Key('services-tabs-detector'),
      animateOnce: true,
      builder: (context, isVisible, child) =>
          child.riseFade(isVisible: isVisible),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final category in categories)
              _buildTab(category, category == selected),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String category, bool isSelected) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: () => onSelected(category),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final _HeaderEntry entry;

  const _CategoryHeader({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: entry.isFirst ? 0 : 40, bottom: 16),
      child: ScrollVisibilityDetector(
        detectorKey: Key('services-header-${entry.name}'),
        animateOnce: true,
        builder: (context, isVisible, child) =>
            child.riseFade(isVisible: isVisible),
        child: Row(
          children: [
            Icon(entry.icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                entry.name,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: AppTheme.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final _RowEntry entry;
  final int columns;

  const _ServiceRow({required this.entry, required this.columns});

  @override
  Widget build(BuildContext context) {
    final items = entry.items;
    // IntrinsicHeight equalises card heights within a row; it's cheap here
    // because only the handful of rows near the viewport are ever built.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var column = 0; column < columns; column++)
            Expanded(
              child: column < items.length
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: ScrollVisibilityDetector(
                        detectorKey: Key(
                          'service-${entry.category}-${entry.startIndex + column}',
                        ),
                        animateOnce: true,
                        builder: (context, isVisible, child) => child.riseFade(
                          isVisible: isVisible,
                          delay: AppMotion.stagger(column),
                        ),
                        child: _ServiceCard(item: items[column]),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final _ServiceItem item;

  const _ServiceCard({required this.item});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  static const _hoveredShadow = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered != value) setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
          ),
          boxShadow: _isHovered ? _hoveredShadow : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: _isHovered ? Colors.white : AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                widget.item.description,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: _isHovered ? Colors.white70 : AppTheme.textSecondary,
                  fontSize: 14,
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

// ─── HERO BANNER ────────────────────────────────────────────────────────────────
class _ServicesHeroBanner extends StatelessWidget {
  const _ServicesHeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isDesktop = sizingInformation.isDesktop;
          return Align(
            alignment: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstants.desktopMaxWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ScrollVisibilityDetector(
                  detectorKey: const Key('services-hero-detector'),
                  animateOnce: true,
                  builder: (context, isVisible, child) {
                    return Column(
                      crossAxisAlignment: isDesktop
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          'SERVICES',
                          textAlign: isDesktop
                              ? TextAlign.left
                              : TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            color: AppTheme.accentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                          ),
                        ).riseFade(isVisible: isVisible),
                        const SizedBox(height: 12),
                        Text(
                          'What We Offer',
                          textAlign: isDesktop
                              ? TextAlign.left
                              : TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            color: Colors.white,
                            fontSize: isDesktop ? 42 : 30,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ).riseFade(
                          isVisible: isVisible,
                          delay: AppMotion.stagger(1),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: isDesktop ? 600 : double.infinity,
                          child:
                              Text(
                                'Comprehensive financial, legal, and business services tailored to your needs.',
                                textAlign: isDesktop
                                    ? TextAlign.left
                                    : TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: isDesktop ? 16 : 15,
                                  height: 1.6,
                                ),
                              ).riseFade(
                                isVisible: isVisible,
                                delay: AppMotion.stagger(2),
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
