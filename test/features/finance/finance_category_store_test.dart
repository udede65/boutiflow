import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/features/finance/finance_category_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('custom expense categories are saved per hotel and deduplicated',
      () async {
    await FinanceCategoryStore.addExpenseCategory('hotel_1', 'Havuz bakimi');
    await FinanceCategoryStore.addExpenseCategory('hotel_1', ' havuz bakimi ');
    await FinanceCategoryStore.addExpenseCategory(
        'hotel_2', 'Personel servisi');

    final hotelOneCategories =
        await FinanceCategoryStore.loadExpenseCategories('hotel_1');
    final hotelTwoCategories =
        await FinanceCategoryStore.loadExpenseCategories('hotel_2');

    expect(hotelOneCategories.map((category) => category.label), [
      'Havuz bakimi',
    ]);
    expect(hotelOneCategories.single.code, 'custom:Havuz bakimi');
    expect(hotelTwoCategories.single.label, 'Personel servisi');
  });
}
