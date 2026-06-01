import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:roompilot_flutter/core/localization/language_preferences.dart';
import 'package:roompilot_flutter/state/app_state.dart';

void main() {
  test('persists and restores the selected app language', () async {
    SharedPreferences.setMockInitialValues({});

    await LanguagePreferences.saveSelectedLanguage('tr');

    expect(await LanguagePreferences.loadSelectedLanguage(), 'tr');
  });

  test('keeps the selected language when restoring a user session', () {
    expect(resolveSessionLocale('tr', 'en'), 'tr');
    expect(resolveSessionLocale(null, 'de'), 'de');
  });
}
