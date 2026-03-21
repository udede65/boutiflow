import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/models/entities.dart';
import 'boutiflow_service.dart';

class BackupService {
  final BoutiFlowService _service;

  BackupService(this._service);

  Future<void> exportData(String hotelId) async {
    final guests = await _service.fetchGuests(hotelId);
    final rooms = await _service.fetchRooms(hotelId);
    final bookings = await _service.fetchBookings(hotelId);

    final data = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'guests': guests.map((g) => {
        'id': g.id,
        'name': g.name,
        'email': g.email,
        'phone': g.phone,
        'language': g.languageCode,
        'visitCount': g.visitCount,
        'totalSpent': g.totalSpent,
        'isBanned': g.isBanned,
      }).toList(),
      'rooms': rooms.map((r) => {
        'id': r.id,
        'name': r.name,
        'capacity': r.capacity,
        'status': r.status,
        'sortOrder': r.sortOrder,
      }).toList(),
      'bookings': bookings.map((b) => {
        'id': b.id,
        'roomId': b.room.id,
        'guestId': b.guest.id,
        'checkIn': b.checkIn.toIso8601String(),
        'checkOut': b.checkOut.toIso8601String(),
        'status': b.status.name,
        'paymentStatus': b.paymentStatus.name,
        'price': b.priceTotal,
        'source': b.source,
      }).toList(),
    };

    final jsonString = jsonEncode(data);
    final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'boutiflow_backup_$dateStr.json';

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonString);

    await Share.shareXFiles([XFile(file.path)], text: 'BoutiFlow Backup');
  }

  Future<void> importData(String hotelId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(content);

      // Basic validation
      if (data['version'] != 1) {
        throw Exception('Unsupported backup version');
      }

      // Import logic
      // 1. Guests
      final guests = (data['guests'] as List).cast<Map<String, dynamic>>();
      for (var g in guests) {
        try {
          await _service.createGuest(
            hotelId: hotelId,
            id: g['id'],
            name: g['name'],
            languageCode: g['language'],
            email: g['email'],
            phone: g['phone'],
          );
          // Update stats if needed, but createGuest initializes to 0. 
          // We might need updateGuest to set stats if we want to restore them perfectly.
          // For now, let's just restore basic info.
          // Actually, let's try to update it immediately to set stats
          await _service.updateGuest(Guest(
            id: g['id'],
            name: g['name'],
            languageCode: g['language'],
            email: g['email'],
            phone: g['phone'],
            visitCount: g['visitCount'] ?? 0,
            totalSpent: (g['totalSpent'] as num?)?.toDouble() ?? 0.0,
            isBanned: g['isBanned'] ?? false,
          ));
        } catch (e) {
          // Ignore duplicates or errors
          print('Error importing guest ${g['id']}: $e');
        }
      }

      // 2. Rooms
      final rooms = (data['rooms'] as List).cast<Map<String, dynamic>>();
      for (var r in rooms) {
        try {
          await _service.createRoom(
            r['name'],
            hotelId: hotelId,
            capacity: r['capacity'] ?? 2,
            id: r['id'],
          );
          // Update status/sortOrder
           await _service.updateRoom(Room(
            id: r['id'],
            name: r['name'],
            capacity: r['capacity'] ?? 2,
            status: RoomStatus.values.firstWhere((e) => e.name == r['status'], orElse: () => RoomStatus.clean),
            sortOrder: r['sortOrder'] ?? 0,
          ));
        } catch (e) {
           print('Error importing room ${r['id']}: $e');
        }
      }

      // 3. Bookings
      final bookings = (data['bookings'] as List).cast<Map<String, dynamic>>();
      for (var b in bookings) {
        try {
          await _service.createBooking(
            hotelId: hotelId,
            id: b['id'],
            roomId: b['roomId'],
            guestId: b['guestId'],
            checkIn: DateTime.parse(b['checkIn']),
            checkOut: DateTime.parse(b['checkOut']),
            price: (b['price'] as num?)?.toDouble(),
            source: b['source'] ?? 'direct',
            status: b['status'] ?? 'reserved',
            paymentStatus: b['paymentStatus'] ?? 'unpaid',
          );
        } catch (e) {
           print('Error importing booking ${b['id']}: $e');
        }
      }
    }
  }
}
