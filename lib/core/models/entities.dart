enum BookingStatus { reserved, checkedIn, checkedOut, cancelled }
enum PaymentStatus { unpaid, partial, paid, refunded }

enum RoomStatus { clean, dirty, maintenance }

class RoomType {
  final String id;
  final String name;
  final double price;
  final String? description;

  const RoomType({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });
}

class Room {
  final String id;
  final String name;
  final int capacity;
  final RoomStatus status;
  final int sortOrder;
  final DateTime? updatedAt;
  final RoomType? type; // New

  const Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
    this.sortOrder = 0,
    this.updatedAt,
    this.type,
  });

  Room copyWith({
    String? name,
    int? capacity,
    RoomStatus? status,
    int? sortOrder,
    DateTime? updatedAt,
    RoomType? type,
  }) {
    return Room(
      id: this.id, // Changed from `id: id,` to `id: this.id,` to maintain syntactic correctness as `id` is not a parameter.
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
    );
  }
}

class Guest {
  const Guest({
    required this.id,
    required this.name,
    required this.languageCode,
    this.email,
    this.phone,
    this.visitCount = 0,
    this.totalSpent = 0.0,
    this.isBanned = false,
    this.notes,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String languageCode;
  final String? email;
  final String? phone;
  final int visitCount;
  final double totalSpent;
  final bool isBanned;
  final String? notes; // New
  final DateTime? updatedAt;

  Guest copyWith({
    String? id,
    String? name,
    String? languageCode,
    String? email,
    String? phone,
    int? visitCount,
    double? totalSpent,
    bool? isBanned,
    String? notes,
    DateTime? updatedAt,
  }) {
    return Guest(
      id: id ?? this.id,
      name: name ?? this.name,
      languageCode: languageCode ?? this.languageCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      visitCount: visitCount ?? this.visitCount,
      totalSpent: totalSpent ?? this.totalSpent,
      isBanned: isBanned ?? this.isBanned,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Booking {
  const Booking({
    required this.id,
    required this.room,
    required this.guest,
    required this.checkIn,
    required this.checkOut,
    this.status = BookingStatus.reserved,
    this.paymentStatus = PaymentStatus.unpaid,
    this.priceTotal = 0.0,
    this.source = 'direct',
    this.notes,
    this.updatedAt,
  });

  final String id;
  final Room room;
  final Guest guest;
  final DateTime checkIn;
  final DateTime checkOut;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double? priceTotal;
  final String source; // direct, airbnb, etc.
  final String? notes;
  final DateTime? updatedAt;

  Booking copyWith({
    String? id,
    Room? room,
    Guest? guest,
    DateTime? checkIn,
    DateTime? checkOut,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    double? priceTotal,
    String? source,
    String? notes,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      room: room ?? this.room,
      guest: guest ?? this.guest,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      priceTotal: priceTotal ?? this.priceTotal,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final DateTime date;
  final String method; // cash, card
  final String type; // payment, deposit
  final String? notes;
  final DateTime? updatedAt;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.date,
    required this.method,
    required this.type,
    this.notes,
    this.updatedAt,
  });
}

class DashboardSummary {
  const DashboardSummary({
    required this.todayCheckIns,
    required this.todayCheckOuts,
    required this.occupancy,
    required this.upcoming,
  });

  final List<Booking> todayCheckIns;
  final List<Booking> todayCheckOuts;
  final double occupancy;
  final List<Booking> upcoming;
}

class MessageTemplate {
  const MessageTemplate({
    required this.id,
    this.code = '',
    required this.language,
    required this.title,
    required this.body,
    this.isCustom = false,
  });

  final String id;
  final String code;
  final String language;
  final String title;
  final String body;
  final bool isCustom;
}

class MessageLogEntry {
  const MessageLogEntry({
    required this.id,
    required this.receiver,
    required this.languageCode,
    required this.preview,
    required this.sentAt,
  });

  final String id;
  final String receiver;
  final String languageCode;
  final String preview;
  final DateTime sentAt;
}

class GuestDocument {
  const GuestDocument({
    required this.id,
    required this.guestId,
    required this.filePath,
    this.description,
    required this.createdAt,
  });

  final String id;
  final String guestId;
  final String filePath;
  final String? description;
  final DateTime createdAt;
}

class ReportSummary {
  const ReportSummary({
    required this.totalBookings,
    required this.totalRevenue,
    required this.occupancySeries,
    required this.topGuests,
    required this.monthlyRevenue,
    required this.bookingSources,
    required this.revenueByRoomType,
  });

  final int totalBookings;
  final double totalRevenue;
  final List<double> occupancySeries;
  final List<Guest> topGuests;
  final Map<String, double> monthlyRevenue;
  final Map<String, int> bookingSources;
  final Map<String, double> revenueByRoomType;
}

extension PlanTypeLabel on PlanType {
  String get label => switch (this) {
        PlanType.free => 'Free',
        PlanType.premium => 'Premium',
        PlanType.premiumPlus => 'Premium+',
      };
}

enum PlanType { free, premium, premiumPlus }

class UserProfile {
  const UserProfile({
    required this.hotelId,
    required this.email,
    required this.displayName,
    required this.hotelName,
    required this.languageCode,
    required this.plan,
    this.currency = 'EUR',
    this.checkInHour = '14:00',
    this.checkOutHour = '11:00',
    this.defaultRoomPrice = 0.0,
  });

  final String hotelId;
  final String email;
  final String displayName;
  final String hotelName;
  final String languageCode;
  final PlanType plan;
  final String currency;
  final String checkInHour;
  final String checkOutHour;
  final double defaultRoomPrice;

  UserProfile copyWith({
    String? hotelId,
    String? languageCode,
    PlanType? plan,
    String? currency,
    String? checkInHour,
    String? checkOutHour,
    double? defaultRoomPrice,
  }) {
    return UserProfile(
      hotelId: hotelId ?? this.hotelId,
      email: email,
      displayName: displayName,
      hotelName: hotelName,
      languageCode: languageCode ?? this.languageCode,
      plan: plan ?? this.plan,
      currency: currency ?? this.currency,
      checkInHour: checkInHour ?? this.checkInHour,
      checkOutHour: checkOutHour ?? this.checkOutHour,
      defaultRoomPrice: defaultRoomPrice ?? this.defaultRoomPrice,
    );
  }
}

class Hotel {
  final String id;
  final String name;
  final String currency;
  final String languageCode;
  final String checkInHour; // "14:00"
  final String checkOutHour; // "11:00"
  final double defaultRoomPrice;
  final DateTime? updatedAt;

  const Hotel({
    required this.id,
    required this.name,
    required this.currency,
    required this.languageCode,
    this.checkInHour = '14:00',
    this.checkOutHour = '11:00',
    this.defaultRoomPrice = 0.0,
    this.updatedAt,
  });

  Hotel copyWith({
    String? id,
    String? name,
    String? currency,
    String? languageCode,
    String? checkInHour,
    String? checkOutHour,
    double? defaultRoomPrice,
    DateTime? updatedAt,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      languageCode: languageCode ?? this.languageCode,
      checkInHour: checkInHour ?? this.checkInHour,
      checkOutHour: checkOutHour ?? this.checkOutHour,
      defaultRoomPrice: defaultRoomPrice ?? this.defaultRoomPrice,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Expense {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;

  const Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}

String getCurrencySymbol(String currencyCode) {
  switch (currencyCode) {
    case 'EUR': return '€';
    case 'USD': return '\$';
    case 'TRY': return '₺';
    case 'GBP': return '£';
    case 'RUB': return '₽';
    default: return currencyCode;
  }
}
