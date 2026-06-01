import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';
import 'package:roompilot_flutter/features/splash/splash_screen.dart';

void main() {
  test('first launch goes to language selection before onboarding', () {
    expect(
      resolveStartupRoute(
        hasLocalUser: false,
        hasSeenOnboarding: false,
        hasSelectedLanguage: false,
      ),
      '/language-selection',
    );
  });

  test('selected language allows first launch to continue to onboarding', () {
    expect(
      resolveStartupRoute(
        hasLocalUser: false,
        hasSeenOnboarding: false,
        hasSelectedLanguage: true,
      ),
      '/onboarding-intro',
    );
  });

  testWidgets('splash uses the app logo instead of the hotel icon',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizationsDelegate()],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SplashBrand(tagline: 'Simplify hotel management'),
        ),
      ),
    );

    expect(find.byIcon(Icons.hotel_rounded), findsNothing);
    expect(find.byType(Image), findsOneWidget);
  });
}
