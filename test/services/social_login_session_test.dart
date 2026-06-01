import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
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

  test('creates a local user for social login when a hotel already exists',
      () async {
    await db.into(db.hotels).insert(
          HotelsCompanion.insert(
            id: 'hotel_1',
            name: 'Bouti Hotel',
            defaultLanguage: const Value('tr'),
          ),
        );

    final user = await service.restoreOrCreateSocialUser(
      email: 'owner@example.com',
      languageCode: 'tr',
    );

    expect(user, isNotNull);
    expect(user!.email, 'owner@example.com');
    expect(user.hotelId, 'hotel_1');
    expect(user.hotelName, 'Bouti Hotel');
    expect(user.languageCode, 'tr');
  });

  test('creates a social user after a cloud hotel profile is restored',
      () async {
    await db.into(db.hotels).insert(
          HotelsCompanion.insert(
            id: 'cloud_hotel_1',
            name: 'Cloud Hotel',
            defaultLanguage: const Value('en'),
            currency: const Value('USD'),
            checkInHour: const Value('15:00'),
            checkOutHour: const Value('10:00'),
            defaultRoomPrice: const Value(120),
          ),
        );

    final user = await service.restoreOrCreateSocialUser(
      email: null,
      languageCode: 'en',
    );

    expect(user, isNotNull);
    expect(user!.hotelId, 'cloud_hotel_1');
    expect(user.hotelName, 'Cloud Hotel');
    expect(user.email, 'social_cloud_hotel_1@boutiflow.local');
    expect(user.currency, 'USD');
    expect(user.checkInHour, '15:00');
    expect(user.checkOutHour, '10:00');
    expect(user.defaultRoomPrice, 120);
  });
}
