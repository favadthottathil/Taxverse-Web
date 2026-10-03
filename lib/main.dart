import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/datasources/static_content_data_source.dart';
import 'presentation/providers/content_provider.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'core/motion.dart';
import 'core/scroll_behavior.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/about_us_page.dart';
import 'presentation/pages/services_page.dart';
// import 'presentation/pages/careers_page.dart';
import 'presentation/pages/contact_page.dart';
import 'presentation/pages/privacy_policy_page.dart';
import 'presentation/pages/terms_page.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  final dataSource = StaticContentDataSource();
  final contentRepository = ContentRepositoryImpl(dataSource: dataSource);

  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    const ScreenBreakpoints(desktop: 1024, tablet: 768, watch: 200),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ContentProvider(repository: contentRepository),
        ),
      ],
      child: const TaxverseApp(),
    ),
  );
}

/// Built once so the router (and its navigation state) survives app rebuilds.
/// Unknown paths fall back to home, matching the previous behaviour.
final GoRouter _router = GoRouter(
  onException: (context, state, router) => router.go('/'),
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildTransitionPage(
        state,
        const HomePage(),
        title:
            'Taxverse | Audit, Tax, GST & Accounting Services in Manjeri, Kerala',
      ),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => buildTransitionPage(
        state,
        const AboutUsPage(),
        title: 'About Us | Taxverse Business Consultancy, Manjeri, Kerala',
      ),
    ),
    GoRoute(
      path: '/services',
      pageBuilder: (context, state) => buildTransitionPage(
        state,
        const ServicesPage(),
        title: 'Audit, Income Tax, GST, Registration & CFO Services | Taxverse',
      ),
    ),
    // GoRoute(
    //   path: '/careers',
    //   pageBuilder: (context, state) =>
    //       buildTransitionPage(state, const CareersPage()),
    // ),
    GoRoute(
      path: '/contact',
      pageBuilder: (context, state) => buildTransitionPage(
        state,
        const ContactPage(),
        title: 'Contact Taxverse | Tax & Accounting Consultants, Manjeri',
      ),
    ),
    GoRoute(
      path: '/privacy',
      pageBuilder: (context, state) => buildTransitionPage(
        state,
        const PrivacyPolicyPage(),
        title: 'Privacy Policy | Taxverse Business Consultancy',
      ),
    ),
    GoRoute(
      path: '/terms',
      pageBuilder: (context, state) => buildTransitionPage(
        state,
        const TermsPage(),
        title: 'Terms & Conditions | Taxverse Business Consultancy',
      ),
    ),
  ],
);

class TaxverseApp extends StatelessWidget {
  const TaxverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: _router,
    );
  }
}
