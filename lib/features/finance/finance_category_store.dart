import 'package:shared_preferences/shared_preferences.dart';

import 'finance_calculations.dart';

class FinanceCategoryStore {
  const FinanceCategoryStore._();

  static String _key(String hotelId) =>
      'boutiflow_custom_expense_categories_$hotelId';

  static Future<List<FinanceCategory>> loadExpenseCategories(
    String hotelId,
  ) async {
    if (hotelId.trim().isEmpty) return const [];
    final prefs = await SharedPreferences.getInstance();
    final labels = prefs.getStringList(_key(hotelId)) ?? const [];
    return labels
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .map(FinanceCategory.custom)
        .toList(growable: false);
  }

  static Future<FinanceCategory?> addExpenseCategory(
    String hotelId,
    String label,
  ) async {
    final cleanHotelId = hotelId.trim();
    final cleanLabel = label.trim();
    if (cleanHotelId.isEmpty || cleanLabel.isEmpty) return null;

    final prefs = await SharedPreferences.getInstance();
    final key = _key(cleanHotelId);
    final existing = prefs
            .getStringList(key)
            ?.map((label) => label.trim())
            .where((label) => label.isNotEmpty)
            .toList() ??
        <String>[];

    final alreadyExists = existing.any(
      (label) => label.toLowerCase() == cleanLabel.toLowerCase(),
    );
    if (!alreadyExists) {
      existing.add(cleanLabel);
      await prefs.setStringList(key, existing);
    }

    return FinanceCategory.custom(cleanLabel);
  }
}
