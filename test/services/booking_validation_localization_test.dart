import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';

void main() {
  test('booking validation errors are translated in every app language', () {
    const keys = [
      'bookingInvalidDateRange',
      'bookingRoomConflict',
      'bookingGuestConflict',
    ];

    for (final languageCode in supportedLanguageCodes) {
      final l10n = AppLocalizations(Locale(languageCode));
      for (final key in keys) {
        expect(
          l10n.t(key),
          isNot(key),
          reason: '$languageCode should translate $key',
        );
      }
    }
  });
}
