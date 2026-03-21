import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room_model.dart';

/// Repository for managing rooms/units in Supabase.
class RoomRepository {
  final SupabaseClient _client;

  RoomRepository(this._client);

  static const String _tableName = 'rooms';

  /// Get all rooms for the current user
  Future<List<RoomModel>> getRooms() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('name');

    return (response as List)
        .map((json) => RoomModel.fromJson(json))
        .toList();
  }

  /// Get a single room by ID
  Future<RoomModel?> getRoomById(String roomId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', roomId)
        .maybeSingle();

    if (response == null) return null;
    return RoomModel.fromJson(response);
  }

  /// Add a new room
  Future<RoomModel> addRoom(RoomModel room) async {
    final userId = _client.auth.currentUser?.id;

    // Fetch hotel_id for this user (needed by NOT NULL constraint)
    String? hotelId;
    if (userId != null) {
      final hotelRow = await _client
          .from('hotels')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();
      hotelId = hotelRow?['id'] as String?;
    }

    // Build explicit payload to avoid toJson() sending null values
    // that override Supabase DEFAULT values (created_at, status, etc.)
    final now = DateTime.now().toUtc().toIso8601String();
    final payload = <String, dynamic>{
      'id': room.id.isEmpty ? _generateUuid() : room.id,
      'name': room.name,
      'status': room.cleaningStatus == CleaningStatus.clean ? 'clean' : 'dirty',
      'color_code': room.colorCode,
      'type': room.type.name,
      'default_price': room.defaultPrice,
      'created_at': now,
      'updated_at': now,
      if (userId != null) 'user_id': userId,
      if (hotelId != null) 'hotel_id': hotelId,
    };

    final response = await _client
        .from(_tableName)
        .insert(payload)
        .select()
        .single();

    return RoomModel.fromJson(response);
  }


  /// Update a room
  Future<RoomModel> updateRoom(RoomModel room) async {
    final response = await _client
        .from(_tableName)
        .update(room.toJson())
        .eq('id', room.id)
        .select()
        .single();

    return RoomModel.fromJson(response);
  }

  /// Update cleaning status
  Future<RoomModel> updateCleaningStatus(String roomId, CleaningStatus status) async {
    final response = await _client
        .from(_tableName)
        .update({
          'cleaning_status': status.name,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', roomId)
        .select()
        .single();

    return RoomModel.fromJson(response);
  }

  /// Delete a room
  Future<void> deleteRoom(String roomId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', roomId);
  }

  /// Generate a UUID v4 without external dependencies
  String _generateUuid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;
    String hex(int n) => n.toRadixString(16).padLeft(2, '0');
    return '${hex(bytes[0])}${hex(bytes[1])}${hex(bytes[2])}${hex(bytes[3])}-'
        '${hex(bytes[4])}${hex(bytes[5])}-'
        '${hex(bytes[6])}${hex(bytes[7])}-'
        '${hex(bytes[8])}${hex(bytes[9])}-'
        '${hex(bytes[10])}${hex(bytes[11])}${hex(bytes[12])}${hex(bytes[13])}${hex(bytes[14])}${hex(bytes[15])}';
  }
}
