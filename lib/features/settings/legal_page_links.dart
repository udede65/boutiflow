import '../../core/localization/app_localizations.dart';

const legalPagesBaseUrl = 'https://udede65.github.io/boutiflow';

Uri buildLegalPageUri(String page, String languageCode) {
  final safeLanguageCode = supportedLanguageCodes.contains(languageCode)
      ? languageCode
      : supportedLanguageCodes.first;

  return Uri.parse('$legalPagesBaseUrl/$page').replace(
    queryParameters: {'lang': safeLanguageCode},
  );
}
