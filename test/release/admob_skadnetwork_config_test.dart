import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iOS Info.plist includes AdMob SKAdNetwork identifiers', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    final ids = RegExp(r'<string>([a-z0-9]+\.skadnetwork)</string>')
        .allMatches(plist)
        .map((match) => match.group(1)!)
        .toSet();

    expect(ids, contains('cstr6suwn9.skadnetwork'));
    expect(ids.length, greaterThanOrEqualTo(49));
  });
}
