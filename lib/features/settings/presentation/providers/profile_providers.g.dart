// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for current user's profile

@ProviderFor(userProfile)
const userProfileProvider = UserProfileProvider._();

/// Provider for current user's profile

final class UserProfileProvider extends $FunctionalProvider<
        AsyncValue<ProfileModel?>, ProfileModel?, FutureOr<ProfileModel?>>
    with $FutureModifier<ProfileModel?>, $FutureProvider<ProfileModel?> {
  /// Provider for current user's profile
  const UserProfileProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userProfileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  $FutureProviderElement<ProfileModel?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileModel?> create(Ref ref) {
    return userProfile(ref);
  }
}

String _$userProfileHash() => r'93240316a9ba1156b95e63f23ff6a43bf7edcb2b';

/// Provider for currency symbol (commonly used)

@ProviderFor(currencySymbol)
const currencySymbolProvider = CurrencySymbolProvider._();

/// Provider for currency symbol (commonly used)

final class CurrencySymbolProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  /// Provider for currency symbol (commonly used)
  const CurrencySymbolProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currencySymbolProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currencySymbolHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currencySymbol(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currencySymbolHash() => r'9b6510464b101140d8fb53dfccafd6122ad2dddd';

/// Profile controller for mutations

@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerProvider._();

/// Profile controller for mutations
final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, void> {
  /// Profile controller for mutations
  const ProfileControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'profileControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'696e857d767da71f896538450ea3f2f65412a570';

/// Profile controller for mutations

abstract class _$ProfileController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, null);
  }
}

/// Provider to check if user has premium subscription

@ProviderFor(isPremium)
const isPremiumProvider = IsPremiumProvider._();

/// Provider to check if user has premium subscription

final class IsPremiumProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if user has premium subscription
  const IsPremiumProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isPremiumProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isPremiumHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isPremium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isPremiumHash() => r'6f218dbb83e623154c7578a908b86a837b2cacfd';
