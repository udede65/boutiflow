import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/features/onboarding/onboarding_wizard.dart';

void main() {
  test('Turkish onboarding defaults to Turkish lira', () {
    expect(defaultCurrencyForLanguage('tr'), 'TRY');
  });

  test('Russian onboarding defaults to ruble', () {
    expect(defaultCurrencyForLanguage('ru'), 'RUB');
  });

  test('other supported onboarding languages default to euro', () {
    expect(defaultCurrencyForLanguage('en'), 'EUR');
    expect(defaultCurrencyForLanguage('de'), 'EUR');
    expect(defaultCurrencyForLanguage('fr'), 'EUR');
    expect(defaultCurrencyForLanguage('es'), 'EUR');
  });
}
