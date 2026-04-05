import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class HeaderNav extends StatefulWidget {
  final Function(String) onNavigate;
  final String activeRoute;

  const HeaderNav({
    super.key,
    required this.onNavigate,
    this.activeRoute = 'HOME',
  });

  @override
  State<HeaderNav> createState() => _HeaderNavState();
}

class _HeaderNavState extends State<HeaderNav> {
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.isDesktop) {
            return _buildDesktopNav(context);
          }
          return _buildMobileNav(context);
        },
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
                _buildNavItem('HOME'),
                _buildNavItem('ABOUT US'),
                _buildNavItem('SERVICES'),
                _buildNavItem('CAREERS'),
                _buildNavItem('CONTACT US'),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(context),
        IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.primaryColor, size: 26),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => widget.onNavigate('HOME'),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SvgPicture.asset(
        'assets/images/taxverse-logo.svg',
        height: 42,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildNavItem(String title) {
    final bool isActive = widget.activeRoute == title;
    final isHovered = _hoveredItem == title;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = title),
      onExit: (_) => setState(() => _hoveredItem = null),
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
                style: GoogleFonts.inter(
                  color: isActive
                      ? AppTheme.accentColor
                      : isHovered
                      ? AppTheme.accentColor
                      : const Color(0xFF374151),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationButton() {
    return ElevatedButton(
      onPressed: () => widget.onNavigate('Contact Us'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentColor,
        foregroundColor: AppTheme.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      child: Text(
        'BOOK CONSULTATION',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
