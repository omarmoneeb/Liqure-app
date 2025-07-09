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
  String? get search => throw _privateConstructorUsedError;
  DrinkType? get type => throw _privateConstructorUsedError;
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
  $Res call({String? search, DrinkType? type, int page, int perPage});
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
    Object? type = freezed,
    Object? page = null,
    Object? perPage = null,
  }) {
    return _then(_value.copyWith(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DrinkType?,
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
  $Res call({String? search, DrinkType? type, int page, int perPage});
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
    Object? type = freezed,
    Object? page = null,
    Object? perPage = null,
  }) {
    return _then(_$DrinksFilterImpl(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DrinkType?,
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
class _$DrinksFilterImpl implements _DrinksFilter {
  const _$DrinksFilterImpl(
      {this.search, this.type, this.page = 1, this.perPage = 50});

  factory _$DrinksFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrinksFilterImplFromJson(json);

  @override
  final String? search;
  @override
  final DrinkType? type;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int perPage;

  @override
  String toString() {
    return 'DrinksFilter(search: $search, type: $type, page: $page, perPage: $perPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrinksFilterImpl &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, search, type, page, perPage);

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

abstract class _DrinksFilter implements DrinksFilter {
  const factory _DrinksFilter(
      {final String? search,
      final DrinkType? type,
      final int page,
      final int perPage}) = _$DrinksFilterImpl;

  factory _DrinksFilter.fromJson(Map<String, dynamic> json) =
      _$DrinksFilterImpl.fromJson;

  @override
  String? get search;
  @override
  DrinkType? get type;
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
