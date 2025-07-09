// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Drink {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DrinkType get type => throw _privateConstructorUsedError;
  double? get abv => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get created => throw _privateConstructorUsedError;
  DateTime? get updated => throw _privateConstructorUsedError;

  /// Create a copy of Drink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrinkCopyWith<Drink> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrinkCopyWith<$Res> {
  factory $DrinkCopyWith(Drink value, $Res Function(Drink) then) =
      _$DrinkCopyWithImpl<$Res, Drink>;
  @useResult
  $Res call(
      {String id,
      String name,
      DrinkType type,
      double? abv,
      String? country,
      String? barcode,
      String? image,
      String? description,
      DateTime? created,
      DateTime? updated});
}

/// @nodoc
class _$DrinkCopyWithImpl<$Res, $Val extends Drink>
    implements $DrinkCopyWith<$Res> {
  _$DrinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Drink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? abv = freezed,
    Object? country = freezed,
    Object? barcode = freezed,
    Object? image = freezed,
    Object? description = freezed,
    Object? created = freezed,
    Object? updated = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DrinkType,
      abv: freezed == abv
          ? _value.abv
          : abv // ignore: cast_nullable_to_non_nullable
              as double?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DrinkImplCopyWith<$Res> implements $DrinkCopyWith<$Res> {
  factory _$$DrinkImplCopyWith(
          _$DrinkImpl value, $Res Function(_$DrinkImpl) then) =
      __$$DrinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DrinkType type,
      double? abv,
      String? country,
      String? barcode,
      String? image,
      String? description,
      DateTime? created,
      DateTime? updated});
}

/// @nodoc
class __$$DrinkImplCopyWithImpl<$Res>
    extends _$DrinkCopyWithImpl<$Res, _$DrinkImpl>
    implements _$$DrinkImplCopyWith<$Res> {
  __$$DrinkImplCopyWithImpl(
      _$DrinkImpl _value, $Res Function(_$DrinkImpl) _then)
      : super(_value, _then);

  /// Create a copy of Drink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? abv = freezed,
    Object? country = freezed,
    Object? barcode = freezed,
    Object? image = freezed,
    Object? description = freezed,
    Object? created = freezed,
    Object? updated = freezed,
  }) {
    return _then(_$DrinkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DrinkType,
      abv: freezed == abv
          ? _value.abv
          : abv // ignore: cast_nullable_to_non_nullable
              as double?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$DrinkImpl implements _Drink {
  const _$DrinkImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.abv,
      this.country,
      this.barcode,
      this.image,
      this.description,
      this.created,
      this.updated});

  @override
  final String id;
  @override
  final String name;
  @override
  final DrinkType type;
  @override
  final double? abv;
  @override
  final String? country;
  @override
  final String? barcode;
  @override
  final String? image;
  @override
  final String? description;
  @override
  final DateTime? created;
  @override
  final DateTime? updated;

  @override
  String toString() {
    return 'Drink(id: $id, name: $name, type: $type, abv: $abv, country: $country, barcode: $barcode, image: $image, description: $description, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.abv, abv) || other.abv == abv) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, abv, country,
      barcode, image, description, created, updated);

  /// Create a copy of Drink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrinkImplCopyWith<_$DrinkImpl> get copyWith =>
      __$$DrinkImplCopyWithImpl<_$DrinkImpl>(this, _$identity);
}

abstract class _Drink implements Drink {
  const factory _Drink(
      {required final String id,
      required final String name,
      required final DrinkType type,
      final double? abv,
      final String? country,
      final String? barcode,
      final String? image,
      final String? description,
      final DateTime? created,
      final DateTime? updated}) = _$DrinkImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  DrinkType get type;
  @override
  double? get abv;
  @override
  String? get country;
  @override
  String? get barcode;
  @override
  String? get image;
  @override
  String? get description;
  @override
  DateTime? get created;
  @override
  DateTime? get updated;

  /// Create a copy of Drink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrinkImplCopyWith<_$DrinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
