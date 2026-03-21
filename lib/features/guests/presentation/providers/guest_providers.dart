import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../providers/repository_providers.dart';
import '../../data/models/guest_model.dart';

part 'guest_providers.g.dart';

/// Provider for guest list (read-only)
@riverpod
Future<List<GuestModel>> guestList(Ref ref) async {
  return ref.watch(guestRepositoryProvider).getGuests();
}

/// Provider for searching guests
@riverpod
Future<List<GuestModel>> guestSearch(Ref ref, String query) async {
  if (query.isEmpty) return [];
  return ref.watch(guestRepositoryProvider).searchGuests(query);
}

/// Provider for a single guest by ID
@riverpod
Future<GuestModel?> guestById(Ref ref, String guestId) async {
  return ref.watch(guestRepositoryProvider).getGuestById(guestId);
}

/// Guest controller for mutations (add, update, delete)
@riverpod
class GuestController extends _$GuestController {
  @override
  FutureOr<void> build() {
    // Initial state is void
  }

  /// Add a new guest
  Future<GuestModel?> addGuest({
    required String fullName,
    String? phone,
    String? nationalId,
    String? nationality,
    String? languageCode,
    String? email,
    String? notes,
  }) async {
    final userId = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final guest = GuestModel(
      id: '',
      userId: userId,
      fullName: fullName,
      phone: phone,
      nationalId: nationalId,
      nationality: nationality ?? 'TR',
      languageCode: languageCode ?? 'tr',
      email: email,
      notes: notes,
    );

    final newGuest = await ref.read(guestRepositoryProvider).addGuest(guest);
    ref.invalidate(guestListProvider);
    return newGuest;
  }

  /// Update an existing guest
  Future<GuestModel> updateGuest(GuestModel guest) async {
    final updatedGuest = await ref.read(guestRepositoryProvider).updateGuest(guest);
    ref.invalidate(guestListProvider);
    ref.invalidate(guestByIdProvider(guest.id));
    return updatedGuest;
  }

  /// Toggle blacklist status
  Future<void> toggleBlacklist(String guestId, bool isBlacklisted) async {
    await ref.read(guestRepositoryProvider).toggleBlacklist(guestId, isBlacklisted);
    ref.invalidate(guestListProvider);
    ref.invalidate(guestByIdProvider(guestId));
  }

  /// Delete a guest
  Future<void> deleteGuest(String guestId) async {
    await ref.read(guestRepositoryProvider).deleteGuest(guestId);
    ref.invalidate(guestListProvider);
  }
}
