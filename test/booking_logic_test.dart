import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/models/entities.dart';

void main() {
  group('Booking Logic Tests', () {
    test('Booking duration calculation is correct', () {
      final checkIn = DateTime(2023, 10, 1);
      final checkOut = DateTime(2023, 10, 5);
      final booking = Booking(
        id: '1',
        room: const Room(id: 'r1', name: 'Room 1', capacity: 2, status: RoomStatus.clean),
        guest: const Guest(id: 'g1', name: 'John Doe', languageCode: 'en'),
        checkIn: checkIn,
        checkOut: checkOut,
        status: BookingStatus.reserved,
      );

      expect(booking.checkOut.difference(booking.checkIn).inDays, 4);
    });

    test('Booking overlap detection', () {
      final baseBooking = Booking(
        id: '1',
        room: const Room(id: 'r1', name: 'Room 1', capacity: 2, status: RoomStatus.clean),
        guest: const Guest(id: 'g1', name: 'John Doe', languageCode: 'en'),
        checkIn: DateTime(2023, 10, 10),
        checkOut: DateTime(2023, 10, 15),
      );

      // Case 1: No overlap (before)
      final before = baseBooking.copyWith(
        id: '2',
        checkIn: DateTime(2023, 10, 1),
        checkOut: DateTime(2023, 10, 5),
      );
      expect(_hasOverlap(baseBooking, before), false);

      // Case 2: No overlap (after)
      final after = baseBooking.copyWith(
        id: '3',
        checkIn: DateTime(2023, 10, 20),
        checkOut: DateTime(2023, 10, 25),
      );
      expect(_hasOverlap(baseBooking, after), false);

      // Case 3: Overlap (starts inside)
      final overlapStart = baseBooking.copyWith(
        id: '4',
        checkIn: DateTime(2023, 10, 12),
        checkOut: DateTime(2023, 10, 18),
      );
      expect(_hasOverlap(baseBooking, overlapStart), true);

      // Case 4: Overlap (ends inside)
      final overlapEnd = baseBooking.copyWith(
        id: '5',
        checkIn: DateTime(2023, 10, 8),
        checkOut: DateTime(2023, 10, 12),
      );
      expect(_hasOverlap(baseBooking, overlapEnd), true);
      
      // Case 5: Exact match
      final exact = baseBooking.copyWith(id: '6');
      expect(_hasOverlap(baseBooking, exact), true);
    });
  });
}

// Helper function to simulate overlap logic usually found in services
bool _hasOverlap(Booking a, Booking b) {
  if (a.room.id != b.room.id) return false;
  return a.checkIn.isBefore(b.checkOut) && b.checkIn.isBefore(a.checkOut);
}
