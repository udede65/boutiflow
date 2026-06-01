import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/data/database.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late BoutiFlowService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    service = BoutiFlowService(db);

    await db.into(db.hotels).insert(
          HotelsCompanion.insert(id: 'hotel_1', name: 'Bouti Hotel'),
        );
    await db.into(db.rooms).insert(
          RoomsCompanion.insert(
            id: 'room_1',
            hotelId: 'hotel_1',
            name: 'Oda 1',
          ),
        );
    await db.into(db.rooms).insert(
          RoomsCompanion.insert(
            id: 'room_2',
            hotelId: 'hotel_1',
            name: 'Oda 2',
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_1',
            hotelId: 'hotel_1',
            name: 'Zeynep',
            phone: const Value('05551112233'),
            identityNo: const Value('A123'),
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_2',
            hotelId: 'hotel_1',
            name: 'Umut',
          ),
        );
    await db.into(db.bookings).insert(
          BookingsCompanion.insert(
            id: 'booking_1',
            hotelId: 'hotel_1',
            roomId: 'room_1',
            guestId: 'guest_1',
            checkIn: DateTime(2026, 5, 14),
            checkOut: DateTime(2026, 5, 17),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('blocks overlapping bookings for the same room', () async {
    expect(
      service.createBooking(
        hotelId: 'hotel_1',
        roomId: 'room_1',
        guestId: 'guest_2',
        checkIn: DateTime(2026, 5, 16),
        checkOut: DateTime(2026, 5, 18),
      ),
      throwsA(
        isA<BookingValidationException>().having(
          (error) => error.type,
          'type',
          BookingValidationErrorType.roomConflict,
        ),
      ),
    );
  });

  test('import preflight blocks room conflicts before creating a guest',
      () async {
    expect(
      service.validateBookingCandidate(
        hotelId: 'hotel_1',
        roomId: 'room_1',
        guestId: 'ical_guest_not_saved_yet',
        checkIn: DateTime(2026, 5, 16),
        checkOut: DateTime(2026, 5, 18),
        status: 'reserved',
      ),
      throwsA(
        isA<BookingValidationException>().having(
          (error) => error.type,
          'type',
          BookingValidationErrorType.roomConflict,
        ),
      ),
    );
  });

  test('allows same-room check-in on the previous booking checkout day',
      () async {
    await service.createBooking(
      hotelId: 'hotel_1',
      roomId: 'room_1',
      guestId: 'guest_2',
      checkIn: DateTime(2026, 5, 17),
      checkOut: DateTime(2026, 5, 20),
    );

    final bookings = await service.fetchBookings('hotel_1');
    expect(bookings, hasLength(2));
  });

  test('ignores cancelled bookings while checking room conflicts', () async {
    await (db.update(db.bookings)
          ..where((booking) => booking.id.equals('booking_1')))
        .write(const BookingsCompanion(status: Value('cancelled')));

    await service.createBooking(
      hotelId: 'hotel_1',
      roomId: 'room_1',
      guestId: 'guest_2',
      checkIn: DateTime(2026, 5, 15),
      checkOut: DateTime(2026, 5, 16),
    );

    final bookings = await service.fetchBookings('hotel_1');
    expect(bookings, hasLength(1));
  });

  test('blocks the same guest from overlapping stays in different rooms',
      () async {
    expect(
      service.createBooking(
        hotelId: 'hotel_1',
        roomId: 'room_2',
        guestId: 'guest_1',
        checkIn: DateTime(2026, 5, 15),
        checkOut: DateTime(2026, 5, 16),
      ),
      throwsA(
        isA<BookingValidationException>().having(
          (error) => error.type,
          'type',
          BookingValidationErrorType.guestConflict,
        ),
      ),
    );
  });

  test('blocks overlapping stays for guests sharing phone or identity',
      () async {
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_same_phone',
            hotelId: 'hotel_1',
            name: 'Ayse',
            phone: const Value('05551112233'),
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_same_identity',
            hotelId: 'hotel_1',
            name: 'Mehmet',
            identityNo: const Value('A123'),
          ),
        );

    expect(
      service.createBooking(
        hotelId: 'hotel_1',
        roomId: 'room_2',
        guestId: 'guest_same_phone',
        checkIn: DateTime(2026, 5, 15),
        checkOut: DateTime(2026, 5, 16),
      ),
      throwsA(
        isA<BookingValidationException>().having(
          (error) => error.type,
          'type',
          BookingValidationErrorType.guestConflict,
        ),
      ),
    );

    expect(
      service.createBooking(
        hotelId: 'hotel_1',
        roomId: 'room_2',
        guestId: 'guest_same_identity',
        checkIn: DateTime(2026, 5, 15),
        checkOut: DateTime(2026, 5, 16),
      ),
      throwsA(
        isA<BookingValidationException>().having(
          (error) => error.type,
          'type',
          BookingValidationErrorType.guestConflict,
        ),
      ),
    );
  });

  test('allows overlapping stays for guests with the same name only', () async {
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_same_name',
            hotelId: 'hotel_1',
            name: 'Zeynep',
          ),
        );

    await service.createBooking(
      hotelId: 'hotel_1',
      roomId: 'room_2',
      guestId: 'guest_same_name',
      checkIn: DateTime(2026, 5, 15),
      checkOut: DateTime(2026, 5, 16),
    );

    final bookings = await service.fetchBookings('hotel_1');
    expect(bookings, hasLength(2));
  });

  test('ignores the current booking while validating updates', () async {
    final original =
        (await service.fetchBookings('hotel_1')).singleWhere((booking) {
      return booking.id == 'booking_1';
    });

    await service.updateBooking(original.copyWith(priceTotal: 3000));

    final updated =
        (await service.fetchBookings('hotel_1')).singleWhere((booking) {
      return booking.id == 'booking_1';
    });
    expect(updated.priceTotal, 3000);
  });

  test('blocks bookings with an invalid date range', () async {
    expect(
      service.createBooking(
        hotelId: 'hotel_1',
        roomId: 'room_2',
        guestId: 'guest_2',
        checkIn: DateTime(2026, 5, 20),
        checkOut: DateTime(2026, 5, 20),
      ),
      throwsA(
        isA<BookingValidationException>().having(
          (error) => error.type,
          'type',
          BookingValidationErrorType.invalidDateRange,
        ),
      ),
    );
  });
}
