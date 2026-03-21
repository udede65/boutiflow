import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../providers/repository_providers.dart';
import '../../data/models/booking_model.dart';

part 'booking_providers.g.dart';

/// Provider for all bookings (read-only)
@riverpod
Future<List<BookingModel>> bookingList(Ref ref) async {
  return ref.watch(bookingRepositoryProvider).getBookings();
}

/// Provider for bookings in a date range (for calendar)
@riverpod
Future<List<BookingModel>> bookingsInRange(
  Ref ref,
  DateTime start,
  DateTime end,
) async {
  return ref.watch(bookingRepositoryProvider).getBookingsInRange(start, end);
}

/// Provider for bookings by room
@riverpod
Future<List<BookingModel>> bookingsByRoom(Ref ref, String roomId) async {
  return ref.watch(bookingRepositoryProvider).getBookingsByRoom(roomId);
}

/// Provider for a single booking by ID
@riverpod
Future<BookingModel?> bookingById(Ref ref, String bookingId) async {
  return ref.watch(bookingRepositoryProvider).getBookingById(bookingId);
}

/// Provider for today's check-ins
@riverpod
Future<List<BookingModel>> todayCheckIns(Ref ref) async {
  return ref.watch(bookingRepositoryProvider).getTodayCheckIns();
}

/// Provider for today's check-outs
@riverpod
Future<List<BookingModel>> todayCheckOuts(Ref ref) async {
  return ref.watch(bookingRepositoryProvider).getTodayCheckOuts();
}

/// Booking controller for mutations
@riverpod
class BookingController extends _$BookingController {
  @override
  FutureOr<void> build() {
    // Initial state is void
  }

  /// Add a new booking
  Future<BookingModel> addBooking({
    required String roomId,
    required String guestId,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    String source = 'manual',
  }) async {
    final userId = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final booking = BookingModel(
      id: '',
      userId: userId,
      roomId: roomId,
      guestId: guestId,
      checkIn: checkIn.toUtc(),
      checkOut: checkOut.toUtc(),
      totalPrice: totalPrice,
      source: source,
    );

    final newBooking = await ref.read(bookingRepositoryProvider).addBooking(booking);
    _invalidateAll();
    return newBooking;
  }

  /// Update a booking
  Future<BookingModel> updateBooking(BookingModel booking) async {
    final updatedBooking = await ref.read(bookingRepositoryProvider).updateBooking(booking);
    _invalidateAll();
    ref.invalidate(bookingByIdProvider(booking.id));
    return updatedBooking;
  }

  /// Update booking status (check-in, check-out, cancel)
  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    await ref.read(bookingRepositoryProvider).updateStatus(bookingId, status);
    _invalidateAll();
    ref.invalidate(bookingByIdProvider(bookingId));
  }

  /// Quick check-in action
  Future<void> checkIn(String bookingId) async {
    await updateStatus(bookingId, BookingStatus.checkedIn);
  }

  /// Quick check-out action
  Future<void> checkOut(String bookingId) async {
    await updateStatus(bookingId, BookingStatus.checkedOut);
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    await updateStatus(bookingId, BookingStatus.cancelled);
  }

  /// Delete a booking
  Future<void> deleteBooking(String bookingId) async {
    await ref.read(bookingRepositoryProvider).deleteBooking(bookingId);
    _invalidateAll();
  }

  void _invalidateAll() {
    ref.invalidate(bookingListProvider);
    ref.invalidate(todayCheckInsProvider);
    ref.invalidate(todayCheckOutsProvider);
  }
}
