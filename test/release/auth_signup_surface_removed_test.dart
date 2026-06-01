import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release app does not expose the legacy email password signup surface',
      () {
    final router = File('lib/router/app_router.dart').readAsStringSync();
    final onboarding = File('lib/features/onboarding/onboarding_wizard.dart')
        .readAsStringSync();

    expect(router, isNot(contains('signup_page.dart')));
    expect(router, contains('OnboardingWizard'));

    expect(onboarding, isNot(contains('_passwordController')));
    expect(onboarding, isNot(contains("password: 'socialauth'")));
    expect(onboarding, isNot(contains("'user@hotel.app'")));
    expect(onboarding, isNot(contains('_buildAccountStep')));
  });
}
