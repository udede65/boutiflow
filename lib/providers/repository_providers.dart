import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/settings/data/repositories/profile_repository.dart';
import '../../features/bookings/data/repositories/room_repository.dart';
import '../../features/bookings/data/repositories/booking_repository.dart';
import '../../features/guests/data/repositories/guest_repository.dart';
import '../../features/finance/data/repositories/expense_repository.dart';

part 'repository_providers.g.dart';

/// Supabase client provider
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Profile repository provider
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
}

/// Room repository provider
@riverpod
RoomRepository roomRepository(Ref ref) {
  return RoomRepository(ref.watch(supabaseClientProvider));
}

/// Booking repository provider
@riverpod
BookingRepository bookingRepository(Ref ref) {
  return BookingRepository(ref.watch(supabaseClientProvider));
}

/// Guest repository provider
@riverpod
GuestRepository guestRepository(Ref ref) {
  return GuestRepository(ref.watch(supabaseClientProvider));
}

/// Expense repository provider
@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepository(ref.watch(supabaseClientProvider));
}
