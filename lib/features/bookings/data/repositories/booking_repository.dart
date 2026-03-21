import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';

/// Repository for managing bookings in Supabase.
class BookingRepository {
  final SupabaseClient _client;

  BookingRepository(this._client);

  static const String _tableName = 'bookings';

  /// Get all bookings for the current user
  Future<List<BookingModel>> getBookings() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('check_in', ascending: false);

    return (response as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }

  /// Get bookings for a date range (for calendar view)
  Future<List<BookingModel>> getBookingsInRange(DateTime start, DateTime end) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .gte('check_out', start.toUtc().toIso8601String())
        .lte('check_in', end.toUtc().toIso8601String())
        .order('check_in');

    return (response as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }

  /// Get bookings for a specific room
  Future<List<BookingModel>> getBookingsByRoom(String roomId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('room_id', roomId)
        .order('check_in', ascending: false);

    return (response as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }

  /// Get a single booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', bookingId)
        .maybeSingle();

    if (response == null) return null;
    return BookingModel.fromJson(response);
  }

  /// Add a new booking
  Future<BookingModel> addBooking(BookingModel booking) async {
    final response = await _client
        .from(_tableName)
        .insert(booking.toJson())
        .select()
        .single();

    return BookingModel.fromJson(response);
  }

  /// Update a booking
  Future<BookingModel> updateBooking(BookingModel booking) async {
    final response = await _client
        .from(_tableName)
        .update(booking.toJson())
        .eq('id', booking.id)
        .select()
        .single();

    return BookingModel.fromJson(response);
  }

  /// Update booking status (check-in, check-out, cancel)
  Future<BookingModel> updateStatus(String bookingId, BookingStatus status) async {
    final response = await _client
        .from(_tableName)
        .update({
          'status': status.name,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', bookingId)
        .select()
        .single();

    return BookingModel.fromJson(response);
  }

  /// Delete a booking
  Future<void> deleteBooking(String bookingId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', bookingId);
  }

  /// Get today's check-ins
  Future<List<BookingModel>> getTodayCheckIns() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .gte('check_in', startOfDay.toUtc().toIso8601String())
        .lt('check_in', endOfDay.toUtc().toIso8601String())
        .order('check_in');

    return (response as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }

  /// Get today's check-outs
  Future<List<BookingModel>> getTodayCheckOuts() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .gte('check_out', startOfDay.toUtc().toIso8601String())
        .lt('check_out', endOfDay.toUtc().toIso8601String())
        .order('check_out');

    return (response as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }
}
