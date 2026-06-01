import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/models/entities.dart' as entities;
import '../data/database.dart';
import 'notification_service.dart';

class BoutiFlowService {
  final AppDatabase db;
  static const _incomeCategoryPrefix = 'income:';

  BoutiFlowService(this.db);

  Future<entities.DashboardSummary> fetchDashboard(String hotelId) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final notCancelled = db.bookings.status.equals('cancelled').not();

    // Fetch today's check-ins (filtered by hotelId)
    final checkInsQuery = db.select(db.bookings).join([
      innerJoin(db.rooms, db.rooms.id.equalsExp(db.bookings.roomId)),
      innerJoin(db.guests, db.guests.id.equalsExp(db.bookings.guestId)),
    ])
      ..where(
        db.bookings.hotelId.equals(hotelId) &
            db.bookings.checkIn.isBiggerOrEqualValue(todayStart) &
            db.bookings.checkIn.isSmallerThanValue(todayEnd) &
            notCancelled,
      );

    final checkInsRows = await checkInsQuery.get();
    final checkIns = checkInsRows.map((row) => _mapBooking(row)).toList();

    // Fetch today's check-outs (filtered by hotelId)
    final checkOutsQuery = db.select(db.bookings).join([
      innerJoin(db.rooms, db.rooms.id.equalsExp(db.bookings.roomId)),
      innerJoin(db.guests, db.guests.id.equalsExp(db.bookings.guestId)),
    ])
      ..where(
        db.bookings.hotelId.equals(hotelId) &
            db.bookings.checkOut.isBiggerOrEqualValue(todayStart) &
            db.bookings.checkOut.isSmallerThanValue(todayEnd) &
            notCancelled,
      );

    final checkOutsRows = await checkOutsQuery.get();
    final checkOuts = checkOutsRows.map((row) => _mapBooking(row)).toList();

    // Calculate occupancy (filtered by hotelId)
    final totalRooms = (await (db.select(db.rooms)
              ..where((t) => t.hotelId.equals(hotelId)))
            .get())
        .length;
    final activeBookings = await (db.select(db.bookings)
          ..where((t) =>
              t.hotelId.equals(hotelId) &
              t.checkIn.isSmallerOrEqualValue(now) &
              t.checkOut.isBiggerThanValue(now) &
              t.status.equals('cancelled').not() &
              t.status.equals('checkedOut').not()))
        .get();

    final occupancy =
        totalRooms > 0 ? (activeBookings.length / totalRooms) * 100 : 0.0;

    // Fetch upcoming bookings (filtered by hotelId)
    final upcomingQuery = db.select(db.bookings).join([
      innerJoin(db.rooms, db.rooms.id.equalsExp(db.bookings.roomId)),
      innerJoin(db.guests, db.guests.id.equalsExp(db.bookings.guestId)),
    ])
      ..where(
        db.bookings.hotelId.equals(hotelId) &
            db.bookings.checkIn.isBiggerThanValue(now) &
            notCancelled,
      )
      ..orderBy([OrderingTerm(expression: db.bookings.checkIn)]);

    final upcomingRows = await upcomingQuery.get();
    final upcoming = upcomingRows.map((row) => _mapBooking(row)).toList();

    return entities.DashboardSummary(
      todayCheckIns: checkIns,
      todayCheckOuts: checkOuts,
      occupancy: occupancy,
      upcoming: upcoming,
    );
  }

  Future<List<entities.Booking>> fetchBookings(String hotelId) async {
    final query = db.select(db.bookings).join([
      innerJoin(db.rooms, db.rooms.id.equalsExp(db.bookings.roomId)),
      innerJoin(db.guests, db.guests.id.equalsExp(db.bookings.guestId)),
    ])
      ..where(db.bookings.hotelId.equals(hotelId));

    final rows = await query.get();
    return rows.map((row) => _mapBooking(row)).toList();
  }

  Future<List<entities.Guest>> fetchGuests(String hotelId) async {
    final guests = await (db.select(db.guests)
          ..where((t) => t.hotelId.equals(hotelId)))
        .get();
    return guests
        .map((g) => entities.Guest(
              id: g.id,
              name: g.name,
              languageCode: g.language ?? 'en',
              email: g.email,
              phone: g.phone,
              visitCount: g.visitCount,
              totalSpent: g.totalSpent,
              isBanned: g.isBanned,
              notes: g.notes,
              updatedAt: g.updatedAt,
            ))
        .toList();
  }

  Future<List<entities.Room>> fetchRooms(String hotelId) async {
    final query = db.select(db.rooms).join([
      leftOuterJoin(
          db.roomTypes, db.roomTypes.id.equalsExp(db.rooms.roomTypeId)),
    ])
      ..where(db.rooms.hotelId.equals(hotelId));

    final rows = await query.get();

    return rows.map((row) {
      final room = row.readTable(db.rooms);
      final type = row.readTableOrNull(db.roomTypes);

      return entities.Room(
        id: room.id,
        name: room.name,
        capacity: room.capacity,
        status: entities.RoomStatus.values.firstWhere(
            (e) => e.name == room.status,
            orElse: () => entities.RoomStatus.clean),
        sortOrder: room.sortOrder,
        updatedAt: room.updatedAt,
        type: type != null
            ? entities.RoomType(
                id: type.id,
                name: type.name,
                price: type.price,
                description: type.description,
              )
            : null,
      );
    }).toList();
  }

  // Helper to map joined rows to Booking entity
  entities.Booking _mapBooking(TypedResult row) {
    final booking = row.readTable(db.bookings);
    final room = row.readTable(db.rooms);
    final guest = row.readTable(db.guests);

    return entities.Booking(
      id: booking.id,
      room: entities.Room(
        id: room.id,
        name: room.name,
        capacity: room.capacity,
        status: entities.RoomStatus.values.firstWhere(
            (e) => e.name == room.status,
            orElse: () => entities.RoomStatus.clean),
        sortOrder: room.sortOrder,
      ),
      guest: entities.Guest(
        id: guest.id,
        name: guest.name,
        languageCode: guest.language ?? 'en',
        email: guest.email,
        phone: guest.phone,
        isBanned: guest.isBanned,
      ),
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      status: _mapStatus(booking.status),
      paymentStatus: _mapPaymentStatus(booking.paymentStatus),
      priceTotal: booking.priceTotal ?? 0.0,
      source: booking.source,
      updatedAt: booking.updatedAt,
    );
  }

  entities.BookingStatus _mapStatus(String status) {
    return entities.BookingStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => entities.BookingStatus.reserved,
    );
  }

  entities.PaymentStatus _mapPaymentStatus(String status) {
    return entities.PaymentStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => entities.PaymentStatus.unpaid,
    );
  }

  // ... (enums mapping remains same)

  Future<List<entities.MessageTemplate>> fetchTemplates() async {
    final templates = await db.select(db.messageTemplates).get();
    return templates
        .map((t) => entities.MessageTemplate(
              id: t.id,
              code: t.code,
              title: t.title,
              body: t.body,
              language: t.language,
              isCustom: t.isCustom,
            ))
        .toList();
  }

  Future<void> createTemplate({
    required String hotelId,
    required String title,
    required String body,
    required String language,
  }) async {
    await db.into(db.messageTemplates).insert(MessageTemplatesCompanion.insert(
          id: _uuid(),
          hotelId: Value(hotelId),
          code: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          language: language,
          title: title,
          body: body,
          isCustom: const Value(true),
        ));
  }

  Future<void> updateTemplate(entities.MessageTemplate template) async {
    await (db.update(db.messageTemplates)
          ..where((t) => t.id.equals(template.id)))
        .write(
      MessageTemplatesCompanion(
        title: Value(template.title),
        body: Value(template.body),
        language: Value(template.language),
      ),
    );
  }

  Future<void> deleteTemplate(String templateId) async {
    await (db.delete(db.messageTemplates)
          ..where((t) => t.id.equals(templateId)))
        .go();
  }

  Future<List<entities.MessageLogEntry>> fetchMessageLogs() async {
    final query = db.select(db.messagesLog).join([
      leftOuterJoin(db.guests, db.guests.id.equalsExp(db.messagesLog.guestId)),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final log = row.readTable(db.messagesLog);
      final guest = row.readTableOrNull(db.guests);

      return entities.MessageLogEntry(
        id: log.id,
        receiver: guest?.name ?? 'Unknown Guest',
        languageCode: log.language,
        preview: log.renderedBody,
        sentAt: log.createdAt,
      );
    }).toList();
  }

  Future<entities.ReportSummary> fetchReports(String hotelId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    // 1. Total Revenue (Monthly) - filtered by hotelId
    final monthlyBookings = await (db.select(db.bookings)
          ..where((t) =>
              t.hotelId.equals(hotelId) &
              t.checkIn.isBiggerOrEqualValue(startOfMonth)))
        .get();

    double totalRevenue = 0;
    for (var b in monthlyBookings) {
      totalRevenue += b.priceTotal ?? 0;
    }

    // 2. Total Bookings - filtered by hotelId
    final allBookingsCount = (await (db.select(db.bookings)
              ..where((t) => t.hotelId.equals(hotelId)))
            .get())
        .length;

    // 3. Top Guests - filtered by hotelId
    final guests = await (db.select(db.guests)
          ..where((t) => t.hotelId.equals(hotelId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.totalSpent, mode: OrderingMode.desc)
          ])
          ..limit(5))
        .get();

    final topGuests = guests
        .map((g) => entities.Guest(
              id: g.id,
              name: g.name,
              languageCode: g.language ?? 'en',
              email: g.email,
              phone: g.phone,
              visitCount: g.visitCount,
              totalSpent: g.totalSpent,
              isBanned: g.isBanned,
              updatedAt: g.updatedAt,
            ))
        .toList();

    // 4. Occupancy Series (Last 7 days) - filtered by hotelId
    List<double> occupancySeries = [];
    final totalRooms = (await (db.select(db.rooms)
              ..where((t) => t.hotelId.equals(hotelId)))
            .get())
        .length;

    if (totalRooms > 0) {
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final activeBookings = await (db.select(db.bookings)
              ..where((t) =>
                  t.hotelId.equals(hotelId) &
                  t.checkIn.isSmallerOrEqualValue(date) &
                  t.checkOut.isBiggerOrEqualValue(date)))
            .get();

        occupancySeries.add((activeBookings.length / totalRooms) * 100);
      }
    } else {
      occupancySeries = List.filled(7, 0.0);
    }

    // 5. Booking Sources Distribution - filtered by hotelId
    final Map<String, int> bookingSources = {};
    final allBookings = await (db.select(db.bookings)
          ..where((t) => t.hotelId.equals(hotelId)))
        .get();
    for (var b in allBookings) {
      bookingSources[b.source] = (bookingSources[b.source] ?? 0) + 1;
    }

    // 6. Revenue by Room Type - filtered by hotelId
    final Map<String, double> revenueByRoomType = {};

    final revenueQuery = db.select(db.bookings).join([
      innerJoin(db.rooms, db.rooms.id.equalsExp(db.bookings.roomId)),
      leftOuterJoin(
          db.roomTypes, db.roomTypes.id.equalsExp(db.rooms.roomTypeId)),
    ])
      ..where(db.bookings.hotelId.equals(hotelId));

    final revenueRows = await revenueQuery.get();

    for (var row in revenueRows) {
      final booking = row.readTable(db.bookings);
      final roomType = row.readTableOrNull(db.roomTypes);

      final typeName = roomType?.name ?? 'Unknown';
      final price = booking.priceTotal ?? 0.0;

      revenueByRoomType[typeName] = (revenueByRoomType[typeName] ?? 0) + price;
    }

    return entities.ReportSummary(
      totalBookings: allBookingsCount,
      totalRevenue: totalRevenue,
      occupancySeries: occupancySeries,
      topGuests: topGuests,
      monthlyRevenue: {}, // Placeholder
      bookingSources: bookingSources,
      revenueByRoomType: revenueByRoomType,
    );
  }

  Future<void> createGuest({
    required String hotelId,
    String? id,
    required String name,
    required String languageCode,
    String? email,
    String? phone,
    String? notes,
  }) async {
    await db.into(db.guests).insert(GuestsCompanion.insert(
          id: id ?? _uuid(),
          hotelId: hotelId,
          name: name,
          language: Value(languageCode),
          email: Value(email),
          phone: Value(phone),
          visitCount: const Value(0),
          totalSpent: const Value(0),
          isBanned: const Value(false),
          notes: Value(notes),
          updatedAt: Value(DateTime.now()),
        ));
  }

  Future<void> updateGuest(entities.Guest guest) async {
    await (db.update(db.guests)..where((t) => t.id.equals(guest.id))).write(
      GuestsCompanion(
        name: Value(guest.name),
        language: Value(guest.languageCode),
        email: Value(guest.email),
        phone: Value(guest.phone),
        visitCount: Value(guest.visitCount),
        totalSpent: Value(guest.totalSpent),
        isBanned: Value(guest.isBanned),
        notes: Value(guest.notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteGuest(String guestId) async {
    await (db.delete(db.guests)..where((t) => t.id.equals(guestId))).go();
  }

  Future<List<entities.RoomType>> fetchRoomTypes() async {
    final types = await db.select(db.roomTypes).get();
    return types
        .map((t) => entities.RoomType(
              id: t.id,
              name: t.name,
              price: t.price,
              description: t.description,
            ))
        .toList();
  }

  Future<void> createRoomType({
    required String hotelId,
    required String name,
    required double price,
    String? description,
  }) async {
    await db.into(db.roomTypes).insert(RoomTypesCompanion.insert(
          id: _uuid(),
          hotelId: hotelId,
          name: name,
          price: Value(price),
          description: Value(description),
        ));
  }

  Future<void> updateRoomType(entities.RoomType type) async {
    await (db.update(db.roomTypes)..where((t) => t.id.equals(type.id))).write(
      RoomTypesCompanion(
        name: Value(type.name),
        price: Value(type.price),
        description: Value(type.description),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteRoomType(String id) async {
    // Check if used
    final used = await (db.select(db.rooms)
          ..where((t) => t.roomTypeId.equals(id)))
        .get();
    if (used.isNotEmpty) {
      throw Exception(
          'Cannot delete room type currently in use by ${used.length} rooms.');
    }
    await (db.delete(db.roomTypes)..where((t) => t.id.equals(id))).go();
  }

  Future<void> createRoom(String name,
      {required String hotelId,
      String? id,
      int capacity = 2,
      entities.RoomStatus status = entities.RoomStatus.clean,
      String? roomTypeId}) async {
    await db.into(db.rooms).insert(
          RoomsCompanion.insert(
            id: id ?? _uuid(),
            hotelId: hotelId,
            name: name,
            capacity: Value(capacity),
            status: Value(status.name),
            roomTypeId: Value(roomTypeId),
          ),
        );
  }

  Future<void> updateRoom(entities.Room room) async {
    await (db.update(db.rooms)..where((t) => t.id.equals(room.id))).write(
      RoomsCompanion(
        name: Value(room.name),
        capacity: Value(room.capacity),
        status: Value(room.status.name),
        sortOrder: Value(room.sortOrder),
        roomTypeId: Value(room.type?.id),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteRoom(String roomId) async {
    await (db.delete(db.rooms)..where((t) => t.id.equals(roomId))).go();
  }

  // ... (deleteRoom remains same)

  Future<void> updateHotelProfile({
    required String name,
    required String languageCode,
    String? currency,
    String? checkInHour,
    String? checkOutHour,
    double? defaultRoomPrice,
  }) async {
    final hotel = await (db.select(db.hotels)..limit(1)).getSingleOrNull();
    if (hotel != null) {
      await (db.update(db.hotels)..where((t) => t.id.equals(hotel.id))).write(
        HotelsCompanion(
          name: Value(name),
          defaultLanguage: Value(languageCode),
          currency: currency != null ? Value(currency) : const Value.absent(),
          checkInHour:
              checkInHour != null ? Value(checkInHour) : const Value.absent(),
          checkOutHour:
              checkOutHour != null ? Value(checkOutHour) : const Value.absent(),
          defaultRoomPrice: defaultRoomPrice != null
              ? Value(defaultRoomPrice)
              : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> upsertHotelProfile({
    required String id,
    required String name,
    required String languageCode,
    String? currency,
    String? checkInHour,
    String? checkOutHour,
    double? defaultRoomPrice,
  }) async {
    await db.into(db.hotels).insertOnConflictUpdate(
          HotelsCompanion.insert(
            id: id,
            name: name,
            defaultLanguage: Value(languageCode),
            currency: Value(currency ?? 'EUR'),
            checkInHour: Value(checkInHour ?? '14:00'),
            checkOutHour: Value(checkOutHour ?? '11:00'),
            defaultRoomPrice: Value(defaultRoomPrice ?? 0.0),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Fetch hotel profile from DB
  Future<Map<String, dynamic>?> getHotel() async {
    final hotel = await (db.select(db.hotels)..limit(1)).getSingleOrNull();
    if (hotel == null) return null;
    return {
      'id': hotel.id,
      'name': hotel.name,
      'currency': hotel.currency,
      'checkInHour': hotel.checkInHour,
      'checkOutHour': hotel.checkOutHour,
      'defaultRoomPrice': hotel.defaultRoomPrice,
      'defaultLanguage': hotel.defaultLanguage,
    };
  }

  Future<void> createBooking({
    required String hotelId,
    String? id,
    required String roomId,
    required String guestId,
    required DateTime checkIn,
    required DateTime checkOut,
    double? price,
    String source = 'direct',
    String status = 'reserved',
    String paymentStatus = 'unpaid',
    String? notes,
  }) async {
    final bookingId = id ?? _uuid();
    await db.into(db.bookings).insert(BookingsCompanion.insert(
          id: bookingId,
          hotelId: hotelId,
          roomId: roomId,
          guestId: guestId,
          checkIn: checkIn,
          checkOut: checkOut,
          priceTotal: Value(price),
          status: Value(status),
          paymentStatus: Value(paymentStatus),
          source: Value(source),
          notes: Value(notes),
          updatedAt: Value(DateTime.now()),
        ));

    // Schedule Notification
    try {
      final row = await (db.select(db.bookings).join([
        innerJoin(db.rooms, db.rooms.id.equalsExp(db.bookings.roomId)),
        innerJoin(db.guests, db.guests.id.equalsExp(db.bookings.guestId)),
      ])
            ..where(db.bookings.id.equals(bookingId)))
          .getSingle();

      final bookingEntity = _mapBooking(row);
      await notificationServiceProvider
          .scheduleBookingNotifications(bookingEntity);
    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
    }
  }

  Future<void> updateBooking(entities.Booking booking) async {
    await (db.update(db.bookings)..where((t) => t.id.equals(booking.id))).write(
      BookingsCompanion(
        roomId: Value(booking.room.id),
        guestId: Value(booking.guest.id),
        checkIn: Value(booking.checkIn),
        checkOut: Value(booking.checkOut),
        priceTotal: Value(booking.priceTotal),
        status: Value(booking.status.name),
        paymentStatus: Value(booking.paymentStatus.name),
        source: Value(booking.source),
        notes: Value(booking.notes),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Recalculate guest stats
    await recalculateGuestStats(booking.guest.id);

    // Update Notification
    try {
      await notificationServiceProvider.scheduleBookingNotifications(booking);
    } catch (e) {
      debugPrint('Failed to update notification: $e');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    await notificationServiceProvider.cancelNotificationsForBooking(bookingId);
    await (db.delete(db.bookings)..where((t) => t.id.equals(bookingId))).go();
  }

  // Payment Methods
  Future<List<entities.Payment>> fetchPayments(String bookingId) async {
    final payments = await (db.select(db.payments)
          ..where((t) => t.bookingId.equals(bookingId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .get();

    return payments
        .map((p) => entities.Payment(
              id: p.id,
              bookingId: p.bookingId,
              amount: p.amount,
              date: p.date,
              method: p.method,
              type: p.type,
              notes: p.notes,
            ))
        .toList();
  }

  Future<void> createPayment({
    required String bookingId,
    required double amount,
    required DateTime date,
    required String method,
    required String type,
    String? notes,
  }) async {
    await db.into(db.payments).insert(PaymentsCompanion.insert(
          id: _uuid(),
          bookingId: bookingId,
          amount: amount,
          date: date,
          method: Value(method),
          type: Value(type),
          notes: Value(notes),
        ));

    // Recalculate guest stats
    final booking = await (db.select(db.bookings)
          ..where((t) => t.id.equals(bookingId)))
        .getSingle();
    await recalculateGuestStats(booking.guestId);
  }

  Future<void> updatePayment(entities.Payment payment) async {
    await (db.update(db.payments)..where((t) => t.id.equals(payment.id))).write(
      PaymentsCompanion(
        amount: Value(payment.amount),
        date: Value(payment.date),
        method: Value(payment.method),
        type: Value(payment.type),
        notes: Value(payment.notes),
      ),
    );

    // Recalculate guest stats
    final p = await (db.select(db.payments)
          ..where((t) => t.id.equals(payment.id)))
        .getSingle();
    final booking = await (db.select(db.bookings)
          ..where((t) => t.id.equals(p.bookingId)))
        .getSingle();
    await recalculateGuestStats(booking.guestId);
  }

  Future<void> deletePayment(String paymentId) async {
    final p = await (db.select(db.payments)
          ..where((t) => t.id.equals(paymentId)))
        .getSingle();
    final booking = await (db.select(db.bookings)
          ..where((t) => t.id.equals(p.bookingId)))
        .getSingle();

    await (db.delete(db.payments)..where((t) => t.id.equals(paymentId))).go();

    await recalculateGuestStats(booking.guestId);
  }

  // Expense Methods
  Future<List<entities.Expense>> fetchExpenses({String? hotelId}) async {
    final entries = await fetchFinanceTransactions(hotelId: hotelId);
    return entries.where((entry) => !entry.isIncome).toList();
  }

  Future<List<entities.Expense>> fetchManualIncome({String? hotelId}) async {
    final entries = await fetchFinanceTransactions(hotelId: hotelId);
    return entries.where((entry) => entry.isIncome).toList();
  }

  Future<List<entities.Expense>> fetchFinanceTransactions({
    String? hotelId,
  }) async {
    final resolvedHotelId = await _resolveHotelId(hotelId);
    if (resolvedHotelId.isEmpty) return const [];

    final entries = await (db.select(db.expenses)
          ..where((t) => t.hotelId.equals(resolvedHotelId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .get();

    return entries
        .map((e) => entities.Expense(
              id: e.id,
              description: e.description,
              amount: e.amount,
              date: e.date,
              category: e.category,
            ))
        .toList();
  }

  Future<void> createIncome({
    required String description,
    required double amount,
    required DateTime date,
    required String category,
    String? hotelId,
  }) {
    final normalizedCategory = category.trim().toLowerCase();
    return createExpense(
      hotelId: hotelId,
      description: description,
      amount: amount,
      date: date,
      category: normalizedCategory.startsWith(_incomeCategoryPrefix)
          ? normalizedCategory
          : '$_incomeCategoryPrefix$normalizedCategory',
    );
  }

  Future<void> createExpense({
    required String description,
    required double amount,
    required DateTime date,
    required String category,
    String? hotelId,
  }) async {
    final resolvedHotelId = await _resolveHotelId(hotelId);
    if (resolvedHotelId.isEmpty) {
      throw Exception('Hotel not found for expense insert');
    }

    await db.into(db.expenses).insert(
          ExpensesCompanion.insert(
            id: _uuid(),
            hotelId: resolvedHotelId,
            description: description,
            amount: amount,
            date: date,
            category: Value(category),
          ),
        );
  }

  Future<void> deleteExpense(String expenseId) async {
    await (db.delete(db.expenses)..where((t) => t.id.equals(expenseId))).go();
  }

  Future<String> _resolveHotelId(String? hotelId) async {
    if (hotelId != null && hotelId.isNotEmpty) return hotelId;

    final user = await db.select(db.users).getSingleOrNull();
    if (user?.hotelId != null && user!.hotelId!.isNotEmpty) {
      return user.hotelId!;
    }

    final hotel = await db.select(db.hotels).getSingleOrNull();
    return hotel?.id ?? '';
  }

  // Auth Methods
  Future<entities.UserProfile?> loginUser(String email, String password) async {
    // Simple hash check (in real app use proper hashing)
    final user = await (db.select(db.users)
          ..where(
              (u) => u.email.equals(email) & u.passwordHash.equals(password)))
        .getSingleOrNull();

    if (user == null) return null;

    final hotel = await (db.select(db.hotels)
          ..where((h) => h.id.equals(user.hotelId ?? '')))
        .getSingleOrNull();

    return entities.UserProfile(
      hotelId: user.hotelId ?? '',
      email: user.email,
      displayName: user.email.split('@').first,
      hotelName: hotel?.name ?? 'Unknown Hotel',
      languageCode: hotel?.defaultLanguage ?? 'en',
      plan: _mapPlan(user.plan),
      currency: hotel?.currency ?? 'EUR',
      checkInHour: hotel?.checkInHour ?? '14:00',
      checkOutHour: hotel?.checkOutHour ?? '11:00',
      defaultRoomPrice: hotel?.defaultRoomPrice ?? 0.0,
    );
  }

  Future<entities.UserProfile?> restoreOrCreateSocialUser({
    required String? email,
    required String languageCode,
  }) async {
    final hotel = await db.select(db.hotels).getSingleOrNull();
    if (hotel == null) return null;

    final resolvedEmail = (email != null && email.trim().isNotEmpty)
        ? email.trim()
        : 'social_${hotel.id}@boutiflow.local';

    var user = await (db.select(db.users)
          ..where((u) =>
              u.email.equals(resolvedEmail) | u.hotelId.equals(hotel.id)))
        .getSingleOrNull();

    if (user == null) {
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: _uuid(),
              email: resolvedEmail,
              passwordHash: 'social_login',
              hotelId: Value(hotel.id),
              role: const Value('owner'),
              plan: const Value('free'),
            ),
          );
      user = await (db.select(db.users)
            ..where((u) => u.email.equals(resolvedEmail)))
          .getSingle();
    }

    return entities.UserProfile(
      hotelId: hotel.id,
      email: user.email,
      displayName: user.email.split('@').first,
      hotelName: hotel.name,
      languageCode: hotel.defaultLanguage.isNotEmpty
          ? hotel.defaultLanguage
          : languageCode,
      plan: _mapPlan(user.plan),
      currency: hotel.currency,
      checkInHour: hotel.checkInHour,
      checkOutHour: hotel.checkOutHour,
      defaultRoomPrice: hotel.defaultRoomPrice,
    );
  }

  /// Get existing logged in user (for session restoration)
  Future<entities.UserProfile?> getLoggedInUser() async {
    // Get the first user in the database (single-user app)
    final user = await db.select(db.users).getSingleOrNull();

    if (user == null) return null;

    final hotel = await (db.select(db.hotels)
          ..where((h) => h.id.equals(user.hotelId ?? '')))
        .getSingleOrNull();

    if (hotel == null) return null;

    return entities.UserProfile(
      hotelId: user.hotelId ?? '',
      email: user.email,
      displayName: user.email.split('@').first,
      hotelName: hotel.name,
      languageCode: hotel.defaultLanguage,
      plan: _mapPlan(user.plan),
      currency: hotel.currency,
      checkInHour: hotel.checkInHour,
      checkOutHour: hotel.checkOutHour,
      defaultRoomPrice: hotel.defaultRoomPrice,
    );
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String hotelName,
    required String languageCode,
  }) async {
    final hotelId = _uuid();

    // Create Hotel
    await db.into(db.hotels).insert(HotelsCompanion.insert(
          id: hotelId,
          name: hotelName,
          defaultLanguage: Value(languageCode),
        ));

    // Create User
    await db.into(db.users).insert(UsersCompanion.insert(
          id: _uuid(),
          email: email,
          passwordHash: password, // In real app, hash this!
          hotelId: Value(hotelId),
          role: const Value('owner'),
          plan: const Value('free'),
        ));

    // NOTE: Do not create default rooms here - let onboarding handle it
  }

  /// Persist current user's plan in local database.
  Future<void> updateCurrentUserPlan(String plan) async {
    final user = await db.select(db.users).getSingleOrNull();
    if (user == null) return;

    await (db.update(db.users)..where((t) => t.id.equals(user.id))).write(
      UsersCompanion(
        plan: Value(plan),
      ),
    );
  }

  entities.PlanType _mapPlan(String plan) {
    return entities.PlanType.values.firstWhere(
      (e) => e.name == plan,
      orElse: () => entities.PlanType.free,
    );
  }

  Future<void> recalculateGuestStats(String guestId) async {
    // Calculate total spent from payments
    final payments = await (db.select(db.payments).join([
      innerJoin(db.bookings, db.bookings.id.equalsExp(db.payments.bookingId)),
    ])
          ..where(db.bookings.guestId.equals(guestId)))
        .get();

    double totalSpent = 0;
    for (final row in payments) {
      final payment = row.readTable(db.payments);
      if (payment.type == 'payment') {
        totalSpent += payment.amount;
      } else if (payment.type == 'refund') {
        totalSpent -= payment.amount;
      }
    }

    // Calculate visit count (completed bookings)
    final bookings = await (db.select(db.bookings)
          ..where(
              (t) => t.guestId.equals(guestId) & t.status.equals('checkedOut')))
        .get();

    final visitCount = bookings.length;

    // Update guest
    await (db.update(db.guests)..where((t) => t.id.equals(guestId))).write(
      GuestsCompanion(
        totalSpent: Value(totalSpent),
        visitCount: Value(visitCount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Guest Documents
  Future<void> createGuestDocument({
    required String guestId,
    required String filePath,
    String? description,
  }) async {
    await db.into(db.guestDocuments).insert(GuestDocumentsCompanion.insert(
          id: _uuid(),
          guestId: guestId,
          filePath: filePath,
          description: Value(description),
        ));
  }

  Future<List<entities.GuestDocument>> fetchGuestDocuments(
      String guestId) async {
    final docs = await (db.select(db.guestDocuments)
          ..where((t) => t.guestId.equals(guestId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();

    return docs
        .map((d) => entities.GuestDocument(
              id: d.id,
              guestId: d.guestId,
              filePath: d.filePath,
              description: d.description,
              createdAt: d.createdAt,
            ))
        .toList();
  }

  Future<void> deleteGuestDocument(String id) async {
    await (db.delete(db.guestDocuments)..where((t) => t.id.equals(id))).go();
  }

  String _uuid() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
