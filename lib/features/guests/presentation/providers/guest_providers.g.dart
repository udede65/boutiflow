// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for guest list (read-only)

@ProviderFor(guestList)
const guestListProvider = GuestListProvider._();

/// Provider for guest list (read-only)

final class GuestListProvider extends $FunctionalProvider<
        AsyncValue<List<GuestModel>>,
        List<GuestModel>,
        FutureOr<List<GuestModel>>>
    with $FutureModifier<List<GuestModel>>, $FutureProvider<List<GuestModel>> {
  /// Provider for guest list (read-only)
  const GuestListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'guestListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$guestListHash();

  @$internal
  @override
  $FutureProviderElement<List<GuestModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<GuestModel>> create(Ref ref) {
    return guestList(ref);
  }
}

String _$guestListHash() => r'9254a92a4b8e8f09afbbac71c9d93fb1362383f6';

/// Provider for searching guests

@ProviderFor(guestSearch)
const guestSearchProvider = GuestSearchFamily._();

/// Provider for searching guests

final class GuestSearchProvider extends $FunctionalProvider<
        AsyncValue<List<GuestModel>>,
        List<GuestModel>,
        FutureOr<List<GuestModel>>>
    with $FutureModifier<List<GuestModel>>, $FutureProvider<List<GuestModel>> {
  /// Provider for searching guests
  const GuestSearchProvider._(
      {required GuestSearchFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'guestSearchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$guestSearchHash();

  @override
  String toString() {
    return r'guestSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GuestModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<GuestModel>> create(Ref ref) {
    final argument = this.argument as String;
    return guestSearch(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GuestSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$guestSearchHash() => r'cd7f9d165e9a7cb2f9b77d215acba170bb2f6501';

/// Provider for searching guests

final class GuestSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GuestModel>>, String> {
  const GuestSearchFamily._()
      : super(
          retry: null,
          name: r'guestSearchProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for searching guests

  GuestSearchProvider call(
    String query,
  ) =>
      GuestSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'guestSearchProvider';
}

/// Provider for a single guest by ID

@ProviderFor(guestById)
const guestByIdProvider = GuestByIdFamily._();

/// Provider for a single guest by ID

final class GuestByIdProvider extends $FunctionalProvider<
        AsyncValue<GuestModel?>, GuestModel?, FutureOr<GuestModel?>>
    with $FutureModifier<GuestModel?>, $FutureProvider<GuestModel?> {
  /// Provider for a single guest by ID
  const GuestByIdProvider._(
      {required GuestByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'guestByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$guestByIdHash();

  @override
  String toString() {
    return r'guestByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GuestModel?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GuestModel?> create(Ref ref) {
    final argument = this.argument as String;
    return guestById(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GuestByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$guestByIdHash() => r'91592a8daad821830b437e8d37d12704d504cfbc';

/// Provider for a single guest by ID

final class GuestByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GuestModel?>, String> {
  const GuestByIdFamily._()
      : super(
          retry: null,
          name: r'guestByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for a single guest by ID

  GuestByIdProvider call(
    String guestId,
  ) =>
      GuestByIdProvider._(argument: guestId, from: this);

  @override
  String toString() => r'guestByIdProvider';
}

/// Guest controller for mutations (add, update, delete)

@ProviderFor(GuestController)
const guestControllerProvider = GuestControllerProvider._();

/// Guest controller for mutations (add, update, delete)
final class GuestControllerProvider
    extends $AsyncNotifierProvider<GuestController, void> {
  /// Guest controller for mutations (add, update, delete)
  const GuestControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'guestControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$guestControllerHash();

  @$internal
  @override
  GuestController create() => GuestController();
}

String _$guestControllerHash() => r'4a9197b4048677b7309258a2031b642a1aec1e36';

/// Guest controller for mutations (add, update, delete)

abstract class _$GuestController extends $AsyncNotifier<void> {
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
