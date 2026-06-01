import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'boutiflow_service.dart';

class CloudSyncService {
  final BoutiFlowService _localDb;
  static const String _lastSyncKey = 'last_sync_time';

  // Supabase credentials
  static const String _supabaseUrl = 'https://poggjnbcysagdumhszex.supabase.co';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvZ2dqbmJjeXNhZ2R1bWhzemV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNTQ4MDEsImV4cCI6MjA4ODgzMDgwMX0.qH0Z0PWCIVI7nEyNjbX9XiAT6PVj47rW9_zH5zl8us4';

  static bool _initialized = false;

  CloudSyncService(this._localDb);

  SupabaseClient get _client => Supabase.instance.client;

  /// Initialize Supabase (call once at app startup)
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
      );
      _initialized = true;
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Supabase init error: $e');
    }
  }

  /// Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Full sync: push local changes, then pull remote changes
  Future<SyncResult> syncNow(String hotelId) async {
    if (!_initialized) {
      return SyncResult(success: false, error: 'Supabase not initialized');
    }

    try {
      int pushed = 0;
      int pulled = 0;

      // 0. First push hotel data to Supabase
      final hotelData = await _localDb.getHotel();
      if (hotelData != null && hotelData['name'] != null) {
        await _client.from('hotels').upsert({
          'id': hotelId,
          'name': hotelData['name'],
          'currency': hotelData['currency'] ?? 'EUR',
          'default_language': hotelData['languageCode'] ?? 'en',
          'check_in_hour': hotelData['checkInHour'] ?? '14:00',
          'check_out_hour': hotelData['checkOutHour'] ?? '11:00',
          'default_room_price': hotelData['defaultRoomPrice'] ?? 0.0,
          'updated_at': DateTime.now().toIso8601String(),
        });
        pushed++;
        debugPrint('Hotel pushed to Supabase: ${hotelData['name']}');
      }

      // 1. Push local rooms to Supabase
      final localRooms = await _localDb.fetchRooms(hotelId);
      for (final room in localRooms) {
        await _client.from('rooms').upsert({
          'id': room.id,
          'hotel_id': hotelId,
          'name': room.name,
          'capacity': room.capacity,
          'status': room.status.name,
          'sort_order': room.sortOrder,
          'updated_at': DateTime.now().toIso8601String(),
        });
        pushed++;
      }

      // 2. Push local guests to Supabase
      final localGuests = await _localDb.fetchGuests(hotelId);
      for (final guest in localGuests) {
        await _client.from('guests').upsert({
          'id': guest.id,
          'hotel_id': hotelId,
          'name': guest.name,
          'email': guest.email,
          'phone': guest.phone,
          'language': guest.languageCode,
          'visit_count': guest.visitCount,
          'total_spent': guest.totalSpent,
          'is_banned': guest.isBanned,
          'notes': guest.notes,
          'updated_at': DateTime.now().toIso8601String(),
        });
        pushed++;
      }

      // 3. Push local bookings to Supabase
      final localBookings = await _localDb.fetchBookings(hotelId);
      for (final booking in localBookings) {
        await _client.from('bookings').upsert({
          'id': booking.id,
          'hotel_id': hotelId,
          'room_id': booking.room.id,
          'guest_id': booking.guest.id,
          'check_in': booking.checkIn.toIso8601String().substring(0, 10),
          'check_out': booking.checkOut.toIso8601String().substring(0, 10),
          'price_total': booking.priceTotal,
          'status': booking.status.name,
          'payment_status': booking.paymentStatus.name,
          'source': booking.source,
          'notes': booking.notes,
          'updated_at': DateTime.now().toIso8601String(),
        });
        pushed++;
      }

      // 4. Pull remote rooms
      final remoteRooms =
          await _client.from('rooms').select().eq('hotel_id', hotelId);

      for (final row in remoteRooms) {
        // Check if exists locally, if not create it
        final exists = localRooms.any((r) => r.id == row['id']);
        if (!exists) {
          try {
            await _localDb.createRoom(
              row['name'],
              hotelId: hotelId,
              id: row['id'],
              capacity: row['capacity'] ?? 2,
            );
            pulled++;
          } catch (e) {
            debugPrint('Skip room (already exists): ${row["id"]}');
          }
        }
      }

      // 5. Pull remote guests
      final remoteGuests =
          await _client.from('guests').select().eq('hotel_id', hotelId);

      for (final row in remoteGuests) {
        final exists = localGuests.any((g) => g.id == row['id']);
        if (!exists) {
          try {
            await _localDb.createGuest(
              hotelId: hotelId,
              id: row['id'],
              name: row['name'],
              languageCode: row['language'] ?? 'en',
              email: row['email'],
              phone: row['phone'],
              notes: row['notes'],
            );
            pulled++;
          } catch (e) {
            debugPrint('Skip guest (already exists): ${row["id"]}');
          }
        }
      }

      // 6. Update last sync time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);

      debugPrint('Sync completed: pushed=$pushed, pulled=$pulled');
      return SyncResult(
        success: true,
        pushedCount: pushed,
        pulledCount: pulled,
      );
    } catch (e) {
      debugPrint('Sync error: $e');
      return SyncResult(success: false, error: e.toString());
    }
  }

  /// Push hotel data to cloud
  Future<void> pushHotel(String hotelId, String name, String currency) async {
    if (!_initialized) return;

    try {
      await _client.from('hotels').upsert({
        'id': hotelId,
        'name': name,
        'currency': currency,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Push hotel error: $e');
    }
  }

  Future<void> linkCurrentUserToHotel(String hotelId) async {
    if (!_initialized) return;

    final user = _client.auth.currentUser;
    if (user == null) return;

    try {
      await _client.auth.updateUser(
        UserAttributes(data: {
          ...(user.userMetadata ?? const <String, dynamic>{}),
          'boutiflow_hotel_id': hotelId,
        }),
      );
    } catch (e) {
      debugPrint('Link current user to hotel error: $e');
    }
  }

  Future<bool> hasPremiumAccessFromCloud(String hotelId) async {
    if (!_initialized) return false;

    try {
      final rows = await _client
          .from('users')
          .select('plan')
          .eq('hotel_id', hotelId)
          .limit(1);
      if (rows.isEmpty) return false;
      final plan = rows.first['plan']?.toString().toLowerCase();
      return plan == 'premium' || plan == 'pro';
    } catch (e) {
      debugPrint('Premium cloud access check error: $e');
      return false;
    }
  }

  Future<RestoreResult> restoreBusinessProfileFromCloud(
    String targetHotelId,
  ) async {
    if (!_initialized) {
      return RestoreResult(success: false, error: 'Supabase not initialized');
    }

    try {
      final rows = await _client
          .from('hotels')
          .select()
          .eq('id', targetHotelId)
          .limit(1);
      if (rows.isEmpty) {
        return RestoreResult(success: false, error: 'Hotel not found');
      }

      final row = rows.first;
      await _localDb.upsertHotelProfile(
        id: targetHotelId,
        name: row['name']?.toString() ?? 'BoutiFlow',
        languageCode: row['default_language']?.toString() ?? 'en',
        currency: row['currency']?.toString(),
        checkInHour: row['check_in_hour']?.toString(),
        checkOutHour: row['check_out_hour']?.toString(),
        defaultRoomPrice: (row['default_room_price'] as num?)?.toDouble(),
      );

      return RestoreResult(success: true, restoredCount: 1);
    } catch (e) {
      debugPrint('Restore business profile error: $e');
      return RestoreResult(success: false, error: e.toString());
    }
  }

  /// Restore data from cloud by finding hotelId through any existing data
  Future<RestoreResult> restoreFromCloud(String targetHotelId) async {
    if (!_initialized) {
      return RestoreResult(success: false, error: 'Supabase not initialized');
    }

    try {
      int restored = 0;

      // 1. Restore rooms
      final roomsData =
          await _client.from('rooms').select().eq('hotel_id', targetHotelId);

      for (final row in roomsData) {
        try {
          await _localDb.createRoom(
            row['name'],
            hotelId: targetHotelId,
            id: row['id'],
            capacity: row['capacity'] ?? 2,
          );
          restored++;
        } catch (e) {
          debugPrint('Skip room restore (already exists): ${row["id"]}');
        }
      }

      // 2. Restore guests
      final guestsData =
          await _client.from('guests').select().eq('hotel_id', targetHotelId);

      for (final row in guestsData) {
        try {
          await _localDb.createGuest(
            hotelId: targetHotelId,
            id: row['id'],
            name: row['name'],
            languageCode: row['language'] ?? 'en',
            email: row['email'],
            phone: row['phone'],
            notes: row['notes'],
          );
          restored++;
        } catch (e) {
          debugPrint('Skip guest restore (already exists): ${row["id"]}');
        }
      }

      // 3. Restore bookings
      final bookingsData =
          await _client.from('bookings').select().eq('hotel_id', targetHotelId);

      for (final row in bookingsData) {
        try {
          await _localDb.createBooking(
            hotelId: targetHotelId,
            id: row['id'],
            roomId: row['room_id'],
            guestId: row['guest_id'],
            checkIn: DateTime.parse(row['check_in']),
            checkOut: DateTime.parse(row['check_out']),
            price: (row['price_total'] as num?)?.toDouble(),
            source: row['source'] ?? 'direct',
            status: row['status'] ?? 'reserved',
            paymentStatus: row['payment_status'] ?? 'unpaid',
            notes: row['notes'],
          );
          restored++;
        } catch (e) {
          debugPrint('Skip booking restore (already exists): ${row["id"]}');
        }
      }

      return RestoreResult(success: true, restoredCount: restored);
    } catch (e) {
      debugPrint('Restore error: $e');
      return RestoreResult(success: false, error: e.toString());
    }
  }

  /// Find hotelId from cloud by checking existing data
  Future<String?> findHotelIdFromCloud() async {
    if (!_initialized) return null;

    try {
      // Check rooms table for any hotelId
      final roomsData = await _client.from('rooms').select('hotel_id').limit(1);
      if (roomsData.isNotEmpty) {
        return roomsData.first['hotel_id'] as String?;
      }

      // Check guests table
      final guestsData =
          await _client.from('guests').select('hotel_id').limit(1);
      if (guestsData.isNotEmpty) {
        return guestsData.first['hotel_id'] as String?;
      }

      return null;
    } catch (e) {
      debugPrint('Find hotelId error: $e');
      return null;
    }
  }
}

/// Result of restore operation
class RestoreResult {
  final bool success;
  final String? error;
  final int restoredCount;

  RestoreResult({
    required this.success,
    this.error,
    this.restoredCount = 0,
  });
}

/// Result of sync operation
class SyncResult {
  final bool success;
  final String? error;
  final int pushedCount;
  final int pulledCount;

  SyncResult({
    required this.success,
    this.error,
    this.pushedCount = 0,
    this.pulledCount = 0,
  });
}
