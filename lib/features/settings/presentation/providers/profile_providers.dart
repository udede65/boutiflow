import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../providers/repository_providers.dart';
import '../../data/models/profile_model.dart';

part 'profile_providers.g.dart';

/// Provider for current user's profile
@riverpod
Future<ProfileModel?> userProfile(Ref ref) async {
  return ref.watch(profileRepositoryProvider).getProfile();
}

/// Provider for currency symbol (commonly used)
@riverpod
String currencySymbol(Ref ref) {
  final asyncProfile = ref.watch(userProfileProvider);
  final profile = asyncProfile.hasValue ? asyncProfile.value : null;
  return profile?.currencySymbol ?? '\$';
}

/// Profile controller for mutations
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {
    // Initial state is void
  }

  /// Update currency symbol
  Future<void> updateCurrencySymbol(String symbol) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(
        currencySymbol: symbol,
      );
      ref.invalidate(userProfileProvider);
    });
  }

  /// Update app language
  Future<void> updateAppLanguage(String languageCode) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(
        appLanguage: languageCode,
      );
      ref.invalidate(userProfileProvider);
    });
  }

  /// Update subscription info (usually called after RevenueCat purchase)
  Future<void> updateSubscription({
    required String tier,
    required DateTime endDate,
  }) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(
        subscriptionTier: tier,
        subscriptionEndDate: endDate,
      );
      ref.invalidate(userProfileProvider);
    });
  }
}

/// Provider to check if user has premium subscription
@riverpod
bool isPremium(Ref ref) {
  final asyncProfile = ref.watch(userProfileProvider);
  final profile = asyncProfile.hasValue ? asyncProfile.value : null;
  if (profile == null) return false;
  
  if (profile.subscriptionTier == 'free') return false;
  
  final endDate = profile.subscriptionEndDate;
  if (endDate == null) return false;
  
  return endDate.isAfter(DateTime.now());
}
