import 'package:drift/native.dart';
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

  test('manual income and expenses are stored as separate finance movements',
      () async {
    await db.into(db.hotels).insert(
          HotelsCompanion.insert(id: 'hotel_1', name: 'Bouti Hotel'),
        );

    await service.createIncome(
      hotelId: 'hotel_1',
      description: 'Minibar satışı',
      amount: 500,
      date: DateTime(2026, 5, 14),
      category: 'service',
    );
    await service.createExpense(
      hotelId: 'hotel_1',
      description: 'Temizlik malzemesi',
      amount: 120,
      date: DateTime(2026, 5, 14),
      category: 'supplies',
    );

    final manualIncome = await service.fetchManualIncome(hotelId: 'hotel_1');
    final expenses = await service.fetchExpenses(hotelId: 'hotel_1');
    final movements =
        await service.fetchFinanceTransactions(hotelId: 'hotel_1');

    expect(manualIncome, hasLength(1));
    expect(manualIncome.single.isIncome, isTrue);
    expect(manualIncome.single.description, 'Minibar satışı');

    expect(expenses, hasLength(1));
    expect(expenses.single.isIncome, isFalse);
    expect(expenses.single.description, 'Temizlik malzemesi');

    expect(movements, hasLength(2));
    expect(
      movements.fold<double>(
        0,
        (sum, movement) =>
            sum + (movement.isIncome ? movement.amount : -movement.amount),
      ),
      380,
    );
  });
}
