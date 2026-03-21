import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/services/ical_import_service.dart';

// Manual Mock Client
class MockClient extends Fake implements http.Client {
  final Future<http.Response> Function(Uri url) _handler;

  MockClient(this._handler);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _handler(url);
  }
}

void main() {
  group('IcalImportService', () {
    test('fetchAndParseIcal returns list of bookings on 200 OK with valid iCal data', () async {
      // 1. Arrange
      final room = Room(id: 'r1', name: 'Room 101', capacity: 2, status: RoomStatus.clean);
      final iCalData = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Airbnb Inc//Hosting Calendar 0.8.8//EN
BEGIN:VEVENT
DTEND;VALUE=DATE:2024-12-10
DTSTART;VALUE=DATE:2024-12-08
UID:1234567890
SUMMARY:Reservation
DESCRIPTION:CHECKIN: 08.12.2024\nCHECKOUT: 10.12.2024
END:VEVENT
END:VCALENDAR
''';

      final mockClient = MockClient((url) async {
        return http.Response(iCalData, 200);
      });

      final service = IcalImportService(client: mockClient);

      // 2. Act
      final bookings = await service.fetchAndParseIcal('https://example.com/calendar.ics', room);

      // 3. Assert
      expect(bookings.length, 1);
      final booking = bookings.first;
      expect(booking.id, '1234567890');
      expect(booking.room.id, room.id);
      expect(booking.checkIn.year, 2024);
      expect(booking.checkIn.month, 12);
      expect(booking.checkIn.day, 8);
      expect(booking.checkOut.day, 10);
      expect(booking.guest.name, 'Reservation');
      expect(booking.status, BookingStatus.reserved);
    });

    test('fetchAndParseIcal throws exception on non-200 status code', () async {
      // 1. Arrange
      final mockClient = MockClient((url) async {
        return http.Response('Not Found', 404);
      });
      final service = IcalImportService(client: mockClient);
      final room = Room(id: 'r1', name: 'Room 101', capacity: 2, status: RoomStatus.clean);

      // 2. Act & Assert
      expect(
        () => service.fetchAndParseIcal('https://example.com/calendar.ics', room),
        throwsA(isA<Exception>()),
      );
    });

    test('fetchAndParseIcal ignores invalid components', () async {
       // 1. Arrange
      final room = Room(id: 'r1', name: 'Room 101', capacity: 2, status: RoomStatus.clean);
      final iCalData = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Airbnb Inc//Hosting Calendar 0.8.8//EN
BEGIN:VTODO
SUMMARY:Task
END:VTODO
BEGIN:VEVENT
DTSTART;VALUE=DATE:20241220
SUMMARY:Incomplete Event
END:VEVENT
END:VCALENDAR
''';
      // The VEVENT above is missing DTEND, so it should be skipped (logic check: dtStart != null && dtEnd != null)

      final mockClient = MockClient((url) async {
        return http.Response(iCalData, 200);
      });
      final service = IcalImportService(client: mockClient);

      // 2. Act
      final bookings = await service.fetchAndParseIcal('https://example.com/calendar.ics', room);

      // 3. Assert
      expect(bookings, isEmpty);
    });
  });
}
