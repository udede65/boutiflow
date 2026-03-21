import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PaywallProduct = AdaptyPaywallProduct;

/// Adapty integration layer.
///
/// Required dart-defines:
/// - ADAPTY_API_KEY
/// Optional dart-defines:
/// - ADAPTY_PAYWALL_PLACEMENT_ID (default: main_paywall)
/// - ADAPTY_ACCESS_LEVEL_ID (default: premium)
class AdaptyService {
  static const String _apiKey =
      String.fromEnvironment('ADAPTY_API_KEY', defaultValue: '');
  static const String _paywallPlacementId = String.fromEnvironment(
    'ADAPTY_PAYWALL_PLACEMENT_ID',
    defaultValue: 'main_paywall',
  );
  static const String _accessLevelId = String.fromEnvironment(
    'ADAPTY_ACCESS_LEVEL_ID',
    defaultValue: 'premium',
  );
  static const String _localProKey = 'is_pro';
  static const String errorNotConfigured = 'adapty_not_configured';
  static const String errorNoProducts = 'adapty_no_products';
  static const String errorPurchasePending = 'adapty_purchase_pending';
  static const String errorUnknownPurchaseState = 'adapty_purchase_unknown';

  static bool _initialized = false;
  static bool get isConfigured => _apiKey.trim().isNotEmpty;

  static Future<void> initialize() async {
    if (_initialized) return;

    if (!isConfigured) {
      _initialized = true;
      debugPrint(
          '[Adapty] ADAPTY_API_KEY is missing. Running in fallback mode.');
      return;
    }

    final configuration = AdaptyConfiguration(apiKey: _apiKey.trim());
    if (kDebugMode) {
      configuration.withLogLevel(AdaptyLogLevel.verbose);
    }

    await Adapty().activate(configuration: configuration);
    _initialized = true;
    debugPrint('[Adapty] SDK activated.');
  }

  Future<void> identify(String customerUserId) async {
    final normalized = customerUserId.trim();
    if (!isConfigured || normalized.isEmpty) return;

    await initialize();
    await Adapty().identify(normalized);
  }

  Future<void> logout() async {
    if (!isConfigured) {
      await _writeLocalProFlag(false);
      return;
    }

    await initialize();
    await Adapty().logout();
    await _writeLocalProFlag(false);
  }

  Future<bool> hasProAccess() async {
    if (!isConfigured) {
      return _readLocalProFlag();
    }

    try {
      await initialize();
      final profile = await Adapty().getProfile();
      final hasPro = _hasActivePremiumAccess(profile);
      await _writeLocalProFlag(hasPro);
      return hasPro;
    } catch (e) {
      debugPrint('[Adapty] hasProAccess failed: $e');
      return _readLocalProFlag();
    }
  }

  Future<List<PaywallProduct>> getProducts({String? locale}) async {
    if (!isConfigured) {
      debugPrint('[Adapty] getProducts skipped: API key not configured.');
      return [];
    }

    await initialize();
    final paywall = await Adapty().getPaywall(
      placementId: _paywallPlacementId,
      locale: locale,
      fetchPolicy: AdaptyPaywallFetchPolicy.reloadRevalidatingCacheData,
      loadTimeout: const Duration(seconds: 15),
    );

    return Adapty().getPaywallProducts(paywall: paywall);
  }

  Future<PurchaseResult> purchase(PaywallProduct product) async {
    if (!isConfigured) {
      return const PurchaseResult(
        success: false,
        error: errorNotConfigured,
      );
    }

    await initialize();

    try {
      final purchaseResult = await Adapty().makePurchase(product: product);

      if (purchaseResult is AdaptyPurchaseResultSuccess) {
        final hasPro = _hasActivePremiumAccess(purchaseResult.profile);
        await _writeLocalProFlag(hasPro);
        return PurchaseResult(success: hasPro);
      }

      if (purchaseResult is AdaptyPurchaseResultUserCancelled) {
        return const PurchaseResult(success: false, cancelled: true);
      }

      if (purchaseResult is AdaptyPurchaseResultPending) {
        return const PurchaseResult(
          success: false,
          error: errorPurchasePending,
        );
      }

      return const PurchaseResult(
        success: false,
        error: errorUnknownPurchaseState,
      );
    } catch (e) {
      debugPrint('[Adapty] purchase failed: $e');
      return PurchaseResult(success: false, error: e.toString());
    }
  }

  Future<RestoreResult> restorePurchases() async {
    if (!isConfigured) {
      final hasPro = await _readLocalProFlag();
      return RestoreResult(success: true, hasPro: hasPro);
    }

    try {
      await initialize();
      final profile = await Adapty().restorePurchases();
      final hasPro = _hasActivePremiumAccess(profile);
      await _writeLocalProFlag(hasPro);
      return RestoreResult(success: true, hasPro: hasPro);
    } catch (e) {
      debugPrint('[Adapty] restorePurchases failed: $e');
      return RestoreResult(success: false, error: e.toString());
    }
  }

  bool _hasActivePremiumAccess(AdaptyProfile profile) {
    if (profile.accessLevels.isEmpty) return false;

    final configuredLevel = profile.accessLevels[_accessLevelId];
    if (configuredLevel != null) {
      return configuredLevel.isActive;
    }

    return profile.accessLevels.values.any((level) => level.isActive);
  }

  Future<bool> _readLocalProFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_localProKey) ?? false;
  }

  Future<void> _writeLocalProFlag(bool hasPro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_localProKey, hasPro);
  }
}

/// Result of a purchase attempt
class PurchaseResult {
  final bool success;
  final bool cancelled;
  final String? error;

  const PurchaseResult({
    required this.success,
    this.cancelled = false,
    this.error,
  });
}

/// Result of restore attempt
class RestoreResult {
  final bool success;
  final bool hasPro;
  final String? error;

  const RestoreResult({
    required this.success,
    this.hasPro = false,
    this.error,
  });
}

/// Provider for AdaptyService
final adaptyServiceProvider = Provider<AdaptyService>((ref) {
  return AdaptyService();
});
