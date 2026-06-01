import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard quick actions do not duplicate bottom tab destinations', () {
    final source =
        File('lib/features/dashboard/dashboard_page.dart').readAsStringSync();
    final quickActionsStart = source.indexOf('final actions = [');
    final quickActionsEnd = source.indexOf('return GridView.builder');

    expect(quickActionsStart, isNonNegative);
    expect(quickActionsEnd, greaterThan(quickActionsStart));

    final quickActions = source.substring(quickActionsStart, quickActionsEnd);

    expect(quickActions, isNot(contains("route: '/calendar'")));
  });
}
