// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingModel {
  String get id;
  @JsonKey(name: 'user_id')
  String get userId;
  @JsonKey(name: 'room_id')
  String get roomId;
  @JsonKey(name: 'guest_id')
  String get guestId;
  @JsonKey(name: 'check_in')
  DateTime get checkIn;
  @JsonKey(name: 'check_out')
  DateTime get checkOut;
  @JsonKey(name: 'total_price')
  double get totalPrice;
  BookingStatus get status;
  String get source;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookingModelCopyWith<BookingModel> get copyWith =>
      _$BookingModelCopyWithImpl<BookingModel>(
          this as BookingModel, _$identity);

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookingModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.guestId, guestId) || other.guestId == guestId) &&
            (identical(other.checkIn, checkIn) || other.checkIn == checkIn) &&
            (identical(other.checkOut, checkOut) ||
                other.checkOut == checkOut) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, roomId, guestId,
      checkIn, checkOut, totalPrice, status, source, createdAt);

  @override
  String toString() {
    return 'BookingModel(id: $id, userId: $userId, roomId: $roomId, guestId: $guestId, checkIn: $checkIn, checkOut: $checkOut, totalPrice: $totalPrice, status: $status, source: $source, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) _then) =
      _$BookingModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'room_id') String roomId,
      @JsonKey(name: 'guest_id') String guestId,
      @JsonKey(name: 'check_in') DateTime checkIn,
      @JsonKey(name: 'check_out') DateTime checkOut,
      @JsonKey(name: 'total_price') double totalPrice,
      BookingStatus status,
      String source,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res> implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? roomId = null,
    Object? guestId = null,
    Object? checkIn = null,
    Object? checkOut = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? source = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      guestId: null == guestId
          ? _self.guestId
          : guestId // ignore: cast_nullable_to_non_nullable
              as String,
      checkIn: null == checkIn
          ? _self.checkIn
          : checkIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkOut: null == checkOut
          ? _self.checkOut
          : checkOut // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPrice: null == totalPrice
          ? _self.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BookingModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BookingModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BookingModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String userId,
            @JsonKey(name: 'room_id') String roomId,
            @JsonKey(name: 'guest_id') String guestId,
            @JsonKey(name: 'check_in') DateTime checkIn,
            @JsonKey(name: 'check_out') DateTime checkOut,
            @JsonKey(name: 'total_price') double totalPrice,
            BookingStatus status,
            String source,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingModel() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.roomId,
            _that.guestId,
            _that.checkIn,
            _that.checkOut,
            _that.totalPrice,
            _that.status,
            _that.source,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String userId,
            @JsonKey(name: 'room_id') String roomId,
            @JsonKey(name: 'guest_id') String guestId,
            @JsonKey(name: 'check_in') DateTime checkIn,
            @JsonKey(name: 'check_out') DateTime checkOut,
            @JsonKey(name: 'total_price') double totalPrice,
            BookingStatus status,
            String source,
            @JsonKey(name: 'created_at') DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingModel():
        return $default(
            _that.id,
            _that.userId,
            _that.roomId,
            _that.guestId,
            _that.checkIn,
            _that.checkOut,
            _that.totalPrice,
            _that.status,
            _that.source,
            _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'user_id') String userId,
            @JsonKey(name: 'room_id') String roomId,
            @JsonKey(name: 'guest_id') String guestId,
            @JsonKey(name: 'check_in') DateTime checkIn,
            @JsonKey(name: 'check_out') DateTime checkOut,
            @JsonKey(name: 'total_price') double totalPrice,
            BookingStatus status,
            String source,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingModel() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.roomId,
            _that.guestId,
            _that.checkIn,
            _that.checkOut,
            _that.totalPrice,
            _that.status,
            _that.source,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookingModel implements BookingModel {
  const _BookingModel(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'room_id') required this.roomId,
      @JsonKey(name: 'guest_id') required this.guestId,
      @JsonKey(name: 'check_in') required this.checkIn,
      @JsonKey(name: 'check_out') required this.checkOut,
      @JsonKey(name: 'total_price') required this.totalPrice,
      this.status = BookingStatus.confirmed,
      this.source = 'manual',
      @JsonKey(name: 'created_at') this.createdAt});
  factory _BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'room_id')
  final String roomId;
  @override
  @JsonKey(name: 'guest_id')
  final String guestId;
  @override
  @JsonKey(name: 'check_in')
  final DateTime checkIn;
  @override
  @JsonKey(name: 'check_out')
  final DateTime checkOut;
  @override
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @override
  @JsonKey()
  final BookingStatus status;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookingModelCopyWith<_BookingModel> get copyWith =>
      __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookingModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookingModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.guestId, guestId) || other.guestId == guestId) &&
            (identical(other.checkIn, checkIn) || other.checkIn == checkIn) &&
            (identical(other.checkOut, checkOut) ||
                other.checkOut == checkOut) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, roomId, guestId,
      checkIn, checkOut, totalPrice, status, source, createdAt);

  @override
  String toString() {
    return 'BookingModel(id: $id, userId: $userId, roomId: $roomId, guestId: $guestId, checkIn: $checkIn, checkOut: $checkOut, totalPrice: $totalPrice, status: $status, source: $source, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(
          _BookingModel value, $Res Function(_BookingModel) _then) =
      __$BookingModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'room_id') String roomId,
      @JsonKey(name: 'guest_id') String guestId,
      @JsonKey(name: 'check_in') DateTime checkIn,
      @JsonKey(name: 'check_out') DateTime checkOut,
      @JsonKey(name: 'total_price') double totalPrice,
      BookingStatus status,
      String source,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? roomId = null,
    Object? guestId = null,
    Object? checkIn = null,
    Object? checkOut = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? source = null,
    Object? createdAt = freezed,
  }) {
    return _then(_BookingModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      guestId: null == guestId
          ? _self.guestId
          : guestId // ignore: cast_nullable_to_non_nullable
              as String,
      checkIn: null == checkIn
          ? _self.checkIn
          : checkIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkOut: null == checkOut
          ? _self.checkOut
          : checkOut // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPrice: null == totalPrice
          ? _self.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
