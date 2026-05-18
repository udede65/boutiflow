import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/features/settings/legal_page_links.dart';

void main() {
  test('buildLegalPageUri keeps the page name and adds the language code', () {
    final uri = buildLegalPageUri('privacy.html', 'tr');

    expect(uri.toString(),
        'https://udede65.github.io/boutiflow/privacy.html?lang=tr');
  });

  test('buildLegalPageUri falls back to English for unsupported languages', () {
    final uri = buildLegalPageUri('support.html', 'it');

    expect(uri.toString(),
        'https://udede65.github.io/boutiflow/support.html?lang=en');
  });
}
