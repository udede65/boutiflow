import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/data/database.dart';
import 'package:roompilot_flutter/features/bookings/booking_form_screen.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';
import 'package:roompilot_flutter/services/providers.dart';
import 'package:roompilot_flutter/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late BoutiFlowService service;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    service = BoutiFlowService(db);

    await db.into(db.hotels).insert(
          HotelsCompanion.insert(id: 'hotel_1', name: 'Bouti Hotel'),
        );
    await db.into(db.rooms).insert(
          RoomsCompanion.insert(
            id: 'room_1',
            hotelId: 'hotel_1',
            name: 'Oda 1',
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_zeynep',
            hotelId: 'hotel_1',
            name: 'Zeynep',
          ),
        );
    await db.into(db.guests).insert(
          GuestsCompanion.insert(
            id: 'guest_umut',
            hotelId: 'hotel_1',
            name: 'Umut',
          ),
        );
    await db.into(db.bookings).insert(
          BookingsCompanion.insert(
            id: 'booking_1',
            hotelId: 'hotel_1',
            roomId: 'room_1',
            guestId: 'guest_zeynep',
            checkIn: DateTime(2026, 5, 14),
            checkOut: DateTime(2026, 5, 17),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('conflicting booking stays on form and shows localized message',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          boutiFlowServiceProvider.overrideWithValue(service),
          appStateProvider.overrideWith(_TestAppStateNotifier.new),
        ],
        child: MaterialApp(
          locale: const Locale('tr'),
          theme: ThemeData(
            useMaterial3: false,
            splashFactory: InkRipple.splashFactory,
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: BookingFormScreen(
            initialRoomId: 'room_1',
            initialDate: DateTime(2026, 5, 15),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Umut').last);
    await tester.pumpAndSettle();

    final createButton = find.text('REZERVASYON OLUŞTUR').first;
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('YENİ REZERVASYON'), findsOneWidget);
    expect(
      find.textContaining(
        'Oda 1, 14.05.2026 - 17.05.2026 tarihlerinde Zeynep',
      ),
      findsOneWidget,
    );
  });
}

class _TestAppStateNotifier extends AppStateNotifier {
  @override
  AppState build() {
    return const AppState(
      isAuthenticated: true,
      selectedLocale: 'tr',
      user: UserProfile(
        hotelId: 'hotel_1',
        email: 'test@boutiflow.app',
        displayName: 'Test',
        hotelName: 'Bouti Hotel',
        languageCode: 'tr',
        plan: PlanType.premium,
        currency: 'TRY',
      ),
    );
  }
}
