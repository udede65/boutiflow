// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HotelsTable extends Hotels with TableInfo<$HotelsTable, Hotel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HotelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultLanguageMeta =
      const VerificationMeta('defaultLanguage');
  @override
  late final GeneratedColumn<String> defaultLanguage = GeneratedColumn<String>(
      'default_language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('EUR'));
  static const VerificationMeta _checkInHourMeta =
      const VerificationMeta('checkInHour');
  @override
  late final GeneratedColumn<String> checkInHour = GeneratedColumn<String>(
      'check_in_hour', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('14:00'));
  static const VerificationMeta _checkOutHourMeta =
      const VerificationMeta('checkOutHour');
  @override
  late final GeneratedColumn<String> checkOutHour = GeneratedColumn<String>(
      'check_out_hour', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('11:00'));
  static const VerificationMeta _defaultRoomPriceMeta =
      const VerificationMeta('defaultRoomPrice');
  @override
  late final GeneratedColumn<double> defaultRoomPrice = GeneratedColumn<double>(
      'default_room_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        defaultLanguage,
        currency,
        checkInHour,
        checkOutHour,
        defaultRoomPrice,
        country,
        city,
        logoUrl,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hotels';
  @override
  VerificationContext validateIntegrity(Insertable<Hotel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_language')) {
      context.handle(
          _defaultLanguageMeta,
          defaultLanguage.isAcceptableOrUnknown(
              data['default_language']!, _defaultLanguageMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('check_in_hour')) {
      context.handle(
          _checkInHourMeta,
          checkInHour.isAcceptableOrUnknown(
              data['check_in_hour']!, _checkInHourMeta));
    }
    if (data.containsKey('check_out_hour')) {
      context.handle(
          _checkOutHourMeta,
          checkOutHour.isAcceptableOrUnknown(
              data['check_out_hour']!, _checkOutHourMeta));
    }
    if (data.containsKey('default_room_price')) {
      context.handle(
          _defaultRoomPriceMeta,
          defaultRoomPrice.isAcceptableOrUnknown(
              data['default_room_price']!, _defaultRoomPriceMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hotel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hotel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      defaultLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}default_language'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      checkInHour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_in_hour'])!,
      checkOutHour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_out_hour'])!,
      defaultRoomPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}default_room_price'])!,
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $HotelsTable createAlias(String alias) {
    return $HotelsTable(attachedDatabase, alias);
  }
}

class Hotel extends DataClass implements Insertable<Hotel> {
  final String id;
  final String name;
  final String defaultLanguage;
  final String currency;
  final String checkInHour;
  final String checkOutHour;
  final double defaultRoomPrice;
  final String? country;
  final String? city;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Hotel(
      {required this.id,
      required this.name,
      required this.defaultLanguage,
      required this.currency,
      required this.checkInHour,
      required this.checkOutHour,
      required this.defaultRoomPrice,
      this.country,
      this.city,
      this.logoUrl,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['default_language'] = Variable<String>(defaultLanguage);
    map['currency'] = Variable<String>(currency);
    map['check_in_hour'] = Variable<String>(checkInHour);
    map['check_out_hour'] = Variable<String>(checkOutHour);
    map['default_room_price'] = Variable<double>(defaultRoomPrice);
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  HotelsCompanion toCompanion(bool nullToAbsent) {
    return HotelsCompanion(
      id: Value(id),
      name: Value(name),
      defaultLanguage: Value(defaultLanguage),
      currency: Value(currency),
      checkInHour: Value(checkInHour),
      checkOutHour: Value(checkOutHour),
      defaultRoomPrice: Value(defaultRoomPrice),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Hotel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hotel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      defaultLanguage: serializer.fromJson<String>(json['defaultLanguage']),
      currency: serializer.fromJson<String>(json['currency']),
      checkInHour: serializer.fromJson<String>(json['checkInHour']),
      checkOutHour: serializer.fromJson<String>(json['checkOutHour']),
      defaultRoomPrice: serializer.fromJson<double>(json['defaultRoomPrice']),
      country: serializer.fromJson<String?>(json['country']),
      city: serializer.fromJson<String?>(json['city']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'defaultLanguage': serializer.toJson<String>(defaultLanguage),
      'currency': serializer.toJson<String>(currency),
      'checkInHour': serializer.toJson<String>(checkInHour),
      'checkOutHour': serializer.toJson<String>(checkOutHour),
      'defaultRoomPrice': serializer.toJson<double>(defaultRoomPrice),
      'country': serializer.toJson<String?>(country),
      'city': serializer.toJson<String?>(city),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Hotel copyWith(
          {String? id,
          String? name,
          String? defaultLanguage,
          String? currency,
          String? checkInHour,
          String? checkOutHour,
          double? defaultRoomPrice,
          Value<String?> country = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> logoUrl = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Hotel(
        id: id ?? this.id,
        name: name ?? this.name,
        defaultLanguage: defaultLanguage ?? this.defaultLanguage,
        currency: currency ?? this.currency,
        checkInHour: checkInHour ?? this.checkInHour,
        checkOutHour: checkOutHour ?? this.checkOutHour,
        defaultRoomPrice: defaultRoomPrice ?? this.defaultRoomPrice,
        country: country.present ? country.value : this.country,
        city: city.present ? city.value : this.city,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Hotel copyWithCompanion(HotelsCompanion data) {
    return Hotel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      defaultLanguage: data.defaultLanguage.present
          ? data.defaultLanguage.value
          : this.defaultLanguage,
      currency: data.currency.present ? data.currency.value : this.currency,
      checkInHour:
          data.checkInHour.present ? data.checkInHour.value : this.checkInHour,
      checkOutHour: data.checkOutHour.present
          ? data.checkOutHour.value
          : this.checkOutHour,
      defaultRoomPrice: data.defaultRoomPrice.present
          ? data.defaultRoomPrice.value
          : this.defaultRoomPrice,
      country: data.country.present ? data.country.value : this.country,
      city: data.city.present ? data.city.value : this.city,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hotel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultLanguage: $defaultLanguage, ')
          ..write('currency: $currency, ')
          ..write('checkInHour: $checkInHour, ')
          ..write('checkOutHour: $checkOutHour, ')
          ..write('defaultRoomPrice: $defaultRoomPrice, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      defaultLanguage,
      currency,
      checkInHour,
      checkOutHour,
      defaultRoomPrice,
      country,
      city,
      logoUrl,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hotel &&
          other.id == this.id &&
          other.name == this.name &&
          other.defaultLanguage == this.defaultLanguage &&
          other.currency == this.currency &&
          other.checkInHour == this.checkInHour &&
          other.checkOutHour == this.checkOutHour &&
          other.defaultRoomPrice == this.defaultRoomPrice &&
          other.country == this.country &&
          other.city == this.city &&
          other.logoUrl == this.logoUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HotelsCompanion extends UpdateCompanion<Hotel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> defaultLanguage;
  final Value<String> currency;
  final Value<String> checkInHour;
  final Value<String> checkOutHour;
  final Value<double> defaultRoomPrice;
  final Value<String?> country;
  final Value<String?> city;
  final Value<String?> logoUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const HotelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultLanguage = const Value.absent(),
    this.currency = const Value.absent(),
    this.checkInHour = const Value.absent(),
    this.checkOutHour = const Value.absent(),
    this.defaultRoomPrice = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HotelsCompanion.insert({
    required String id,
    required String name,
    this.defaultLanguage = const Value.absent(),
    this.currency = const Value.absent(),
    this.checkInHour = const Value.absent(),
    this.checkOutHour = const Value.absent(),
    this.defaultRoomPrice = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Hotel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? defaultLanguage,
    Expression<String>? currency,
    Expression<String>? checkInHour,
    Expression<String>? checkOutHour,
    Expression<double>? defaultRoomPrice,
    Expression<String>? country,
    Expression<String>? city,
    Expression<String>? logoUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (defaultLanguage != null) 'default_language': defaultLanguage,
      if (currency != null) 'currency': currency,
      if (checkInHour != null) 'check_in_hour': checkInHour,
      if (checkOutHour != null) 'check_out_hour': checkOutHour,
      if (defaultRoomPrice != null) 'default_room_price': defaultRoomPrice,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HotelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? defaultLanguage,
      Value<String>? currency,
      Value<String>? checkInHour,
      Value<String>? checkOutHour,
      Value<double>? defaultRoomPrice,
      Value<String?>? country,
      Value<String?>? city,
      Value<String?>? logoUrl,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return HotelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      currency: currency ?? this.currency,
      checkInHour: checkInHour ?? this.checkInHour,
      checkOutHour: checkOutHour ?? this.checkOutHour,
      defaultRoomPrice: defaultRoomPrice ?? this.defaultRoomPrice,
      country: country ?? this.country,
      city: city ?? this.city,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultLanguage.present) {
      map['default_language'] = Variable<String>(defaultLanguage.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (checkInHour.present) {
      map['check_in_hour'] = Variable<String>(checkInHour.value);
    }
    if (checkOutHour.present) {
      map['check_out_hour'] = Variable<String>(checkOutHour.value);
    }
    if (defaultRoomPrice.present) {
      map['default_room_price'] = Variable<double>(defaultRoomPrice.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HotelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultLanguage: $defaultLanguage, ')
          ..write('currency: $currency, ')
          ..write('checkInHour: $checkInHour, ')
          ..write('checkOutHour: $checkOutHour, ')
          ..write('defaultRoomPrice: $defaultRoomPrice, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomTypesTable extends RoomTypes
    with TableInfo<$RoomTypesTable, RoomType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, hotelId, name, price, description, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_types';
  @override
  VerificationContext validateIntegrity(Insertable<RoomType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RoomTypesTable createAlias(String alias) {
    return $RoomTypesTable(attachedDatabase, alias);
  }
}

class RoomType extends DataClass implements Insertable<RoomType> {
  final String id;
  final String hotelId;
  final String name;
  final double price;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const RoomType(
      {required this.id,
      required this.hotelId,
      required this.name,
      required this.price,
      this.description,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hotel_id'] = Variable<String>(hotelId);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RoomTypesCompanion toCompanion(bool nullToAbsent) {
    return RoomTypesCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      name: Value(name),
      price: Value(price),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RoomType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomType(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String>(json['hotelId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String>(hotelId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RoomType copyWith(
          {String? id,
          String? hotelId,
          String? name,
          double? price,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      RoomType(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        name: name ?? this.name,
        price: price ?? this.price,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  RoomType copyWithCompanion(RoomTypesCompanion data) {
    return RoomType(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomType(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, hotelId, name, price, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomType &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.name == this.name &&
          other.price == this.price &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoomTypesCompanion extends UpdateCompanion<RoomType> {
  final Value<String> id;
  final Value<String> hotelId;
  final Value<String> name;
  final Value<double> price;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RoomTypesCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomTypesCompanion.insert({
    required String id,
    required String hotelId,
    required String name,
    this.price = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hotelId = Value(hotelId),
        name = Value(name);
  static Insertable<RoomType> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomTypesCompanion copyWith(
      {Value<String>? id,
      Value<String>? hotelId,
      Value<String>? name,
      Value<double>? price,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return RoomTypesCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomTypesCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _roomTypeIdMeta =
      const VerificationMeta('roomTypeId');
  @override
  late final GeneratedColumn<String> roomTypeId = GeneratedColumn<String>(
      'room_type_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES room_types (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('clean'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, hotelId, roomTypeId, name, capacity, status, sortOrder, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(Insertable<Room> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('room_type_id')) {
      context.handle(
          _roomTypeIdMeta,
          roomTypeId.isAcceptableOrUnknown(
              data['room_type_id']!, _roomTypeIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id'])!,
      roomTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_type_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class Room extends DataClass implements Insertable<Room> {
  final String id;
  final String hotelId;
  final String? roomTypeId;
  final String name;
  final int capacity;
  final String status;
  final int sortOrder;
  final DateTime? updatedAt;
  const Room(
      {required this.id,
      required this.hotelId,
      this.roomTypeId,
      required this.name,
      required this.capacity,
      required this.status,
      required this.sortOrder,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hotel_id'] = Variable<String>(hotelId);
    if (!nullToAbsent || roomTypeId != null) {
      map['room_type_id'] = Variable<String>(roomTypeId);
    }
    map['name'] = Variable<String>(name);
    map['capacity'] = Variable<int>(capacity);
    map['status'] = Variable<String>(status);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      roomTypeId: roomTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(roomTypeId),
      name: Value(name),
      capacity: Value(capacity),
      status: Value(status),
      sortOrder: Value(sortOrder),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Room.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Room(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String>(json['hotelId']),
      roomTypeId: serializer.fromJson<String?>(json['roomTypeId']),
      name: serializer.fromJson<String>(json['name']),
      capacity: serializer.fromJson<int>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String>(hotelId),
      'roomTypeId': serializer.toJson<String?>(roomTypeId),
      'name': serializer.toJson<String>(name),
      'capacity': serializer.toJson<int>(capacity),
      'status': serializer.toJson<String>(status),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Room copyWith(
          {String? id,
          String? hotelId,
          Value<String?> roomTypeId = const Value.absent(),
          String? name,
          int? capacity,
          String? status,
          int? sortOrder,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Room(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        roomTypeId: roomTypeId.present ? roomTypeId.value : this.roomTypeId,
        name: name ?? this.name,
        capacity: capacity ?? this.capacity,
        status: status ?? this.status,
        sortOrder: sortOrder ?? this.sortOrder,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Room copyWithCompanion(RoomsCompanion data) {
    return Room(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      roomTypeId:
          data.roomTypeId.present ? data.roomTypeId.value : this.roomTypeId,
      name: data.name.present ? data.name.value : this.name,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Room(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('roomTypeId: $roomTypeId, ')
          ..write('name: $name, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, hotelId, roomTypeId, name, capacity, status, sortOrder, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Room &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.roomTypeId == this.roomTypeId &&
          other.name == this.name &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<String> id;
  final Value<String> hotelId;
  final Value<String?> roomTypeId;
  final Value<String> name;
  final Value<int> capacity;
  final Value<String> status;
  final Value<int> sortOrder;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.roomTypeId = const Value.absent(),
    this.name = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomsCompanion.insert({
    required String id,
    required String hotelId,
    this.roomTypeId = const Value.absent(),
    required String name,
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hotelId = Value(hotelId),
        name = Value(name);
  static Insertable<Room> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? roomTypeId,
    Expression<String>? name,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (roomTypeId != null) 'room_type_id': roomTypeId,
      if (name != null) 'name': name,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomsCompanion copyWith(
      {Value<String>? id,
      Value<String>? hotelId,
      Value<String?>? roomTypeId,
      Value<String>? name,
      Value<int>? capacity,
      Value<String>? status,
      Value<int>? sortOrder,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return RoomsCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      roomTypeId: roomTypeId ?? this.roomTypeId,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (roomTypeId.present) {
      map['room_type_id'] = Variable<String>(roomTypeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('roomTypeId: $roomTypeId, ')
          ..write('name: $name, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuestsTable extends Guests with TableInfo<$GuestsTable, Guest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _visitCountMeta =
      const VerificationMeta('visitCount');
  @override
  late final GeneratedColumn<int> visitCount = GeneratedColumn<int>(
      'visit_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalSpentMeta =
      const VerificationMeta('totalSpent');
  @override
  late final GeneratedColumn<double> totalSpent = GeneratedColumn<double>(
      'total_spent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isBannedMeta =
      const VerificationMeta('isBanned');
  @override
  late final GeneratedColumn<bool> isBanned = GeneratedColumn<bool>(
      'is_banned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_banned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        hotelId,
        name,
        phone,
        email,
        country,
        language,
        visitCount,
        totalSpent,
        isBanned,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guests';
  @override
  VerificationContext validateIntegrity(Insertable<Guest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('visit_count')) {
      context.handle(
          _visitCountMeta,
          visitCount.isAcceptableOrUnknown(
              data['visit_count']!, _visitCountMeta));
    }
    if (data.containsKey('total_spent')) {
      context.handle(
          _totalSpentMeta,
          totalSpent.isAcceptableOrUnknown(
              data['total_spent']!, _totalSpentMeta));
    }
    if (data.containsKey('is_banned')) {
      context.handle(_isBannedMeta,
          isBanned.isAcceptableOrUnknown(data['is_banned']!, _isBannedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Guest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Guest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      visitCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visit_count'])!,
      totalSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_spent'])!,
      isBanned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_banned'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $GuestsTable createAlias(String alias) {
    return $GuestsTable(attachedDatabase, alias);
  }
}

class Guest extends DataClass implements Insertable<Guest> {
  final String id;
  final String hotelId;
  final String name;
  final String? phone;
  final String? email;
  final String? country;
  final String? language;
  final int visitCount;
  final double totalSpent;
  final bool isBanned;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Guest(
      {required this.id,
      required this.hotelId,
      required this.name,
      this.phone,
      this.email,
      this.country,
      this.language,
      required this.visitCount,
      required this.totalSpent,
      required this.isBanned,
      this.notes,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hotel_id'] = Variable<String>(hotelId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    map['visit_count'] = Variable<int>(visitCount);
    map['total_spent'] = Variable<double>(totalSpent);
    map['is_banned'] = Variable<bool>(isBanned);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  GuestsCompanion toCompanion(bool nullToAbsent) {
    return GuestsCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      visitCount: Value(visitCount),
      totalSpent: Value(totalSpent),
      isBanned: Value(isBanned),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Guest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Guest(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String>(json['hotelId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      country: serializer.fromJson<String?>(json['country']),
      language: serializer.fromJson<String?>(json['language']),
      visitCount: serializer.fromJson<int>(json['visitCount']),
      totalSpent: serializer.fromJson<double>(json['totalSpent']),
      isBanned: serializer.fromJson<bool>(json['isBanned']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String>(hotelId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'country': serializer.toJson<String?>(country),
      'language': serializer.toJson<String?>(language),
      'visitCount': serializer.toJson<int>(visitCount),
      'totalSpent': serializer.toJson<double>(totalSpent),
      'isBanned': serializer.toJson<bool>(isBanned),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Guest copyWith(
          {String? id,
          String? hotelId,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> country = const Value.absent(),
          Value<String?> language = const Value.absent(),
          int? visitCount,
          double? totalSpent,
          bool? isBanned,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Guest(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        country: country.present ? country.value : this.country,
        language: language.present ? language.value : this.language,
        visitCount: visitCount ?? this.visitCount,
        totalSpent: totalSpent ?? this.totalSpent,
        isBanned: isBanned ?? this.isBanned,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Guest copyWithCompanion(GuestsCompanion data) {
    return Guest(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      country: data.country.present ? data.country.value : this.country,
      language: data.language.present ? data.language.value : this.language,
      visitCount:
          data.visitCount.present ? data.visitCount.value : this.visitCount,
      totalSpent:
          data.totalSpent.present ? data.totalSpent.value : this.totalSpent,
      isBanned: data.isBanned.present ? data.isBanned.value : this.isBanned,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Guest(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('country: $country, ')
          ..write('language: $language, ')
          ..write('visitCount: $visitCount, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('isBanned: $isBanned, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hotelId, name, phone, email, country,
      language, visitCount, totalSpent, isBanned, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Guest &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.country == this.country &&
          other.language == this.language &&
          other.visitCount == this.visitCount &&
          other.totalSpent == this.totalSpent &&
          other.isBanned == this.isBanned &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GuestsCompanion extends UpdateCompanion<Guest> {
  final Value<String> id;
  final Value<String> hotelId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> country;
  final Value<String?> language;
  final Value<int> visitCount;
  final Value<double> totalSpent;
  final Value<bool> isBanned;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const GuestsCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.country = const Value.absent(),
    this.language = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.isBanned = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuestsCompanion.insert({
    required String id,
    required String hotelId,
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.country = const Value.absent(),
    this.language = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.isBanned = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hotelId = Value(hotelId),
        name = Value(name);
  static Insertable<Guest> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? country,
    Expression<String>? language,
    Expression<int>? visitCount,
    Expression<double>? totalSpent,
    Expression<bool>? isBanned,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (country != null) 'country': country,
      if (language != null) 'language': language,
      if (visitCount != null) 'visit_count': visitCount,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (isBanned != null) 'is_banned': isBanned,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuestsCompanion copyWith(
      {Value<String>? id,
      Value<String>? hotelId,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? country,
      Value<String?>? language,
      Value<int>? visitCount,
      Value<double>? totalSpent,
      Value<bool>? isBanned,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return GuestsCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      country: country ?? this.country,
      language: language ?? this.language,
      visitCount: visitCount ?? this.visitCount,
      totalSpent: totalSpent ?? this.totalSpent,
      isBanned: isBanned ?? this.isBanned,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (visitCount.present) {
      map['visit_count'] = Variable<int>(visitCount.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<double>(totalSpent.value);
    }
    if (isBanned.present) {
      map['is_banned'] = Variable<bool>(isBanned.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuestsCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('country: $country, ')
          ..write('language: $language, ')
          ..write('visitCount: $visitCount, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('isBanned: $isBanned, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookingsTable extends Bookings with TableInfo<$BookingsTable, Booking> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
      'room_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES rooms (id)'));
  static const VerificationMeta _guestIdMeta =
      const VerificationMeta('guestId');
  @override
  late final GeneratedColumn<String> guestId = GeneratedColumn<String>(
      'guest_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES guests (id)'));
  static const VerificationMeta _checkInMeta =
      const VerificationMeta('checkIn');
  @override
  late final GeneratedColumn<DateTime> checkIn = GeneratedColumn<DateTime>(
      'check_in', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _checkOutMeta =
      const VerificationMeta('checkOut');
  @override
  late final GeneratedColumn<DateTime> checkOut = GeneratedColumn<DateTime>(
      'check_out', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('reserved'));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('direct'));
  static const VerificationMeta _priceTotalMeta =
      const VerificationMeta('priceTotal');
  @override
  late final GeneratedColumn<double> priceTotal = GeneratedColumn<double>(
      'price_total', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _paymentStatusMeta =
      const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
      'payment_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unpaid'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        hotelId,
        roomId,
        guestId,
        checkIn,
        checkOut,
        status,
        source,
        priceTotal,
        paymentStatus,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookings';
  @override
  VerificationContext validateIntegrity(Insertable<Booking> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(_roomIdMeta,
          roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta));
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('guest_id')) {
      context.handle(_guestIdMeta,
          guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta));
    } else if (isInserting) {
      context.missing(_guestIdMeta);
    }
    if (data.containsKey('check_in')) {
      context.handle(_checkInMeta,
          checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta));
    } else if (isInserting) {
      context.missing(_checkInMeta);
    }
    if (data.containsKey('check_out')) {
      context.handle(_checkOutMeta,
          checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta));
    } else if (isInserting) {
      context.missing(_checkOutMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('price_total')) {
      context.handle(
          _priceTotalMeta,
          priceTotal.isAcceptableOrUnknown(
              data['price_total']!, _priceTotalMeta));
    }
    if (data.containsKey('payment_status')) {
      context.handle(
          _paymentStatusMeta,
          paymentStatus.isAcceptableOrUnknown(
              data['payment_status']!, _paymentStatusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Booking map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Booking(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id'])!,
      roomId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_id'])!,
      guestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_id'])!,
      checkIn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}check_in'])!,
      checkOut: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}check_out'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      priceTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_total']),
      paymentStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $BookingsTable createAlias(String alias) {
    return $BookingsTable(attachedDatabase, alias);
  }
}

class Booking extends DataClass implements Insertable<Booking> {
  final String id;
  final String hotelId;
  final String roomId;
  final String guestId;
  final DateTime checkIn;
  final DateTime checkOut;
  final String status;
  final String source;
  final double? priceTotal;
  final String paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Booking(
      {required this.id,
      required this.hotelId,
      required this.roomId,
      required this.guestId,
      required this.checkIn,
      required this.checkOut,
      required this.status,
      required this.source,
      this.priceTotal,
      required this.paymentStatus,
      this.notes,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hotel_id'] = Variable<String>(hotelId);
    map['room_id'] = Variable<String>(roomId);
    map['guest_id'] = Variable<String>(guestId);
    map['check_in'] = Variable<DateTime>(checkIn);
    map['check_out'] = Variable<DateTime>(checkOut);
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || priceTotal != null) {
      map['price_total'] = Variable<double>(priceTotal);
    }
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  BookingsCompanion toCompanion(bool nullToAbsent) {
    return BookingsCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      roomId: Value(roomId),
      guestId: Value(guestId),
      checkIn: Value(checkIn),
      checkOut: Value(checkOut),
      status: Value(status),
      source: Value(source),
      priceTotal: priceTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(priceTotal),
      paymentStatus: Value(paymentStatus),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Booking(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String>(json['hotelId']),
      roomId: serializer.fromJson<String>(json['roomId']),
      guestId: serializer.fromJson<String>(json['guestId']),
      checkIn: serializer.fromJson<DateTime>(json['checkIn']),
      checkOut: serializer.fromJson<DateTime>(json['checkOut']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      priceTotal: serializer.fromJson<double?>(json['priceTotal']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String>(hotelId),
      'roomId': serializer.toJson<String>(roomId),
      'guestId': serializer.toJson<String>(guestId),
      'checkIn': serializer.toJson<DateTime>(checkIn),
      'checkOut': serializer.toJson<DateTime>(checkOut),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'priceTotal': serializer.toJson<double?>(priceTotal),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Booking copyWith(
          {String? id,
          String? hotelId,
          String? roomId,
          String? guestId,
          DateTime? checkIn,
          DateTime? checkOut,
          String? status,
          String? source,
          Value<double?> priceTotal = const Value.absent(),
          String? paymentStatus,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Booking(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        roomId: roomId ?? this.roomId,
        guestId: guestId ?? this.guestId,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        status: status ?? this.status,
        source: source ?? this.source,
        priceTotal: priceTotal.present ? priceTotal.value : this.priceTotal,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Booking copyWithCompanion(BookingsCompanion data) {
    return Booking(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      priceTotal:
          data.priceTotal.present ? data.priceTotal.value : this.priceTotal,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Booking(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('roomId: $roomId, ')
          ..write('guestId: $guestId, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('priceTotal: $priceTotal, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      hotelId,
      roomId,
      guestId,
      checkIn,
      checkOut,
      status,
      source,
      priceTotal,
      paymentStatus,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Booking &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.roomId == this.roomId &&
          other.guestId == this.guestId &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.status == this.status &&
          other.source == this.source &&
          other.priceTotal == this.priceTotal &&
          other.paymentStatus == this.paymentStatus &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BookingsCompanion extends UpdateCompanion<Booking> {
  final Value<String> id;
  final Value<String> hotelId;
  final Value<String> roomId;
  final Value<String> guestId;
  final Value<DateTime> checkIn;
  final Value<DateTime> checkOut;
  final Value<String> status;
  final Value<String> source;
  final Value<double?> priceTotal;
  final Value<String> paymentStatus;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const BookingsCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.guestId = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.priceTotal = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookingsCompanion.insert({
    required String id,
    required String hotelId,
    required String roomId,
    required String guestId,
    required DateTime checkIn,
    required DateTime checkOut,
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.priceTotal = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hotelId = Value(hotelId),
        roomId = Value(roomId),
        guestId = Value(guestId),
        checkIn = Value(checkIn),
        checkOut = Value(checkOut);
  static Insertable<Booking> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? roomId,
    Expression<String>? guestId,
    Expression<DateTime>? checkIn,
    Expression<DateTime>? checkOut,
    Expression<String>? status,
    Expression<String>? source,
    Expression<double>? priceTotal,
    Expression<String>? paymentStatus,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (roomId != null) 'room_id': roomId,
      if (guestId != null) 'guest_id': guestId,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (priceTotal != null) 'price_total': priceTotal,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? hotelId,
      Value<String>? roomId,
      Value<String>? guestId,
      Value<DateTime>? checkIn,
      Value<DateTime>? checkOut,
      Value<String>? status,
      Value<String>? source,
      Value<double?>? priceTotal,
      Value<String>? paymentStatus,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return BookingsCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      roomId: roomId ?? this.roomId,
      guestId: guestId ?? this.guestId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      source: source ?? this.source,
      priceTotal: priceTotal ?? this.priceTotal,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (guestId.present) {
      map['guest_id'] = Variable<String>(guestId.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<DateTime>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<DateTime>(checkOut.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (priceTotal.present) {
      map['price_total'] = Variable<double>(priceTotal.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookingsCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('roomId: $roomId, ')
          ..write('guestId: $guestId, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('priceTotal: $priceTotal, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookingIdMeta =
      const VerificationMeta('bookingId');
  @override
  late final GeneratedColumn<String> bookingId = GeneratedColumn<String>(
      'booking_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bookings (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('payment'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookingId, amount, date, method, type, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('booking_id')) {
      context.handle(_bookingIdMeta,
          bookingId.isAcceptableOrUnknown(data['booking_id']!, _bookingIdMeta));
    } else if (isInserting) {
      context.missing(_bookingIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}booking_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String bookingId;
  final double amount;
  final DateTime date;
  final String method;
  final String type;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Payment(
      {required this.id,
      required this.bookingId,
      required this.amount,
      required this.date,
      required this.method,
      required this.type,
      this.notes,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['booking_id'] = Variable<String>(bookingId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['method'] = Variable<String>(method);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      bookingId: Value(bookingId),
      amount: Value(amount),
      date: Value(date),
      method: Value(method),
      type: Value(type),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      bookingId: serializer.fromJson<String>(json['bookingId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      method: serializer.fromJson<String>(json['method']),
      type: serializer.fromJson<String>(json['type']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookingId': serializer.toJson<String>(bookingId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'method': serializer.toJson<String>(method),
      'type': serializer.toJson<String>(type),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Payment copyWith(
          {String? id,
          String? bookingId,
          double? amount,
          DateTime? date,
          String? method,
          String? type,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Payment(
        id: id ?? this.id,
        bookingId: bookingId ?? this.bookingId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        method: method ?? this.method,
        type: type ?? this.type,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      bookingId: data.bookingId.present ? data.bookingId.value : this.bookingId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('bookingId: $bookingId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bookingId, amount, date, method, type, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.bookingId == this.bookingId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.method == this.method &&
          other.type == this.type &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> bookingId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> method;
  final Value<String> type;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.bookingId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String bookingId,
    required double amount,
    required DateTime date,
    this.method = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookingId = Value(bookingId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? bookingId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? method,
    Expression<String>? type,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookingId != null) 'booking_id': bookingId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (type != null) 'type': type,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookingId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? method,
      Value<String>? type,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      method: method ?? this.method,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookingId.present) {
      map['booking_id'] = Variable<String>(bookingId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('bookingId: $bookingId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Other'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, hotelId, description, amount, date, category, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String hotelId;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final DateTime createdAt;
  const Expense(
      {required this.id,
      required this.hotelId,
      required this.description,
      required this.amount,
      required this.date,
      required this.category,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hotel_id'] = Variable<String>(hotelId);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      description: Value(description),
      amount: Value(amount),
      date: Value(date),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String>(json['hotelId']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String>(hotelId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith(
          {String? id,
          String? hotelId,
          String? description,
          double? amount,
          DateTime? date,
          String? category,
          DateTime? createdAt}) =>
      Expense(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, hotelId, description, amount, date, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> hotelId;
  final Value<String> description;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String hotelId,
    required String description,
    required double amount,
    required DateTime date,
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hotelId = Value(hotelId),
        description = Value(description),
        amount = Value(amount),
        date = Value(date);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? hotelId,
      Value<String>? description,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? category,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('owner'));
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
      'plan', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('free'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, email, passwordHash, createdAt, role, hotelId, plan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    }
    if (data.containsKey('plan')) {
      context.handle(
          _planMeta, plan.isAcceptableOrUnknown(data['plan']!, _planMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id']),
      plan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String email;
  final String passwordHash;
  final DateTime createdAt;
  final String role;
  final String? hotelId;
  final String plan;
  const User(
      {required this.id,
      required this.email,
      required this.passwordHash,
      required this.createdAt,
      required this.role,
      this.hotelId,
      required this.plan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || hotelId != null) {
      map['hotel_id'] = Variable<String>(hotelId);
    }
    map['plan'] = Variable<String>(plan);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      passwordHash: Value(passwordHash),
      createdAt: Value(createdAt),
      role: Value(role),
      hotelId: hotelId == null && nullToAbsent
          ? const Value.absent()
          : Value(hotelId),
      plan: Value(plan),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      role: serializer.fromJson<String>(json['role']),
      hotelId: serializer.fromJson<String?>(json['hotelId']),
      plan: serializer.fromJson<String>(json['plan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'role': serializer.toJson<String>(role),
      'hotelId': serializer.toJson<String?>(hotelId),
      'plan': serializer.toJson<String>(plan),
    };
  }

  User copyWith(
          {String? id,
          String? email,
          String? passwordHash,
          DateTime? createdAt,
          String? role,
          Value<String?> hotelId = const Value.absent(),
          String? plan}) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        createdAt: createdAt ?? this.createdAt,
        role: role ?? this.role,
        hotelId: hotelId.present ? hotelId.value : this.hotelId,
        plan: plan ?? this.plan,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      role: data.role.present ? data.role.value : this.role,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      plan: data.plan.present ? data.plan.value : this.plan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('role: $role, ')
          ..write('hotelId: $hotelId, ')
          ..write('plan: $plan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, email, passwordHash, createdAt, role, hotelId, plan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.createdAt == this.createdAt &&
          other.role == this.role &&
          other.hotelId == this.hotelId &&
          other.plan == this.plan);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<DateTime> createdAt;
  final Value<String> role;
  final Value<String?> hotelId;
  final Value<String> plan;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.role = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.plan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String passwordHash,
    this.createdAt = const Value.absent(),
    this.role = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.plan = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email),
        passwordHash = Value(passwordHash);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<DateTime>? createdAt,
    Expression<String>? role,
    Expression<String>? hotelId,
    Expression<String>? plan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (createdAt != null) 'created_at': createdAt,
      if (role != null) 'role': role,
      if (hotelId != null) 'hotel_id': hotelId,
      if (plan != null) 'plan': plan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<DateTime>? createdAt,
      Value<String>? role,
      Value<String?>? hotelId,
      Value<String>? plan,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      hotelId: hotelId ?? this.hotelId,
      plan: plan ?? this.plan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('role: $role, ')
          ..write('hotelId: $hotelId, ')
          ..write('plan: $plan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageTemplatesTable extends MessageTemplates
    with TableInfo<$MessageTemplatesTable, MessageTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, hotelId, code, language, title, body, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_templates';
  @override
  VerificationContext validateIntegrity(Insertable<MessageTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $MessageTemplatesTable createAlias(String alias) {
    return $MessageTemplatesTable(attachedDatabase, alias);
  }
}

class MessageTemplate extends DataClass implements Insertable<MessageTemplate> {
  final String id;
  final String? hotelId;
  final String code;
  final String language;
  final String title;
  final String body;
  final bool isCustom;
  const MessageTemplate(
      {required this.id,
      this.hotelId,
      required this.code,
      required this.language,
      required this.title,
      required this.body,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || hotelId != null) {
      map['hotel_id'] = Variable<String>(hotelId);
    }
    map['code'] = Variable<String>(code);
    map['language'] = Variable<String>(language);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  MessageTemplatesCompanion toCompanion(bool nullToAbsent) {
    return MessageTemplatesCompanion(
      id: Value(id),
      hotelId: hotelId == null && nullToAbsent
          ? const Value.absent()
          : Value(hotelId),
      code: Value(code),
      language: Value(language),
      title: Value(title),
      body: Value(body),
      isCustom: Value(isCustom),
    );
  }

  factory MessageTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTemplate(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String?>(json['hotelId']),
      code: serializer.fromJson<String>(json['code']),
      language: serializer.fromJson<String>(json['language']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String?>(hotelId),
      'code': serializer.toJson<String>(code),
      'language': serializer.toJson<String>(language),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  MessageTemplate copyWith(
          {String? id,
          Value<String?> hotelId = const Value.absent(),
          String? code,
          String? language,
          String? title,
          String? body,
          bool? isCustom}) =>
      MessageTemplate(
        id: id ?? this.id,
        hotelId: hotelId.present ? hotelId.value : this.hotelId,
        code: code ?? this.code,
        language: language ?? this.language,
        title: title ?? this.title,
        body: body ?? this.body,
        isCustom: isCustom ?? this.isCustom,
      );
  MessageTemplate copyWithCompanion(MessageTemplatesCompanion data) {
    return MessageTemplate(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      code: data.code.present ? data.code.value : this.code,
      language: data.language.present ? data.language.value : this.language,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTemplate(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('code: $code, ')
          ..write('language: $language, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, hotelId, code, language, title, body, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTemplate &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.code == this.code &&
          other.language == this.language &&
          other.title == this.title &&
          other.body == this.body &&
          other.isCustom == this.isCustom);
}

class MessageTemplatesCompanion extends UpdateCompanion<MessageTemplate> {
  final Value<String> id;
  final Value<String?> hotelId;
  final Value<String> code;
  final Value<String> language;
  final Value<String> title;
  final Value<String> body;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const MessageTemplatesCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.code = const Value.absent(),
    this.language = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageTemplatesCompanion.insert({
    required String id,
    this.hotelId = const Value.absent(),
    required String code,
    required String language,
    required String title,
    required String body,
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        code = Value(code),
        language = Value(language),
        title = Value(title),
        body = Value(body);
  static Insertable<MessageTemplate> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? code,
    Expression<String>? language,
    Expression<String>? title,
    Expression<String>? body,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (code != null) 'code': code,
      if (language != null) 'language': language,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageTemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? hotelId,
      Value<String>? code,
      Value<String>? language,
      Value<String>? title,
      Value<String>? body,
      Value<bool>? isCustom,
      Value<int>? rowid}) {
    return MessageTemplatesCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      code: code ?? this.code,
      language: language ?? this.language,
      title: title ?? this.title,
      body: body ?? this.body,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('code: $code, ')
          ..write('language: $language, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesLogTable extends MessagesLog
    with TableInfo<$MessagesLogTable, MessagesLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<String> hotelId = GeneratedColumn<String>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _guestIdMeta =
      const VerificationMeta('guestId');
  @override
  late final GeneratedColumn<String> guestId = GeneratedColumn<String>(
      'guest_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES guests (id)'));
  static const VerificationMeta _templateCodeMeta =
      const VerificationMeta('templateCode');
  @override
  late final GeneratedColumn<String> templateCode = GeneratedColumn<String>(
      'template_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _renderedBodyMeta =
      const VerificationMeta('renderedBody');
  @override
  late final GeneratedColumn<String> renderedBody = GeneratedColumn<String>(
      'rendered_body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelMeta =
      const VerificationMeta('channel');
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
      'channel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        hotelId,
        guestId,
        templateCode,
        language,
        renderedBody,
        channel,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_log';
  @override
  VerificationContext validateIntegrity(Insertable<MessagesLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('guest_id')) {
      context.handle(_guestIdMeta,
          guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta));
    }
    if (data.containsKey('template_code')) {
      context.handle(
          _templateCodeMeta,
          templateCode.isAcceptableOrUnknown(
              data['template_code']!, _templateCodeMeta));
    } else if (isInserting) {
      context.missing(_templateCodeMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('rendered_body')) {
      context.handle(
          _renderedBodyMeta,
          renderedBody.isAcceptableOrUnknown(
              data['rendered_body']!, _renderedBodyMeta));
    } else if (isInserting) {
      context.missing(_renderedBodyMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(_channelMeta,
          channel.isAcceptableOrUnknown(data['channel']!, _channelMeta));
    } else if (isInserting) {
      context.missing(_channelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessagesLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hotel_id'])!,
      guestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_id']),
      templateCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_code'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      renderedBody: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rendered_body'])!,
      channel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MessagesLogTable createAlias(String alias) {
    return $MessagesLogTable(attachedDatabase, alias);
  }
}

class MessagesLogData extends DataClass implements Insertable<MessagesLogData> {
  final String id;
  final String hotelId;
  final String? guestId;
  final String templateCode;
  final String language;
  final String renderedBody;
  final String channel;
  final DateTime createdAt;
  const MessagesLogData(
      {required this.id,
      required this.hotelId,
      this.guestId,
      required this.templateCode,
      required this.language,
      required this.renderedBody,
      required this.channel,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hotel_id'] = Variable<String>(hotelId);
    if (!nullToAbsent || guestId != null) {
      map['guest_id'] = Variable<String>(guestId);
    }
    map['template_code'] = Variable<String>(templateCode);
    map['language'] = Variable<String>(language);
    map['rendered_body'] = Variable<String>(renderedBody);
    map['channel'] = Variable<String>(channel);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessagesLogCompanion toCompanion(bool nullToAbsent) {
    return MessagesLogCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      guestId: guestId == null && nullToAbsent
          ? const Value.absent()
          : Value(guestId),
      templateCode: Value(templateCode),
      language: Value(language),
      renderedBody: Value(renderedBody),
      channel: Value(channel),
      createdAt: Value(createdAt),
    );
  }

  factory MessagesLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesLogData(
      id: serializer.fromJson<String>(json['id']),
      hotelId: serializer.fromJson<String>(json['hotelId']),
      guestId: serializer.fromJson<String?>(json['guestId']),
      templateCode: serializer.fromJson<String>(json['templateCode']),
      language: serializer.fromJson<String>(json['language']),
      renderedBody: serializer.fromJson<String>(json['renderedBody']),
      channel: serializer.fromJson<String>(json['channel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hotelId': serializer.toJson<String>(hotelId),
      'guestId': serializer.toJson<String?>(guestId),
      'templateCode': serializer.toJson<String>(templateCode),
      'language': serializer.toJson<String>(language),
      'renderedBody': serializer.toJson<String>(renderedBody),
      'channel': serializer.toJson<String>(channel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MessagesLogData copyWith(
          {String? id,
          String? hotelId,
          Value<String?> guestId = const Value.absent(),
          String? templateCode,
          String? language,
          String? renderedBody,
          String? channel,
          DateTime? createdAt}) =>
      MessagesLogData(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        guestId: guestId.present ? guestId.value : this.guestId,
        templateCode: templateCode ?? this.templateCode,
        language: language ?? this.language,
        renderedBody: renderedBody ?? this.renderedBody,
        channel: channel ?? this.channel,
        createdAt: createdAt ?? this.createdAt,
      );
  MessagesLogData copyWithCompanion(MessagesLogCompanion data) {
    return MessagesLogData(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      templateCode: data.templateCode.present
          ? data.templateCode.value
          : this.templateCode,
      language: data.language.present ? data.language.value : this.language,
      renderedBody: data.renderedBody.present
          ? data.renderedBody.value
          : this.renderedBody,
      channel: data.channel.present ? data.channel.value : this.channel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessagesLogData(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('guestId: $guestId, ')
          ..write('templateCode: $templateCode, ')
          ..write('language: $language, ')
          ..write('renderedBody: $renderedBody, ')
          ..write('channel: $channel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hotelId, guestId, templateCode, language,
      renderedBody, channel, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesLogData &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.guestId == this.guestId &&
          other.templateCode == this.templateCode &&
          other.language == this.language &&
          other.renderedBody == this.renderedBody &&
          other.channel == this.channel &&
          other.createdAt == this.createdAt);
}

class MessagesLogCompanion extends UpdateCompanion<MessagesLogData> {
  final Value<String> id;
  final Value<String> hotelId;
  final Value<String?> guestId;
  final Value<String> templateCode;
  final Value<String> language;
  final Value<String> renderedBody;
  final Value<String> channel;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MessagesLogCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.guestId = const Value.absent(),
    this.templateCode = const Value.absent(),
    this.language = const Value.absent(),
    this.renderedBody = const Value.absent(),
    this.channel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesLogCompanion.insert({
    required String id,
    required String hotelId,
    this.guestId = const Value.absent(),
    required String templateCode,
    required String language,
    required String renderedBody,
    required String channel,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hotelId = Value(hotelId),
        templateCode = Value(templateCode),
        language = Value(language),
        renderedBody = Value(renderedBody),
        channel = Value(channel);
  static Insertable<MessagesLogData> custom({
    Expression<String>? id,
    Expression<String>? hotelId,
    Expression<String>? guestId,
    Expression<String>? templateCode,
    Expression<String>? language,
    Expression<String>? renderedBody,
    Expression<String>? channel,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (guestId != null) 'guest_id': guestId,
      if (templateCode != null) 'template_code': templateCode,
      if (language != null) 'language': language,
      if (renderedBody != null) 'rendered_body': renderedBody,
      if (channel != null) 'channel': channel,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesLogCompanion copyWith(
      {Value<String>? id,
      Value<String>? hotelId,
      Value<String?>? guestId,
      Value<String>? templateCode,
      Value<String>? language,
      Value<String>? renderedBody,
      Value<String>? channel,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MessagesLogCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      guestId: guestId ?? this.guestId,
      templateCode: templateCode ?? this.templateCode,
      language: language ?? this.language,
      renderedBody: renderedBody ?? this.renderedBody,
      channel: channel ?? this.channel,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<String>(hotelId.value);
    }
    if (guestId.present) {
      map['guest_id'] = Variable<String>(guestId.value);
    }
    if (templateCode.present) {
      map['template_code'] = Variable<String>(templateCode.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (renderedBody.present) {
      map['rendered_body'] = Variable<String>(renderedBody.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesLogCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('guestId: $guestId, ')
          ..write('templateCode: $templateCode, ')
          ..write('language: $language, ')
          ..write('renderedBody: $renderedBody, ')
          ..write('channel: $channel, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuestDocumentsTable extends GuestDocuments
    with TableInfo<$GuestDocumentsTable, GuestDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuestDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _guestIdMeta =
      const VerificationMeta('guestId');
  @override
  late final GeneratedColumn<String> guestId = GeneratedColumn<String>(
      'guest_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES guests (id)'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, guestId, filePath, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guest_documents';
  @override
  VerificationContext validateIntegrity(Insertable<GuestDocument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('guest_id')) {
      context.handle(_guestIdMeta,
          guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta));
    } else if (isInserting) {
      context.missing(_guestIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuestDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuestDocument(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      guestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GuestDocumentsTable createAlias(String alias) {
    return $GuestDocumentsTable(attachedDatabase, alias);
  }
}

class GuestDocument extends DataClass implements Insertable<GuestDocument> {
  final String id;
  final String guestId;
  final String filePath;
  final String? description;
  final DateTime createdAt;
  const GuestDocument(
      {required this.id,
      required this.guestId,
      required this.filePath,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['guest_id'] = Variable<String>(guestId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GuestDocumentsCompanion toCompanion(bool nullToAbsent) {
    return GuestDocumentsCompanion(
      id: Value(id),
      guestId: Value(guestId),
      filePath: Value(filePath),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory GuestDocument.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuestDocument(
      id: serializer.fromJson<String>(json['id']),
      guestId: serializer.fromJson<String>(json['guestId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'guestId': serializer.toJson<String>(guestId),
      'filePath': serializer.toJson<String>(filePath),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GuestDocument copyWith(
          {String? id,
          String? guestId,
          String? filePath,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      GuestDocument(
        id: id ?? this.id,
        guestId: guestId ?? this.guestId,
        filePath: filePath ?? this.filePath,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  GuestDocument copyWithCompanion(GuestDocumentsCompanion data) {
    return GuestDocument(
      id: data.id.present ? data.id.value : this.id,
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuestDocument(')
          ..write('id: $id, ')
          ..write('guestId: $guestId, ')
          ..write('filePath: $filePath, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, guestId, filePath, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuestDocument &&
          other.id == this.id &&
          other.guestId == this.guestId &&
          other.filePath == this.filePath &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class GuestDocumentsCompanion extends UpdateCompanion<GuestDocument> {
  final Value<String> id;
  final Value<String> guestId;
  final Value<String> filePath;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GuestDocumentsCompanion({
    this.id = const Value.absent(),
    this.guestId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuestDocumentsCompanion.insert({
    required String id,
    required String guestId,
    required String filePath,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        guestId = Value(guestId),
        filePath = Value(filePath);
  static Insertable<GuestDocument> custom({
    Expression<String>? id,
    Expression<String>? guestId,
    Expression<String>? filePath,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (guestId != null) 'guest_id': guestId,
      if (filePath != null) 'file_path': filePath,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuestDocumentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? guestId,
      Value<String>? filePath,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return GuestDocumentsCompanion(
      id: id ?? this.id,
      guestId: guestId ?? this.guestId,
      filePath: filePath ?? this.filePath,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (guestId.present) {
      map['guest_id'] = Variable<String>(guestId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuestDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('guestId: $guestId, ')
          ..write('filePath: $filePath, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HotelsTable hotels = $HotelsTable(this);
  late final $RoomTypesTable roomTypes = $RoomTypesTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $GuestsTable guests = $GuestsTable(this);
  late final $BookingsTable bookings = $BookingsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $MessageTemplatesTable messageTemplates =
      $MessageTemplatesTable(this);
  late final $MessagesLogTable messagesLog = $MessagesLogTable(this);
  late final $GuestDocumentsTable guestDocuments = $GuestDocumentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        hotels,
        roomTypes,
        rooms,
        guests,
        bookings,
        payments,
        expenses,
        users,
        messageTemplates,
        messagesLog,
        guestDocuments
      ];
}

typedef $$HotelsTableCreateCompanionBuilder = HotelsCompanion Function({
  required String id,
  required String name,
  Value<String> defaultLanguage,
  Value<String> currency,
  Value<String> checkInHour,
  Value<String> checkOutHour,
  Value<double> defaultRoomPrice,
  Value<String?> country,
  Value<String?> city,
  Value<String?> logoUrl,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$HotelsTableUpdateCompanionBuilder = HotelsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> defaultLanguage,
  Value<String> currency,
  Value<String> checkInHour,
  Value<String> checkOutHour,
  Value<double> defaultRoomPrice,
  Value<String?> country,
  Value<String?> city,
  Value<String?> logoUrl,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$HotelsTableReferences
    extends BaseReferences<_$AppDatabase, $HotelsTable, Hotel> {
  $$HotelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoomTypesTable, List<RoomType>>
      _roomTypesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.roomTypes,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.roomTypes.hotelId));

  $$RoomTypesTableProcessedTableManager get roomTypesRefs {
    final manager = $$RoomTypesTableTableManager($_db, $_db.roomTypes)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomTypesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RoomsTable, List<Room>> _roomsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.rooms,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.rooms.hotelId));

  $$RoomsTableProcessedTableManager get roomsRefs {
    final manager = $$RoomsTableTableManager($_db, $_db.rooms)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GuestsTable, List<Guest>> _guestsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.guests,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.guests.hotelId));

  $$GuestsTableProcessedTableManager get guestsRefs {
    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_guestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BookingsTable, List<Booking>> _bookingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.bookings,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.bookings.hotelId));

  $$BookingsTableProcessedTableManager get bookingsRefs {
    final manager = $$BookingsTableTableManager($_db, $_db.bookings)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.expenses.hotelId));

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UsersTable, List<User>> _usersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.users,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.users.hotelId));

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MessageTemplatesTable, List<MessageTemplate>>
      _messageTemplatesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.messageTemplates,
              aliasName: $_aliasNameGenerator(
                  db.hotels.id, db.messageTemplates.hotelId));

  $$MessageTemplatesTableProcessedTableManager get messageTemplatesRefs {
    final manager =
        $$MessageTemplatesTableTableManager($_db, $_db.messageTemplates)
            .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_messageTemplatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MessagesLogTable, List<MessagesLogData>>
      _messagesLogRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.messagesLog,
              aliasName:
                  $_aliasNameGenerator(db.hotels.id, db.messagesLog.hotelId));

  $$MessagesLogTableProcessedTableManager get messagesLogRefs {
    final manager = $$MessagesLogTableTableManager($_db, $_db.messagesLog)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesLogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HotelsTableFilterComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultLanguage => $composableBuilder(
      column: $table.defaultLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkInHour => $composableBuilder(
      column: $table.checkInHour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkOutHour => $composableBuilder(
      column: $table.checkOutHour, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultRoomPrice => $composableBuilder(
      column: $table.defaultRoomPrice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> roomTypesRefs(
      Expression<bool> Function($$RoomTypesTableFilterComposer f) f) {
    final $$RoomTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.roomTypes,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomTypesTableFilterComposer(
              $db: $db,
              $table: $db.roomTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> roomsRefs(
      Expression<bool> Function($$RoomsTableFilterComposer f) f) {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableFilterComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> guestsRefs(
      Expression<bool> Function($$GuestsTableFilterComposer f) f) {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> bookingsRefs(
      Expression<bool> Function($$BookingsTableFilterComposer f) f) {
    final $$BookingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableFilterComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> usersRefs(
      Expression<bool> Function($$UsersTableFilterComposer f) f) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> messageTemplatesRefs(
      Expression<bool> Function($$MessageTemplatesTableFilterComposer f) f) {
    final $$MessageTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messageTemplates,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessageTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.messageTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> messagesLogRefs(
      Expression<bool> Function($$MessagesLogTableFilterComposer f) f) {
    final $$MessagesLogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messagesLog,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesLogTableFilterComposer(
              $db: $db,
              $table: $db.messagesLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HotelsTableOrderingComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultLanguage => $composableBuilder(
      column: $table.defaultLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkInHour => $composableBuilder(
      column: $table.checkInHour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkOutHour => $composableBuilder(
      column: $table.checkOutHour,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultRoomPrice => $composableBuilder(
      column: $table.defaultRoomPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HotelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get defaultLanguage => $composableBuilder(
      column: $table.defaultLanguage, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get checkInHour => $composableBuilder(
      column: $table.checkInHour, builder: (column) => column);

  GeneratedColumn<String> get checkOutHour => $composableBuilder(
      column: $table.checkOutHour, builder: (column) => column);

  GeneratedColumn<double> get defaultRoomPrice => $composableBuilder(
      column: $table.defaultRoomPrice, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> roomTypesRefs<T extends Object>(
      Expression<T> Function($$RoomTypesTableAnnotationComposer a) f) {
    final $$RoomTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.roomTypes,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.roomTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> roomsRefs<T extends Object>(
      Expression<T> Function($$RoomsTableAnnotationComposer a) f) {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableAnnotationComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> guestsRefs<T extends Object>(
      Expression<T> Function($$GuestsTableAnnotationComposer a) f) {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> bookingsRefs<T extends Object>(
      Expression<T> Function($$BookingsTableAnnotationComposer a) f) {
    final $$BookingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> usersRefs<T extends Object>(
      Expression<T> Function($$UsersTableAnnotationComposer a) f) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> messageTemplatesRefs<T extends Object>(
      Expression<T> Function($$MessageTemplatesTableAnnotationComposer a) f) {
    final $$MessageTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messageTemplates,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessageTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.messageTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> messagesLogRefs<T extends Object>(
      Expression<T> Function($$MessagesLogTableAnnotationComposer a) f) {
    final $$MessagesLogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messagesLog,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesLogTableAnnotationComposer(
              $db: $db,
              $table: $db.messagesLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HotelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HotelsTable,
    Hotel,
    $$HotelsTableFilterComposer,
    $$HotelsTableOrderingComposer,
    $$HotelsTableAnnotationComposer,
    $$HotelsTableCreateCompanionBuilder,
    $$HotelsTableUpdateCompanionBuilder,
    (Hotel, $$HotelsTableReferences),
    Hotel,
    PrefetchHooks Function(
        {bool roomTypesRefs,
        bool roomsRefs,
        bool guestsRefs,
        bool bookingsRefs,
        bool expensesRefs,
        bool usersRefs,
        bool messageTemplatesRefs,
        bool messagesLogRefs})> {
  $$HotelsTableTableManager(_$AppDatabase db, $HotelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HotelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HotelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HotelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> defaultLanguage = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> checkInHour = const Value.absent(),
            Value<String> checkOutHour = const Value.absent(),
            Value<double> defaultRoomPrice = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HotelsCompanion(
            id: id,
            name: name,
            defaultLanguage: defaultLanguage,
            currency: currency,
            checkInHour: checkInHour,
            checkOutHour: checkOutHour,
            defaultRoomPrice: defaultRoomPrice,
            country: country,
            city: city,
            logoUrl: logoUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> defaultLanguage = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> checkInHour = const Value.absent(),
            Value<String> checkOutHour = const Value.absent(),
            Value<double> defaultRoomPrice = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HotelsCompanion.insert(
            id: id,
            name: name,
            defaultLanguage: defaultLanguage,
            currency: currency,
            checkInHour: checkInHour,
            checkOutHour: checkOutHour,
            defaultRoomPrice: defaultRoomPrice,
            country: country,
            city: city,
            logoUrl: logoUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HotelsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {roomTypesRefs = false,
              roomsRefs = false,
              guestsRefs = false,
              bookingsRefs = false,
              expensesRefs = false,
              usersRefs = false,
              messageTemplatesRefs = false,
              messagesLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (roomTypesRefs) db.roomTypes,
                if (roomsRefs) db.rooms,
                if (guestsRefs) db.guests,
                if (bookingsRefs) db.bookings,
                if (expensesRefs) db.expenses,
                if (usersRefs) db.users,
                if (messageTemplatesRefs) db.messageTemplates,
                if (messagesLogRefs) db.messagesLog
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomTypesRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, RoomType>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._roomTypesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0)
                                .roomTypesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (roomsRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, Room>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._roomsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).roomsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (guestsRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, Guest>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._guestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).guestsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (bookingsRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, Booking>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._bookingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).bookingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (expensesRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, Expense>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).expensesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (usersRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, User>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._usersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).usersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (messageTemplatesRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable,
                            MessageTemplate>(
                        currentTable: table,
                        referencedTable: $$HotelsTableReferences
                            ._messageTemplatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0)
                                .messageTemplatesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (messagesLogRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable,
                            MessagesLogData>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._messagesLogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0)
                                .messagesLogRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HotelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HotelsTable,
    Hotel,
    $$HotelsTableFilterComposer,
    $$HotelsTableOrderingComposer,
    $$HotelsTableAnnotationComposer,
    $$HotelsTableCreateCompanionBuilder,
    $$HotelsTableUpdateCompanionBuilder,
    (Hotel, $$HotelsTableReferences),
    Hotel,
    PrefetchHooks Function(
        {bool roomTypesRefs,
        bool roomsRefs,
        bool guestsRefs,
        bool bookingsRefs,
        bool expensesRefs,
        bool usersRefs,
        bool messageTemplatesRefs,
        bool messagesLogRefs})>;
typedef $$RoomTypesTableCreateCompanionBuilder = RoomTypesCompanion Function({
  required String id,
  required String hotelId,
  required String name,
  Value<double> price,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$RoomTypesTableUpdateCompanionBuilder = RoomTypesCompanion Function({
  Value<String> id,
  Value<String> hotelId,
  Value<String> name,
  Value<double> price,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$RoomTypesTableReferences
    extends BaseReferences<_$AppDatabase, $RoomTypesTable, RoomType> {
  $$RoomTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.roomTypes.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<String>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RoomsTable, List<Room>> _roomsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.rooms,
          aliasName:
              $_aliasNameGenerator(db.roomTypes.id, db.rooms.roomTypeId));

  $$RoomsTableProcessedTableManager get roomsRefs {
    final manager = $$RoomsTableTableManager($_db, $_db.rooms)
        .filter((f) => f.roomTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoomTypesTableFilterComposer
    extends Composer<_$AppDatabase, $RoomTypesTable> {
  $$RoomTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> roomsRefs(
      Expression<bool> Function($$RoomsTableFilterComposer f) f) {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.roomTypeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableFilterComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoomTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomTypesTable> {
  $$RoomTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoomTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomTypesTable> {
  $$RoomTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> roomsRefs<T extends Object>(
      Expression<T> Function($$RoomsTableAnnotationComposer a) f) {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.roomTypeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableAnnotationComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoomTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoomTypesTable,
    RoomType,
    $$RoomTypesTableFilterComposer,
    $$RoomTypesTableOrderingComposer,
    $$RoomTypesTableAnnotationComposer,
    $$RoomTypesTableCreateCompanionBuilder,
    $$RoomTypesTableUpdateCompanionBuilder,
    (RoomType, $$RoomTypesTableReferences),
    RoomType,
    PrefetchHooks Function({bool hotelId, bool roomsRefs})> {
  $$RoomTypesTableTableManager(_$AppDatabase db, $RoomTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hotelId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoomTypesCompanion(
            id: id,
            hotelId: hotelId,
            name: name,
            price: price,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hotelId,
            required String name,
            Value<double> price = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoomTypesCompanion.insert(
            id: id,
            hotelId: hotelId,
            name: name,
            price: price,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RoomTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({hotelId = false, roomsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (roomsRefs) db.rooms],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable:
                        $$RoomTypesTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$RoomTypesTableReferences._hotelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomsRefs)
                    await $_getPrefetchedData<RoomType, $RoomTypesTable, Room>(
                        currentTable: table,
                        referencedTable:
                            $$RoomTypesTableReferences._roomsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoomTypesTableReferences(db, table, p0).roomsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.roomTypeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoomTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoomTypesTable,
    RoomType,
    $$RoomTypesTableFilterComposer,
    $$RoomTypesTableOrderingComposer,
    $$RoomTypesTableAnnotationComposer,
    $$RoomTypesTableCreateCompanionBuilder,
    $$RoomTypesTableUpdateCompanionBuilder,
    (RoomType, $$RoomTypesTableReferences),
    RoomType,
    PrefetchHooks Function({bool hotelId, bool roomsRefs})>;
typedef $$RoomsTableCreateCompanionBuilder = RoomsCompanion Function({
  required String id,
  required String hotelId,
  Value<String?> roomTypeId,
  required String name,
  Value<int> capacity,
  Value<String> status,
  Value<int> sortOrder,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$RoomsTableUpdateCompanionBuilder = RoomsCompanion Function({
  Value<String> id,
  Value<String> hotelId,
  Value<String?> roomTypeId,
  Value<String> name,
  Value<int> capacity,
  Value<String> status,
  Value<int> sortOrder,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$RoomsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomsTable, Room> {
  $$RoomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.rooms.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<String>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RoomTypesTable _roomTypeIdTable(_$AppDatabase db) => db.roomTypes
      .createAlias($_aliasNameGenerator(db.rooms.roomTypeId, db.roomTypes.id));

  $$RoomTypesTableProcessedTableManager? get roomTypeId {
    final $_column = $_itemColumn<String>('room_type_id');
    if ($_column == null) return null;
    final manager = $$RoomTypesTableTableManager($_db, $_db.roomTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BookingsTable, List<Booking>> _bookingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.bookings,
          aliasName: $_aliasNameGenerator(db.rooms.id, db.bookings.roomId));

  $$BookingsTableProcessedTableManager get bookingsRefs {
    final manager = $$BookingsTableTableManager($_db, $_db.bookings)
        .filter((f) => f.roomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomTypesTableFilterComposer get roomTypeId {
    final $$RoomTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomTypeId,
        referencedTable: $db.roomTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomTypesTableFilterComposer(
              $db: $db,
              $table: $db.roomTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> bookingsRefs(
      Expression<bool> Function($$BookingsTableFilterComposer f) f) {
    final $$BookingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.roomId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableFilterComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomTypesTableOrderingComposer get roomTypeId {
    final $$RoomTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomTypeId,
        referencedTable: $db.roomTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomTypesTableOrderingComposer(
              $db: $db,
              $table: $db.roomTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomTypesTableAnnotationComposer get roomTypeId {
    final $$RoomTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomTypeId,
        referencedTable: $db.roomTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.roomTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> bookingsRefs<T extends Object>(
      Expression<T> Function($$BookingsTableAnnotationComposer a) f) {
    final $$BookingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.roomId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoomsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoomsTable,
    Room,
    $$RoomsTableFilterComposer,
    $$RoomsTableOrderingComposer,
    $$RoomsTableAnnotationComposer,
    $$RoomsTableCreateCompanionBuilder,
    $$RoomsTableUpdateCompanionBuilder,
    (Room, $$RoomsTableReferences),
    Room,
    PrefetchHooks Function(
        {bool hotelId, bool roomTypeId, bool bookingsRefs})> {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hotelId = const Value.absent(),
            Value<String?> roomTypeId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoomsCompanion(
            id: id,
            hotelId: hotelId,
            roomTypeId: roomTypeId,
            name: name,
            capacity: capacity,
            status: status,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hotelId,
            Value<String?> roomTypeId = const Value.absent(),
            required String name,
            Value<int> capacity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoomsCompanion.insert(
            id: id,
            hotelId: hotelId,
            roomTypeId: roomTypeId,
            name: name,
            capacity: capacity,
            status: status,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RoomsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {hotelId = false, roomTypeId = false, bookingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (bookingsRefs) db.bookings],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable: $$RoomsTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$RoomsTableReferences._hotelIdTable(db).id,
                  ) as T;
                }
                if (roomTypeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.roomTypeId,
                    referencedTable:
                        $$RoomsTableReferences._roomTypeIdTable(db),
                    referencedColumn:
                        $$RoomsTableReferences._roomTypeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookingsRefs)
                    await $_getPrefetchedData<Room, $RoomsTable, Booking>(
                        currentTable: table,
                        referencedTable:
                            $$RoomsTableReferences._bookingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoomsTableReferences(db, table, p0).bookingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.roomId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoomsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoomsTable,
    Room,
    $$RoomsTableFilterComposer,
    $$RoomsTableOrderingComposer,
    $$RoomsTableAnnotationComposer,
    $$RoomsTableCreateCompanionBuilder,
    $$RoomsTableUpdateCompanionBuilder,
    (Room, $$RoomsTableReferences),
    Room,
    PrefetchHooks Function({bool hotelId, bool roomTypeId, bool bookingsRefs})>;
typedef $$GuestsTableCreateCompanionBuilder = GuestsCompanion Function({
  required String id,
  required String hotelId,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> country,
  Value<String?> language,
  Value<int> visitCount,
  Value<double> totalSpent,
  Value<bool> isBanned,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$GuestsTableUpdateCompanionBuilder = GuestsCompanion Function({
  Value<String> id,
  Value<String> hotelId,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> country,
  Value<String?> language,
  Value<int> visitCount,
  Value<double> totalSpent,
  Value<bool> isBanned,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$GuestsTableReferences
    extends BaseReferences<_$AppDatabase, $GuestsTable, Guest> {
  $$GuestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.guests.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<String>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BookingsTable, List<Booking>> _bookingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.bookings,
          aliasName: $_aliasNameGenerator(db.guests.id, db.bookings.guestId));

  $$BookingsTableProcessedTableManager get bookingsRefs {
    final manager = $$BookingsTableTableManager($_db, $_db.bookings)
        .filter((f) => f.guestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MessagesLogTable, List<MessagesLogData>>
      _messagesLogRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.messagesLog,
              aliasName:
                  $_aliasNameGenerator(db.guests.id, db.messagesLog.guestId));

  $$MessagesLogTableProcessedTableManager get messagesLogRefs {
    final manager = $$MessagesLogTableTableManager($_db, $_db.messagesLog)
        .filter((f) => f.guestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesLogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GuestDocumentsTable, List<GuestDocument>>
      _guestDocumentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.guestDocuments,
              aliasName: $_aliasNameGenerator(
                  db.guests.id, db.guestDocuments.guestId));

  $$GuestDocumentsTableProcessedTableManager get guestDocumentsRefs {
    final manager = $$GuestDocumentsTableTableManager($_db, $_db.guestDocuments)
        .filter((f) => f.guestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_guestDocumentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GuestsTableFilterComposer
    extends Composer<_$AppDatabase, $GuestsTable> {
  $$GuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visitCount => $composableBuilder(
      column: $table.visitCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBanned => $composableBuilder(
      column: $table.isBanned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> bookingsRefs(
      Expression<bool> Function($$BookingsTableFilterComposer f) f) {
    final $$BookingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableFilterComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> messagesLogRefs(
      Expression<bool> Function($$MessagesLogTableFilterComposer f) f) {
    final $$MessagesLogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messagesLog,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesLogTableFilterComposer(
              $db: $db,
              $table: $db.messagesLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> guestDocumentsRefs(
      Expression<bool> Function($$GuestDocumentsTableFilterComposer f) f) {
    final $$GuestDocumentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guestDocuments,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestDocumentsTableFilterComposer(
              $db: $db,
              $table: $db.guestDocuments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $GuestsTable> {
  $$GuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visitCount => $composableBuilder(
      column: $table.visitCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBanned => $composableBuilder(
      column: $table.isBanned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuestsTable> {
  $$GuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get visitCount => $composableBuilder(
      column: $table.visitCount, builder: (column) => column);

  GeneratedColumn<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => column);

  GeneratedColumn<bool> get isBanned =>
      $composableBuilder(column: $table.isBanned, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> bookingsRefs<T extends Object>(
      Expression<T> Function($$BookingsTableAnnotationComposer a) f) {
    final $$BookingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> messagesLogRefs<T extends Object>(
      Expression<T> Function($$MessagesLogTableAnnotationComposer a) f) {
    final $$MessagesLogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messagesLog,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesLogTableAnnotationComposer(
              $db: $db,
              $table: $db.messagesLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> guestDocumentsRefs<T extends Object>(
      Expression<T> Function($$GuestDocumentsTableAnnotationComposer a) f) {
    final $$GuestDocumentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guestDocuments,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestDocumentsTableAnnotationComposer(
              $db: $db,
              $table: $db.guestDocuments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GuestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GuestsTable,
    Guest,
    $$GuestsTableFilterComposer,
    $$GuestsTableOrderingComposer,
    $$GuestsTableAnnotationComposer,
    $$GuestsTableCreateCompanionBuilder,
    $$GuestsTableUpdateCompanionBuilder,
    (Guest, $$GuestsTableReferences),
    Guest,
    PrefetchHooks Function(
        {bool hotelId,
        bool bookingsRefs,
        bool messagesLogRefs,
        bool guestDocumentsRefs})> {
  $$GuestsTableTableManager(_$AppDatabase db, $GuestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hotelId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<int> visitCount = const Value.absent(),
            Value<double> totalSpent = const Value.absent(),
            Value<bool> isBanned = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GuestsCompanion(
            id: id,
            hotelId: hotelId,
            name: name,
            phone: phone,
            email: email,
            country: country,
            language: language,
            visitCount: visitCount,
            totalSpent: totalSpent,
            isBanned: isBanned,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hotelId,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<int> visitCount = const Value.absent(),
            Value<double> totalSpent = const Value.absent(),
            Value<bool> isBanned = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GuestsCompanion.insert(
            id: id,
            hotelId: hotelId,
            name: name,
            phone: phone,
            email: email,
            country: country,
            language: language,
            visitCount: visitCount,
            totalSpent: totalSpent,
            isBanned: isBanned,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GuestsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {hotelId = false,
              bookingsRefs = false,
              messagesLogRefs = false,
              guestDocumentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bookingsRefs) db.bookings,
                if (messagesLogRefs) db.messagesLog,
                if (guestDocumentsRefs) db.guestDocuments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable: $$GuestsTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$GuestsTableReferences._hotelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookingsRefs)
                    await $_getPrefetchedData<Guest, $GuestsTable, Booking>(
                        currentTable: table,
                        referencedTable:
                            $$GuestsTableReferences._bookingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GuestsTableReferences(db, table, p0).bookingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.guestId == item.id),
                        typedResults: items),
                  if (messagesLogRefs)
                    await $_getPrefetchedData<Guest, $GuestsTable,
                            MessagesLogData>(
                        currentTable: table,
                        referencedTable:
                            $$GuestsTableReferences._messagesLogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GuestsTableReferences(db, table, p0)
                                .messagesLogRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.guestId == item.id),
                        typedResults: items),
                  if (guestDocumentsRefs)
                    await $_getPrefetchedData<Guest, $GuestsTable,
                            GuestDocument>(
                        currentTable: table,
                        referencedTable: $$GuestsTableReferences
                            ._guestDocumentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GuestsTableReferences(db, table, p0)
                                .guestDocumentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.guestId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GuestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GuestsTable,
    Guest,
    $$GuestsTableFilterComposer,
    $$GuestsTableOrderingComposer,
    $$GuestsTableAnnotationComposer,
    $$GuestsTableCreateCompanionBuilder,
    $$GuestsTableUpdateCompanionBuilder,
    (Guest, $$GuestsTableReferences),
    Guest,
    PrefetchHooks Function(
        {bool hotelId,
        bool bookingsRefs,
        bool messagesLogRefs,
        bool guestDocumentsRefs})>;
typedef $$BookingsTableCreateCompanionBuilder = BookingsCompanion Function({
  required String id,
  required String hotelId,
  required String roomId,
  required String guestId,
  required DateTime checkIn,
  required DateTime checkOut,
  Value<String> status,
  Value<String> source,
  Value<double?> priceTotal,
  Value<String> paymentStatus,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$BookingsTableUpdateCompanionBuilder = BookingsCompanion Function({
  Value<String> id,
  Value<String> hotelId,
  Value<String> roomId,
  Value<String> guestId,
  Value<DateTime> checkIn,
  Value<DateTime> checkOut,
  Value<String> status,
  Value<String> source,
  Value<double?> priceTotal,
  Value<String> paymentStatus,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$BookingsTableReferences
    extends BaseReferences<_$AppDatabase, $BookingsTable, Booking> {
  $$BookingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.bookings.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<String>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RoomsTable _roomIdTable(_$AppDatabase db) => db.rooms
      .createAlias($_aliasNameGenerator(db.bookings.roomId, db.rooms.id));

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<String>('room_id')!;

    final manager = $$RoomsTableTableManager($_db, $_db.rooms)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GuestsTable _guestIdTable(_$AppDatabase db) => db.guests
      .createAlias($_aliasNameGenerator(db.bookings.guestId, db.guests.id));

  $$GuestsTableProcessedTableManager get guestId {
    final $_column = $_itemColumn<String>('guest_id')!;

    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_guestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName:
              $_aliasNameGenerator(db.bookings.id, db.payments.bookingId));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.bookingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BookingsTableFilterComposer
    extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceTotal => $composableBuilder(
      column: $table.priceTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableFilterComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GuestsTableFilterComposer get guestId {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.bookingId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BookingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceTotal => $composableBuilder(
      column: $table.priceTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableOrderingComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GuestsTableOrderingComposer get guestId {
    final $$GuestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableOrderingComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<DateTime> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get priceTotal => $composableBuilder(
      column: $table.priceTotal, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableAnnotationComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GuestsTableAnnotationComposer get guestId {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.bookingId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BookingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookingsTable,
    Booking,
    $$BookingsTableFilterComposer,
    $$BookingsTableOrderingComposer,
    $$BookingsTableAnnotationComposer,
    $$BookingsTableCreateCompanionBuilder,
    $$BookingsTableUpdateCompanionBuilder,
    (Booking, $$BookingsTableReferences),
    Booking,
    PrefetchHooks Function(
        {bool hotelId, bool roomId, bool guestId, bool paymentsRefs})> {
  $$BookingsTableTableManager(_$AppDatabase db, $BookingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hotelId = const Value.absent(),
            Value<String> roomId = const Value.absent(),
            Value<String> guestId = const Value.absent(),
            Value<DateTime> checkIn = const Value.absent(),
            Value<DateTime> checkOut = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<double?> priceTotal = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookingsCompanion(
            id: id,
            hotelId: hotelId,
            roomId: roomId,
            guestId: guestId,
            checkIn: checkIn,
            checkOut: checkOut,
            status: status,
            source: source,
            priceTotal: priceTotal,
            paymentStatus: paymentStatus,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hotelId,
            required String roomId,
            required String guestId,
            required DateTime checkIn,
            required DateTime checkOut,
            Value<String> status = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<double?> priceTotal = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookingsCompanion.insert(
            id: id,
            hotelId: hotelId,
            roomId: roomId,
            guestId: guestId,
            checkIn: checkIn,
            checkOut: checkOut,
            status: status,
            source: source,
            priceTotal: priceTotal,
            paymentStatus: paymentStatus,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BookingsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {hotelId = false,
              roomId = false,
              guestId = false,
              paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paymentsRefs) db.payments],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable:
                        $$BookingsTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$BookingsTableReferences._hotelIdTable(db).id,
                  ) as T;
                }
                if (roomId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.roomId,
                    referencedTable: $$BookingsTableReferences._roomIdTable(db),
                    referencedColumn:
                        $$BookingsTableReferences._roomIdTable(db).id,
                  ) as T;
                }
                if (guestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.guestId,
                    referencedTable:
                        $$BookingsTableReferences._guestIdTable(db),
                    referencedColumn:
                        $$BookingsTableReferences._guestIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentsRefs)
                    await $_getPrefetchedData<Booking, $BookingsTable, Payment>(
                        currentTable: table,
                        referencedTable:
                            $$BookingsTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BookingsTableReferences(db, table, p0)
                                .paymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.bookingId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BookingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookingsTable,
    Booking,
    $$BookingsTableFilterComposer,
    $$BookingsTableOrderingComposer,
    $$BookingsTableAnnotationComposer,
    $$BookingsTableCreateCompanionBuilder,
    $$BookingsTableUpdateCompanionBuilder,
    (Booking, $$BookingsTableReferences),
    Booking,
    PrefetchHooks Function(
        {bool hotelId, bool roomId, bool guestId, bool paymentsRefs})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String id,
  required String bookingId,
  required double amount,
  required DateTime date,
  Value<String> method,
  Value<String> type,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String> bookingId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> method,
  Value<String> type,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BookingsTable _bookingIdTable(_$AppDatabase db) => db.bookings
      .createAlias($_aliasNameGenerator(db.payments.bookingId, db.bookings.id));

  $$BookingsTableProcessedTableManager get bookingId {
    final $_column = $_itemColumn<String>('booking_id')!;

    final manager = $$BookingsTableTableManager($_db, $_db.bookings)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$BookingsTableFilterComposer get bookingId {
    final $$BookingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookingId,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableFilterComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$BookingsTableOrderingComposer get bookingId {
    final $$BookingsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookingId,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableOrderingComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BookingsTableAnnotationComposer get bookingId {
    final $$BookingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookingId,
        referencedTable: $db.bookings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool bookingId})> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bookingId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            bookingId: bookingId,
            amount: amount,
            date: date,
            method: method,
            type: type,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bookingId,
            required double amount,
            required DateTime date,
            Value<String> method = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            bookingId: bookingId,
            amount: amount,
            date: date,
            method: method,
            type: type,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PaymentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({bookingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bookingId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookingId,
                    referencedTable:
                        $$PaymentsTableReferences._bookingIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._bookingIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool bookingId})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  required String id,
  required String hotelId,
  required String description,
  required double amount,
  required DateTime date,
  Value<String> category,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<String> id,
  Value<String> hotelId,
  Value<String> description,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> category,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.expenses.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<String>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool hotelId})> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hotelId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            hotelId: hotelId,
            description: description,
            amount: amount,
            date: date,
            category: category,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hotelId,
            required String description,
            required double amount,
            required DateTime date,
            Value<String> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            hotelId: hotelId,
            description: description,
            amount: amount,
            date: date,
            category: category,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExpensesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({hotelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable:
                        $$ExpensesTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._hotelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool hotelId})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String email,
  required String passwordHash,
  Value<DateTime> createdAt,
  Value<String> role,
  Value<String?> hotelId,
  Value<String> plan,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> passwordHash,
  Value<DateTime> createdAt,
  Value<String> role,
  Value<String?> hotelId,
  Value<String> plan,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.users.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager? get hotelId {
    final $_column = $_itemColumn<String>('hotel_id');
    if ($_column == null) return null;
    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool hotelId})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> hotelId = const Value.absent(),
            Value<String> plan = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            email: email,
            passwordHash: passwordHash,
            createdAt: createdAt,
            role: role,
            hotelId: hotelId,
            plan: plan,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            required String passwordHash,
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> hotelId = const Value.absent(),
            Value<String> plan = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            email: email,
            passwordHash: passwordHash,
            createdAt: createdAt,
            role: role,
            hotelId: hotelId,
            plan: plan,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({hotelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable: $$UsersTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$UsersTableReferences._hotelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool hotelId})>;
typedef $$MessageTemplatesTableCreateCompanionBuilder
    = MessageTemplatesCompanion Function({
  required String id,
  Value<String?> hotelId,
  required String code,
  required String language,
  required String title,
  required String body,
  Value<bool> isCustom,
  Value<int> rowid,
});
typedef $$MessageTemplatesTableUpdateCompanionBuilder
    = MessageTemplatesCompanion Function({
  Value<String> id,
  Value<String?> hotelId,
  Value<String> code,
  Value<String> language,
  Value<String> title,
  Value<String> body,
  Value<bool> isCustom,
  Value<int> rowid,
});

final class $$MessageTemplatesTableReferences extends BaseReferences<
    _$AppDatabase, $MessageTemplatesTable, MessageTemplate> {
  $$MessageTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels.createAlias(
      $_aliasNameGenerator(db.messageTemplates.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager? get hotelId {
    final $_column = $_itemColumn<String>('hotel_id');
    if ($_column == null) return null;
    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessageTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessageTemplatesTable,
    MessageTemplate,
    $$MessageTemplatesTableFilterComposer,
    $$MessageTemplatesTableOrderingComposer,
    $$MessageTemplatesTableAnnotationComposer,
    $$MessageTemplatesTableCreateCompanionBuilder,
    $$MessageTemplatesTableUpdateCompanionBuilder,
    (MessageTemplate, $$MessageTemplatesTableReferences),
    MessageTemplate,
    PrefetchHooks Function({bool hotelId})> {
  $$MessageTemplatesTableTableManager(
      _$AppDatabase db, $MessageTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> hotelId = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageTemplatesCompanion(
            id: id,
            hotelId: hotelId,
            code: code,
            language: language,
            title: title,
            body: body,
            isCustom: isCustom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> hotelId = const Value.absent(),
            required String code,
            required String language,
            required String title,
            required String body,
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageTemplatesCompanion.insert(
            id: id,
            hotelId: hotelId,
            code: code,
            language: language,
            title: title,
            body: body,
            isCustom: isCustom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MessageTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({hotelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable:
                        $$MessageTemplatesTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$MessageTemplatesTableReferences._hotelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessageTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessageTemplatesTable,
    MessageTemplate,
    $$MessageTemplatesTableFilterComposer,
    $$MessageTemplatesTableOrderingComposer,
    $$MessageTemplatesTableAnnotationComposer,
    $$MessageTemplatesTableCreateCompanionBuilder,
    $$MessageTemplatesTableUpdateCompanionBuilder,
    (MessageTemplate, $$MessageTemplatesTableReferences),
    MessageTemplate,
    PrefetchHooks Function({bool hotelId})>;
typedef $$MessagesLogTableCreateCompanionBuilder = MessagesLogCompanion
    Function({
  required String id,
  required String hotelId,
  Value<String?> guestId,
  required String templateCode,
  required String language,
  required String renderedBody,
  required String channel,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$MessagesLogTableUpdateCompanionBuilder = MessagesLogCompanion
    Function({
  Value<String> id,
  Value<String> hotelId,
  Value<String?> guestId,
  Value<String> templateCode,
  Value<String> language,
  Value<String> renderedBody,
  Value<String> channel,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$MessagesLogTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesLogTable, MessagesLogData> {
  $$MessagesLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.messagesLog.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<String>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GuestsTable _guestIdTable(_$AppDatabase db) => db.guests
      .createAlias($_aliasNameGenerator(db.messagesLog.guestId, db.guests.id));

  $$GuestsTableProcessedTableManager? get guestId {
    final $_column = $_itemColumn<String>('guest_id');
    if ($_column == null) return null;
    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_guestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessagesLogTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesLogTable> {
  $$MessagesLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateCode => $composableBuilder(
      column: $table.templateCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get renderedBody => $composableBuilder(
      column: $table.renderedBody, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GuestsTableFilterComposer get guestId {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesLogTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesLogTable> {
  $$MessagesLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateCode => $composableBuilder(
      column: $table.templateCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get renderedBody => $composableBuilder(
      column: $table.renderedBody,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GuestsTableOrderingComposer get guestId {
    final $$GuestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableOrderingComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesLogTable> {
  $$MessagesLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateCode => $composableBuilder(
      column: $table.templateCode, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get renderedBody => $composableBuilder(
      column: $table.renderedBody, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GuestsTableAnnotationComposer get guestId {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessagesLogTable,
    MessagesLogData,
    $$MessagesLogTableFilterComposer,
    $$MessagesLogTableOrderingComposer,
    $$MessagesLogTableAnnotationComposer,
    $$MessagesLogTableCreateCompanionBuilder,
    $$MessagesLogTableUpdateCompanionBuilder,
    (MessagesLogData, $$MessagesLogTableReferences),
    MessagesLogData,
    PrefetchHooks Function({bool hotelId, bool guestId})> {
  $$MessagesLogTableTableManager(_$AppDatabase db, $MessagesLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hotelId = const Value.absent(),
            Value<String?> guestId = const Value.absent(),
            Value<String> templateCode = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> renderedBody = const Value.absent(),
            Value<String> channel = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesLogCompanion(
            id: id,
            hotelId: hotelId,
            guestId: guestId,
            templateCode: templateCode,
            language: language,
            renderedBody: renderedBody,
            channel: channel,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hotelId,
            Value<String?> guestId = const Value.absent(),
            required String templateCode,
            required String language,
            required String renderedBody,
            required String channel,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesLogCompanion.insert(
            id: id,
            hotelId: hotelId,
            guestId: guestId,
            templateCode: templateCode,
            language: language,
            renderedBody: renderedBody,
            channel: channel,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MessagesLogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({hotelId = false, guestId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable:
                        $$MessagesLogTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$MessagesLogTableReferences._hotelIdTable(db).id,
                  ) as T;
                }
                if (guestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.guestId,
                    referencedTable:
                        $$MessagesLogTableReferences._guestIdTable(db),
                    referencedColumn:
                        $$MessagesLogTableReferences._guestIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessagesLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessagesLogTable,
    MessagesLogData,
    $$MessagesLogTableFilterComposer,
    $$MessagesLogTableOrderingComposer,
    $$MessagesLogTableAnnotationComposer,
    $$MessagesLogTableCreateCompanionBuilder,
    $$MessagesLogTableUpdateCompanionBuilder,
    (MessagesLogData, $$MessagesLogTableReferences),
    MessagesLogData,
    PrefetchHooks Function({bool hotelId, bool guestId})>;
typedef $$GuestDocumentsTableCreateCompanionBuilder = GuestDocumentsCompanion
    Function({
  required String id,
  required String guestId,
  required String filePath,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$GuestDocumentsTableUpdateCompanionBuilder = GuestDocumentsCompanion
    Function({
  Value<String> id,
  Value<String> guestId,
  Value<String> filePath,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$GuestDocumentsTableReferences
    extends BaseReferences<_$AppDatabase, $GuestDocumentsTable, GuestDocument> {
  $$GuestDocumentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GuestsTable _guestIdTable(_$AppDatabase db) => db.guests.createAlias(
      $_aliasNameGenerator(db.guestDocuments.guestId, db.guests.id));

  $$GuestsTableProcessedTableManager get guestId {
    final $_column = $_itemColumn<String>('guest_id')!;

    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_guestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GuestDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $GuestDocumentsTable> {
  $$GuestDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$GuestsTableFilterComposer get guestId {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GuestDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $GuestDocumentsTable> {
  $$GuestDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$GuestsTableOrderingComposer get guestId {
    final $$GuestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableOrderingComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GuestDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuestDocumentsTable> {
  $$GuestDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GuestsTableAnnotationComposer get guestId {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GuestDocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GuestDocumentsTable,
    GuestDocument,
    $$GuestDocumentsTableFilterComposer,
    $$GuestDocumentsTableOrderingComposer,
    $$GuestDocumentsTableAnnotationComposer,
    $$GuestDocumentsTableCreateCompanionBuilder,
    $$GuestDocumentsTableUpdateCompanionBuilder,
    (GuestDocument, $$GuestDocumentsTableReferences),
    GuestDocument,
    PrefetchHooks Function({bool guestId})> {
  $$GuestDocumentsTableTableManager(
      _$AppDatabase db, $GuestDocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuestDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuestDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuestDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> guestId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GuestDocumentsCompanion(
            id: id,
            guestId: guestId,
            filePath: filePath,
            description: description,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String guestId,
            required String filePath,
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GuestDocumentsCompanion.insert(
            id: id,
            guestId: guestId,
            filePath: filePath,
            description: description,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GuestDocumentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({guestId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (guestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.guestId,
                    referencedTable:
                        $$GuestDocumentsTableReferences._guestIdTable(db),
                    referencedColumn:
                        $$GuestDocumentsTableReferences._guestIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GuestDocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GuestDocumentsTable,
    GuestDocument,
    $$GuestDocumentsTableFilterComposer,
    $$GuestDocumentsTableOrderingComposer,
    $$GuestDocumentsTableAnnotationComposer,
    $$GuestDocumentsTableCreateCompanionBuilder,
    $$GuestDocumentsTableUpdateCompanionBuilder,
    (GuestDocument, $$GuestDocumentsTableReferences),
    GuestDocument,
    PrefetchHooks Function({bool guestId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db, _db.hotels);
  $$RoomTypesTableTableManager get roomTypes =>
      $$RoomTypesTableTableManager(_db, _db.roomTypes);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$GuestsTableTableManager get guests =>
      $$GuestsTableTableManager(_db, _db.guests);
  $$BookingsTableTableManager get bookings =>
      $$BookingsTableTableManager(_db, _db.bookings);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MessageTemplatesTableTableManager get messageTemplates =>
      $$MessageTemplatesTableTableManager(_db, _db.messageTemplates);
  $$MessagesLogTableTableManager get messagesLog =>
      $$MessagesLogTableTableManager(_db, _db.messagesLog);
  $$GuestDocumentsTableTableManager get guestDocuments =>
      $$GuestDocumentsTableTableManager(_db, _db.guestDocuments);
}
