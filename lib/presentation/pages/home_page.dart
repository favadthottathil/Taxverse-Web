import 'package:flutter/material.dart';
import '../widgets/header_nav.dart';
import 'sections/hero_section.dart';
import 'sections/services_section.dart';
import 'sections/about_section.dart';
import 'sections/approach_section.dart';
import 'sections/industries_section.dart';
import 'sections/insights_section.dart';
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

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderNav(
            onNavigate: (section) {
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
                  Navigator.pushNamed(context, '/services');
                  break;
                case 'CAREERS':
                  Navigator.pushNamed(context, '/careers');
                  break;
                case 'Contact':
                case 'Contact Us':
                case 'CONTACT US':
                  Navigator.pushNamed(context, '/contact');
                  break;
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(
                    key: _heroKey,
                    onServicesClick: () => _scrollToSection(_servicesKey),
                  ),
                  ServicesSection(key: _servicesKey),
                  AboutSection(key: _aboutKey),
                  const ApproachSection(),
                  const IndustriesSection(),
                  const InsightsSection(),
                  TestimonialsSection(key: _testimonialsKey),
                  FooterSection(
                    key: _footerKey,
                    onNavigate: (section) {
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
                          Navigator.pushNamed(context, '/services');
                          break;
                        case 'CAREERS':
                          Navigator.pushNamed(context, '/careers');
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
