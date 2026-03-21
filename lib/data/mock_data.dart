import '../core/models/entities.dart';

final mockRooms = [
  const Room(id: '101', name: 'Deluxe 101', capacity: 2),
  const Room(id: '102', name: 'Suite 102', capacity: 3),
  const Room(id: '103', name: 'Garden 103', capacity: 2),
];

final mockGuests = [
  const Guest(
    id: 'g1',
    name: 'Ayşe Demir',
    languageCode: 'tr',
    email: 'ayse@example.com',
    visitCount: 3,
    totalSpent: 950,
  ),
  const Guest(
    id: 'g2',
    name: 'Daniel Klein',
    languageCode: 'de',
    email: 'daniel@example.com',
    visitCount: 2,
    totalSpent: 720,
  ),
  const Guest(
    id: 'g3',
    name: 'Elena Popova',
    languageCode: 'ru',
    email: 'elena@example.com',
    visitCount: 5,
    totalSpent: 1400,
  ),
];

final now = DateTime.now();

final mockBookings = [
  Booking(
    id: 'b1',
    room: mockRooms[0],
    guest: mockGuests[0],
    checkIn: DateTime(now.year, now.month, now.day),
    checkOut: DateTime(now.year, now.month, now.day + 2),
    status: BookingStatus.reserved,
    paymentStatus: PaymentStatus.deposit,
    price: 250,
  ),
  Booking(
    id: 'b2',
    room: mockRooms[1],
    guest: mockGuests[1],
    checkIn: DateTime(now.year, now.month, now.day - 1),
    checkOut: DateTime(now.year, now.month, now.day),
    status: BookingStatus.checkedIn,
    paymentStatus: PaymentStatus.partial,
    price: 310,
  ),
  Booking(
    id: 'b3',
    room: mockRooms[2],
    guest: mockGuests[2],
    checkIn: DateTime(now.year, now.month, now.day + 2),
    checkOut: DateTime(now.year, now.month, now.day + 5),
    status: BookingStatus.reserved,
    paymentStatus: PaymentStatus.unpaid,
    price: 450,
  ),
];

final mockTemplates = [
  MessageTemplate(
    id: 't1',
    code: 'checkout_thanks',
    languageCode: 'en',
    title: 'Checkout Thank You',
    body:
        'Dear {{guest_name}}, thank you for staying with us at {{hotel_name}}. We hope to host you again!',
  ),
  MessageTemplate(
    id: 't2',
    code: 'review_request',
    languageCode: 'tr',
    title: 'Yorum Talebi',
    body:
        '{{guest_name}}, {{hotel_name}} konaklamanızdan memnun kaldıysanız kısa bir yorum bırakabilir misiniz?',
  ),
];

final mockLogs = [
  MessageLogEntry(
    id: 'm1',
    receiver: 'Ayşe Demir',
    languageCode: 'tr',
    preview: 'Değerli misafirimiz, yorumunuzu bekliyoruz...',
    sentAt: now.subtract(const Duration(hours: 2)),
  ),
  MessageLogEntry(
    id: 'm2',
    receiver: 'Daniel Klein',
    languageCode: 'de',
    preview: 'Vielen Dank für Ihren Aufenthalt bei uns!',
    sentAt: now.subtract(const Duration(days: 1)),
  ),
];
