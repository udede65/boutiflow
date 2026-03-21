// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingModel _$BookingModelFromJson(Map<String, dynamic> json) =>
    _BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      roomId: json['room_id'] as String,
      guestId: json['guest_id'] as String,
      checkIn: DateTime.parse(json['check_in'] as String),
      checkOut: DateTime.parse(json['check_out'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
          BookingStatus.confirmed,
      source: json['source'] as String? ?? 'manual',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BookingModelToJson(_BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'room_id': instance.roomId,
      'guest_id': instance.guestId,
      'check_in': instance.checkIn.toIso8601String(),
      'check_out': instance.checkOut.toIso8601String(),
      'total_price': instance.totalPrice,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'source': instance.source,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.pending: 'pending',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.checkedIn: 'checked_in',
  BookingStatus.checkedOut: 'checked_out',
};
