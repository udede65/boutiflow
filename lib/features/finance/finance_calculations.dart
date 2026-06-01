import 'package:intl/intl.dart';

import '../../core/models/entities.dart';

class FinanceCategory {
  const FinanceCategory({
    required this.code,
    required this.labelKey,
    this.label,
  });

  factory FinanceCategory.custom(String label) {
    final cleanLabel = label.trim();
    return FinanceCategory(
      code: 'custom:$cleanLabel',
      labelKey: 'categoryCustom',
      label: cleanLabel,
    );
  }

  final String code;
  final String labelKey;
  final String? label;
}

class FinanceTotals {
  const FinanceTotals({
    required this.bookingIncome,
    required this.roomServiceIncome,
    required this.manualIncome,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netProfit,
  });

  final double bookingIncome;
  final double roomServiceIncome;
  final double manualIncome;
  final double totalIncome;
  final double totalExpenses;
  final double netProfit;
}

enum FinanceReportPeriod { today, week, month, custom }

class FinanceDateRange {
  const FinanceDateRange({
    required this.start,
    required this.endExclusive,
  });

  final DateTime start;
  final DateTime endExclusive;

  bool contains(DateTime value) {
    final date = DateTime(value.year, value.month, value.day);
    return !date.isBefore(start) && date.isBefore(endExclusive);
  }

  @override
  bool operator ==(Object other) =>
      other is FinanceDateRange &&
      start == other.start &&
      endExclusive == other.endExclusive;

  @override
  int get hashCode => Object.hash(start, endExclusive);
}

class FinanceMovement {
  const FinanceMovement({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
  });

  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String category;
}

FinanceDateRange financeDateRangeForPeriod(
  FinanceReportPeriod period, {
  DateTime? now,
  DateTime? customStart,
  DateTime? customEnd,
}) {
  final reference = now ?? DateTime.now();
  final today = DateTime(reference.year, reference.month, reference.day);

  switch (period) {
    case FinanceReportPeriod.today:
      return FinanceDateRange(
        start: today,
        endExclusive: today.add(const Duration(days: 1)),
      );
    case FinanceReportPeriod.week:
      final start = today.subtract(Duration(days: today.weekday - 1));
      return FinanceDateRange(
        start: start,
        endExclusive: start.add(const Duration(days: 7)),
      );
    case FinanceReportPeriod.month:
      final start = DateTime(today.year, today.month);
      return FinanceDateRange(
        start: start,
        endExclusive: DateTime(today.year, today.month + 1),
      );
    case FinanceReportPeriod.custom:
      final startSource = customStart ?? today;
      final endSource = customEnd ?? startSource;
      final start =
          DateTime(startSource.year, startSource.month, startSource.day);
      final end = DateTime(endSource.year, endSource.month, endSource.day);
      if (end.isBefore(start)) {
        return FinanceDateRange(
          start: end,
          endExclusive: start.add(const Duration(days: 1)),
        );
      }
      return FinanceDateRange(
        start: start,
        endExclusive: end.add(const Duration(days: 1)),
      );
  }
}

const financeIncomeCategories = [
  FinanceCategory(code: 'room', labelKey: 'categoryRoom'),
  FinanceCategory(code: 'service', labelKey: 'categoryService'),
  FinanceCategory(code: 'food', labelKey: 'categoryFood'),
  FinanceCategory(code: 'other', labelKey: 'categoryOther'),
];

const financeExpenseCategories = [
  FinanceCategory(code: 'maintenance', labelKey: 'categoryMaintenance'),
  FinanceCategory(code: 'cleaning', labelKey: 'categoryCleaning'),
  FinanceCategory(code: 'supplies', labelKey: 'categorySupplies'),
  FinanceCategory(code: 'utilities', labelKey: 'categoryUtilities'),
  FinanceCategory(code: 'salaries', labelKey: 'categorySalaries'),
  FinanceCategory(code: 'commission', labelKey: 'categoryCommission'),
  FinanceCategory(code: 'other', labelKey: 'categoryOther'),
];

FinanceTotals calculateFinanceTotals({
  List<Payment> payments = const [],
  List<Booking> bookings = const [],
  required List<Expense> manualIncome,
  required List<Expense> expenses,
}) {
  final reservationIncome = reservationIncomeTotal(bookings);
  final bookingIncome =
      reservationIncome > 0 ? reservationIncome : bookingIncomeTotal(payments);
  final roomServiceIncome =
      sumFinanceEntries(manualIncome.where(isRoomServiceIncome).toList());
  final manualIncomeTotal = sumFinanceEntries(manualIncome);
  final totalIncome = bookingIncome + manualIncomeTotal;
  final totalExpenses = sumFinanceEntries(expenses);

  return FinanceTotals(
    bookingIncome: bookingIncome,
    roomServiceIncome: roomServiceIncome,
    manualIncome: manualIncomeTotal,
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    netProfit: totalIncome - totalExpenses,
  );
}

FinanceTotals calculateFinanceTotalsForRange({
  required FinanceDateRange range,
  List<Payment> payments = const [],
  List<Booking> bookings = const [],
  required List<Expense> manualIncome,
  required List<Expense> expenses,
}) {
  return calculateFinanceTotals(
    payments:
        payments.where((payment) => range.contains(payment.date)).toList(),
    bookings:
        bookings.where((booking) => range.contains(booking.checkIn)).toList(),
    manualIncome:
        manualIncome.where((entry) => range.contains(entry.date)).toList(),
    expenses: expenses.where((entry) => range.contains(entry.date)).toList(),
  );
}

List<FinanceMovement> recentFinanceMovements(
  List<Payment> payments,
  List<Expense> transactions, {
  List<Booking> bookings = const [],
  bool incomeOnly = false,
  String bookingPaymentTitle = 'Booking payment',
}) {
  final includePayments = bookings.isEmpty;
  final movements = <FinanceMovement>[
    ...bookings
        .where((booking) =>
            booking.status != BookingStatus.cancelled &&
            (booking.priceTotal ?? 0) > 0)
        .map(
          (booking) => FinanceMovement(
            title: '${booking.guest.name} - ${booking.room.name}',
            amount: booking.priceTotal ?? 0,
            date: booking.checkIn,
            isIncome: true,
            category: 'room',
          ),
        ),
    if (includePayments)
      ...payments.map(
        (payment) => FinanceMovement(
          title: payment.notes?.trim().isNotEmpty == true
              ? payment.notes!.trim()
              : bookingPaymentTitle,
          amount: payment.amount,
          date: payment.date,
          isIncome: payment.type.toLowerCase() != 'refund',
          category: payment.method,
        ),
      ),
    ...transactions.map(
      (transaction) => FinanceMovement(
        title: transaction.description,
        amount: transaction.amount,
        date: transaction.date,
        isIncome: isIncomeEntry(transaction),
        category: normalizedFinanceCategory(transaction.category),
      ),
    ),
  ];

  final filtered = incomeOnly
      ? movements.where((movement) => movement.isIncome).toList()
      : movements;
  filtered.sort((a, b) => b.date.compareTo(a.date));
  return filtered;
}

Map<String, double> monthlyNet(
  List<Payment> payments,
  List<Expense> entries, {
  List<Booking> bookings = const [],
  DateTime? now,
}) {
  final referenceDate = now ?? DateTime.now();
  final keys = List.generate(6, (index) {
    final month =
        DateTime(referenceDate.year, referenceDate.month - (5 - index));
    return DateFormat('yyyy-MM').format(month);
  });
  final totals = {for (final key in keys) key: 0.0};

  if (bookings.isEmpty) {
    for (final payment in payments) {
      final key = DateFormat('yyyy-MM').format(payment.date);
      if (totals.containsKey(key)) {
        totals[key] = totals[key]! +
            (payment.type.toLowerCase() == 'refund'
                ? -payment.amount
                : payment.amount);
      }
    }
  }

  for (final booking in bookings) {
    final total = booking.priceTotal ?? 0;
    if (booking.status == BookingStatus.cancelled || total <= 0) {
      continue;
    }
    final key = DateFormat('yyyy-MM').format(booking.checkIn);
    if (totals.containsKey(key)) {
      totals[key] = totals[key]! + total;
    }
  }

  for (final entry in entries) {
    final key = DateFormat('yyyy-MM').format(entry.date);
    if (totals.containsKey(key)) {
      totals[key] =
          totals[key]! + (isIncomeEntry(entry) ? entry.amount : -entry.amount);
    }
  }

  return totals;
}

Map<String, double> expenseByCategory(List<Expense> transactions) {
  final totals = <String, double>{};
  for (final entry in transactions.where((entry) => !isIncomeEntry(entry))) {
    final category = normalizedFinanceCategory(entry.category);
    totals[category] = (totals[category] ?? 0) + entry.amount;
  }
  return totals;
}

double bookingIncomeTotal(List<Payment> payments) {
  return payments.fold<double>(
    0,
    (sum, payment) =>
        sum +
        (payment.type.toLowerCase() == 'refund'
            ? -payment.amount
            : payment.amount),
  );
}

double reservationIncomeTotal(List<Booking> bookings) {
  return bookings.fold<double>(
    0,
    (sum, booking) => booking.status == BookingStatus.cancelled
        ? sum
        : sum + (booking.priceTotal ?? 0),
  );
}

double sumFinanceEntries(List<Expense> entries) {
  return entries.fold<double>(0, (sum, entry) => sum + entry.amount);
}

const incomeCategoryPrefix = 'income:';

String incomeCategoryCode(String categoryCode) {
  final normalized = normalizedFinanceCategory(categoryCode);
  return '$incomeCategoryPrefix$normalized';
}

bool isIncomeEntry(Expense entry) {
  return entry.category.toLowerCase().startsWith(incomeCategoryPrefix);
}

bool isRoomServiceIncome(Expense entry) {
  return normalizedFinanceCategory(entry.category) == 'service';
}

String normalizedFinanceCategory(String categoryCode) {
  final trimmed = categoryCode.trim();
  if (trimmed.toLowerCase().startsWith(incomeCategoryPrefix)) {
    return trimmed.substring(incomeCategoryPrefix.length).trim().toLowerCase();
  }
  return trimmed.toLowerCase();
}

String? customCategoryLabelFromCode(String categoryCode) {
  const prefix = 'custom:';
  if (!categoryCode.startsWith(prefix)) return null;
  final label = categoryCode.substring(prefix.length).trim();
  return label.isEmpty ? null : label;
}

String financeCategoryLabelKey(String categoryCode) {
  final normalized = categoryCode.toLowerCase();
  for (final category in [
    ...financeIncomeCategories,
    ...financeExpenseCategories,
  ]) {
    if (category.code == normalized) return category.labelKey;
  }
  return 'categoryOther';
}
