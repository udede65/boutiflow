import 'package:icalendar_parser/icalendar_parser.dart';

void main() {
  final iCalData = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Airbnb Inc//Hosting Calendar 0.8.8//EN
BEGIN:VEVENT
DTEND;VALUE=DATE:2024-12-10
DTSTART;VALUE=DATE:2024-12-08
UID:1234567890
SUMMARY:Reservation
DESCRIPTION:CHECKIN: 08.12.2024\nCHECKOUT: 10.12.2024
END:VEVENT
END:VCALENDAR
''';

  final iCalendar = ICalendar.fromString(iCalData);
  print('Parsed Data: ${iCalendar.data}');
  if (iCalendar.data is List) {
    for (final item in iCalendar.data) {
      print('Item: $item');
      if (item is Map) {
        print('DTSTART: ${item['DTSTART']} (${item['DTSTART'].runtimeType})');
        print('DTEND: ${item['DTEND']} (${item['DTEND'].runtimeType})');
      }
    }
  }
}
