// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for room list (read-only)

@ProviderFor(roomList)
const roomListProvider = RoomListProvider._();

/// Provider for room list (read-only)

final class RoomListProvider extends $FunctionalProvider<
        AsyncValue<List<RoomModel>>, List<RoomModel>, FutureOr<List<RoomModel>>>
    with $FutureModifier<List<RoomModel>>, $FutureProvider<List<RoomModel>> {
  /// Provider for room list (read-only)
  const RoomListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'roomListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$roomListHash();

  @$internal
  @override
  $FutureProviderElement<List<RoomModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<RoomModel>> create(Ref ref) {
    return roomList(ref);
  }
}

String _$roomListHash() => r'b584c211472c1ed2539c2c226969009705cb87ac';

/// Provider for a single room by ID

@ProviderFor(roomById)
const roomByIdProvider = RoomByIdFamily._();

/// Provider for a single room by ID

final class RoomByIdProvider extends $FunctionalProvider<AsyncValue<RoomModel?>,
        RoomModel?, FutureOr<RoomModel?>>
    with $FutureModifier<RoomModel?>, $FutureProvider<RoomModel?> {
  /// Provider for a single room by ID
  const RoomByIdProvider._(
      {required RoomByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'roomByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$roomByIdHash();

  @override
  String toString() {
    return r'roomByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RoomModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RoomModel?> create(Ref ref) {
    final argument = this.argument as String;
    return roomById(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomByIdHash() => r'b4fd01adcdf2a378de905674fd15f1173da9d623';

/// Provider for a single room by ID

final class RoomByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RoomModel?>, String> {
  const RoomByIdFamily._()
      : super(
          retry: null,
          name: r'roomByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for a single room by ID

  RoomByIdProvider call(
    String roomId,
  ) =>
      RoomByIdProvider._(argument: roomId, from: this);

  @override
  String toString() => r'roomByIdProvider';
}

/// Room controller for mutations (add, update, delete)

@ProviderFor(RoomController)
const roomControllerProvider = RoomControllerProvider._();

/// Room controller for mutations (add, update, delete)
final class RoomControllerProvider
    extends $AsyncNotifierProvider<RoomController, void> {
  /// Room controller for mutations (add, update, delete)
  const RoomControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'roomControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$roomControllerHash();

  @$internal
  @override
  RoomController create() => RoomController();
}

String _$roomControllerHash() => r'52f7c7e2ee0937593c8bf27d0b0b2f996d27e992';

/// Room controller for mutations (add, update, delete)

abstract class _$RoomController extends $AsyncNotifier<void> {
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
