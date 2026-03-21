// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {
  String get id;
  @JsonKey(name: 'business_name')
  String? get businessName;
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol;
  @JsonKey(name: 'app_language')
  String get appLanguage;
  @JsonKey(name: 'subscription_tier')
  String get subscriptionTier;
  @JsonKey(name: 'subscription_end_date')
  DateTime? get subscriptionEndDate;
  @JsonKey(name: 'is_trial_used')
  bool get isTrialUsed;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      _$ProfileModelCopyWithImpl<ProfileModel>(
          this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.appLanguage, appLanguage) ||
                other.appLanguage == appLanguage) &&
            (identical(other.subscriptionTier, subscriptionTier) ||
                other.subscriptionTier == subscriptionTier) &&
            (identical(other.subscriptionEndDate, subscriptionEndDate) ||
                other.subscriptionEndDate == subscriptionEndDate) &&
            (identical(other.isTrialUsed, isTrialUsed) ||
                other.isTrialUsed == isTrialUsed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      businessName,
      currencySymbol,
      appLanguage,
      subscriptionTier,
      subscriptionEndDate,
      isTrialUsed,
      createdAt);

  @override
  String toString() {
    return 'ProfileModel(id: $id, businessName: $businessName, currencySymbol: $currencySymbol, appLanguage: $appLanguage, subscriptionTier: $subscriptionTier, subscriptionEndDate: $subscriptionEndDate, isTrialUsed: $isTrialUsed, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
          ProfileModel value, $Res Function(ProfileModel) _then) =
      _$ProfileModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'business_name') String? businessName,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'app_language') String appLanguage,
      @JsonKey(name: 'subscription_tier') String subscriptionTier,
      @JsonKey(name: 'subscription_end_date') DateTime? subscriptionEndDate,
      @JsonKey(name: 'is_trial_used') bool isTrialUsed,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res> implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = freezed,
    Object? currencySymbol = null,
    Object? appLanguage = null,
    Object? subscriptionTier = null,
    Object? subscriptionEndDate = freezed,
    Object? isTrialUsed = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: freezed == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _self.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      appLanguage: null == appLanguage
          ? _self.appLanguage
          : appLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionTier: null == subscriptionTier
          ? _self.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionEndDate: freezed == subscriptionEndDate
          ? _self.subscriptionEndDate
          : subscriptionEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isTrialUsed: null == isTrialUsed
          ? _self.isTrialUsed
          : isTrialUsed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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
    TResult Function(_ProfileModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
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
    TResult Function(_ProfileModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel():
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
    TResult? Function(_ProfileModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
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
            @JsonKey(name: 'business_name') String? businessName,
            @JsonKey(name: 'currency_symbol') String currencySymbol,
            @JsonKey(name: 'app_language') String appLanguage,
            @JsonKey(name: 'subscription_tier') String subscriptionTier,
            @JsonKey(name: 'subscription_end_date')
            DateTime? subscriptionEndDate,
            @JsonKey(name: 'is_trial_used') bool isTrialUsed,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
        return $default(
            _that.id,
            _that.businessName,
            _that.currencySymbol,
            _that.appLanguage,
            _that.subscriptionTier,
            _that.subscriptionEndDate,
            _that.isTrialUsed,
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
            @JsonKey(name: 'business_name') String? businessName,
            @JsonKey(name: 'currency_symbol') String currencySymbol,
            @JsonKey(name: 'app_language') String appLanguage,
            @JsonKey(name: 'subscription_tier') String subscriptionTier,
            @JsonKey(name: 'subscription_end_date')
            DateTime? subscriptionEndDate,
            @JsonKey(name: 'is_trial_used') bool isTrialUsed,
            @JsonKey(name: 'created_at') DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel():
        return $default(
            _that.id,
            _that.businessName,
            _that.currencySymbol,
            _that.appLanguage,
            _that.subscriptionTier,
            _that.subscriptionEndDate,
            _that.isTrialUsed,
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
            @JsonKey(name: 'business_name') String? businessName,
            @JsonKey(name: 'currency_symbol') String currencySymbol,
            @JsonKey(name: 'app_language') String appLanguage,
            @JsonKey(name: 'subscription_tier') String subscriptionTier,
            @JsonKey(name: 'subscription_end_date')
            DateTime? subscriptionEndDate,
            @JsonKey(name: 'is_trial_used') bool isTrialUsed,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
        return $default(
            _that.id,
            _that.businessName,
            _that.currencySymbol,
            _that.appLanguage,
            _that.subscriptionTier,
            _that.subscriptionEndDate,
            _that.isTrialUsed,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfileModel implements ProfileModel {
  const _ProfileModel(
      {required this.id,
      @JsonKey(name: 'business_name') this.businessName,
      @JsonKey(name: 'currency_symbol') this.currencySymbol = '\$',
      @JsonKey(name: 'app_language') this.appLanguage = 'tr',
      @JsonKey(name: 'subscription_tier') this.subscriptionTier = 'free',
      @JsonKey(name: 'subscription_end_date') this.subscriptionEndDate,
      @JsonKey(name: 'is_trial_used') this.isTrialUsed = false,
      @JsonKey(name: 'created_at') this.createdAt});
  factory _ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_name')
  final String? businessName;
  @override
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;
  @override
  @JsonKey(name: 'app_language')
  final String appLanguage;
  @override
  @JsonKey(name: 'subscription_tier')
  final String subscriptionTier;
  @override
  @JsonKey(name: 'subscription_end_date')
  final DateTime? subscriptionEndDate;
  @override
  @JsonKey(name: 'is_trial_used')
  final bool isTrialUsed;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileModelCopyWith<_ProfileModel> get copyWith =>
      __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.appLanguage, appLanguage) ||
                other.appLanguage == appLanguage) &&
            (identical(other.subscriptionTier, subscriptionTier) ||
                other.subscriptionTier == subscriptionTier) &&
            (identical(other.subscriptionEndDate, subscriptionEndDate) ||
                other.subscriptionEndDate == subscriptionEndDate) &&
            (identical(other.isTrialUsed, isTrialUsed) ||
                other.isTrialUsed == isTrialUsed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      businessName,
      currencySymbol,
      appLanguage,
      subscriptionTier,
      subscriptionEndDate,
      isTrialUsed,
      createdAt);

  @override
  String toString() {
    return 'ProfileModel(id: $id, businessName: $businessName, currencySymbol: $currencySymbol, appLanguage: $appLanguage, subscriptionTier: $subscriptionTier, subscriptionEndDate: $subscriptionEndDate, isTrialUsed: $isTrialUsed, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(
          _ProfileModel value, $Res Function(_ProfileModel) _then) =
      __$ProfileModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'business_name') String? businessName,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'app_language') String appLanguage,
      @JsonKey(name: 'subscription_tier') String subscriptionTier,
      @JsonKey(name: 'subscription_end_date') DateTime? subscriptionEndDate,
      @JsonKey(name: 'is_trial_used') bool isTrialUsed,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? businessName = freezed,
    Object? currencySymbol = null,
    Object? appLanguage = null,
    Object? subscriptionTier = null,
    Object? subscriptionEndDate = freezed,
    Object? isTrialUsed = null,
    Object? createdAt = freezed,
  }) {
    return _then(_ProfileModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: freezed == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _self.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      appLanguage: null == appLanguage
          ? _self.appLanguage
          : appLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionTier: null == subscriptionTier
          ? _self.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionEndDate: freezed == subscriptionEndDate
          ? _self.subscriptionEndDate
          : subscriptionEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isTrialUsed: null == isTrialUsed
          ? _self.isTrialUsed
          : isTrialUsed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
