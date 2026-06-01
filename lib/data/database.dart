import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'database.g.dart';

class Hotels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get defaultLanguage => text().withDefault(const Constant('en'))();
  TextColumn get currency => text().withDefault(const Constant('EUR'))(); // New
  TextColumn get checkInHour =>
      text().withDefault(const Constant('14:00'))(); // New v5
  TextColumn get checkOutHour =>
      text().withDefault(const Constant('11:00'))(); // New v5
  RealColumn get defaultRoomPrice =>
      real().withDefault(const Constant(0.0))(); // New v5
  TextColumn get country => text().nullable()();
  TextColumn get city => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()(); // New

  @override
  Set<Column> get primaryKey => {id};
}

class RoomTypes extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId => text().references(Hotels, #id)();
  TextColumn get name => text()();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId => text().references(Hotels, #id)();
  TextColumn get roomTypeId =>
      text().nullable().references(RoomTypes, #id)(); // New v6
  TextColumn get name => text()();
  IntColumn get capacity => integer().withDefault(const Constant(2))();
  TextColumn get status => text()
      .withDefault(const Constant('clean'))(); // clean, dirty, maintenance
  IntColumn get sortOrder => integer().withDefault(const Constant(0))(); // New
  DateTimeColumn get updatedAt => dateTime().nullable()(); // New

  @override
  Set<Column> get primaryKey => {id};
}

class Guests extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId => text().references(Hotels, #id)();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get language => text().nullable()();
  IntColumn get visitCount => integer().withDefault(const Constant(0))();
  RealColumn get totalSpent => real().withDefault(const Constant(0.0))();
  BoolColumn get isBanned =>
      boolean().withDefault(const Constant(false))(); // New
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()(); // New

  @override
  Set<Column> get primaryKey => {id};
}

class Bookings extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId => text().references(Hotels, #id)();
  TextColumn get roomId => text().references(Rooms, #id)();
  TextColumn get guestId => text().references(Guests, #id)();
  DateTimeColumn get checkIn => dateTime()();
  DateTimeColumn get checkOut => dateTime()();
  TextColumn get status => text().withDefault(const Constant('reserved'))();
  TextColumn get source => text().withDefault(
      const Constant('direct'))(); // New: direct, airbnb, booking_com
  RealColumn get priceTotal => real().nullable()();
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('unpaid'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()(); // New

  @override
  Set<Column> get primaryKey => {id};
}

class Payments extends Table {
  // New Table
  TextColumn get id => text()();
  TextColumn get bookingId => text().references(Bookings, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get method =>
      text().withDefault(const Constant('cash'))(); // cash, card, transfer
  TextColumn get type => text()
      .withDefault(const Constant('payment'))(); // payment, deposit, refund
  TextColumn get notes => text().nullable()(); // New
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId => text().references(Hotels, #id)();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text().withDefault(
      const Constant('Other'))(); // Maintenance, Supplies, Utilities, Other
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get role =>
      text().withDefault(const Constant('owner'))(); // owner, staff
  TextColumn get hotelId => text().nullable().references(Hotels, #id)();
  TextColumn get plan => text()
      .withDefault(const Constant('free'))(); // free, premium, premium_plus

  @override
  Set<Column> get primaryKey => {id};
}

class MessageTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId =>
      text().nullable().references(Hotels, #id)(); // null = global
  TextColumn get code => text()(); // checkout_thanks, review_request, etc.
  TextColumn get language => text()(); // tr, en, de, etc.
  TextColumn get title => text()();
  TextColumn get body => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class MessagesLog extends Table {
  TextColumn get id => text()();
  TextColumn get hotelId => text().references(Hotels, #id)();
  TextColumn get guestId => text().nullable().references(Guests, #id)();
  TextColumn get templateCode => text()();
  TextColumn get language => text()();
  TextColumn get renderedBody => text()();
  TextColumn get channel => text()(); // whatsapp_copy, email_copy
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class GuestDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get guestId => text().references(Guests, #id)();
  TextColumn get filePath => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Hotels,
  RoomTypes,
  Rooms,
  Guests,
  Bookings,
  Payments,
  Expenses,
  Users,
  MessageTemplates,
  MessagesLog,
  GuestDocuments
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 9; // Bumped to 9

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedMessageTemplates();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(users);
            await m.createTable(messageTemplates);
            await m.createTable(messagesLog);
            await _seedMessageTemplates();
          }
          if (from < 3) {
            // Migration to v3
            try {
              await m.addColumn(hotels, hotels.currency);
            } catch (_) {}
            try {
              await m.addColumn(hotels, hotels.updatedAt);
            } catch (_) {}

            try {
              await m.addColumn(rooms, rooms.sortOrder);
            } catch (_) {}
            try {
              await m.addColumn(rooms, rooms.updatedAt);
            } catch (_) {}

            try {
              await m.addColumn(guests, guests.isBanned);
            } catch (_) {}
            try {
              await m.addColumn(guests, guests.updatedAt);
            } catch (_) {}

            try {
              await m.addColumn(bookings, bookings.source);
            } catch (_) {}
            try {
              await m.addColumn(bookings, bookings.updatedAt);
            } catch (_) {}

            try {
              await m.createTable(payments);
            } catch (_) {}
          }
          if (from < 4) {
            // Migration to v4
            try {
              await m.addColumn(rooms, rooms.status);
            } catch (_) {}
          }
          if (from < 5) {
            // Migration to v5
            try {
              await m.addColumn(hotels, hotels.checkInHour);
            } catch (_) {}
            try {
              await m.addColumn(hotels, hotels.checkOutHour);
            } catch (_) {}
            try {
              await m.addColumn(hotels, hotels.defaultRoomPrice);
            } catch (_) {}
          }
          if (from < 6) {
            // Migration to v6
            await m.createTable(roomTypes);
            try {
              await m.addColumn(rooms, rooms.roomTypeId);
            } catch (_) {}

            // Seed default room type
            final defaultTypeId = 'rt_standard';
            await into(roomTypes).insert(
              RoomTypesCompanion.insert(
                id: defaultTypeId,
                hotelId: 'default-hotel', // Assuming single hotel for now
                name: 'Standard',
                price: const Value(100.0),
              ),
              mode: InsertMode.insertOrIgnore,
            );

            // Update existing rooms to use default type
            await (update(rooms)..where((t) => t.roomTypeId.isNull())).write(
              RoomsCompanion(roomTypeId: Value(defaultTypeId)),
            );
          }
          if (from < 7) {
            // Migration to v7
            await m.createTable(guestDocuments);
          }
          if (from < 8) {
            // Migration to v8
            await m.createTable(expenses);
          }
          if (from < 9) {
            // Migration to v9
            try {
              await m.addColumn(bookings, bookings.notes);
            } catch (_) {}
          }
        },
      );

  Future<void> _seedMessageTemplates() async {
    final templates = [
      // Checkout Thanks
      (
        code: 'checkout_thanks',
        lang: 'tr',
        title: 'Çıkış Sonrası Teşekkür',
        body:
            "Merhaba {{guest_name}},\n\n{{hotel_name}} olarak bizi tercih ettiğiniz için teşekkür ederiz. Sizi yeniden ağırlamaktan mutluluk duyarız.\n\nİyi günler dileriz!"
      ),
      (
        code: 'checkout_thanks',
        lang: 'en',
        title: 'Checkout Thank You',
        body:
            "Dear {{guest_name}},\n\nThank you for staying with us at {{hotel_name}}. We would be happy to welcome you again in the future.\n\nBest regards!"
      ),
      (
        code: 'checkout_thanks',
        lang: 'de',
        title: 'Vielen Dank für Ihren Aufenthalt',
        body:
            "Liebe/r {{guest_name}},\n\nvielen Dank, dass Sie im {{hotel_name}} übernachtet haben. Wir würden uns freuen, Sie wieder bei uns zu begrüßen.\n\nMit freundlichen Grüßen!"
      ),
      (
        code: 'checkout_thanks',
        lang: 'ru',
        title: 'Спасибо за проживание',
        body:
            "Уважаемый(ая) {{guest_name}},\n\nспасибо, что выбрали {{hotel_name}}. Мы будем рады снова видеть вас у нас в гостях.\n\nС уважением!"
      ),
      (
        code: 'checkout_thanks',
        lang: 'fr',
        title: 'Merci pour votre séjour',
        body:
            "Cher/Chère {{guest_name}},\n\nmerci d’avoir séjourné chez {{hotel_name}}. Nous serions ravis de vous accueillir à nouveau.\n\nCordialement !"
      ),
      (
        code: 'checkout_thanks',
        lang: 'es',
        title: 'Gracias por su estancia',
        body:
            "Estimado/a {{guest_name}},\n\ngracías por haberse alojado en {{hotel_name}}. Estaremos encantados de recibirle de nuevo.\n\nSaludos cordiales."
      ),

      // Review Request
      (
        code: 'review_request',
        lang: 'tr',
        title: 'Yorum Talebi',
        body:
            "Merhaba {{guest_name}},\n\n{{hotel_name}}’deki konaklamanızdan memnun kaldıysanız, lütfen birkaç dakikanızı ayırıp bizim için bir yorum bırakır mısınız? Görüşleriniz bizim için çok değerli.\n\nTeşekkürler!"
      ),
      (
        code: 'review_request',
        lang: 'en',
        title: 'Review Request',
        body:
            "Dear {{guest_name}},\n\nif you enjoyed your stay at {{hotel_name}}, would you mind leaving us a short review? Your feedback is very valuable to us.\n\nThank you!"
      ),
      (
        code: 'review_request',
        lang: 'de',
        title: 'Bewertungsanfrage',
        body:
            "Liebe/r {{guest_name}},\n\nwenn Ihnen Ihr Aufenthalt im {{hotel_name}} gefallen hat, würden Sie uns bitte eine kurze Bewertung hinterlassen? Ihr Feedback ist uns sehr wichtig.\n\nVielen Dank!"
      ),
      (
        code: 'review_request',
        lang: 'ru',
        title: 'Просьба оставить отзыв',
        body:
            "Уважаемый(ая) {{guest_name}},\n\nесли вам понравилось проживание в {{hotel_name}}, не могли бы вы оставить для нас краткий отзыв? Ваше мнение очень важно для нас.\n\nСпасибо!"
      ),
      (
        code: 'review_request',
        lang: 'fr',
        title: 'Demande d’avis',
        body:
            "Cher/Chère {{guest_name}},\n\nsi vous avez apprécié votre séjour au {{hotel_name}}, pourriez-vous nous laisser un petit avis ? Votre retour est très important pour nous.\n\nMerci beaucoup !"
      ),
      (
        code: 'review_request',
        lang: 'es',
        title: 'Solicitud de reseña',
        body:
            "Estimado/a {{guest_name}},\n\nsi disfrutó de su estancia en {{hotel_name}}, ¿podría dejarnos una breve reseña? Sus comentarios son muy importantes para nosotros.\n\n¡Muchas gracias!"
      ),

      // Come Back
      (
        code: 'come_back',
        lang: 'tr',
        title: 'Yeniden Bekleriz',
        body:
            "Merhaba {{guest_name}},\n\nSizi {{hotel_name}}’de tekrar ağırlamaktan mutluluk duyarız. Yeni sezon için avantajlı fiyatlarımız ve özel fırsatlarımız var.\n\nDilediğiniz zaman bizimle iletişime geçebilirsiniz."
      ),
      (
        code: 'come_back',
        lang: 'en',
        title: 'We\'d Love to Host You Again',
        body:
            "Dear {{guest_name}},\n\nwe would be happy to welcome you again at {{hotel_name}}. We have special offers and attractive rates for our returning guests.\n\nFeel free to contact us anytime."
      ),
      (
        code: 'come_back',
        lang: 'de',
        title: 'Wir freuen uns auf Ihren nächsten Besuch',
        body:
            "Liebe/r {{guest_name}},\n\nwir würden uns freuen, Sie erneut im {{hotel_name}} begrüßen zu dürfen. Für unsere Stammgäste haben wir besondere Angebote.\n\nKontaktieren Sie uns jederzeit gerne."
      ),
      (
        code: 'come_back',
        lang: 'ru',
        title: 'Будем рады вашему возвращению',
        body:
            "Уважаемый(ая) {{guest_name}},\n\nмы будем рады снова видеть вас в {{hotel_name}}. Для постоянных гостей у нас есть специальные предложения.\n\nСвяжитесь с нами в любое время."
      ),
      (
        code: 'come_back',
        lang: 'fr',
        title: 'Nous serions ravis de vous revoir',
        body:
            "Cher/Chère {{guest_name}},\n\nnous serions heureux de vous accueillir de nouveau au {{hotel_name}}. Nous proposons des offres spéciales à nos clients fidèles.\n\nN’hésitez pas à nous contacter."
      ),
      (
        code: 'come_back',
        lang: 'es',
        title: 'Nos encantaría recibirle de nuevo',
        body:
            "Estimado/a {{guest_name}},\n\nnos gustaría darle la bienvenida de nuevo en {{hotel_name}}. Tenemos ofertas especiales para nuestros clientes habituales.\n\nNo dude en contactarnos."
      ),

      // Season Opening
      (
        code: 'season_opening',
        lang: 'tr',
        title: 'Sezon Açılışı',
        body:
            "Merhaba {{guest_name}},\n\n{{hotel_name}} olarak yeni sezona başladık! Sınırlı süreli erken rezervasyon fırsatlarımızdan yararlanmak için bizimle iletişime geçebilirsiniz.\n\nSizi yeniden ağırlamaktan mutluluk duyarız."
      ),
      (
        code: 'season_opening',
        lang: 'en',
        title: 'Season Opening',
        body:
            "Dear {{guest_name}},\n\nwe are happy to announce that {{hotel_name}} has opened for the new season! You can benefit from our limited early-bird offers.\n\nWe would love to host you again."
      ),
      (
        code: 'season_opening',
        lang: 'de',
        title: 'Saisoneröffnung',
        body:
            "Liebe/r {{guest_name}},\n\nwir freuen uns, Ihnen mitzuteilen, dass das {{hotel_name}} in die neue Saison gestartet ist! Nutzen Sie unsere Frühbucherangebote.\n\nWir würden uns freuen, Sie wiederzusehen."
      ),
      (
        code: 'season_opening',
        lang: 'ru',
        title: 'Открытие сезона',
        body:
            "Уважаемый(ая) {{guest_name}},\n\nмы рады сообщить, что {{hotel_name}} открылся в новом сезоне! Вы можете воспользоваться нашими особыми предложениями для раннего бронирования.\n\nБудем рады видеть вас снова."
      ),
      (
        code: 'season_opening',
        lang: 'fr',
        title: 'Ouverture de la saison',
        body:
            "Cher/Chère {{guest_name}},\n\nnous sommes heureux de vous annoncer que {{hotel_name}} ouvre la nouvelle saison ! Profitez de nos offres spéciales early-bird.\n\nAu plaisir de vous revoir."
      ),
      (
        code: 'season_opening',
        lang: 'es',
        title: 'Apertura de temporada',
        body:
            "Estimado/a {{guest_name}},\n\nnos complace anunciar que {{hotel_name}} ha abierto la nueva temporada. Puede aprovechar nuestras ofertas especiales de reserva anticipada.\n\nNos encantaría recibirle de nuevo."
      ),
    ];

    await batch((batch) {
      for (final t in templates) {
        batch.insert(
          messageTemplates,
          MessageTemplatesCompanion.insert(
            id: 'tpl_${t.code}_${t.lang}',
            code: t.code,
            language: t.lang,
            title: t.title,
            body: t.body,
            isCustom: const Value(false),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'boutiflow_db');
  }
}
