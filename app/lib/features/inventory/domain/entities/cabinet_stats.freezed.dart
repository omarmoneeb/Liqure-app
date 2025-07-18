// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cabinet_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CabinetStats {
// Overall counts
  int get totalItems => throw _privateConstructorUsedError;
  int get availableItems => throw _privateConstructorUsedError;
  int get emptyItems => throw _privateConstructorUsedError;
  int get wishlistItems => throw _privateConstructorUsedError; // By location
  Map<StorageLocation, int> get itemsByLocation =>
      throw _privateConstructorUsedError; // By type/category
  Map<String, int> get itemsByType =>
      throw _privateConstructorUsedError; // Value calculations
  double get totalValue => throw _privateConstructorUsedError;
  double get averagePrice => throw _privateConstructorUsedError;
  double get highestPrice => throw _privateConstructorUsedError;
  double get lowestPrice =>
      throw _privateConstructorUsedError; // Fill level analytics
  int get fullBottles => throw _privateConstructorUsedError; // 90-100%
  int get partialBottles => throw _privateConstructorUsedError; // 1-89%
  int get emptyBottles => throw _privateConstructorUsedError; // 0%
  double get averageFillLevel =>
      throw _privateConstructorUsedError; // Time analytics
  DateTime? get oldestPurchase => throw _privateConstructorUsedError;
  DateTime? get newestPurchase => throw _privateConstructorUsedError;
  int get itemsAddedThisMonth => throw _privateConstructorUsedError;
  int get itemsFinishedThisMonth =>
      throw _privateConstructorUsedError; // Top items
  List<String>? get topLocations =>
      throw _privateConstructorUsedError; // Most used locations
  List<String>? get topTypes =>
      throw _privateConstructorUsedError; // Most collected types
  List<String>? get recentActivity => throw _privateConstructorUsedError;

  /// Create a copy of CabinetStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CabinetStatsCopyWith<CabinetStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CabinetStatsCopyWith<$Res> {
  factory $CabinetStatsCopyWith(
          CabinetStats value, $Res Function(CabinetStats) then) =
      _$CabinetStatsCopyWithImpl<$Res, CabinetStats>;
  @useResult
  $Res call(
      {int totalItems,
      int availableItems,
      int emptyItems,
      int wishlistItems,
      Map<StorageLocation, int> itemsByLocation,
      Map<String, int> itemsByType,
      double totalValue,
      double averagePrice,
      double highestPrice,
      double lowestPrice,
      int fullBottles,
      int partialBottles,
      int emptyBottles,
      double averageFillLevel,
      DateTime? oldestPurchase,
      DateTime? newestPurchase,
      int itemsAddedThisMonth,
      int itemsFinishedThisMonth,
      List<String>? topLocations,
      List<String>? topTypes,
      List<String>? recentActivity});
}

/// @nodoc
class _$CabinetStatsCopyWithImpl<$Res, $Val extends CabinetStats>
    implements $CabinetStatsCopyWith<$Res> {
  _$CabinetStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CabinetStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? availableItems = null,
    Object? emptyItems = null,
    Object? wishlistItems = null,
    Object? itemsByLocation = null,
    Object? itemsByType = null,
    Object? totalValue = null,
    Object? averagePrice = null,
    Object? highestPrice = null,
    Object? lowestPrice = null,
    Object? fullBottles = null,
    Object? partialBottles = null,
    Object? emptyBottles = null,
    Object? averageFillLevel = null,
    Object? oldestPurchase = freezed,
    Object? newestPurchase = freezed,
    Object? itemsAddedThisMonth = null,
    Object? itemsFinishedThisMonth = null,
    Object? topLocations = freezed,
    Object? topTypes = freezed,
    Object? recentActivity = freezed,
  }) {
    return _then(_value.copyWith(
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      availableItems: null == availableItems
          ? _value.availableItems
          : availableItems // ignore: cast_nullable_to_non_nullable
              as int,
      emptyItems: null == emptyItems
          ? _value.emptyItems
          : emptyItems // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistItems: null == wishlistItems
          ? _value.wishlistItems
          : wishlistItems // ignore: cast_nullable_to_non_nullable
              as int,
      itemsByLocation: null == itemsByLocation
          ? _value.itemsByLocation
          : itemsByLocation // ignore: cast_nullable_to_non_nullable
              as Map<StorageLocation, int>,
      itemsByType: null == itemsByType
          ? _value.itemsByType
          : itemsByType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
      highestPrice: null == highestPrice
          ? _value.highestPrice
          : highestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lowestPrice: null == lowestPrice
          ? _value.lowestPrice
          : lowestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      fullBottles: null == fullBottles
          ? _value.fullBottles
          : fullBottles // ignore: cast_nullable_to_non_nullable
              as int,
      partialBottles: null == partialBottles
          ? _value.partialBottles
          : partialBottles // ignore: cast_nullable_to_non_nullable
              as int,
      emptyBottles: null == emptyBottles
          ? _value.emptyBottles
          : emptyBottles // ignore: cast_nullable_to_non_nullable
              as int,
      averageFillLevel: null == averageFillLevel
          ? _value.averageFillLevel
          : averageFillLevel // ignore: cast_nullable_to_non_nullable
              as double,
      oldestPurchase: freezed == oldestPurchase
          ? _value.oldestPurchase
          : oldestPurchase // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      newestPurchase: freezed == newestPurchase
          ? _value.newestPurchase
          : newestPurchase // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemsAddedThisMonth: null == itemsAddedThisMonth
          ? _value.itemsAddedThisMonth
          : itemsAddedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      itemsFinishedThisMonth: null == itemsFinishedThisMonth
          ? _value.itemsFinishedThisMonth
          : itemsFinishedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      topLocations: freezed == topLocations
          ? _value.topLocations
          : topLocations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      topTypes: freezed == topTypes
          ? _value.topTypes
          : topTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recentActivity: freezed == recentActivity
          ? _value.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CabinetStatsImplCopyWith<$Res>
    implements $CabinetStatsCopyWith<$Res> {
  factory _$$CabinetStatsImplCopyWith(
          _$CabinetStatsImpl value, $Res Function(_$CabinetStatsImpl) then) =
      __$$CabinetStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalItems,
      int availableItems,
      int emptyItems,
      int wishlistItems,
      Map<StorageLocation, int> itemsByLocation,
      Map<String, int> itemsByType,
      double totalValue,
      double averagePrice,
      double highestPrice,
      double lowestPrice,
      int fullBottles,
      int partialBottles,
      int emptyBottles,
      double averageFillLevel,
      DateTime? oldestPurchase,
      DateTime? newestPurchase,
      int itemsAddedThisMonth,
      int itemsFinishedThisMonth,
      List<String>? topLocations,
      List<String>? topTypes,
      List<String>? recentActivity});
}

/// @nodoc
class __$$CabinetStatsImplCopyWithImpl<$Res>
    extends _$CabinetStatsCopyWithImpl<$Res, _$CabinetStatsImpl>
    implements _$$CabinetStatsImplCopyWith<$Res> {
  __$$CabinetStatsImplCopyWithImpl(
      _$CabinetStatsImpl _value, $Res Function(_$CabinetStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CabinetStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? availableItems = null,
    Object? emptyItems = null,
    Object? wishlistItems = null,
    Object? itemsByLocation = null,
    Object? itemsByType = null,
    Object? totalValue = null,
    Object? averagePrice = null,
    Object? highestPrice = null,
    Object? lowestPrice = null,
    Object? fullBottles = null,
    Object? partialBottles = null,
    Object? emptyBottles = null,
    Object? averageFillLevel = null,
    Object? oldestPurchase = freezed,
    Object? newestPurchase = freezed,
    Object? itemsAddedThisMonth = null,
    Object? itemsFinishedThisMonth = null,
    Object? topLocations = freezed,
    Object? topTypes = freezed,
    Object? recentActivity = freezed,
  }) {
    return _then(_$CabinetStatsImpl(
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      availableItems: null == availableItems
          ? _value.availableItems
          : availableItems // ignore: cast_nullable_to_non_nullable
              as int,
      emptyItems: null == emptyItems
          ? _value.emptyItems
          : emptyItems // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistItems: null == wishlistItems
          ? _value.wishlistItems
          : wishlistItems // ignore: cast_nullable_to_non_nullable
              as int,
      itemsByLocation: null == itemsByLocation
          ? _value._itemsByLocation
          : itemsByLocation // ignore: cast_nullable_to_non_nullable
              as Map<StorageLocation, int>,
      itemsByType: null == itemsByType
          ? _value._itemsByType
          : itemsByType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
      highestPrice: null == highestPrice
          ? _value.highestPrice
          : highestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lowestPrice: null == lowestPrice
          ? _value.lowestPrice
          : lowestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      fullBottles: null == fullBottles
          ? _value.fullBottles
          : fullBottles // ignore: cast_nullable_to_non_nullable
              as int,
      partialBottles: null == partialBottles
          ? _value.partialBottles
          : partialBottles // ignore: cast_nullable_to_non_nullable
              as int,
      emptyBottles: null == emptyBottles
          ? _value.emptyBottles
          : emptyBottles // ignore: cast_nullable_to_non_nullable
              as int,
      averageFillLevel: null == averageFillLevel
          ? _value.averageFillLevel
          : averageFillLevel // ignore: cast_nullable_to_non_nullable
              as double,
      oldestPurchase: freezed == oldestPurchase
          ? _value.oldestPurchase
          : oldestPurchase // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      newestPurchase: freezed == newestPurchase
          ? _value.newestPurchase
          : newestPurchase // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemsAddedThisMonth: null == itemsAddedThisMonth
          ? _value.itemsAddedThisMonth
          : itemsAddedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      itemsFinishedThisMonth: null == itemsFinishedThisMonth
          ? _value.itemsFinishedThisMonth
          : itemsFinishedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      topLocations: freezed == topLocations
          ? _value._topLocations
          : topLocations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      topTypes: freezed == topTypes
          ? _value._topTypes
          : topTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recentActivity: freezed == recentActivity
          ? _value._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$CabinetStatsImpl extends _CabinetStats {
  const _$CabinetStatsImpl(
      {this.totalItems = 0,
      this.availableItems = 0,
      this.emptyItems = 0,
      this.wishlistItems = 0,
      final Map<StorageLocation, int> itemsByLocation = const {},
      final Map<String, int> itemsByType = const {},
      this.totalValue = 0.0,
      this.averagePrice = 0.0,
      this.highestPrice = 0.0,
      this.lowestPrice = 0.0,
      this.fullBottles = 0,
      this.partialBottles = 0,
      this.emptyBottles = 0,
      this.averageFillLevel = 0.0,
      this.oldestPurchase,
      this.newestPurchase,
      this.itemsAddedThisMonth = 0,
      this.itemsFinishedThisMonth = 0,
      final List<String>? topLocations,
      final List<String>? topTypes,
      final List<String>? recentActivity})
      : _itemsByLocation = itemsByLocation,
        _itemsByType = itemsByType,
        _topLocations = topLocations,
        _topTypes = topTypes,
        _recentActivity = recentActivity,
        super._();

// Overall counts
  @override
  @JsonKey()
  final int totalItems;
  @override
  @JsonKey()
  final int availableItems;
  @override
  @JsonKey()
  final int emptyItems;
  @override
  @JsonKey()
  final int wishlistItems;
// By location
  final Map<StorageLocation, int> _itemsByLocation;
// By location
  @override
  @JsonKey()
  Map<StorageLocation, int> get itemsByLocation {
    if (_itemsByLocation is EqualUnmodifiableMapView) return _itemsByLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_itemsByLocation);
  }

// By type/category
  final Map<String, int> _itemsByType;
// By type/category
  @override
  @JsonKey()
  Map<String, int> get itemsByType {
    if (_itemsByType is EqualUnmodifiableMapView) return _itemsByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_itemsByType);
  }

// Value calculations
  @override
  @JsonKey()
  final double totalValue;
  @override
  @JsonKey()
  final double averagePrice;
  @override
  @JsonKey()
  final double highestPrice;
  @override
  @JsonKey()
  final double lowestPrice;
// Fill level analytics
  @override
  @JsonKey()
  final int fullBottles;
// 90-100%
  @override
  @JsonKey()
  final int partialBottles;
// 1-89%
  @override
  @JsonKey()
  final int emptyBottles;
// 0%
  @override
  @JsonKey()
  final double averageFillLevel;
// Time analytics
  @override
  final DateTime? oldestPurchase;
  @override
  final DateTime? newestPurchase;
  @override
  @JsonKey()
  final int itemsAddedThisMonth;
  @override
  @JsonKey()
  final int itemsFinishedThisMonth;
// Top items
  final List<String>? _topLocations;
// Top items
  @override
  List<String>? get topLocations {
    final value = _topLocations;
    if (value == null) return null;
    if (_topLocations is EqualUnmodifiableListView) return _topLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Most used locations
  final List<String>? _topTypes;
// Most used locations
  @override
  List<String>? get topTypes {
    final value = _topTypes;
    if (value == null) return null;
    if (_topTypes is EqualUnmodifiableListView) return _topTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Most collected types
  final List<String>? _recentActivity;
// Most collected types
  @override
  List<String>? get recentActivity {
    final value = _recentActivity;
    if (value == null) return null;
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CabinetStats(totalItems: $totalItems, availableItems: $availableItems, emptyItems: $emptyItems, wishlistItems: $wishlistItems, itemsByLocation: $itemsByLocation, itemsByType: $itemsByType, totalValue: $totalValue, averagePrice: $averagePrice, highestPrice: $highestPrice, lowestPrice: $lowestPrice, fullBottles: $fullBottles, partialBottles: $partialBottles, emptyBottles: $emptyBottles, averageFillLevel: $averageFillLevel, oldestPurchase: $oldestPurchase, newestPurchase: $newestPurchase, itemsAddedThisMonth: $itemsAddedThisMonth, itemsFinishedThisMonth: $itemsFinishedThisMonth, topLocations: $topLocations, topTypes: $topTypes, recentActivity: $recentActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CabinetStatsImpl &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.availableItems, availableItems) ||
                other.availableItems == availableItems) &&
            (identical(other.emptyItems, emptyItems) ||
                other.emptyItems == emptyItems) &&
            (identical(other.wishlistItems, wishlistItems) ||
                other.wishlistItems == wishlistItems) &&
            const DeepCollectionEquality()
                .equals(other._itemsByLocation, _itemsByLocation) &&
            const DeepCollectionEquality()
                .equals(other._itemsByType, _itemsByType) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.averagePrice, averagePrice) ||
                other.averagePrice == averagePrice) &&
            (identical(other.highestPrice, highestPrice) ||
                other.highestPrice == highestPrice) &&
            (identical(other.lowestPrice, lowestPrice) ||
                other.lowestPrice == lowestPrice) &&
            (identical(other.fullBottles, fullBottles) ||
                other.fullBottles == fullBottles) &&
            (identical(other.partialBottles, partialBottles) ||
                other.partialBottles == partialBottles) &&
            (identical(other.emptyBottles, emptyBottles) ||
                other.emptyBottles == emptyBottles) &&
            (identical(other.averageFillLevel, averageFillLevel) ||
                other.averageFillLevel == averageFillLevel) &&
            (identical(other.oldestPurchase, oldestPurchase) ||
                other.oldestPurchase == oldestPurchase) &&
            (identical(other.newestPurchase, newestPurchase) ||
                other.newestPurchase == newestPurchase) &&
            (identical(other.itemsAddedThisMonth, itemsAddedThisMonth) ||
                other.itemsAddedThisMonth == itemsAddedThisMonth) &&
            (identical(other.itemsFinishedThisMonth, itemsFinishedThisMonth) ||
                other.itemsFinishedThisMonth == itemsFinishedThisMonth) &&
            const DeepCollectionEquality()
                .equals(other._topLocations, _topLocations) &&
            const DeepCollectionEquality().equals(other._topTypes, _topTypes) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        totalItems,
        availableItems,
        emptyItems,
        wishlistItems,
        const DeepCollectionEquality().hash(_itemsByLocation),
        const DeepCollectionEquality().hash(_itemsByType),
        totalValue,
        averagePrice,
        highestPrice,
        lowestPrice,
        fullBottles,
        partialBottles,
        emptyBottles,
        averageFillLevel,
        oldestPurchase,
        newestPurchase,
        itemsAddedThisMonth,
        itemsFinishedThisMonth,
        const DeepCollectionEquality().hash(_topLocations),
        const DeepCollectionEquality().hash(_topTypes),
        const DeepCollectionEquality().hash(_recentActivity)
      ]);

  /// Create a copy of CabinetStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CabinetStatsImplCopyWith<_$CabinetStatsImpl> get copyWith =>
      __$$CabinetStatsImplCopyWithImpl<_$CabinetStatsImpl>(this, _$identity);
}

abstract class _CabinetStats extends CabinetStats {
  const factory _CabinetStats(
      {final int totalItems,
      final int availableItems,
      final int emptyItems,
      final int wishlistItems,
      final Map<StorageLocation, int> itemsByLocation,
      final Map<String, int> itemsByType,
      final double totalValue,
      final double averagePrice,
      final double highestPrice,
      final double lowestPrice,
      final int fullBottles,
      final int partialBottles,
      final int emptyBottles,
      final double averageFillLevel,
      final DateTime? oldestPurchase,
      final DateTime? newestPurchase,
      final int itemsAddedThisMonth,
      final int itemsFinishedThisMonth,
      final List<String>? topLocations,
      final List<String>? topTypes,
      final List<String>? recentActivity}) = _$CabinetStatsImpl;
  const _CabinetStats._() : super._();

// Overall counts
  @override
  int get totalItems;
  @override
  int get availableItems;
  @override
  int get emptyItems;
  @override
  int get wishlistItems; // By location
  @override
  Map<StorageLocation, int> get itemsByLocation; // By type/category
  @override
  Map<String, int> get itemsByType; // Value calculations
  @override
  double get totalValue;
  @override
  double get averagePrice;
  @override
  double get highestPrice;
  @override
  double get lowestPrice; // Fill level analytics
  @override
  int get fullBottles; // 90-100%
  @override
  int get partialBottles; // 1-89%
  @override
  int get emptyBottles; // 0%
  @override
  double get averageFillLevel; // Time analytics
  @override
  DateTime? get oldestPurchase;
  @override
  DateTime? get newestPurchase;
  @override
  int get itemsAddedThisMonth;
  @override
  int get itemsFinishedThisMonth; // Top items
  @override
  List<String>? get topLocations; // Most used locations
  @override
  List<String>? get topTypes; // Most collected types
  @override
  List<String>? get recentActivity;

  /// Create a copy of CabinetStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CabinetStatsImplCopyWith<_$CabinetStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
