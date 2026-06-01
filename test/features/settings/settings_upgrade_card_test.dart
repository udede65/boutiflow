import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/features/settings/settings_page.dart';

void main() {
  test('settings upgrade prompt is shown only for free users', () {
    expect(shouldShowSettingsUpgradePrompt(PlanType.free), isTrue);
    expect(shouldShowSettingsUpgradePrompt(PlanType.premium), isFalse);
    expect(shouldShowSettingsUpgradePrompt(PlanType.premiumPlus), isFalse);
  });
}
