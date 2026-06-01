import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';
import 'package:roompilot_flutter/features/settings/settings_preferences.dart';

void main() {
  testWidgets('preferences hide theme and show notification toggles',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        theme: _testTheme(),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: SettingsPreferencesList(
            languageLabel: 'Türkçe',
            isPremium: true,
            dailyBookingNotificationsEnabled: true,
            backupRemindersEnabled: true,
            onLanguageTap: () {},
            onDailyBookingNotificationsChanged: (_) {},
            onBackupRemindersChanged: (_) {},
            onBackupRemindersUpgrade: () {},
          ),
        ),
      ),
    );

    expect(find.text('Tema'), findsNothing);
    expect(find.text('Dil'), findsOneWidget);
    expect(find.text('Günlük randevu bildirimleri'), findsOneWidget);
    expect(find.text('Yedekleme Hatırlatmaları'), findsOneWidget);
  });

  testWidgets('free users see backup reminders as a premium upsell',
      (tester) async {
    var upgradeTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        theme: _testTheme(),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: SettingsPreferencesList(
            languageLabel: 'Türkçe',
            isPremium: false,
            dailyBookingNotificationsEnabled: true,
            backupRemindersEnabled: false,
            onLanguageTap: () {},
            onDailyBookingNotificationsChanged: (_) {},
            onBackupRemindersChanged: (_) {},
            onBackupRemindersUpgrade: () => upgradeTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Yedekleme Hatırlatmaları'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(
      find.text('Haftalık yedekleme hatırlatmaları Premium ile açılır.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Yedekleme Hatırlatmaları'));
    expect(upgradeTapped, isTrue);
  });
}

ThemeData _testTheme() => ThemeData(
      useMaterial3: false,
      splashFactory: InkRipple.splashFactory,
    );
