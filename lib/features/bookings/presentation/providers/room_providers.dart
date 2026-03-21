import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../providers/repository_providers.dart';
import '../../data/models/room_model.dart';

part 'room_providers.g.dart';

/// Provider for room list (read-only)
@riverpod
Future<List<RoomModel>> roomList(Ref ref) async {
  return ref.watch(roomRepositoryProvider).getRooms();
}

/// Provider for a single room by ID
@riverpod
Future<RoomModel?> roomById(Ref ref, String roomId) async {
  return ref.watch(roomRepositoryProvider).getRoomById(roomId);
}

/// Room controller for mutations (add, update, delete)
@riverpod
class RoomController extends _$RoomController {
  @override
  FutureOr<void> build() {
    // Initial state is void
  }

  /// Add a new room
  Future<RoomModel> addRoom({
    required String name,
    RoomType type = RoomType.room,
    double defaultPrice = 0,
    String colorCode = '#3B82F6',
  }) async {
    final userId = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final room = RoomModel(
      id: '',
      userId: userId,
      name: name,
      type: type,
      defaultPrice: defaultPrice,
      colorCode: colorCode,
    );

    final newRoom = await ref.read(roomRepositoryProvider).addRoom(room);
    ref.invalidate(roomListProvider);
    return newRoom;
  }

  /// Update a room
  Future<RoomModel> updateRoom(RoomModel room) async {
    final updatedRoom = await ref.read(roomRepositoryProvider).updateRoom(room);
    ref.invalidate(roomListProvider);
    ref.invalidate(roomByIdProvider(room.id));
    return updatedRoom;
  }

  /// Update cleaning status (quick action for housekeeping)
  Future<void> updateCleaningStatus(String roomId, CleaningStatus status) async {
    await ref.read(roomRepositoryProvider).updateCleaningStatus(roomId, status);
    ref.invalidate(roomListProvider);
    ref.invalidate(roomByIdProvider(roomId));
  }

  /// Delete a room
  Future<void> deleteRoom(String roomId) async {
    await ref.read(roomRepositoryProvider).deleteRoom(roomId);
    ref.invalidate(roomListProvider);
  }
}
