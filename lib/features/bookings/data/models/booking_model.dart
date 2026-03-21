import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Booking status enumeration
enum BookingStatus {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('pending')
  pending,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('checked_in')
  checkedIn,
  @JsonValue('checked_out')
  checkedOut,
}

/// Booking model representing reservations from Supabase `bookings` table.
@freezed
abstract class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'guest_id') required String guestId,
    @JsonKey(name: 'check_in') required DateTime checkIn,
    @JsonKey(name: 'check_out') required DateTime checkOut,
    @JsonKey(name: 'total_price') required double totalPrice,
    @Default(BookingStatus.confirmed) BookingStatus status,
    @Default('manual') String source,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
