import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:taxverse_portfolio/main.dart';
import 'package:taxverse_portfolio/data/repositories/content_repository_impl.dart';
import 'package:taxverse_portfolio/data/datasources/static_content_data_source.dart';
import 'package:taxverse_portfolio/presentation/providers/content_provider.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('App smoke test - homepage loads content', (WidgetTester tester) async {
    final dataSource = StaticContentDataSource();
    final contentRepository = ContentRepositoryImpl(dataSource: dataSource);

    // Build our app wrapped in providers (exactly like in main.dart) and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ContentProvider(repository: contentRepository),
          ),
        ],
        child: const TaxverseApp(),
      ),
    );

    // Allow any initial async content loading/layout to settle
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    // Verify that our main tagline "ESTABLISHED 2020" is displayed.
    expect(find.text('ESTABLISHED 2020'), findsWidgets);
  });
}
