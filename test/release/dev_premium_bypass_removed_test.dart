import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release code has no developer premium bypass', () {
    final paywallProvider =
        File('lib/features/paywall/paywall_provider.dart').readAsStringSync();
    final settingsPage =
        File('lib/features/settings/settings_page.dart').readAsStringSync();

    expect(paywallProvider, isNot(contains('mockPurchase')));
    expect(paywallProvider, isNot(contains('Legacy mock path')));
    expect(
      settingsPage,
      isNot(contains('read(appStateProvider.notifier).upgradePlan')),
    );
  });
}
