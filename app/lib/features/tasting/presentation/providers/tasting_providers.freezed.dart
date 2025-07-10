// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasting_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DrinksFilter _$DrinksFilterFromJson(Map<String, dynamic> json) {
  return _DrinksFilter.fromJson(json);
}

/// @nodoc
mixin _$DrinksFilter {
// Text search
  String? get search => throw _privateConstructorUsedError;
  List<SearchField> get searchFields =>
      throw _privateConstructorUsedError; // Basic filters
  DrinkType? get type => throw _privateConstructorUsedError;
  List<DrinkType>? get types =>
      throw _privateConstructorUsedError; // Multi-select
// Range filters
  double? get minAbv => throw _privateConstructorUsedError;
  double? get maxAbv => throw _privateConstructorUsedError; // Location filters
  String? get country => throw _privateConstructorUsedError;
  List<String>? get countries =>
      throw _privateConstructorUsedError; // Rating filters
  double? get minRating => throw _privateConstructorUsedError;
  double? get maxRating => throw _privateConstructorUsedError;
  bool? get onlyRated => throw _privateConstructorUsedError;
  bool? get onlyUnrated => throw _privateConstructorUsedError; // Sorting
  SortBy get sortBy => throw _privateConstructorUsedError;
  SortDirection get sortDirection =>
      throw _privateConstructorUsedError; // Pagination
  int get page => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;

  /// Serializes this DrinksFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DrinksFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrinksFilterCopyWith<DrinksFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrinksFilterCopyWith<$Res> {
  factory $DrinksFilterCopyWith(
          DrinksFilter value, $Res Function(DrinksFilter) then) =
      _$DrinksFilterCopyWithImpl<$Res, DrinksFilter>;
  @useResult
  $Res call(
      {String? search,
      List<SearchField> searchFields,
      DrinkType? type,
      List<DrinkType>? types,
      double? minAbv,
      double? maxAbv,
      String? country,
      List<String>? countries,
      double? minRating,
      double? maxRating,
      bool? onlyRated,
      bool? onlyUnrated,
      SortBy sortBy,
      SortDirection sortDirection,
      int page,
      int perPage});
}

/// @nodoc
class _$DrinksFilterCopyWithImpl<$Res, $Val extends DrinksFilter>
    implements $DrinksFilterCopyWith<$Res> {
  _$DrinksFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrinksFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? searchFields = null,
    Object? type = freezed,
    Object? types = freezed,
    Object? minAbv = freezed,
    Object? maxAbv = freezed,
    Object? country = freezed,
    Object? countries = freezed,
    Object? minRating = freezed,
    Object? maxRating = freezed,
    Object? onlyRated = freezed,
    Object? onlyUnrated = freezed,
    Object? sortBy = null,
    Object? sortDirection = null,
    Object? page = null,
    Object? perPage = null,
  }) {
    return _then(_value.copyWith(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      searchFields: null == searchFields
          ? _value.searchFields
          : searchFields // ignore: cast_nullable_to_non_nullable
              as List<SearchField>,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DrinkType?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<DrinkType>?,
      minAbv: freezed == minAbv
          ? _value.minAbv
          : minAbv // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAbv: freezed == maxAbv
          ? _value.maxAbv
          : maxAbv // ignore: cast_nullable_to_non_nullable
              as double?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      countries: freezed == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      maxRating: freezed == maxRating
          ? _value.maxRating
          : maxRating // ignore: cast_nullable_to_non_nullable
              as double?,
      onlyRated: freezed == onlyRated
          ? _value.onlyRated
          : onlyRated // ignore: cast_nullable_to_non_nullable
              as bool?,
      onlyUnrated: freezed == onlyUnrated
          ? _value.onlyUnrated
          : onlyUnrated // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortBy,
      sortDirection: null == sortDirection
          ? _value.sortDirection
          : sortDirection // ignore: cast_nullable_to_non_nullable
              as SortDirection,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DrinksFilterImplCopyWith<$Res>
    implements $DrinksFilterCopyWith<$Res> {
  factory _$$DrinksFilterImplCopyWith(
          _$DrinksFilterImpl value, $Res Function(_$DrinksFilterImpl) then) =
      __$$DrinksFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? search,
      List<SearchField> searchFields,
      DrinkType? type,
      List<DrinkType>? types,
      double? minAbv,
      double? maxAbv,
      String? country,
      List<String>? countries,
      double? minRating,
      double? maxRating,
      bool? onlyRated,
      bool? onlyUnrated,
      SortBy sortBy,
      SortDirection sortDirection,
      int page,
      int perPage});
}

/// @nodoc
class __$$DrinksFilterImplCopyWithImpl<$Res>
    extends _$DrinksFilterCopyWithImpl<$Res, _$DrinksFilterImpl>
    implements _$$DrinksFilterImplCopyWith<$Res> {
  __$$DrinksFilterImplCopyWithImpl(
      _$DrinksFilterImpl _value, $Res Function(_$DrinksFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of DrinksFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? searchFields = null,
    Object? type = freezed,
    Object? types = freezed,
    Object? minAbv = freezed,
    Object? maxAbv = freezed,
    Object? country = freezed,
    Object? countries = freezed,
    Object? minRating = freezed,
    Object? maxRating = freezed,
    Object? onlyRated = freezed,
    Object? onlyUnrated = freezed,
    Object? sortBy = null,
    Object? sortDirection = null,
    Object? page = null,
    Object? perPage = null,
  }) {
    return _then(_$DrinksFilterImpl(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      searchFields: null == searchFields
          ? _value._searchFields
          : searchFields // ignore: cast_nullable_to_non_nullable
              as List<SearchField>,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DrinkType?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<DrinkType>?,
      minAbv: freezed == minAbv
          ? _value.minAbv
          : minAbv // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAbv: freezed == maxAbv
          ? _value.maxAbv
          : maxAbv // ignore: cast_nullable_to_non_nullable
              as double?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      countries: freezed == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      maxRating: freezed == maxRating
          ? _value.maxRating
          : maxRating // ignore: cast_nullable_to_non_nullable
              as double?,
      onlyRated: freezed == onlyRated
          ? _value.onlyRated
          : onlyRated // ignore: cast_nullable_to_non_nullable
              as bool?,
      onlyUnrated: freezed == onlyUnrated
          ? _value.onlyUnrated
          : onlyUnrated // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortBy,
      sortDirection: null == sortDirection
          ? _value.sortDirection
          : sortDirection // ignore: cast_nullable_to_non_nullable
              as SortDirection,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DrinksFilterImpl extends _DrinksFilter {
  const _$DrinksFilterImpl(
      {this.search,
      final List<SearchField> searchFields = const [SearchField.name],
      this.type,
      final List<DrinkType>? types,
      this.minAbv,
      this.maxAbv,
      this.country,
      final List<String>? countries,
      this.minRating,
      this.maxRating,
      this.onlyRated,
      this.onlyUnrated,
      this.sortBy = SortBy.created,
      this.sortDirection = SortDirection.descending,
      this.page = 1,
      this.perPage = 50})
      : _searchFields = searchFields,
        _types = types,
        _countries = countries,
        super._();

  factory _$DrinksFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrinksFilterImplFromJson(json);

// Text search
  @override
  final String? search;
  final List<SearchField> _searchFields;
  @override
  @JsonKey()
  List<SearchField> get searchFields {
    if (_searchFields is EqualUnmodifiableListView) return _searchFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchFields);
  }

// Basic filters
  @override
  final DrinkType? type;
  final List<DrinkType>? _types;
  @override
  List<DrinkType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Multi-select
// Range filters
  @override
  final double? minAbv;
  @override
  final double? maxAbv;
// Location filters
  @override
  final String? country;
  final List<String>? _countries;
  @override
  List<String>? get countries {
    final value = _countries;
    if (value == null) return null;
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Rating filters
  @override
  final double? minRating;
  @override
  final double? maxRating;
  @override
  final bool? onlyRated;
  @override
  final bool? onlyUnrated;
// Sorting
  @override
  @JsonKey()
  final SortBy sortBy;
  @override
  @JsonKey()
  final SortDirection sortDirection;
// Pagination
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int perPage;

  @override
  String toString() {
    return 'DrinksFilter(search: $search, searchFields: $searchFields, type: $type, types: $types, minAbv: $minAbv, maxAbv: $maxAbv, country: $country, countries: $countries, minRating: $minRating, maxRating: $maxRating, onlyRated: $onlyRated, onlyUnrated: $onlyUnrated, sortBy: $sortBy, sortDirection: $sortDirection, page: $page, perPage: $perPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrinksFilterImpl &&
            (identical(other.search, search) || other.search == search) &&
            const DeepCollectionEquality()
                .equals(other._searchFields, _searchFields) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.minAbv, minAbv) || other.minAbv == minAbv) &&
            (identical(other.maxAbv, maxAbv) || other.maxAbv == maxAbv) &&
            (identical(other.country, country) || other.country == country) &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.maxRating, maxRating) ||
                other.maxRating == maxRating) &&
            (identical(other.onlyRated, onlyRated) ||
                other.onlyRated == onlyRated) &&
            (identical(other.onlyUnrated, onlyUnrated) ||
                other.onlyUnrated == onlyUnrated) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortDirection, sortDirection) ||
                other.sortDirection == sortDirection) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      search,
      const DeepCollectionEquality().hash(_searchFields),
      type,
      const DeepCollectionEquality().hash(_types),
      minAbv,
      maxAbv,
      country,
      const DeepCollectionEquality().hash(_countries),
      minRating,
      maxRating,
      onlyRated,
      onlyUnrated,
      sortBy,
      sortDirection,
      page,
      perPage);

  /// Create a copy of DrinksFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrinksFilterImplCopyWith<_$DrinksFilterImpl> get copyWith =>
      __$$DrinksFilterImplCopyWithImpl<_$DrinksFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrinksFilterImplToJson(
      this,
    );
  }
}

abstract class _DrinksFilter extends DrinksFilter {
  const factory _DrinksFilter(
      {final String? search,
      final List<SearchField> searchFields,
      final DrinkType? type,
      final List<DrinkType>? types,
      final double? minAbv,
      final double? maxAbv,
      final String? country,
      final List<String>? countries,
      final double? minRating,
      final double? maxRating,
      final bool? onlyRated,
      final bool? onlyUnrated,
      final SortBy sortBy,
      final SortDirection sortDirection,
      final int page,
      final int perPage}) = _$DrinksFilterImpl;
  const _DrinksFilter._() : super._();

  factory _DrinksFilter.fromJson(Map<String, dynamic> json) =
      _$DrinksFilterImpl.fromJson;

// Text search
  @override
  String? get search;
  @override
  List<SearchField> get searchFields; // Basic filters
  @override
  DrinkType? get type;
  @override
  List<DrinkType>? get types; // Multi-select
// Range filters
  @override
  double? get minAbv;
  @override
  double? get maxAbv; // Location filters
  @override
  String? get country;
  @override
  List<String>? get countries; // Rating filters
  @override
  double? get minRating;
  @override
  double? get maxRating;
  @override
  bool? get onlyRated;
  @override
  bool? get onlyUnrated; // Sorting
  @override
  SortBy get sortBy;
  @override
  SortDirection get sortDirection; // Pagination
  @override
  int get page;
  @override
  int get perPage;

  /// Create a copy of DrinksFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrinksFilterImplCopyWith<_$DrinksFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
