import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/services/pdf_service.dart';

void main() {
  group('PDF currency formatting', () {
    test(
        'uses TL text for Turkish lira because PDF fonts may not render the symbol',
        () {
      expect(formatPdfAmount(3000, '₺'), '3000 TL');
      expect(formatPdfAmount(3000.5, '₺', decimalDigits: 2), '3000.50 TL');
    });

    test('keeps supported currency symbols unchanged', () {
      expect(formatPdfAmount(3000, '€'), '3000 €');
      expect(formatPdfAmount(3000, r'$'), r'3000 $');
    });
  });
}
