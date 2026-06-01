import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/features/finance/finance_calculations.dart';

void main() {
  test('finance categories are available for income and expense forms', () {
    expect(financeIncomeCategories.map((category) => category.code), [
      'room',
      'service',
      'food',
      'other',
    ]);
    expect(financeExpenseCategories.map((category) => category.code), [
      'maintenance',
      'cleaning',
      'supplies',
      'utilities',
      'salaries',
      'commission',
      'other',
    ]);
  });

  test(
      'finance totals include reservations, service income, manual income, and expenses',
      () {
    final totals = calculateFinanceTotals(
      bookings: [
        Booking(
          id: 'booking_1',
          room: const Room(
            id: 'room_1',
            name: 'Oda 1',
            capacity: 2,
            status: RoomStatus.clean,
          ),
          guest: const Guest(
            id: 'guest_1',
            name: 'Zeynep',
            languageCode: 'tr',
          ),
          checkIn: DateTime(2026, 5, 10),
          checkOut: DateTime(2026, 5, 11),
          priceTotal: 1000,
        ),
        Booking(
          id: 'booking_cancelled',
          room: const Room(
            id: 'room_2',
            name: 'Oda 2',
            capacity: 2,
            status: RoomStatus.clean,
          ),
          guest: const Guest(
            id: 'guest_2',
            name: 'Umut',
            languageCode: 'tr',
          ),
          checkIn: DateTime(2026, 5, 12),
          checkOut: DateTime(2026, 5, 13),
          priceTotal: 900,
          status: BookingStatus.cancelled,
        ),
      ],
      manualIncome: [
        Expense(
          id: 'income_1',
          description: 'Oda servisi',
          amount: 300,
          date: DateTime(2026, 5, 11),
          category: incomeCategoryCode('service'),
        ),
        Expense(
          id: 'income_2',
          description: 'Minibar',
          amount: 250,
          date: DateTime(2026, 5, 11),
          category: incomeCategoryCode('food'),
        ),
      ],
      expenses: [
        Expense(
          id: 'expense_1',
          description: 'Bakim',
          amount: 150,
          date: DateTime(2026, 5, 12),
          category: 'maintenance',
        ),
      ],
    );

    expect(totals.bookingIncome, 1000);
    expect(totals.roomServiceIncome, 300);
    expect(totals.manualIncome, 550);
    expect(totals.totalIncome, 1550);
    expect(totals.totalExpenses, 150);
    expect(totals.netProfit, 1400);
  });

  test('expense category breakdown ignores income and aggregates expenses', () {
    final breakdown = expenseByCategory([
      Expense(
        id: 'income_1',
        description: 'Room',
        amount: 500,
        date: DateTime(2026, 5, 1),
        category: incomeCategoryCode('room'),
      ),
      Expense(
        id: 'expense_1',
        description: 'Paint',
        amount: 120,
        date: DateTime(2026, 5, 2),
        category: 'maintenance',
      ),
      Expense(
        id: 'expense_2',
        description: 'Repair',
        amount: 80,
        date: DateTime(2026, 5, 3),
        category: 'maintenance',
      ),
    ]);

    expect(breakdown, {'maintenance': 200});
  });

  test('monthly net includes the last six months in chronological order', () {
    final monthly = monthlyNet(
      [
        Payment(
          id: 'payment_1',
          bookingId: 'booking_1',
          amount: 500,
          date: DateTime(2026, 5, 3),
          method: 'card',
          type: 'payment',
        ),
      ],
      [
        Expense(
          id: 'expense_1',
          description: 'Invoice',
          amount: 125,
          date: DateTime(2026, 5, 4),
          category: 'utilities',
        ),
      ],
      now: DateTime(2026, 5, 17),
    );

    expect(monthly.keys, [
      '2025-12',
      '2026-01',
      '2026-02',
      '2026-03',
      '2026-04',
      '2026-05',
    ]);
    expect(monthly['2026-05'], 375);
  });

  test('custom expense category is stored as a displayable synced code', () {
    final category = FinanceCategory.custom('Havuz bakimi');

    expect(category.code, 'custom:Havuz bakimi');
    expect(category.label, 'Havuz bakimi');
    expect(customCategoryLabelFromCode(category.code), 'Havuz bakimi');
  });

  test('finance date ranges cover today, week, month and custom periods', () {
    final now = DateTime(2026, 5, 20, 12);

    expect(
      financeDateRangeForPeriod(FinanceReportPeriod.today, now: now),
      FinanceDateRange(
        start: DateTime(2026, 5, 20),
        endExclusive: DateTime(2026, 5, 21),
      ),
    );
    expect(
      financeDateRangeForPeriod(FinanceReportPeriod.week, now: now),
      FinanceDateRange(
        start: DateTime(2026, 5, 18),
        endExclusive: DateTime(2026, 5, 25),
      ),
    );
    expect(
      financeDateRangeForPeriod(FinanceReportPeriod.month, now: now),
      FinanceDateRange(
        start: DateTime(2026, 5, 1),
        endExclusive: DateTime(2026, 6, 1),
      ),
    );
    expect(
      financeDateRangeForPeriod(
        FinanceReportPeriod.custom,
        now: now,
        customStart: DateTime(2026, 5, 10),
        customEnd: DateTime(2026, 5, 12),
      ),
      FinanceDateRange(
        start: DateTime(2026, 5, 10),
        endExclusive: DateTime(2026, 5, 13),
      ),
    );
  });

  test('finance totals can be filtered by a report date range', () {
    final range = FinanceDateRange(
      start: DateTime(2026, 5, 18),
      endExclusive: DateTime(2026, 5, 25),
    );

    final totals = calculateFinanceTotalsForRange(
      range: range,
      bookings: [
        Booking(
          id: 'booking_in_range',
          room: const Room(
            id: 'room_1',
            name: 'Oda 1',
            capacity: 2,
            status: RoomStatus.clean,
          ),
          guest: const Guest(
            id: 'guest_1',
            name: 'Zeynep',
            languageCode: 'tr',
          ),
          checkIn: DateTime(2026, 5, 18),
          checkOut: DateTime(2026, 5, 20),
          priceTotal: 2000,
        ),
        Booking(
          id: 'booking_out_of_range',
          room: const Room(
            id: 'room_2',
            name: 'Oda 2',
            capacity: 2,
            status: RoomStatus.clean,
          ),
          guest: const Guest(
            id: 'guest_2',
            name: 'Umut',
            languageCode: 'tr',
          ),
          checkIn: DateTime(2026, 5, 30),
          checkOut: DateTime(2026, 6, 1),
          priceTotal: 3000,
        ),
      ],
      payments: const [],
      manualIncome: [
        Expense(
          id: 'income_in_range',
          description: 'Oda servisi',
          amount: 500,
          date: DateTime(2026, 5, 19),
          category: incomeCategoryCode('service'),
        ),
        Expense(
          id: 'income_out_of_range',
          description: 'Minibar',
          amount: 250,
          date: DateTime(2026, 5, 26),
          category: incomeCategoryCode('food'),
        ),
      ],
      expenses: [
        Expense(
          id: 'expense_in_range',
          description: 'Temizlik',
          amount: 300,
          date: DateTime(2026, 5, 20),
          category: 'cleaning',
        ),
        Expense(
          id: 'expense_out_of_range',
          description: 'Bakim',
          amount: 400,
          date: DateTime(2026, 5, 10),
          category: 'maintenance',
        ),
      ],
    );

    expect(totals.bookingIncome, 2000);
    expect(totals.roomServiceIncome, 500);
    expect(totals.manualIncome, 500);
    expect(totals.totalIncome, 2500);
    expect(totals.totalExpenses, 300);
    expect(totals.netProfit, 2200);
  });
}
