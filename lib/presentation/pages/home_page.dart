import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../widgets/header_nav.dart';
import 'sections/hero_section.dart';
import 'sections/services_section.dart';
import 'sections/about_section.dart';
import 'sections/approach_section.dart';
import 'sections/industries_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _scrolledThreshold = 20;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();

  /// Scoped so crossing the scroll threshold rebuilds only the header, not
  /// the whole page.
  final ValueNotifier<bool> _isScrolled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      // ValueNotifier ignores equal values, so this only notifies on a flip.
      _isScrolled.value = _scrollController.offset > _scrolledThreshold;
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 1800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToServices() => _scrollToSection(_servicesKey);

  /// Shared by the header and footer, which use slightly different labels for
  /// the same destinations.
  void _handleNavigate(String section) {
    if (section.startsWith('SERVICES|')) {
      context.go('/services', extra: section.split('|')[1]);
      return;
    }
    switch (section) {
      case 'Home':
      case 'HOME':
        _scrollToSection(_heroKey);
        break;
      case 'About':
      case 'About Us':
      case 'ABOUT US':
        context.go('/about');
        break;
      case 'Services':
      case 'Our Services':
      case 'SERVICES':
        _scrollToServices();
        break;
      case 'Contact':
      case 'Contact Us':
      case 'CONTACT US':
        context.go('/contact');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(
                    key: _heroKey,
                    onServicesClick: _scrollToServices,
                  ),
                  ServicesSection(key: _servicesKey),
                  AboutSection(key: _aboutKey),
                  const ApproachSection(),
                  const IndustriesSection(),
                  TestimonialsSection(key: _testimonialsKey),
                  FooterSection(key: _footerKey, onNavigate: _handleNavigate),
                ],
              ),
            ),
          ),
          // Floating Header Navigation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isScrolled,
              builder: (context, isScrolled, _) => HeaderNav(
                onNavigate: _handleNavigate,
                activeRoute: 'HOME',
                isScrolled: isScrolled,
                blurBackdrop: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _isScrolled.dispose();
    super.dispose();
  }
}
