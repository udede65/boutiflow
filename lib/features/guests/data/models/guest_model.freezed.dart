// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuestModel {
  String get id;
  @JsonKey(name: 'user_id')
  String get userId;
  @JsonKey(name: 'full_name')
  String get fullName;
  String? get phone;
  @JsonKey(name: 'national_id')
  String? get nationalId;
  String get nationality;
  @JsonKey(name: 'language_code')
  String get languageCode;
  @JsonKey(name: 'is_blacklisted')
  bool get isBlacklisted;
  String? get email;
  String? get notes;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of GuestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GuestModelCopyWith<GuestModel> get copyWith =>
      _$GuestModelCopyWithImpl<GuestModel>(this as GuestModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GuestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.nationalId, nationalId) ||
                other.nationalId == nationalId) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.isBlacklisted, isBlacklisted) ||
                other.isBlacklisted == isBlacklisted) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      fullName,
      phone,
      nationalId,
      nationality,
      languageCode,
      isBlacklisted,
      email,
      notes,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'GuestModel(id: $id, userId: $userId, fullName: $fullName, phone: $phone, nationalId: $nationalId, nationality: $nationality, languageCode: $languageCode, isBlacklisted: $isBlacklisted, email: $email, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $GuestModelCopyWith<$Res> {
  factory $GuestModelCopyWith(
          GuestModel value, $Res Function(GuestModel) _then) =
      _$GuestModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      String? phone,
      @JsonKey(name: 'national_id') String? nationalId,
      String nationality,
      @JsonKey(name: 'language_code') String languageCode,
      @JsonKey(name: 'is_blacklisted') bool isBlacklisted,
      String? email,
      String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$GuestModelCopyWithImpl<$Res> implements $GuestModelCopyWith<$Res> {
  _$GuestModelCopyWithImpl(this._self, this._then);

  final GuestModel _self;
  final $Res Function(GuestModel) _then;

  /// Create a copy of GuestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? nationalId = freezed,
    Object? nationality = null,
    Object? languageCode = null,
    Object? isBlacklisted = null,
    Object? email = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      nationalId: freezed == nationalId
          ? _self.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: null == nationality
          ? _self.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _self.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      isBlacklisted: null == isBlacklisted
          ? _self.isBlacklisted
          : isBlacklisted // ignore: cast_nullable_to_non_nullable
              as bool,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GuestModel].
extension GuestModelPatterns on GuestModel {
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
    TResult Function(_GuestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GuestModel() when $default != null:
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
    TResult Function(_GuestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GuestModel():
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
    TResult? Function(_GuestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GuestModel() when $default != null:
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
            @JsonKey(name: 'full_name') String fullName,
            String? phone,
            @JsonKey(name: 'national_id') String? nationalId,
            String nationality,
            @JsonKey(name: 'language_code') String languageCode,
            @JsonKey(name: 'is_blacklisted') bool isBlacklisted,
            String? email,
            String? notes,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'updated_at') DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GuestModel() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.fullName,
            _that.phone,
            _that.nationalId,
            _that.nationality,
            _that.languageCode,
            _that.isBlacklisted,
            _that.email,
            _that.notes,
            _that.createdAt,
            _that.updatedAt);
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
            @JsonKey(name: 'full_name') String fullName,
            String? phone,
            @JsonKey(name: 'national_id') String? nationalId,
            String nationality,
            @JsonKey(name: 'language_code') String languageCode,
            @JsonKey(name: 'is_blacklisted') bool isBlacklisted,
            String? email,
            String? notes,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'updated_at') DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GuestModel():
        return $default(
            _that.id,
            _that.userId,
            _that.fullName,
            _that.phone,
            _that.nationalId,
            _that.nationality,
            _that.languageCode,
            _that.isBlacklisted,
            _that.email,
            _that.notes,
            _that.createdAt,
            _that.updatedAt);
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
            @JsonKey(name: 'full_name') String fullName,
            String? phone,
            @JsonKey(name: 'national_id') String? nationalId,
            String nationality,
            @JsonKey(name: 'language_code') String languageCode,
            @JsonKey(name: 'is_blacklisted') bool isBlacklisted,
            String? email,
            String? notes,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'updated_at') DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GuestModel() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.fullName,
            _that.phone,
            _that.nationalId,
            _that.nationality,
            _that.languageCode,
            _that.isBlacklisted,
            _that.email,
            _that.notes,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GuestModel extends GuestModel {
  const _GuestModel(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'full_name') required this.fullName,
      this.phone,
      @JsonKey(name: 'national_id') this.nationalId,
      this.nationality = 'TR',
      @JsonKey(name: 'language_code') this.languageCode = 'tr',
      @JsonKey(name: 'is_blacklisted') this.isBlacklisted = false,
      this.email,
      this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'national_id')
  final String? nationalId;
  @override
  @JsonKey()
  final String nationality;
  @override
  @JsonKey(name: 'language_code')
  final String languageCode;
  @override
  @JsonKey(name: 'is_blacklisted')
  final bool isBlacklisted;
  @override
  final String? email;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Create a copy of GuestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GuestModelCopyWith<_GuestModel> get copyWith =>
      __$GuestModelCopyWithImpl<_GuestModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GuestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.nationalId, nationalId) ||
                other.nationalId == nationalId) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.isBlacklisted, isBlacklisted) ||
                other.isBlacklisted == isBlacklisted) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      fullName,
      phone,
      nationalId,
      nationality,
      languageCode,
      isBlacklisted,
      email,
      notes,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'GuestModel(id: $id, userId: $userId, fullName: $fullName, phone: $phone, nationalId: $nationalId, nationality: $nationality, languageCode: $languageCode, isBlacklisted: $isBlacklisted, email: $email, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$GuestModelCopyWith<$Res>
    implements $GuestModelCopyWith<$Res> {
  factory _$GuestModelCopyWith(
          _GuestModel value, $Res Function(_GuestModel) _then) =
      __$GuestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      String? phone,
      @JsonKey(name: 'national_id') String? nationalId,
      String nationality,
      @JsonKey(name: 'language_code') String languageCode,
      @JsonKey(name: 'is_blacklisted') bool isBlacklisted,
      String? email,
      String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$GuestModelCopyWithImpl<$Res> implements _$GuestModelCopyWith<$Res> {
  __$GuestModelCopyWithImpl(this._self, this._then);

  final _GuestModel _self;
  final $Res Function(_GuestModel) _then;

  /// Create a copy of GuestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? nationalId = freezed,
    Object? nationality = null,
    Object? languageCode = null,
    Object? isBlacklisted = null,
    Object? email = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_GuestModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      nationalId: freezed == nationalId
          ? _self.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: null == nationality
          ? _self.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _self.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      isBlacklisted: null == isBlacklisted
          ? _self.isBlacklisted
          : isBlacklisted // ignore: cast_nullable_to_non_nullable
              as bool,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
