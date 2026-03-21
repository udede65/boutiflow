import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/models/entities.dart';

class IcalService {
  Future<void> exportRoomCalendar(Room room, List<Booking> bookings) async {
    final icsContent = _generateIcsContent(room, bookings);
    final fileName = '${room.name.replaceAll(' ', '_')}_calendar.ics';
    
    // Save to temporary file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(icsContent);
    
    // Share the file
    await Share.shareXFiles([XFile(file.path)], text: 'Calendar for ${room.name}');
  }

  String _generateIcsContent(Room room, List<Booking> bookings) {
    final buffer = StringBuffer();
    
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//BoutiFlow//BoutiFlow Calendar//EN');
    buffer.writeln('CALSCALE:GREGORIAN');
    buffer.writeln('METHOD:PUBLISH');
    buffer.writeln('X-WR-CALNAME:${room.name} (BoutiFlow)');
    
    for (final booking in bookings) {
      if (booking.status == BookingStatus.cancelled) continue;
      
      buffer.writeln('BEGIN:VEVENT');
      buffer.writeln('UID:${booking.id}');
      buffer.writeln('DTSTAMP:${_formatDateTime(DateTime.now())}');
      buffer.writeln('DTSTART;VALUE=DATE:${_formatDate(booking.checkIn)}');
      buffer.writeln('DTEND;VALUE=DATE:${_formatDate(booking.checkOut)}');
      buffer.writeln('SUMMARY:Booking: ${booking.guest.name}');
      buffer.writeln('DESCRIPTION:Phone: ${booking.guest.phone ?? "N/A"}\\nNotes: ${booking.notes ?? ""}');
      buffer.writeln('STATUS:CONFIRMED');
      buffer.writeln('END:VEVENT');
    }
    
    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  String _formatDateTime(DateTime dt) {
    // Format: YYYYMMDDTHHMMSSZ
    return '${dt.year}${_twoDigits(dt.month)}${_twoDigits(dt.day)}T'
           '${_twoDigits(dt.hour)}${_twoDigits(dt.minute)}${_twoDigits(dt.second)}Z';
  }

  String _formatDate(DateTime dt) {
    // Format: YYYYMMDD (for all-day events)
    return '${dt.year}${_twoDigits(dt.month)}${_twoDigits(dt.day)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}

final icalServiceProvider = IcalService();
