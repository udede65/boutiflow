// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuestModel _$GuestModelFromJson(Map<String, dynamic> json) => _GuestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      nationalId: json['national_id'] as String?,
      nationality: json['nationality'] as String? ?? 'TR',
      languageCode: json['language_code'] as String? ?? 'tr',
      isBlacklisted: json['is_blacklisted'] as bool? ?? false,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$GuestModelToJson(_GuestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'national_id': instance.nationalId,
      'nationality': instance.nationality,
      'language_code': instance.languageCode,
      'is_blacklisted': instance.isBlacklisted,
      'email': instance.email,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
