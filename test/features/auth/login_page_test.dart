import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:go_router/go_router.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';
import 'package:roompilot_flutter/data/database.dart';
import 'package:roompilot_flutter/features/auth/login_page.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';
import 'package:roompilot_flutter/services/cloud_sync_service.dart'
    as cloud_sync;
import 'package:roompilot_flutter/services/providers.dart';
import 'package:roompilot_flutter/services/revenuecat_service.dart';
import 'package:roompilot_flutter/services/supabase_auth_service.dart';

void main() {
  testWidgets('shows only Apple sign in on login screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginPage(),
        ),
      ),
    );

    expect(find.text('Apple ile Giriş Yap'), findsOneWidget);
    expect(find.text('Google ile Giriş Yap'), findsNothing);
    expect(find.text('Demo Hesabı ile Giriş'), findsNothing);
    expect(find.text('veya'), findsNothing);
  });

  testWidgets(
      'refreshes premium cloud data when Apple login restores a local session',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final service = BoutiFlowService(db);
    await service.db.into(service.db.hotels).insert(
          HotelsCompanion.insert(
            id: 'hotel_1',
            name: 'BoutiFlow',
            defaultLanguage: const Value('tr'),
          ),
        );

    final fakeAuth = _FakeSupabaseAuthService();
    final fakeRevenueCat = _FakeRevenueCatService(hasPro: true);
    final fakeCloudSync = _FakeCloudSyncService(service);

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Text('dashboard'),
        ),
        GoRoute(
          path: '/paywall',
          builder: (context, state) => const Text('paywall'),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const Text('signup'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          boutiFlowServiceProvider.overrideWithValue(service),
          supabaseAuthServiceProvider.overrideWithValue(fakeAuth),
          revenuecatServiceProvider.overrideWithValue(fakeRevenueCat),
          cloudSyncServiceProvider.overrideWithValue(fakeCloudSync),
        ],
        child: MaterialApp.router(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.text('Apple ile Giriş Yap'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(fakeAuth.appleSignInCount, 1);
    expect(fakeRevenueCat.identifiedUserIds, contains('hotel_1'));
    expect(fakeCloudSync.linkedHotelIds, ['hotel_1']);
    expect(fakeCloudSync.restoredHotelIds, ['hotel_1']);
    expect(find.text('dashboard'), findsOneWidget);
  });

  testWidgets('restores cloud data when RevenueCat receipt restore has premium',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final service = BoutiFlowService(db);
    final fakeAuth = _FakeSupabaseAuthService();
    final fakeRevenueCat = _FakeRevenueCatService(
      hasPro: false,
      restoredHasPro: true,
    );
    final fakeCloudSync = _FakeCloudSyncService(
      service,
      cloudHotelIdToFind: 'cloud_hotel_1',
    );

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Text('dashboard'),
        ),
        GoRoute(
          path: '/paywall',
          builder: (context, state) => const Text('paywall'),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const Text('signup'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          boutiFlowServiceProvider.overrideWithValue(service),
          supabaseAuthServiceProvider.overrideWithValue(fakeAuth),
          revenuecatServiceProvider.overrideWithValue(fakeRevenueCat),
          cloudSyncServiceProvider.overrideWithValue(fakeCloudSync),
        ],
        child: MaterialApp.router(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.text('Apple ile Giriş Yap'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(fakeRevenueCat.identifiedUserIds, contains('cloud_hotel_1'));
    expect(fakeRevenueCat.restorePurchasesCount, 1);
    expect(fakeCloudSync.profileRestoredHotelIds, ['cloud_hotel_1']);
    expect(fakeCloudSync.restoredHotelIds, ['cloud_hotel_1']);
    expect(find.text('dashboard'), findsOneWidget);
    expect(find.text('paywall'), findsNothing);
  });

  testWidgets('restores cloud data when Supabase marks the account premium',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final service = BoutiFlowService(db);
    final fakeAuth = _FakeSupabaseAuthService();
    final fakeRevenueCat = _FakeRevenueCatService(
      hasPro: false,
      restoredHasPro: false,
    );
    final fakeCloudSync = _FakeCloudSyncService(
      service,
      cloudHotelIdToFind: 'cloud_hotel_1',
      cloudPremiumAccess: true,
    );

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Text('dashboard'),
        ),
        GoRoute(
          path: '/paywall',
          builder: (context, state) => const Text('paywall'),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const Text('signup'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          boutiFlowServiceProvider.overrideWithValue(service),
          supabaseAuthServiceProvider.overrideWithValue(fakeAuth),
          revenuecatServiceProvider.overrideWithValue(fakeRevenueCat),
          cloudSyncServiceProvider.overrideWithValue(fakeCloudSync),
        ],
        child: MaterialApp.router(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.text('Apple ile Giriş Yap'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(fakeRevenueCat.restorePurchasesCount, 1);
    expect(fakeCloudSync.premiumAccessChecks, ['cloud_hotel_1']);
    expect(fakeCloudSync.restoredHotelIds, ['cloud_hotel_1']);
    expect(find.text('dashboard'), findsOneWidget);
    expect(find.text('paywall'), findsNothing);
  });

  testWidgets('continues premium fallback restore after login widget unmounts',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final service = BoutiFlowService(db);
    final restoreCompleter = Completer<RestoreResult>();
    final fakeAuth = _FakeSupabaseAuthService();
    final fakeRevenueCat = _FakeRevenueCatService(
      hasPro: false,
      restoredHasPro: false,
      restoreCompleter: restoreCompleter,
    );
    final fakeCloudSync = _FakeCloudSyncService(
      service,
      cloudHotelIdToFind: 'cloud_hotel_1',
      cloudPremiumAccess: true,
    );

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Text('dashboard'),
        ),
        GoRoute(
          path: '/paywall',
          builder: (context, state) => const Text('paywall'),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const Text('signup'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          boutiFlowServiceProvider.overrideWithValue(service),
          supabaseAuthServiceProvider.overrideWithValue(fakeAuth),
          revenuecatServiceProvider.overrideWithValue(fakeRevenueCat),
          cloudSyncServiceProvider.overrideWithValue(fakeCloudSync),
        ],
        child: MaterialApp.router(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.text('Apple ile Giriş Yap'));
    await tester.pump();
    router.go('/paywall');
    await tester.pump();

    restoreCompleter.complete(
      const RestoreResult(success: true, hasPro: false),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(fakeCloudSync.premiumAccessChecks, ['cloud_hotel_1']);
    expect(fakeCloudSync.restoredHotelIds, ['cloud_hotel_1']);
  });
}

class _FakeSupabaseAuthService extends SupabaseAuthService {
  int appleSignInCount = 0;

  @override
  Future<AuthResult> signInWithApple() async {
    appleSignInCount++;
    return AuthResult(
      success: true,
      userId: 'apple_user_1',
      email: 'owner@example.com',
    );
  }
}

class _FakeRevenueCatService extends RevenueCatService {
  _FakeRevenueCatService({
    required this.hasPro,
    this.restoredHasPro = false,
    this.restoreCompleter,
  });

  final bool hasPro;
  final bool restoredHasPro;
  final Completer<RestoreResult>? restoreCompleter;
  final List<String> identifiedUserIds = [];
  int restorePurchasesCount = 0;

  @override
  Future<void> identify(String customerUserId) async {
    identifiedUserIds.add(customerUserId);
  }

  @override
  Future<bool> hasProAccess() async => hasPro;

  @override
  Future<RestoreResult> restorePurchases() async {
    restorePurchasesCount++;
    if (restoreCompleter != null) {
      return restoreCompleter!.future;
    }
    return RestoreResult(success: true, hasPro: restoredHasPro);
  }
}

class _FakeCloudSyncService extends cloud_sync.CloudSyncService {
  _FakeCloudSyncService(
    BoutiFlowService localDb, {
    this.cloudHotelIdToFind,
    this.cloudPremiumAccess = false,
  })  : _localDb = localDb,
        super(localDb);

  final BoutiFlowService _localDb;
  final String? cloudHotelIdToFind;
  final bool cloudPremiumAccess;
  final List<String> linkedHotelIds = [];
  final List<String> profileRestoredHotelIds = [];
  final List<String> restoredHotelIds = [];
  final List<String> premiumAccessChecks = [];

  @override
  Future<String?> findHotelIdFromCloud() async => cloudHotelIdToFind;

  @override
  Future<bool> hasPremiumAccessFromCloud(String hotelId) async {
    premiumAccessChecks.add(hotelId);
    return cloudPremiumAccess;
  }

  @override
  Future<void> linkCurrentUserToHotel(String hotelId) async {
    linkedHotelIds.add(hotelId);
  }

  @override
  Future<cloud_sync.RestoreResult> restoreBusinessProfileFromCloud(
    String targetHotelId,
  ) async {
    profileRestoredHotelIds.add(targetHotelId);
    await _localDb.db.into(_localDb.db.hotels).insert(
          HotelsCompanion.insert(
            id: targetHotelId,
            name: 'Cloud Hotel',
            defaultLanguage: const Value('tr'),
          ),
        );
    return cloud_sync.RestoreResult(success: true, restoredCount: 1);
  }

  @override
  Future<cloud_sync.RestoreResult> restoreFromCloud(
      String targetHotelId) async {
    restoredHotelIds.add(targetHotelId);
    return cloud_sync.RestoreResult(success: true, restoredCount: 4);
  }
}
