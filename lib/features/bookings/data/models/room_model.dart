import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

/// Room type enumeration
enum RoomType {
  @JsonValue('room')
  room,
  @JsonValue('bungalow')
  bungalow,
  @JsonValue('tent')
  tent,
}

/// Cleaning status enumeration
enum CleaningStatus {
  @JsonValue('clean')
  clean,
  @JsonValue('dirty')
  dirty,
}

/// Room model representing units from Supabase `rooms` table.
@freezed
abstract class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @Default(RoomType.room) RoomType type,
    @JsonKey(name: 'default_price') @Default(0) double defaultPrice,
    @JsonKey(name: 'color_code') @Default('#3B82F6') String colorCode,
    @JsonKey(name: 'cleaning_status') @Default(CleaningStatus.clean) CleaningStatus cleaningStatus,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
