import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../providers/repository_providers.dart';
import '../../data/models/expense_model.dart';

part 'expense_providers.g.dart';

/// Provider for expense list (read-only)
@riverpod
Future<List<ExpenseModel>> expenseList(Ref ref) async {
  return ref.watch(expenseRepositoryProvider).getExpenses();
}

/// Provider for expenses in a date range (for reports)
@riverpod
Future<List<ExpenseModel>> expensesInRange(
  Ref ref,
  DateTime start,
  DateTime end,
) async {
  return ref.watch(expenseRepositoryProvider).getExpensesInRange(start, end);
}

/// Provider for expenses by category
@riverpod
Future<List<ExpenseModel>> expensesByCategory(Ref ref, String category) async {
  return ref.watch(expenseRepositoryProvider).getExpensesByCategory(category);
}

/// Provider for total expenses in a period
@riverpod
Future<double> totalExpenses(Ref ref, DateTime start, DateTime end) async {
  return ref.watch(expenseRepositoryProvider).getTotalExpenses(start, end);
}

/// Provider for total income in a period
@riverpod
Future<double> totalIncome(Ref ref, DateTime start, DateTime end) async {
  return ref.watch(expenseRepositoryProvider).getTotalIncome(start, end);
}

/// Expense controller for mutations
@riverpod
class ExpenseController extends _$ExpenseController {
  @override
  FutureOr<void> build() {
    // Initial state is void
  }

  /// Add a new expense
  Future<ExpenseModel> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    String? category,
    String? notes,
    bool isIncome = false,
  }) async {
    final userId = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final expense = ExpenseModel(
      id: '',
      userId: userId,
      title: title,
      amount: amount,
      date: date.toUtc(),
      category: category,
      notes: notes,
      isIncome: isIncome,
    );

    final newExpense = await ref.read(expenseRepositoryProvider).addExpense(expense);
    ref.invalidate(expenseListProvider);
    return newExpense;
  }

  /// Update an expense
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final updatedExpense = await ref.read(expenseRepositoryProvider).updateExpense(expense);
    ref.invalidate(expenseListProvider);
    return updatedExpense;
  }

  /// Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    await ref.read(expenseRepositoryProvider).deleteExpense(expenseId);
    ref.invalidate(expenseListProvider);
  }

  /// Quick add income (from booking payment)
  Future<ExpenseModel> addIncome({
    required String title,
    required double amount,
    String? notes,
  }) async {
    return addExpense(
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: 'Payment',
      notes: notes,
      isIncome: true,
    );
  }
}
