// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for all bookings (read-only)

@ProviderFor(bookingList)
const bookingListProvider = BookingListProvider._();

/// Provider for all bookings (read-only)

final class BookingListProvider extends $FunctionalProvider<
        AsyncValue<List<BookingModel>>,
        List<BookingModel>,
        FutureOr<List<BookingModel>>>
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  /// Provider for all bookings (read-only)
  const BookingListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'bookingListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bookingListHash();

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    return bookingList(ref);
  }
}

String _$bookingListHash() => r'7a36bb14460ff4d1fb3e17a3179b74620a1ff95e';

/// Provider for bookings in a date range (for calendar)

@ProviderFor(bookingsInRange)
const bookingsInRangeProvider = BookingsInRangeFamily._();

/// Provider for bookings in a date range (for calendar)

final class BookingsInRangeProvider extends $FunctionalProvider<
        AsyncValue<List<BookingModel>>,
        List<BookingModel>,
        FutureOr<List<BookingModel>>>
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  /// Provider for bookings in a date range (for calendar)
  const BookingsInRangeProvider._(
      {required BookingsInRangeFamily super.from,
      required (
        DateTime,
        DateTime,
      )
          super.argument})
      : super(
          retry: null,
          name: r'bookingsInRangeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bookingsInRangeHash();

  @override
  String toString() {
    return r'bookingsInRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    final argument = this.argument as (
      DateTime,
      DateTime,
    );
    return bookingsInRange(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookingsInRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingsInRangeHash() => r'8ddc7e9fbca690740a0470b870d329bcfc3c6242';

/// Provider for bookings in a date range (for calendar)

final class BookingsInRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<BookingModel>>,
            (
              DateTime,
              DateTime,
            )> {
  const BookingsInRangeFamily._()
      : super(
          retry: null,
          name: r'bookingsInRangeProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for bookings in a date range (for calendar)

  BookingsInRangeProvider call(
    DateTime start,
    DateTime end,
  ) =>
      BookingsInRangeProvider._(argument: (
        start,
        end,
      ), from: this);

  @override
  String toString() => r'bookingsInRangeProvider';
}

/// Provider for bookings by room

@ProviderFor(bookingsByRoom)
const bookingsByRoomProvider = BookingsByRoomFamily._();

/// Provider for bookings by room

final class BookingsByRoomProvider extends $FunctionalProvider<
        AsyncValue<List<BookingModel>>,
        List<BookingModel>,
        FutureOr<List<BookingModel>>>
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  /// Provider for bookings by room
  const BookingsByRoomProvider._(
      {required BookingsByRoomFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'bookingsByRoomProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bookingsByRoomHash();

  @override
  String toString() {
    return r'bookingsByRoomProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    final argument = this.argument as String;
    return bookingsByRoom(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookingsByRoomProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingsByRoomHash() => r'9ce494403f32341d859f3fdc979c61ecfb57f713';

/// Provider for bookings by room

final class BookingsByRoomFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookingModel>>, String> {
  const BookingsByRoomFamily._()
      : super(
          retry: null,
          name: r'bookingsByRoomProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for bookings by room

  BookingsByRoomProvider call(
    String roomId,
  ) =>
      BookingsByRoomProvider._(argument: roomId, from: this);

  @override
  String toString() => r'bookingsByRoomProvider';
}

/// Provider for a single booking by ID

@ProviderFor(bookingById)
const bookingByIdProvider = BookingByIdFamily._();

/// Provider for a single booking by ID

final class BookingByIdProvider extends $FunctionalProvider<
        AsyncValue<BookingModel?>, BookingModel?, FutureOr<BookingModel?>>
    with $FutureModifier<BookingModel?>, $FutureProvider<BookingModel?> {
  /// Provider for a single booking by ID
  const BookingByIdProvider._(
      {required BookingByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'bookingByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bookingByIdHash();

  @override
  String toString() {
    return r'bookingByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BookingModel?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<BookingModel?> create(Ref ref) {
    final argument = this.argument as String;
    return bookingById(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookingByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingByIdHash() => r'a19d2de55c30644ad38a34ef7f141b988f4827d9';

/// Provider for a single booking by ID

final class BookingByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BookingModel?>, String> {
  const BookingByIdFamily._()
      : super(
          retry: null,
          name: r'bookingByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for a single booking by ID

  BookingByIdProvider call(
    String bookingId,
  ) =>
      BookingByIdProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'bookingByIdProvider';
}

/// Provider for today's check-ins

@ProviderFor(todayCheckIns)
const todayCheckInsProvider = TodayCheckInsProvider._();

/// Provider for today's check-ins

final class TodayCheckInsProvider extends $FunctionalProvider<
        AsyncValue<List<BookingModel>>,
        List<BookingModel>,
        FutureOr<List<BookingModel>>>
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  /// Provider for today's check-ins
  const TodayCheckInsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayCheckInsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayCheckInsHash();

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    return todayCheckIns(ref);
  }
}

String _$todayCheckInsHash() => r'540859add0ba72d502b01a0ba09505c7462160e2';

/// Provider for today's check-outs

@ProviderFor(todayCheckOuts)
const todayCheckOutsProvider = TodayCheckOutsProvider._();

/// Provider for today's check-outs

final class TodayCheckOutsProvider extends $FunctionalProvider<
        AsyncValue<List<BookingModel>>,
        List<BookingModel>,
        FutureOr<List<BookingModel>>>
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  /// Provider for today's check-outs
  const TodayCheckOutsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayCheckOutsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayCheckOutsHash();

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    return todayCheckOuts(ref);
  }
}

String _$todayCheckOutsHash() => r'e796f5d22dfd2fd73299dd241f7a2bb06a39572d';

/// Booking controller for mutations

@ProviderFor(BookingController)
const bookingControllerProvider = BookingControllerProvider._();

/// Booking controller for mutations
final class BookingControllerProvider
    extends $AsyncNotifierProvider<BookingController, void> {
  /// Booking controller for mutations
  const BookingControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'bookingControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bookingControllerHash();

  @$internal
  @override
  BookingController create() => BookingController();
}

String _$bookingControllerHash() => r'2d5ace338091770a50d4e31274cfd0011c0b39e5';

/// Booking controller for mutations

abstract class _$BookingController extends $AsyncNotifier<void> {
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
