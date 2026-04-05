import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/datasources/static_content_data_source.dart';
import 'presentation/providers/content_provider.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/about_us_page.dart';
import 'presentation/pages/services_page.dart';
import 'presentation/pages/careers_page.dart';
import 'presentation/pages/contact_page.dart';

void main() async {
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

class TaxverseApp extends StatelessWidget {
  const TaxverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutUsPage(),
        '/services': (context) => const ServicesPage(),
        '/careers': (context) => const CareersPage(),
        '/contact': (context) => const ContactPage(),
      },
    );
  }
}
