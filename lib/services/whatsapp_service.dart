import 'package:url_launcher/url_launcher.dart';

/// WhatsApp integration service for sending messages
class WhatsAppService {
  /// Generate WhatsApp deep link URL
  static String generateWhatsAppUrl(String phoneNumber, String message) {
    // Clean phone number (remove spaces, dashes, etc.)
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    
    // Remove leading + if present and ensure it starts with country code
    final phone = cleanPhone.startsWith('+') ? cleanPhone.substring(1) : cleanPhone;
    
    // URL encode the message
    final encodedMessage = Uri.encodeComponent(message);
    
    return 'https://wa.me/$phone?text=$encodedMessage';
  }

  /// Open WhatsApp with pre-filled message
  static Future<bool> sendMessage(String phoneNumber, String message) async {
    final url = generateWhatsAppUrl(phoneNumber, message);
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Open WhatsApp chat without pre-filled message
  static Future<bool> openChat(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final phone = cleanPhone.startsWith('+') ? cleanPhone.substring(1) : cleanPhone;
    
    final uri = Uri.parse('https://wa.me/$phone');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Check if phone number is valid for WhatsApp (basic validation)
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return cleanPhone.length >= 10;
  }
}
