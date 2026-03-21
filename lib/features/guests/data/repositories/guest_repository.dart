import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/guest_model.dart';

/// Repository for managing guests in Supabase.
class GuestRepository {
  final SupabaseClient _client;

  GuestRepository(this._client);

  static const String _tableName = 'guests';

  /// Get all guests for the current user
  Future<List<GuestModel>> getGuests() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('full_name');

    return (response as List)
        .map((json) => GuestModel.fromJson(json))
        .toList();
  }

  /// Search guests by name or phone
  Future<List<GuestModel>> searchGuests(String query) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .or('full_name.ilike.%$query%,phone.ilike.%$query%')
        .order('full_name')
        .limit(20);

    return (response as List)
        .map((json) => GuestModel.fromJson(json))
        .toList();
  }

  /// Get a single guest by ID
  Future<GuestModel?> getGuestById(String guestId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', guestId)
        .maybeSingle();

    if (response == null) return null;
    return GuestModel.fromJson(response);
  }

  /// Find guest by phone number
  Future<GuestModel?> findByPhone(String phone) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .eq('phone', phone)
        .maybeSingle();

    if (response == null) return null;
    return GuestModel.fromJson(response);
  }

  /// Add a new guest
  Future<GuestModel> addGuest(GuestModel guest) async {
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

    // Build explicit payload — do NOT use toJson() as it sends null
    // values which override Supabase DEFAULT values (e.g. created_at DEFAULT NOW())
    final now = DateTime.now().toUtc().toIso8601String();
    final payload = <String, dynamic>{
      'id': guest.id.isEmpty ? _generateUuid() : guest.id,
      'name': guest.fullName,
      'full_name': guest.fullName,
      'created_at': now,
      'updated_at': now,
      'visit_count': 0,
      'total_spent': 0.0,
      'is_blacklisted': false,
      'is_banned': false,
      if (userId != null) 'user_id': userId,
      if (hotelId != null) 'hotel_id': hotelId,
      if (guest.phone != null && guest.phone!.isNotEmpty) 'phone': guest.phone,
      if (guest.email != null && guest.email!.isNotEmpty) 'email': guest.email,
      if (guest.notes != null && guest.notes!.isNotEmpty) 'notes': guest.notes,
      if (guest.nationalId != null && guest.nationalId!.isNotEmpty)
        'national_id': guest.nationalId,
      'language': guest.languageCode,
      'language_code': guest.languageCode,
      'nationality': guest.nationality,
    };

    final response = await _client
        .from(_tableName)
        .insert(payload)
        .select()
        .single();

    return GuestModel.fromJson(response);
  }

  /// Update a guest
  Future<GuestModel> updateGuest(GuestModel guest) async {
    final response = await _client
        .from(_tableName)
        .update(guest.toJson())
        .eq('id', guest.id)
        .select()
        .single();

    return GuestModel.fromJson(response);
  }

  /// Toggle blacklist status
  Future<GuestModel> toggleBlacklist(String guestId, bool isBlacklisted) async {
    final response = await _client
        .from(_tableName)
        .update({
          'is_blacklisted': isBlacklisted,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', guestId)
        .select()
        .single();

    return GuestModel.fromJson(response);
  }

  /// Delete a guest
  Future<void> deleteGuest(String guestId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', guestId);
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
