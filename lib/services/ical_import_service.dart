import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/entities.dart';

class IcalImportService {
  final http.Client _client;
  static const String _icalUrlsKey = 'ical_urls';

  IcalImportService({http.Client? client}) : _client = client ?? http.Client();

  /// Save iCal URL for a specific room
  Future<void> saveIcalUrl(String roomId, String url) async {
    final prefs = await SharedPreferences.getInstance();
    final urlsJson = prefs.getString(_icalUrlsKey) ?? '{}';
    final urls = Map<String, String>.from(jsonDecode(urlsJson));
    urls[roomId] = url;
    await prefs.setString(_icalUrlsKey, jsonEncode(urls));
  }

  /// Get saved iCal URL for a room
  Future<String?> getIcalUrl(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final urlsJson = prefs.getString(_icalUrlsKey) ?? '{}';
    final urls = Map<String, String>.from(jsonDecode(urlsJson));
    return urls[roomId];
  }

  /// Get all saved iCal URLs
  Future<Map<String, String>> getAllIcalUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final urlsJson = prefs.getString(_icalUrlsKey) ?? '{}';
    return Map<String, String>.from(jsonDecode(urlsJson));
  }

  /// Remove iCal URL for a room
  Future<void> removeIcalUrl(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final urlsJson = prefs.getString(_icalUrlsKey) ?? '{}';
    final urls = Map<String, String>.from(jsonDecode(urlsJson));
    urls.remove(roomId);
    await prefs.setString(_icalUrlsKey, jsonEncode(urls));
  }

  /// Fetches an iCal file from the given [url] and parses it into a list of
  /// [Booking] objects for the provided [room].
  Future<List<Booking>> fetchAndParseIcal(String url, Room room) async {
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch calendar: ${response.statusCode}');
    }

    final iCalendar = ICalendar.fromString(response.body);
    final bookings = <Booking>[];

    // iCalendar.data is a List of component maps. Look for VEVENT entries.
    for (final component in iCalendar.data) {
      if (component is Map<String, dynamic> && component['type'] == 'VEVENT') {
        final map = component;
        final dtStart = _parseIcalDate(map['dtstart']);
        final dtEnd = _parseIcalDate(map['dtend']);
        final uid = map['uid'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString();
        final summary = map['summary'] as String? ?? 'External Booking';
        final description = map['description'] as String?;

        if (dtStart != null && dtEnd != null) {
          bookings.add(Booking(
            id: uid,
            room: room,
            guest: Guest(
              id: 'ext_${uid.hashCode}',
              name: summary,
              languageCode: 'en',
              notes: description,
            ),
            checkIn: dtStart,
            checkOut: dtEnd,
            status: BookingStatus.reserved,
            source: 'external',
            priceTotal: 0.0,
          ));
        }
      }
    }

    return bookings;
  }

  /// Check if dates overlap with existing bookings
  bool hasConflict(Booking newBooking, List<Booking> existingBookings) {
    for (final existing in existingBookings) {
      if (existing.room.id != newBooking.room.id) continue;
      if (existing.id == newBooking.id) continue; // Same booking
      
      // Check overlap
      if (newBooking.checkIn.isBefore(existing.checkOut) &&
          newBooking.checkOut.isAfter(existing.checkIn)) {
        return true;
      }
    }
    return false;
  }

  DateTime? _parseIcalDate(dynamic dateData) {
    if (dateData == null) return null;
    if (dateData is IcsDateTime) {
      return dateData.toDateTime();
    } else if (dateData is String) {
      try {
        return DateTime.parse(dateData);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

final icalImportServiceProvider = IcalImportService();
