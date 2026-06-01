import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/data/database.dart';
import 'package:roompilot_flutter/features/finance/payments_page.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';
import 'package:roompilot_flutter/services/providers.dart';
import 'package:roompilot_flutter/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late BoutiFlowService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    service = BoutiFlowService(db);

    await db.into(db.hotels).insert(
          HotelsCompanion.insert(
            id: 'hotel_1',
            name: 'Bouti Hotel',
            currency: const Value('TRY'),
          ),
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
            id: 'guest_1',
            hotelId: 'hotel_1',
            name: 'Zeynep',
          ),
        );
    await db.into(db.bookings).insert(
          BookingsCompanion.insert(
            id: 'booking_1',
            hotelId: 'hotel_1',
            roomId: 'room_1',
            guestId: 'guest_1',
            checkIn: DateTime(2026, 5, 14),
            checkOut: DateTime(2026, 5, 17),
            priceTotal: const Value(7250),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('overview finance rows keep bounded readable text styles',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          boutiFlowServiceProvider.overrideWithValue(service),
          appStateProvider.overrideWith(_FinanceAppStateNotifier.new),
        ],
        child: MaterialApp(
          locale: const Locale('tr'),
          theme: ThemeData.dark(),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const PaymentsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text('Rezervasyon geliri').first);
    final amount = tester.widget<Text>(find.text('7250₺').first);

    expect(label.style?.fontSize, lessThanOrEqualTo(15));
    expect(label.style?.color, Colors.black);
    expect(amount.style?.fontSize, lessThanOrEqualTo(15));
    expect(tester.takeException(), isNull);
  });
}

class _FinanceAppStateNotifier extends AppStateNotifier {
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
