import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/entities.dart';
import '../state/app_state.dart';
import 'providers.dart';
import 'revenuecat_service.dart';

Future<void> syncPremiumCloudData(
  Ref ref, {
  bool includeFinance = false,
}) async {
  await _syncPremiumCloudData(
    read: (provider) => ref.read(provider),
    includeFinance: includeFinance,
  );
}

Future<void> syncPremiumCloudDataFromWidgetRef(
  WidgetRef ref, {
  bool includeFinance = false,
}) async {
  await _syncPremiumCloudData(
    read: (provider) => ref.read(provider),
    includeFinance: includeFinance,
  );
}

Future<void> _syncPremiumCloudData({
  required dynamic Function(dynamic provider) read,
  required bool includeFinance,
}) async {
  final appState = read(appStateProvider) as AppState;
  final user = appState.user;
  if (user == null || user.hotelId.trim().isEmpty) return;

  try {
    var hasPremiumAccess = user.plan == PlanType.premium;
    if (!hasPremiumAccess) {
      final revenuecat = read(revenuecatServiceProvider) as RevenueCatService;
      await revenuecat.identify(user.hotelId);
      hasPremiumAccess = await revenuecat.hasProAccess();
      if (hasPremiumAccess) {
        (read(appStateProvider.notifier) as AppStateNotifier)
            .upgradePlan(PlanType.premium);
      }
    }

    if (!hasPremiumAccess) return;

    final cloudSync = read(cloudSyncServiceProvider);
    final result = await cloudSync
        .syncNow(user.hotelId, includeFinance: includeFinance);
    if (!result.success) {
      debugPrint('Premium cloud autosync failed: ${result.error}');
    }
  } catch (e) {
    debugPrint('Premium cloud autosync error: $e');
  }
}
