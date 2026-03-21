import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';

/// Repository for managing expenses in Supabase.
class ExpenseRepository {
  final SupabaseClient _client;

  ExpenseRepository(this._client);

  static const String _tableName = 'expenses';

  /// Get all expenses for the current user
  Future<List<ExpenseModel>> getExpenses() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    return (response as List)
        .map((json) => ExpenseModel.fromJson(json))
        .toList();
  }

  /// Get expenses for a date range (for reports)
  Future<List<ExpenseModel>> getExpensesInRange(DateTime start, DateTime end) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .gte('date', start.toUtc().toIso8601String())
        .lte('date', end.toUtc().toIso8601String())
        .order('date', ascending: false);

    return (response as List)
        .map((json) => ExpenseModel.fromJson(json))
        .toList();
  }

  /// Get expenses by category
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .eq('category', category)
        .order('date', ascending: false);

    return (response as List)
        .map((json) => ExpenseModel.fromJson(json))
        .toList();
  }

  /// Add a new expense
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    final response = await _client
        .from(_tableName)
        .insert(expense.toJson())
        .select()
        .single();

    return ExpenseModel.fromJson(response);
  }

  /// Update an expense
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final response = await _client
        .from(_tableName)
        .update(expense.toJson())
        .eq('id', expense.id)
        .select()
        .single();

    return ExpenseModel.fromJson(response);
  }

  /// Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', expenseId);
  }

  /// Get total expenses for a period
  Future<double> getTotalExpenses(DateTime start, DateTime end) async {
    final expenses = await getExpensesInRange(start, end);
    return expenses
        .where((e) => !e.isIncome)
        .fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  /// Get total income for a period
  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    final expenses = await getExpensesInRange(start, end);
    return expenses
        .where((e) => e.isIncome)
        .fold<double>(0.0, (sum, e) => sum + e.amount);
  }
}
