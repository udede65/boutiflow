import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';
import 'package:roompilot_flutter/data/database.dart';

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

  test('registerUser persists the selected business currency immediately',
      () async {
    await service.registerUser(
      email: 'owner@boutiflow.app',
      password: 'password',
      hotelName: 'Bouti Bungalow',
      languageCode: 'tr',
      currency: 'TRY',
    );

    final user = await service.loginUser(
      'owner@boutiflow.app',
      'password',
    );

    expect(user, isNotNull);
    expect(user!.currency, 'TRY');
  });
}
