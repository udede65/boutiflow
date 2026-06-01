import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';
import 'package:roompilot_flutter/features/auth/language_selection_screen.dart';
import 'package:roompilot_flutter/features/onboarding/onboarding_screen.dart';

void main() {
  test('builds an informative onboarding tour with at least ten slides', () {
    final slides = buildOnboardingSlides(AppLocalizations(const Locale('tr')));

    expect(slides.length, greaterThanOrEqualTo(10));
    expect(slides.first.title, contains('BoutiFlow'));
    expect(slides.map((slide) => slide.title), contains('Premium'));
  });

  test('localizes onboarding slide copy for every supported language', () {
    const overviewTitles = {
      'en': 'Run your hotel from one BoutiFlow workspace',
      'tr': 'BoutiFlow ile otelinizi tek ekranda yönetin',
      'de': 'Verwalte dein Hotel in einem BoutiFlow-Arbeitsbereich',
      'ru': 'Управляйте отелем из одного пространства BoutiFlow',
      'fr': 'Gérez votre hôtel depuis un espace BoutiFlow',
      'es': 'Gestiona tu hotel desde un espacio BoutiFlow',
    };

    for (final entry in overviewTitles.entries) {
      final slides = buildOnboardingSlides(AppLocalizations(Locale(entry.key)));

      expect(
        slides.first.title,
        entry.value,
        reason: 'overview slide should use ${entry.key} copy',
      );
    }
  });

  test('non-English onboarding slides avoid leftover English UI words', () {
    const forbiddenByLanguage = {
      'de': ['Housekeeping', 'Status', 'Free-Plan', 'Cloud', 'sync'],
      'ru': ['sync'],
      'fr': ['sync', 'cloud'],
      'es': ['offline first', 'sync'],
    };

    for (final entry in forbiddenByLanguage.entries) {
      final slideText =
          buildOnboardingSlides(AppLocalizations(Locale(entry.key)))
              .expand(
                (slide) => [
                  slide.title,
                  slide.subtitle,
                  ...slide.highlights,
                  slide.statValue,
                  slide.statLabel,
                ],
              )
              .join(' ');

      for (final word in entry.value) {
        expect(
          slideText,
          isNot(contains(word)),
          reason: '$word should not remain in ${entry.key} onboarding copy',
        );
      }
    }
  });

  testWidgets('renders the Turkish onboarding tour on a phone viewport',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const OnboardingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1/11'), findsOneWidget);
    expect(find.textContaining('BoutiFlow'), findsWidgets);
    expect(find.text('İLERİ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders localized overview slides on a phone viewport',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const overviewTitles = {
      'en': 'Run your hotel from one BoutiFlow workspace',
      'tr': 'BoutiFlow ile otelinizi tek ekranda yönetin',
      'de': 'Verwalte dein Hotel in einem BoutiFlow-Arbeitsbereich',
      'ru': 'Управляйте отелем из одного пространства BoutiFlow',
      'fr': 'Gérez votre hôtel depuis un espace BoutiFlow',
      'es': 'Gestiona tu hotel desde un espacio BoutiFlow',
    };

    for (final entry in overviewTitles.entries) {
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(entry.key),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsWidgets);
      expect(
        tester.takeException(),
        isNull,
        reason: '${entry.key} overview should fit on a phone viewport',
      );
    }
  });

  testWidgets('returns to language selection from any onboarding slide',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      initialLocation: '/onboarding-intro',
      routes: [
        GoRoute(
          path: '/onboarding-intro',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/language-selection',
          builder: (context, state) => const LanguageSelectionScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('tr'),
        routerConfig: router,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('İLERİ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding-language-back')));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageSelectionScreen), findsOneWidget);
  });
}
