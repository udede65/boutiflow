import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

class LanguagePreferences {
  static const selectedLanguageKey = 'selected_language_code';

  static Future<String?> loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(selectedLanguageKey);
    if (code == null || !isSupportedLanguage(code)) {
      return null;
    }
    return code;
  }

  static Future<void> saveSelectedLanguage(String code) async {
    if (!isSupportedLanguage(code)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedLanguageKey, code);
  }

  static bool isSupportedLanguage(String code) =>
      supportedLanguageCodes.contains(code);
}
