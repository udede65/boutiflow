import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/data/database.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';

void main() {
  late AppDatabase db;
  late BoutiFlowService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = BoutiFlowService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('top guests are calculated from non-cancelled booking totals', () async {
    await db.into(db.hotels).insert(
          HotelsCompanion.insert(id: 'hotel_1', name: 'Bouti Hotel'),
        );
    await db.into(db.rooms).insert(
          RoomsCompanion.insert(
            id: 'room_1',
            hotelId: 'hotel_1',
            name: '101',
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_zeynep',
            hotelId: 'hotel_1',
            name: 'Zeynep',
            visitCount: const Value(0),
            totalSpent: const Value(0),
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_umut',
            hotelId: 'hotel_1',
            name: 'Umut',
            visitCount: const Value(0),
            totalSpent: const Value(0),
          ),
        );

    await db.into(db.bookings).insert(
          BookingsCompanion.insert(
            id: 'booking_1',
            hotelId: 'hotel_1',
            roomId: 'room_1',
            guestId: 'guest_zeynep',
            checkIn: DateTime(2026, 5, 10),
            checkOut: DateTime(2026, 5, 12),
            priceTotal: const Value(3000),
          ),
        );
    await db.into(db.bookings).insert(
          BookingsCompanion.insert(
            id: 'booking_2',
            hotelId: 'hotel_1',
            roomId: 'room_1',
            guestId: 'guest_umut',
            checkIn: DateTime(2026, 5, 13),
            checkOut: DateTime(2026, 5, 14),
            priceTotal: const Value(1000),
            status: const Value('cancelled'),
          ),
        );

    final report = await service.fetchReports('hotel_1');

    expect(report.topGuests, hasLength(1));
    expect(report.topGuests.single.name, 'Zeynep');
    expect(report.topGuests.single.visitCount, 1);
    expect(report.topGuests.single.totalSpent, 3000);
    expect(report.revenueByRoomType, {unassignedRoomTypeReportKey: 3000});
  });

  test('new rooms without a selected type use the hotel default room type',
      () async {
    await db.into(db.hotels).insert(
          HotelsCompanion.insert(
            id: 'hotel_1',
            name: 'Bouti Hotel',
            defaultRoomPrice: const Value(1500),
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_1',
            hotelId: 'hotel_1',
            name: 'Zeynep',
          ),
        );

    await service.createRoom('Oda 1', hotelId: 'hotel_1', id: 'room_1');
    await db.into(db.bookings).insert(
          BookingsCompanion.insert(
            id: 'booking_1',
            hotelId: 'hotel_1',
            roomId: 'room_1',
            guestId: 'guest_1',
            checkIn: DateTime(2026, 5, 10),
            checkOut: DateTime(2026, 5, 12),
            priceTotal: const Value(3000),
          ),
        );

    final report = await service.fetchReports('hotel_1');

    expect(report.revenueByRoomType, {'Standard': 3000});
  });
}
