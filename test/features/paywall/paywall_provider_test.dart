import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/data/database.dart';
import 'package:roompilot_flutter/services/boutiflow_service.dart';
import 'package:roompilot_flutter/services/cloud_sync_service.dart'
    as cloud_sync;
import 'package:roompilot_flutter/services/providers.dart';
import 'package:roompilot_flutter/services/revenuecat_service.dart';
import 'package:roompilot_flutter/state/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:roompilot_flutter/features/paywall/paywall_provider.dart';

void main() {
  group('planPackagesForPaywall', () {
    test('prefers annual as the default selected plan and keeps monthly', () {
      final monthly =
          _package('boutiflow_premium_monthly', PackageType.monthly);
      final annual = _package('boutiflow_premium_yearly', PackageType.annual);

      final plans = planPackagesForPaywall([monthly, annual]);

      expect(plans.monthly, same(monthly));
      expect(plans.annual, same(annual));
      expect(plans.defaultSelected, same(annual));
    });

    test('falls back to the first product when no annual package exists', () {
      final monthly =
          _package('boutiflow_premium_monthly', PackageType.monthly);

      final plans = planPackagesForPaywall([monthly]);

      expect(plans.monthly, same(monthly));
      expect(plans.annual, isNull);
      expect(plans.defaultSelected, same(monthly));
    });

    test('recognizes configured product ids even when package type is custom',
        () {
      final monthly = _package('boutiflow_premium_monthly', PackageType.custom);
      final annual = _package('boutiflow_premium_yearly', PackageType.custom);

      final plans = planPackagesForPaywall([monthly, annual]);

      expect(plans.monthly, same(monthly));
      expect(plans.annual, same(annual));
      expect(plans.defaultSelected, same(annual));
    });
  });

  group('premium cloud restore', () {
    late AppDatabase db;
    late BoutiFlowService service;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      service = BoutiFlowService(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('restores cloud data after successful purchase restore', () async {
      final revenuecat = _FakeRevenueCatService(restoreHasPro: true);
      final cloudSync = _FakeCloudSyncService(service);
      final container = ProviderContainer(
        overrides: [
          appStateProvider.overrideWith(_PremiumRestoreAppStateNotifier.new),
          boutiFlowServiceProvider.overrideWithValue(service),
          revenuecatServiceProvider.overrideWithValue(revenuecat),
          cloudSyncServiceProvider.overrideWithValue(cloudSync),
        ],
      );
      addTearDown(container.dispose);

      final restored =
          await container.read(paywallProvider.notifier).restorePurchases();

      expect(restored, isTrue);
      expect(revenuecat.identifiedUserIds, ['hotel_1']);
      expect(cloudSync.restoredHotelIds, ['hotel_1']);
      expect(container.read(paywallProvider).isPro, isTrue);
    });

    test('identifies the current business before purchase', () async {
      final revenuecat = _FakeRevenueCatService(
        restoreHasPro: false,
        purchaseSucceeds: true,
      );
      final cloudSync = _FakeCloudSyncService(service);
      final container = ProviderContainer(
        overrides: [
          appStateProvider.overrideWith(_PremiumRestoreAppStateNotifier.new),
          boutiFlowServiceProvider.overrideWithValue(service),
          revenuecatServiceProvider.overrideWithValue(revenuecat),
          cloudSyncServiceProvider.overrideWithValue(cloudSync),
        ],
      );
      addTearDown(container.dispose);

      final purchased = await container
          .read(paywallProvider.notifier)
          .purchaseProduct(_package('boutiflow_premium_monthly', PackageType.monthly));

      expect(purchased, isTrue);
      expect(cloudSync.linkedHotelIds, ['hotel_1']);
      expect(revenuecat.identifiedUserIds, ['hotel_1']);
      expect(cloudSync.restoredHotelIds, ['hotel_1']);
    });

    test('does not restore cloud data when restore has no premium access',
        () async {
      final revenuecat = _FakeRevenueCatService(restoreHasPro: false);
      final cloudSync = _FakeCloudSyncService(service);
      final container = ProviderContainer(
        overrides: [
          appStateProvider.overrideWith(_PremiumRestoreAppStateNotifier.new),
          boutiFlowServiceProvider.overrideWithValue(service),
          revenuecatServiceProvider.overrideWithValue(revenuecat),
          cloudSyncServiceProvider.overrideWithValue(cloudSync),
        ],
      );
      addTearDown(container.dispose);

      final restored =
          await container.read(paywallProvider.notifier).restorePurchases();

      expect(restored, isFalse);
      expect(cloudSync.restoredHotelIds, isEmpty);
      expect(container.read(paywallProvider).isPro, isFalse);
    });
  });
}

Package _package(String productId, PackageType type) {
  return Package(
    productId,
    type,
    StoreProduct(
      productId,
      'Premium',
      'Premium',
      type == PackageType.annual ? 39.99 : 4.99,
      type == PackageType.annual ? r'$39.99' : r'$4.99',
      'USD',
      subscriptionPeriod: type == PackageType.annual ? 'P1Y' : 'P1M',
    ),
    const PresentedOfferingContext('default', null, null),
  );
}

class _FakeRevenueCatService extends RevenueCatService {
  _FakeRevenueCatService({
    required this.restoreHasPro,
    this.purchaseSucceeds = false,
  });

  final bool restoreHasPro;
  final bool purchaseSucceeds;
  final List<String> identifiedUserIds = [];

  @override
  Future<void> identify(String customerUserId) async {
    identifiedUserIds.add(customerUserId);
  }

  @override
  Future<AppPurchaseResult> purchase(PaywallProduct product) async {
    return AppPurchaseResult(success: purchaseSucceeds);
  }

  @override
  Future<RestoreResult> restorePurchases() async {
    return RestoreResult(success: true, hasPro: restoreHasPro);
  }
}

class _FakeCloudSyncService extends cloud_sync.CloudSyncService {
  _FakeCloudSyncService(super.localDb);

  final List<String> linkedHotelIds = [];
  final List<String> restoredHotelIds = [];

  @override
  Future<void> linkCurrentUserToHotel(String hotelId) async {
    linkedHotelIds.add(hotelId);
  }

  @override
  Future<cloud_sync.RestoreResult> restoreFromCloud(
      String targetHotelId) async {
    restoredHotelIds.add(targetHotelId);
    return cloud_sync.RestoreResult(success: true, restoredCount: 3);
  }
}

class _PremiumRestoreAppStateNotifier extends AppStateNotifier {
  @override
  AppState build() {
    return const AppState(
      isAuthenticated: true,
      user: UserProfile(
        hotelId: 'hotel_1',
        email: 'owner@example.com',
        displayName: 'Owner',
        hotelName: 'BoutiFlow',
        languageCode: 'tr',
        plan: PlanType.free,
      ),
      selectedLocale: 'tr',
    );
  }

  @override
  void upgradePlan(PlanType plan) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(user: user.copyWith(plan: plan));
  }
}
