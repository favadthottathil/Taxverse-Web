import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../widgets/header_nav.dart';
import 'sections/footer_section.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'All Services';

  final List<String> _categories = [
    'All Services',
    'Audit & Assurance',
    'Taxation',
    'Accounting & Payroll',
    'Registrations',
    'Consulting & Advisory',
    'IP & Others'
  ];

  final Map<String, _CategoryData> _categoryData = {
    'Audit & Assurance': _CategoryData(
      icon: Icons.shield_outlined,
      services: [
        _ServiceItem('Statutory Audit',
            'Comprehensive statutory audit services ensuring compliance with applicable laws and regulations.'),
        _ServiceItem('Internal Audit',
            'Systematic evaluation of internal controls and risk management processes.'),
        _ServiceItem('Tax Audit',
            'Expert tax audit services under Section 44AB of the Income Tax Act.'),
        _ServiceItem('Stock Audit',
            'Thorough verification of inventory and stock records for financial accuracy.'),
        _ServiceItem('Concurrent Audit',
            'Real-time audit of banking transactions to ensure ongoing compliance.'),
        _ServiceItem('Bank Audit',
            'Specialized audit services for banking and financial institutions.'),
        _ServiceItem('Revenue Audit',
            'Assessment of revenue recognition practices and controls.'),
        _ServiceItem('Management Audit',
            'Evaluation of management effectiveness and organizational performance.'),
        _ServiceItem('Due Diligence',
            'Comprehensive due diligence reviews for mergers, acquisitions, and investments.'),
      ],
    ),
    'Taxation': _CategoryData(
      icon: Icons.description_outlined,
      services: [
        _ServiceItem('Income Tax Returns (Individuals)',
            'Professional ITR filing services for salaried and non-salaried individuals.'),
        _ServiceItem('Income Tax Returns (Business)',
            'Expert business tax return preparation and filing services.'),
        _ServiceItem('TDS Filing & Compliance',
            'End-to-end TDS deduction, filing, and compliance management.'),
        _ServiceItem('GST Returns & Filing',
            'Complete GST return filing including GSTR-1, GSTR-3B, and annual returns.'),
        _ServiceItem('GST Audit',
            'Thorough GST audit services ensuring compliance with GST regulations.'),
        _ServiceItem('International Taxation',
            'Cross-border tax planning and compliance for international businesses.'),
        _ServiceItem('Transfer Pricing',
            'Transfer pricing documentation, analysis, and compliance services.'),
        _ServiceItem('Tax Planning & Advisory',
            'Strategic tax planning to optimize your tax liability legally.'),
        _ServiceItem('Tax Notices & Litigation',
            'Expert representation in tax disputes and litigation matters.'),
      ],
    ),
    'Accounting & Payroll': _CategoryData(
      icon: Icons.calculate_outlined,
      services: [
        _ServiceItem('Bookkeeping Services',
            'Accurate and timely bookkeeping to keep your financials in order.'),
        _ServiceItem('Outsourced Accounting',
            'Complete accounting function outsourcing for growing businesses.'),
        _ServiceItem('Payroll Processing',
            'End-to-end payroll management including compliance and reporting.'),
        _ServiceItem('MIS Reporting',
            'Custom management information system reports for better decision-making.'),
        _ServiceItem('Financial Statement Preparation',
            'Professional preparation of balance sheets, P&L, and cash flow statements.'),
        _ServiceItem('Virtual CFO Services',
            'Strategic financial leadership without the cost of a full-time CFO.'),
      ],
    ),
    'Registrations': _CategoryData(
      icon: Icons.article_outlined,
      services: [
        _ServiceItem('Company Incorporation (Pvt Ltd)',
            'End-to-end private limited company registration and compliance setup.'),
        _ServiceItem('LLP Registration',
            'Complete Limited Liability Partnership formation and filing services.'),
        _ServiceItem('One Person Company',
            'OPC registration for solo entrepreneurs with limited liability protection.'),
        _ServiceItem('Public Limited Company',
            'Registration and compliance services for public limited companies.'),
        _ServiceItem('Partnership Firm',
            'Partnership deed drafting and firm registration services.'),
        _ServiceItem('Proprietorship',
            'Sole proprietorship setup with all required registrations.'),
        _ServiceItem('GST Registration',
            'Complete GST registration and compliance setup for businesses.'),
        _ServiceItem('GST for Foreigners',
            'Specialized GST registration services for foreign entities operating in India.'),
        _ServiceItem('TAN Registration',
            'Tax Account Number registration for TDS deduction compliance.'),
        _ServiceItem('PF Registration',
            'Provident Fund registration and compliance for employers.'),
        _ServiceItem('Professional Tax Registration',
            'State-level professional tax registration and filing services.'),
        _ServiceItem('FSSAI Registration',
            'Food safety license and registration for food businesses.'),
        _ServiceItem('Import-Export Code',
            'IEC registration for businesses engaged in international trade.'),
        _ServiceItem('Trade License',
            'Municipal trade license acquisition for business operations.'),
        _ServiceItem('MSME/Udyam Registration',
            'Udyam registration for micro, small, and medium enterprises.'),
        _ServiceItem('Startup India Registration',
            'DPIIT recognition and benefits for eligible startups.'),
        _ServiceItem('12A & 80G Registration (NGO)',
            'Tax exemption registration for non-profit organizations.'),
        _ServiceItem('FCRA Registration',
            'Foreign Contribution Regulation Act registration for NGOs.'),
      ],
    ),
    'Consulting & Advisory': _CategoryData(
      icon: Icons.business_center_outlined,
      services: [
        _ServiceItem('Business Setup Advisory',
            'Expert guidance on business structure, jurisdiction, and setup strategy.'),
        _ServiceItem('Project Financing',
            'Comprehensive project financing solutions and documentation support.'),
        _ServiceItem('Bank Loan Assistance',
            'End-to-end support for bank loan applications and documentation.'),
        _ServiceItem('Financial Due Diligence',
            'Thorough financial investigation for informed business decisions.'),
        _ServiceItem('Business Valuation',
            'Professional business valuation services for M&A, funding, and compliance.'),
        _ServiceItem('FEMA & RBI Compliance',
            'Foreign exchange management and RBI regulatory compliance services.'),
        _ServiceItem('Company Law Advisory',
            'Expert advisory on Companies Act compliance and corporate governance.'),
        _ServiceItem('Mergers & Acquisitions',
            'End-to-end M&A advisory including structuring, valuation, and execution.'),
      ],
    ),
    'IP & Others': _CategoryData(
      icon: Icons.verified_outlined,
      services: [
        _ServiceItem('Trademark Registration',
            'Complete trademark search, filing, and registration services.'),
        _ServiceItem('Copyright Registration',
            'Protection of original creative works through copyright registration.'),
        _ServiceItem('Patent Filing',
            'Patent application drafting, filing, and prosecution services.'),
        _ServiceItem('ISO Certification',
            'ISO quality management system certification assistance.'),
        _ServiceItem('ROC Filings & Compliance',
            'Annual ROC filings and ongoing corporate compliance management.'),
        _ServiceItem('Labour Law Compliance',
            'Comprehensive labour law advisory and compliance services.'),
        _ServiceItem('RERA Advisory',
            'Real Estate Regulatory Authority compliance and advisory services.'),
      ],
    ),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && _categories.contains(args)) {
      _selectedCategory = args;
    }
  }

  void _handleNavigate(String section) {
    if (section.startsWith('SERVICES|')) {
      final category = section.split('|')[1];
      if (_categories.contains(category)) {
        setState(() {
          _selectedCategory = category;
        });
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutQuart,
        );
      }
      return;
    }

    switch (section) {
      case 'HOME':
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 'ABOUT US':
        Navigator.pushReplacementNamed(context, '/about');
        break;
      case 'SERVICES':
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutQuart,
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderNav(
            onNavigate: _handleNavigate,
            activeRoute: 'SERVICES',
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const _ServicesHeroBanner(),
                  _buildContentArea(),
                  FooterSection(onNavigate: _handleNavigate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryTabs(),
              const SizedBox(height: 48),
              _buildServicesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppTheme.primaryColor : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fade(duration: 1600.ms).slideY(begin: 0.1, end: 0, duration: 1600.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildServicesList() {
    List<Widget> sections = [];

    if (_selectedCategory == 'All Services') {
      _categoryData.forEach((categoryName, data) {
        sections.add(_buildCategorySection(categoryName, data));
        sections.add(const SizedBox(height: 48));
      });
    } else if (_categoryData.containsKey(_selectedCategory)) {
      sections.add(_buildCategorySection(
          _selectedCategory, _categoryData[_selectedCategory]!));
    } else {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: Center(
            child: Text(
              'No services specifically defined for $_selectedCategory in this preview.',
              style: TextStyle(
                  fontFamily: 'Metropolis', color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  Widget _buildCategorySection(String name, _CategoryData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(data.icon, color: AppTheme.accentColor, size: 28),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: AppTheme.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ).animate().fade(duration: 1600.ms).slideX(begin: -0.1, end: 0, duration: 1600.ms, curve: Curves.easeOutCubic),
        const SizedBox(height: 24),
        ResponsiveBuilder(
          builder: (context, sizingInfo) {
            int crossAxisCount = 1;
            if (sizingInfo.isDesktop) {
              crossAxisCount = 3;
            } else if (sizingInfo.isTablet) {
              crossAxisCount = 2;
            }

            List<Widget> rows = [];
            for (var i = 0; i < data.services.length; i += crossAxisCount) {
              int end = (i + crossAxisCount < data.services.length)
                  ? i + crossAxisCount
                  : data.services.length;
              List<_ServiceItem> rowItems = data.services.sublist(i, end);

              rows.add(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: rowItems.map((item) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _ServiceCard(item: item),
                      ),
                    );
                  }).toList()
                    // Fill remaining space if row is not full on desktop/tablet
                    ..addAll(
                      List.generate(
                        crossAxisCount - rowItems.length,
                        (_) => Expanded(
                            child:
                                Container(margin: const EdgeInsets.all(8.0))),
                      ),
                    ),
                ),
              );
            }

            return Column(
              children: rows.map((row) => IntrinsicHeight(child: row)).toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _CategoryData {
  final IconData icon;
  final List<_ServiceItem> services;
  _CategoryData({required this.icon, required this.services});
}

class _ServiceItem {
  final String title;
  final String description;
  _ServiceItem(this.title, this.description);
}

class _ServiceCard extends StatefulWidget {
  final _ServiceItem item;

  const _ServiceCard({required this.item});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? AppTheme.primaryColor : AppTheme.secondaryColor,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
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
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    color: _isHovered ? Colors.white : AppTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: _isHovered ? Colors.white : AppTheme.primaryColor,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fade(duration: 1600.ms)
          .slideY(begin: 0.05, end: 0, duration: 1600.ms, curve: Curves.easeOutCubic),
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
              constraints:
                  const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: isDesktop
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SERVICES',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppTheme.accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    )
                        .animate()
                        .fade(duration: 1600.ms)
                        .slideY(begin: 0.2, end: 0, duration: 1600.ms),
                    const SizedBox(height: 12),
                    Text(
                      'What We Offer',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: Colors.white,
                        fontSize: isDesktop ? 42 : 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    )
                        .animate()
                        .fade(delay: 100.ms, duration: 1600.ms)
                        .slideY(begin: 0.2, end: 0, duration: 1600.ms),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: isDesktop ? 600 : double.infinity,
                      child: Text(
                        'Comprehensive financial, legal, and business services tailored to your needs.',
                        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: isDesktop ? 16 : 15,
                          height: 1.6,
                        ),
                      )
                          .animate()
                          .fade(delay: 200.ms, duration: 1600.ms)
                          .slideY(begin: 0.2, end: 0, duration: 1600.ms),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
