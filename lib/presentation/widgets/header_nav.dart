import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import 'consultation_dialog.dart';

class HeaderNav extends StatefulWidget {
  final Function(String) onNavigate;
  final String activeRoute;
  final bool isScrolled;

  const HeaderNav({
    super.key,
    required this.onNavigate,
    this.activeRoute = 'HOME',
    this.isScrolled = true,
  });

  @override
  State<HeaderNav> createState() => _HeaderNavState();
}

class _HeaderNavState extends State<HeaderNav> {
  String? _hoveredItem;
  OverlayEntry? _megaMenuOverlay;
  bool _isHoveringMenu = false;
  bool _isHoveringNavItem = false;
  Timer? _hideTimer;

  static const Map<String, List<String>> _megaMenuData = {
    'Audit & Assurance': [
      'Statutory Audit',
      'Internal Audit',
      'Tax Audit',
      'Stock Audit',
      'Concurrent Audit',
      'Bank Audit',
      'Revenue Audit',
      'Management Audit',
      'Due Diligence',
    ],
    'Taxation': [
      'Income Tax Returns (Individuals)',
      'Income Tax Returns (Business)',
      'TDS Filing & Compliance',
      'GST Returns & Filing',
      'GST Audit',
      'International Taxation',
      'Transfer Pricing',
      'Tax Planning & Advisory',
      'Tax Notices & Litigation',
    ],
    'Accounting & Payroll': [
      'Bookkeeping Services',
      'Outsourced Accounting',
      'Payroll Processing',
      'MIS Reporting',
      'Financial Statement Preparation',
      'Virtual CFO Services',
    ],
    'Registrations': [
      'Company Incorporation (Pvt Ltd)',
      'LLP Registration',
      'One Person Company',
      'Public Limited Company',
      'Partnership Firm',
      'Proprietorship',
      'GST Registration',
      'GST for Foreigners',
      'TAN Registration',
      'PF Registration',
      'Professional Tax Registration',
      'FSSAI Registration',
      'Import-Export Code',
      'Trade License',
      'MSME/Udyam Registration',
      'Startup India Registration',
      '12A & 80G Registration (NGO)',
      'FCRA Registration',
    ],
    'Consulting & Advisory': [
      'Business Setup Advisory',
      'Project Financing',
      'Bank Loan Assistance',
      'Financial Due Diligence',
      'Business Valuation',
      'FEMA & RBI Compliance',
      'Company Law Advisory',
      'Mergers & Acquisitions',
    ],
    'IP & Others': [
      'Trademark Registration',
      'Copyright Registration',
      'Patent Filing',
      'ISO Certification',
      'ROC Filings & Compliance',
      'Labour Law Compliance',
      'RERA Advisory',
    ],
  };

  @override
  void dispose() {
    _hideTimer?.cancel();
    _megaMenuOverlay?.remove();
    super.dispose();
  }

  void _showMegaMenu() {
    if (_megaMenuOverlay != null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _megaMenuOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + size.height,
          left: 0,
          right: 0,
          child: MouseRegion(
            onEnter: (_) {
              _isHoveringMenu = true;
              _hideTimer?.cancel();
            },
            onExit: (_) {
              _isHoveringMenu = false;
              _hideMegaMenuDelayed();
            },
            child: Material(
              elevation: 4,
              color: Colors.white,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppConstants.desktopMaxWidth +
                          160, // Slight expansion to let columns breathe
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _megaMenuData.entries.map((entry) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      color: AppTheme.primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: AppTheme.accentColor
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 12),
                                  ...entry.value.map(
                                    (service) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      child: _MegaMenuServiceItem(
                                        title: service,
                                        onTap: () {
                                          widget.onNavigate(
                                            'SERVICES|${entry.key}',
                                          );
                                          _megaMenuOverlay?.remove();
                                          _megaMenuOverlay = null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().fade(duration: 200.ms).slideY(
                  begin: -0.02,
                  end: 0,
                  duration: 200.ms,
                  curve: Curves.easeOut,
                ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_megaMenuOverlay!);
  }

  void _hideMegaMenuDelayed() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 150), () {
      if (!_isHoveringMenu && !_isHoveringNavItem) {
        _megaMenuOverlay?.remove();
        _megaMenuOverlay = null;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTransparent = !widget.isScrolled;
    final double blurSigma = isTransparent ? 0.0 : 10.0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: isTransparent
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.85),
            boxShadow: isTransparent
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
            border: isTransparent
                ? null
                : Border(
                    bottom: BorderSide(
                      color: Colors.black.withValues(alpha: 0.06),
                      width: 1,
                    ),
                  ),
          ),
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              if (sizingInformation.isDesktop) {
                return _buildDesktopNav(context);
              }
              return _buildMobileNav(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.desktopMaxWidth,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavItem('HOME', true),
                _buildNavItem('ABOUT US', true),
                _buildNavItem('SERVICES', true),
                // _buildNavItem('CAREERS', true),
                _buildNavItem('CONTACT US', true),
                const SizedBox(width: 28),
                _buildConsultationButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    final bool isTransparent = !widget.isScrolled;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(context),
        IconButton(
          icon: Icon(
            Icons.menu,
            color: isTransparent ? Colors.white : AppTheme.primaryColor,
            size: 26,
          ),
          onPressed: () => _showMobileMenu(context),
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMobileNavItem('HOME', context),
                _buildMobileNavItem('ABOUT US', context),
                _buildMobileNavItem('SERVICES', context),
                _buildMobileNavItem('CONTACT US', context),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildConsultationButton(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileNavItem(String title, BuildContext context) {
    final isActive = widget.activeRoute == title;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.onNavigate(title);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: isActive ? AppTheme.primaryColor : const Color(0xFF374151),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final bool isTransparent = !widget.isScrolled;
    return InkWell(
      onTap: () => widget.onNavigate('HOME'),
      hoverColor: Colors.transparent,
      child: SvgPicture.asset(
        'assets/images/taxverse-logo.svg',
        height: 48,
        fit: BoxFit.contain,
        colorFilter: isTransparent
            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            : null,
      ),
    );
  }

  Widget _buildNavItem(String title, bool isDesktop) {
    final bool isActive = widget.activeRoute == title;
    final isHovered = _hoveredItem == title;
    final bool isServices = title == 'SERVICES';
    final bool isTransparent = !widget.isScrolled;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hoveredItem = title);
        if (isServices && isDesktop) {
          _isHoveringNavItem = true;
          _hideTimer?.cancel();
          _showMegaMenu();
        }
      },
      onExit: (_) {
        setState(() => _hoveredItem = null);
        if (isServices && isDesktop) {
          _isHoveringNavItem = false;
          _hideMegaMenuDelayed();
        }
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavigate(title),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: isActive
                      ? (isTransparent ? AppTheme.accentColor : AppTheme.primaryColor)
                      : isHovered
                          ? (isTransparent ? AppTheme.accentColor : AppTheme.primaryColor)
                          : (isTransparent ? Colors.white : const Color(0xFF374151)),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              if (isServices && isDesktop) ...[
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: (isHovered || _megaMenuOverlay != null) ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: isActive || isHovered || _megaMenuOverlay != null
                        ? (isTransparent ? AppTheme.accentColor : AppTheme.primaryColor)
                        : (isTransparent ? Colors.white70 : const Color(0xFF374151)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationButton() {
    final bool isTransparent = !widget.isScrolled;
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ConsultationDialog(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isTransparent ? Colors.white : AppTheme.primaryColor,
        foregroundColor: isTransparent ? AppTheme.primaryColor : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      child: Text(
        'BOOK CONSULTATION',
        style: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: isTransparent ? AppTheme.primaryColor : Colors.white,
        ),
      ),
    );
  }
}

class _MegaMenuServiceItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _MegaMenuServiceItem({required this.title, required this.onTap});

  @override
  State<_MegaMenuServiceItem> createState() => _MegaMenuServiceItemState();
}

class _MegaMenuServiceItemState extends State<_MegaMenuServiceItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: _isHovered
                    ? Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '>',
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: _isHovered
                      ? AppTheme.primaryColor
                      : const Color(0xFF64748B),
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: _isHovered ? FontWeight.w500 : FontWeight.w400,
                ),
                child: Text(widget.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
