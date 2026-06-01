import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/services/whatsapp_service.dart';

void main() {
  group('WhatsAppService', () {
    test('normalizes Turkish local mobile numbers for wa.me links', () {
      expect(
        WhatsAppService.normalizePhoneForWhatsApp('0555 111 22 33'),
        '905551112233',
      );
      expect(
        WhatsAppService.normalizePhoneForWhatsApp('5551112233'),
        '905551112233',
      );
      expect(
        WhatsAppService.normalizePhoneForWhatsApp('+90 555 111 22 33'),
        '905551112233',
      );
    });

    test('generates encoded WhatsApp message urls', () {
      expect(
        WhatsAppService.generateWhatsAppUrl('0555 111 22 33', 'Merhaba Umut'),
        'https://wa.me/905551112233?text=Merhaba%20Umut',
      );
    });

    test('generates encoded WhatsApp share urls without phone number', () {
      expect(
        WhatsAppService.generateWhatsAppShareUrl('Merhaba Zeynep'),
        'https://wa.me/?text=Merhaba%20Zeynep',
      );
    });
  });
}
