// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cabinet_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CabinetItem {
  String get id => throw _privateConstructorUsedError;
  String get drinkId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  CabinetStatus get status =>
      throw _privateConstructorUsedError; // Physical details
  DateTime get addedAt => throw _privateConstructorUsedError;
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get openedDate => throw _privateConstructorUsedError;
  DateTime? get finishedDate =>
      throw _privateConstructorUsedError; // Storage and organization
  StorageLocation get location => throw _privateConstructorUsedError;
  String? get customLocation => throw _privateConstructorUsedError;
  int? get quantity =>
      throw _privateConstructorUsedError; // Purchase information
  double? get purchasePrice => throw _privateConstructorUsedError;
  String? get purchaseStore => throw _privateConstructorUsedError;
  String? get purchaseNotes =>
      throw _privateConstructorUsedError; // Condition and notes
  int get fillLevel => throw _privateConstructorUsedError; // Percentage 0-100
  String? get personalNotes => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of CabinetItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CabinetItemCopyWith<CabinetItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CabinetItemCopyWith<$Res> {
  factory $CabinetItemCopyWith(
          CabinetItem value, $Res Function(CabinetItem) then) =
      _$CabinetItemCopyWithImpl<$Res, CabinetItem>;
  @useResult
  $Res call(
      {String id,
      String drinkId,
      String userId,
      CabinetStatus status,
      DateTime addedAt,
      DateTime? purchaseDate,
      DateTime? openedDate,
      DateTime? finishedDate,
      StorageLocation location,
      String? customLocation,
      int? quantity,
      double? purchasePrice,
      String? purchaseStore,
      String? purchaseNotes,
      int fillLevel,
      String? personalNotes,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CabinetItemCopyWithImpl<$Res, $Val extends CabinetItem>
    implements $CabinetItemCopyWith<$Res> {
  _$CabinetItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CabinetItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drinkId = null,
    Object? userId = null,
    Object? status = null,
    Object? addedAt = null,
    Object? purchaseDate = freezed,
    Object? openedDate = freezed,
    Object? finishedDate = freezed,
    Object? location = null,
    Object? customLocation = freezed,
    Object? quantity = freezed,
    Object? purchasePrice = freezed,
    Object? purchaseStore = freezed,
    Object? purchaseNotes = freezed,
    Object? fillLevel = null,
    Object? personalNotes = freezed,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      drinkId: null == drinkId
          ? _value.drinkId
          : drinkId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CabinetStatus,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      openedDate: freezed == openedDate
          ? _value.openedDate
          : openedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedDate: freezed == finishedDate
          ? _value.finishedDate
          : finishedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as StorageLocation,
      customLocation: freezed == customLocation
          ? _value.customLocation
          : customLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      purchaseStore: freezed == purchaseStore
          ? _value.purchaseStore
          : purchaseStore // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseNotes: freezed == purchaseNotes
          ? _value.purchaseNotes
          : purchaseNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      fillLevel: null == fillLevel
          ? _value.fillLevel
          : fillLevel // ignore: cast_nullable_to_non_nullable
              as int,
      personalNotes: freezed == personalNotes
          ? _value.personalNotes
          : personalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CabinetItemImplCopyWith<$Res>
    implements $CabinetItemCopyWith<$Res> {
  factory _$$CabinetItemImplCopyWith(
          _$CabinetItemImpl value, $Res Function(_$CabinetItemImpl) then) =
      __$$CabinetItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String drinkId,
      String userId,
      CabinetStatus status,
      DateTime addedAt,
      DateTime? purchaseDate,
      DateTime? openedDate,
      DateTime? finishedDate,
      StorageLocation location,
      String? customLocation,
      int? quantity,
      double? purchasePrice,
      String? purchaseStore,
      String? purchaseNotes,
      int fillLevel,
      String? personalNotes,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$CabinetItemImplCopyWithImpl<$Res>
    extends _$CabinetItemCopyWithImpl<$Res, _$CabinetItemImpl>
    implements _$$CabinetItemImplCopyWith<$Res> {
  __$$CabinetItemImplCopyWithImpl(
      _$CabinetItemImpl _value, $Res Function(_$CabinetItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CabinetItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drinkId = null,
    Object? userId = null,
    Object? status = null,
    Object? addedAt = null,
    Object? purchaseDate = freezed,
    Object? openedDate = freezed,
    Object? finishedDate = freezed,
    Object? location = null,
    Object? customLocation = freezed,
    Object? quantity = freezed,
    Object? purchasePrice = freezed,
    Object? purchaseStore = freezed,
    Object? purchaseNotes = freezed,
    Object? fillLevel = null,
    Object? personalNotes = freezed,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CabinetItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      drinkId: null == drinkId
          ? _value.drinkId
          : drinkId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CabinetStatus,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      openedDate: freezed == openedDate
          ? _value.openedDate
          : openedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedDate: freezed == finishedDate
          ? _value.finishedDate
          : finishedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as StorageLocation,
      customLocation: freezed == customLocation
          ? _value.customLocation
          : customLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      purchaseStore: freezed == purchaseStore
          ? _value.purchaseStore
          : purchaseStore // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseNotes: freezed == purchaseNotes
          ? _value.purchaseNotes
          : purchaseNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      fillLevel: null == fillLevel
          ? _value.fillLevel
          : fillLevel // ignore: cast_nullable_to_non_nullable
              as int,
      personalNotes: freezed == personalNotes
          ? _value.personalNotes
          : personalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CabinetItemImpl extends _CabinetItem {
  const _$CabinetItemImpl(
      {required this.id,
      required this.drinkId,
      required this.userId,
      required this.status,
      required this.addedAt,
      this.purchaseDate,
      this.openedDate,
      this.finishedDate,
      this.location = StorageLocation.mainShelf,
      this.customLocation,
      this.quantity,
      this.purchasePrice,
      this.purchaseStore,
      this.purchaseNotes,
      this.fillLevel = 100,
      this.personalNotes,
      final List<String>? tags,
      required this.createdAt,
      required this.updatedAt})
      : _tags = tags,
        super._();

  @override
  final String id;
  @override
  final String drinkId;
  @override
  final String userId;
  @override
  final CabinetStatus status;
// Physical details
  @override
  final DateTime addedAt;
  @override
  final DateTime? purchaseDate;
  @override
  final DateTime? openedDate;
  @override
  final DateTime? finishedDate;
// Storage and organization
  @override
  @JsonKey()
  final StorageLocation location;
  @override
  final String? customLocation;
  @override
  final int? quantity;
// Purchase information
  @override
  final double? purchasePrice;
  @override
  final String? purchaseStore;
  @override
  final String? purchaseNotes;
// Condition and notes
  @override
  @JsonKey()
  final int fillLevel;
// Percentage 0-100
  @override
  final String? personalNotes;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CabinetItem(id: $id, drinkId: $drinkId, userId: $userId, status: $status, addedAt: $addedAt, purchaseDate: $purchaseDate, openedDate: $openedDate, finishedDate: $finishedDate, location: $location, customLocation: $customLocation, quantity: $quantity, purchasePrice: $purchasePrice, purchaseStore: $purchaseStore, purchaseNotes: $purchaseNotes, fillLevel: $fillLevel, personalNotes: $personalNotes, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CabinetItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.drinkId, drinkId) || other.drinkId == drinkId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.openedDate, openedDate) ||
                other.openedDate == openedDate) &&
            (identical(other.finishedDate, finishedDate) ||
                other.finishedDate == finishedDate) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.customLocation, customLocation) ||
                other.customLocation == customLocation) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.purchaseStore, purchaseStore) ||
                other.purchaseStore == purchaseStore) &&
            (identical(other.purchaseNotes, purchaseNotes) ||
                other.purchaseNotes == purchaseNotes) &&
            (identical(other.fillLevel, fillLevel) ||
                other.fillLevel == fillLevel) &&
            (identical(other.personalNotes, personalNotes) ||
                other.personalNotes == personalNotes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        drinkId,
        userId,
        status,
        addedAt,
        purchaseDate,
        openedDate,
        finishedDate,
        location,
        customLocation,
        quantity,
        purchasePrice,
        purchaseStore,
        purchaseNotes,
        fillLevel,
        personalNotes,
        const DeepCollectionEquality().hash(_tags),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of CabinetItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CabinetItemImplCopyWith<_$CabinetItemImpl> get copyWith =>
      __$$CabinetItemImplCopyWithImpl<_$CabinetItemImpl>(this, _$identity);
}

abstract class _CabinetItem extends CabinetItem {
  const factory _CabinetItem(
      {required final String id,
      required final String drinkId,
      required final String userId,
      required final CabinetStatus status,
      required final DateTime addedAt,
      final DateTime? purchaseDate,
      final DateTime? openedDate,
      final DateTime? finishedDate,
      final StorageLocation location,
      final String? customLocation,
      final int? quantity,
      final double? purchasePrice,
      final String? purchaseStore,
      final String? purchaseNotes,
      final int fillLevel,
      final String? personalNotes,
      final List<String>? tags,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CabinetItemImpl;
  const _CabinetItem._() : super._();

  @override
  String get id;
  @override
  String get drinkId;
  @override
  String get userId;
  @override
  CabinetStatus get status; // Physical details
  @override
  DateTime get addedAt;
  @override
  DateTime? get purchaseDate;
  @override
  DateTime? get openedDate;
  @override
  DateTime? get finishedDate; // Storage and organization
  @override
  StorageLocation get location;
  @override
  String? get customLocation;
  @override
  int? get quantity; // Purchase information
  @override
  double? get purchasePrice;
  @override
  String? get purchaseStore;
  @override
  String? get purchaseNotes; // Condition and notes
  @override
  int get fillLevel; // Percentage 0-100
  @override
  String? get personalNotes;
  @override
  List<String>? get tags; // Metadata
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of CabinetItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CabinetItemImplCopyWith<_$CabinetItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
