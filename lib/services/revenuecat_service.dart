import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PaywallProduct = Package;

class RevenueCatService {
  static const String _appleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
    defaultValue: 'appl_SnWjBPnJxzbHKVujHtWxennhuiV',
  );
  static const String _googleApiKey =
      String.fromEnvironment('REVENUECAT_GOOGLE_API_KEY', defaultValue: '');

  static const String _entitlementId = String.fromEnvironment(
    'REVENUECAT_ENTITLEMENT_ID',
    defaultValue: 'Boutiflow Premium',
  );

  static const String _localProKey = 'is_pro';
  static const String errorNotConfigured = 'revenuecat_not_configured';
  static const String errorNoProducts = 'revenuecat_no_products';
  static const String errorPurchasePending = 'revenuecat_purchase_pending';
  static const String errorUnknownPurchaseState = 'revenuecat_purchase_unknown';

  static bool _initialized = false;

  static bool get isConfigured {
    if (kIsWeb) return false;
    if (Platform.isIOS || Platform.isMacOS) {
      return _appleApiKey.trim().isNotEmpty;
    }
    if (Platform.isAndroid) return _googleApiKey.trim().isNotEmpty;
    return false;
  }

  static Future<void> initialize() async {
    if (_initialized || kIsWeb) return;

    if (!isConfigured) {
      _initialized = true;
      debugPrint('[RevenueCat] API Key is missing. Running in fallback mode.');
      return;
    }

    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }

    PurchasesConfiguration? configuration;
    if (Platform.isIOS || Platform.isMacOS) {
      configuration = PurchasesConfiguration(_appleApiKey.trim());
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_googleApiKey.trim());
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
      _initialized = true;
      debugPrint('[RevenueCat] SDK activated.');
    }
  }

  Future<void> identify(String customerUserId) async {
    final normalized = customerUserId.trim();
    if (!isConfigured || normalized.isEmpty) return;

    await initialize();
    await Purchases.logIn(normalized);
  }

  Future<void> logout() async {
    if (!isConfigured) {
      await _writeLocalProFlag(false);
      return;
    }

    await initialize();
    await Purchases.logOut();
    await _writeLocalProFlag(false);
  }

  Future<bool> hasProAccess() async {
    if (!isConfigured) {
      return _readLocalProFlag();
    }

    try {
      await initialize();
      final customerInfo = await Purchases.getCustomerInfo();
      final hasPro = _hasActivePremiumAccess(customerInfo);
      await _writeLocalProFlag(hasPro);
      return hasPro;
    } catch (e) {
      debugPrint('[RevenueCat] hasProAccess failed: $e');
      return _readLocalProFlag();
    }
  }

  Future<List<PaywallProduct>> getProducts({String? locale}) async {
    if (!isConfigured) {
      debugPrint('[RevenueCat] getProducts skipped: API key not configured.');
      return [];
    }

    await initialize();
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        final productIds = offerings.current!.availablePackages
            .map((package) => package.storeProduct.identifier)
            .join(', ');
        debugPrint(
          '[RevenueCat] getProducts loaded '
          '${offerings.current!.availablePackages.length} packages: '
          '$productIds',
        );
        return offerings.current!.availablePackages;
      }
      debugPrint('[RevenueCat] getProducts returned no current packages.');
    } catch (e) {
      debugPrint('[RevenueCat] getProducts failed: $e');
    }
    return [];
  }

  Future<AppPurchaseResult> purchase(PaywallProduct product) async {
    if (!isConfigured) {
      return const AppPurchaseResult(
        success: false,
        error: errorNotConfigured,
      );
    }

    await initialize();

    try {
      final purchaseResult =
          await Purchases.purchase(PurchaseParams.package(product));
      final customerInfo = purchaseResult.customerInfo;
      final hasPro = _hasActivePremiumAccess(customerInfo);
      await _writeLocalProFlag(hasPro);
      return AppPurchaseResult(success: hasPro);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return const AppPurchaseResult(success: false, cancelled: true);
      }
      if (errorCode == PurchasesErrorCode.paymentPendingError) {
        return const AppPurchaseResult(
          success: false,
          error: errorPurchasePending,
        );
      }
      debugPrint('[RevenueCat] purchase failed: $e');
      return AppPurchaseResult(success: false, error: e.message ?? e.code);
    } catch (e) {
      debugPrint('[RevenueCat] purchase failed: $e');
      return AppPurchaseResult(success: false, error: e.toString());
    }
  }

  Future<RestoreResult> restorePurchases() async {
    if (!isConfigured) {
      final hasPro = await _readLocalProFlag();
      return RestoreResult(success: true, hasPro: hasPro);
    }

    try {
      await initialize();
      final customerInfo = await Purchases.restorePurchases();
      final hasPro = _hasActivePremiumAccess(customerInfo);
      await _writeLocalProFlag(hasPro);
      return RestoreResult(success: true, hasPro: hasPro);
    } catch (e) {
      debugPrint('[RevenueCat] restorePurchases failed: $e');
      return RestoreResult(success: false, error: e.toString());
    }
  }

  bool _hasActivePremiumAccess(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all.isEmpty) return false;

    final entitlement = customerInfo.entitlements.all[_entitlementId];
    if (entitlement != null && entitlement.isActive) {
      return true;
    }

    return customerInfo.entitlements.active.isNotEmpty;
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

class AppPurchaseResult {
  final bool success;
  final bool cancelled;
  final String? error;

  const AppPurchaseResult({
    required this.success,
    this.cancelled = false,
    this.error,
  });
}

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

final revenuecatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService();
});
