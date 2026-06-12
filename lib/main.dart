import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';
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

import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // The package default throttles visibility callbacks by 500ms. Setting this
  // to Duration.zero disables throttling, making scroll animations trigger
  // instantly as soon as elements cross the threshold.
  VisibilityDetectorController.instance.updateInterval = Duration.zero;

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

class TaxverseApp extends StatelessWidget {
  const TaxverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/about':
            return buildPageRoute(
                settings, (context) => const AboutUsPage());
          case '/services':
            return buildPageRoute(
                settings, (context) => const ServicesPage());
          // case '/careers':
          //   return buildPageRoute(
          //       settings, (context) => const CareersPage());
          case '/contact':
            return buildPageRoute(
                settings, (context) => const ContactPage());
          case '/':
          default:
            return buildPageRoute(settings, (context) => const HomePage());
        }
      },
    );
  }
}
