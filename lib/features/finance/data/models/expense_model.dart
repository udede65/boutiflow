import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

/// Expense model representing cash transactions from Supabase `expenses` table.
@freezed
abstract class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required double amount,
    required DateTime date,
    String? category,
    String? notes,
    @JsonKey(name: 'is_income') @Default(false) bool isIncome,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
