import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';

void main() {
  test('business setup labels are translated for every supported language', () {
    const expectedCopy = {
      'en': {
        'title': 'BUSINESS DETAILS',
        'name': 'Business Name',
        'profile': 'Business profile',
      },
      'tr': {
        'title': 'İŞLETME BİLGİLERİ',
        'name': 'İşletme Adı',
        'profile': 'İşletme profili',
      },
      'de': {
        'title': 'BETRIEBSDETAILS',
        'name': 'Betriebsname',
        'profile': 'Betriebsprofil',
      },
      'ru': {
        'title': 'ДАННЫЕ ОБЪЕКТА',
        'name': 'Название объекта',
        'profile': 'Профиль объекта',
      },
      'fr': {
        'title': 'INFOS ÉTABLISSEMENT',
        'name': "Nom de l'établissement",
        'profile': "Profil de l'établissement",
      },
      'es': {
        'title': 'DATOS DEL NEGOCIO',
        'name': 'Nombre del negocio',
        'profile': 'Perfil del negocio',
      },
    };

    for (final languageCode in supportedLanguageCodes) {
      final l10n = AppLocalizations(Locale(languageCode));
      final expected = expectedCopy[languageCode]!;

      expect(
        l10n.t('onboardingHotelInfoTitle'),
        expected['title'],
        reason: '$languageCode wizard title must fit all property types',
      );
      expect(
        l10n.t('hotelName'),
        expected['name'],
        reason: '$languageCode name field must fit all property types',
      );
      expect(
        l10n.t('hotelProfile'),
        expected['profile'],
        reason: '$languageCode settings profile must fit all property types',
      );
    }
  });
}
