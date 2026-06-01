import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/app_state.dart';
import '../../core/models/entities.dart';
import '../../core/services/plan_limits.dart';
import '../../services/revenuecat_service.dart';

/// Paywall state holder
class PaywallState {
  final bool isPro;
  final bool isLoading;
  final List<PaywallProduct> products;
  final String? error;

  PaywallState({
    this.isPro = false,
    this.isLoading = false,
    this.products = const [],
    this.error,
  });

  PaywallState copyWith({
    bool? isPro,
    bool? isLoading,
    List<PaywallProduct>? products,
    String? error,
  }) {
    return PaywallState(
      isPro: isPro ?? this.isPro,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }
}

class PaywallNotifier extends Notifier<PaywallState> {
  @override
  PaywallState build() {
    // Check initial state from user profile
    final user = ref.watch(appStateProvider).user;
    final isPro = user != null && PlanLimits.isPremium(user.plan);
    return PaywallState(isPro: isPro);
  }

  Future<void> loadProducts({String? locale}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final revenuecat = ref.read(revenuecatServiceProvider);
      final products = await revenuecat.getProducts(locale: locale);
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> purchaseProduct(PaywallProduct product) async {
    state = state.copyWith(isLoading: true);

    try {
      final revenuecat = ref.read(revenuecatServiceProvider);
      final result = await revenuecat.purchase(product);

      if (result.success) {
        ref.read(appStateProvider.notifier).upgradePlan(PlanType.premium);
        state = state.copyWith(isLoading: false, isPro: true, error: null);
        return true;
      }

      if (result.cancelled) {
        state = state.copyWith(isLoading: false, error: null);
        return false;
      }

      state = state.copyWith(isLoading: false, error: result.error);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> purchaseDefaultProduct({String? locale}) async {
    if (state.products.isEmpty) {
      await loadProducts(locale: locale);
    }

    final product = state.products.isEmpty ? null : state.products.first;
    if (product == null) {
      state = state.copyWith(
        isLoading: false,
        error: RevenueCatService.errorNoProducts,
      );
      return false;
    }

    return purchaseProduct(product);
  }

  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true);

    try {
      final revenuecat = ref.read(revenuecatServiceProvider);
      final result = await revenuecat.restorePurchases();

      if (result.success && result.hasPro) {
        ref.read(appStateProvider.notifier).upgradePlan(PlanType.premium);
        state = state.copyWith(isLoading: false, isPro: true, error: null);
        return true;
      }

      state = state.copyWith(isLoading: false, error: result.error);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Legacy mock path intentionally kept for local UI tests.
  Future<bool> mockPurchase() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 1));

    ref.read(appStateProvider.notifier).upgradePlan(PlanType.premium);
    state = state.copyWith(isLoading: false, isPro: true, error: null);
    return true;
  }

  Future<void> checkProStatus() async {
    try {
      final revenuecat = ref.read(revenuecatServiceProvider);
      final hasPro = await revenuecat.hasProAccess();

      if (hasPro) {
        ref.read(appStateProvider.notifier).upgradePlan(PlanType.premium);
        state = state.copyWith(isPro: true, error: null);
      }
    } catch (_) {
      // Keep local state when remote check fails.
    }
  }
}

final paywallProvider =
    NotifierProvider<PaywallNotifier, PaywallState>(PaywallNotifier.new);

/// Legacy support: simple bool provider for isPro checks
final isProProvider = Provider<bool>((ref) {
  final plan = ref.watch(appStateProvider).user?.plan ?? PlanType.free;
  return PlanLimits.isPremium(plan);
});
