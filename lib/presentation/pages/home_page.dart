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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isScrolled = _scrollController.offset > 20;
      if (isScrolled != _isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    }
  }

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 1800),
        curve: Curves.easeInOutCubic,
      );
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
                    scrollController: _scrollController,
                    onServicesClick: () => _scrollToSection(_servicesKey),
                  ),
                  ServicesSection(key: _servicesKey),
                  AboutSection(key: _aboutKey),
                  const ApproachSection(),
                  const IndustriesSection(),
                  TestimonialsSection(key: _testimonialsKey),
                  FooterSection(
                    key: _footerKey,
                    onNavigate: (section) {
                      if (section.startsWith('SERVICES|')) {
                        Navigator.pushNamed(
                          context,
                          '/services',
                          arguments: section.split('|')[1],
                        );
                        return;
                      }
                      switch (section) {
                        case 'Home':
                        case 'HOME':
                          _scrollToSection(_heroKey);
                          break;
                        case 'About Us':
                        case 'ABOUT US':
                          Navigator.pushNamed(context, '/about');
                          break;
                        case 'Our Services':
                        case 'SERVICES':
                          _scrollToSection(_servicesKey);
                          break;
                        case 'Contact Us':
                        case 'CONTACT US':
                          Navigator.pushNamed(context, '/contact');
                          break;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Floating Header Navigation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderNav(
              onNavigate: (section) {
                if (section.startsWith('SERVICES|')) {
                  Navigator.pushNamed(
                    context,
                    '/services',
                    arguments: section.split('|')[1],
                  );
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
                    Navigator.pushNamed(context, '/about');
                    break;
                  case 'Services':
                  case 'Our Services':
                  case 'SERVICES':
                    _scrollToSection(_servicesKey);
                    break;
                  case 'Contact':
                  case 'Contact Us':
                  case 'CONTACT US':
                    Navigator.pushNamed(context, '/contact');
                    break;
                }
              },
              activeRoute: 'HOME',
              isScrolled: _isScrolled,
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
    super.dispose();
  }
}
