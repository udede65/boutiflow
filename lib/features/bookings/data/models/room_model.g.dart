// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type:
          $enumDecodeNullable(_$RoomTypeEnumMap, json['type']) ?? RoomType.room,
      defaultPrice: (json['default_price'] as num?)?.toDouble() ?? 0,
      colorCode: json['color_code'] as String? ?? '#3B82F6',
      cleaningStatus: $enumDecodeNullable(
              _$CleaningStatusEnumMap, json['cleaning_status']) ??
          CleaningStatus.clean,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'type': _$RoomTypeEnumMap[instance.type]!,
      'default_price': instance.defaultPrice,
      'color_code': instance.colorCode,
      'cleaning_status': _$CleaningStatusEnumMap[instance.cleaningStatus]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$RoomTypeEnumMap = {
  RoomType.room: 'room',
  RoomType.bungalow: 'bungalow',
  RoomType.tent: 'tent',
};

const _$CleaningStatusEnumMap = {
  CleaningStatus.clean: 'clean',
  CleaningStatus.dirty: 'dirty',
};
