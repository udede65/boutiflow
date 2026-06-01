import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_model.freezed.dart';

/// Guest model representing customers from Supabase `guests` table.
@freezed
abstract class GuestModel with _$GuestModel {
  const GuestModel._();

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

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return _GuestModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      nationality: json['nationality']?.toString() ?? 'TR',
      languageCode: json['language_code']?.toString() ?? 'tr',
      isBlacklisted: json['is_blacklisted'] is bool
          ? json['is_blacklisted'] as bool
          : (json['is_blacklisted']?.toString().toLowerCase() == 'true'),
      email: json['email']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'national_id': nationalId,
      'nationality': nationality,
      'language_code': languageCode,
      'is_blacklisted': isBlacklisted,
      'email': email,
      'notes': notes,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String(),
    };
  }
}
