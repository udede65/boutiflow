import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_model.freezed.dart';
part 'guest_model.g.dart';

/// Guest model representing customers from Supabase `guests` table.
@freezed
abstract class GuestModel with _$GuestModel {
  const factory GuestModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    @JsonKey(name: 'national_id') String? nationalId,
    @Default('TR') String nationality,
    @JsonKey(name: 'language_code') @Default('tr') String languageCode,
    @JsonKey(name: 'is_blacklisted') @Default(false) bool isBlacklisted,
    String? email,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _GuestModel;

  factory GuestModel.fromJson(Map<String, dynamic> json) =>
      _$GuestModelFromJson(json);
}
