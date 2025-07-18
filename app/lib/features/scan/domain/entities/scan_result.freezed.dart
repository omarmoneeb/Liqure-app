// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScanResult {
  String get barcode => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  ScanResultType get type => throw _privateConstructorUsedError;
  String? get drinkId => throw _privateConstructorUsedError;
  String? get drinkName => throw _privateConstructorUsedError;
  bool? get found => throw _privateConstructorUsedError;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanResultCopyWith<ScanResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanResultCopyWith<$Res> {
  factory $ScanResultCopyWith(
          ScanResult value, $Res Function(ScanResult) then) =
      _$ScanResultCopyWithImpl<$Res, ScanResult>;
  @useResult
  $Res call(
      {String barcode,
      DateTime timestamp,
      ScanResultType type,
      String? drinkId,
      String? drinkName,
      bool? found});
}

/// @nodoc
class _$ScanResultCopyWithImpl<$Res, $Val extends ScanResult>
    implements $ScanResultCopyWith<$Res> {
  _$ScanResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? barcode = null,
    Object? timestamp = null,
    Object? type = null,
    Object? drinkId = freezed,
    Object? drinkName = freezed,
    Object? found = freezed,
  }) {
    return _then(_value.copyWith(
      barcode: null == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ScanResultType,
      drinkId: freezed == drinkId
          ? _value.drinkId
          : drinkId // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkName: freezed == drinkName
          ? _value.drinkName
          : drinkName // ignore: cast_nullable_to_non_nullable
              as String?,
      found: freezed == found
          ? _value.found
          : found // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanResultImplCopyWith<$Res>
    implements $ScanResultCopyWith<$Res> {
  factory _$$ScanResultImplCopyWith(
          _$ScanResultImpl value, $Res Function(_$ScanResultImpl) then) =
      __$$ScanResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String barcode,
      DateTime timestamp,
      ScanResultType type,
      String? drinkId,
      String? drinkName,
      bool? found});
}

/// @nodoc
class __$$ScanResultImplCopyWithImpl<$Res>
    extends _$ScanResultCopyWithImpl<$Res, _$ScanResultImpl>
    implements _$$ScanResultImplCopyWith<$Res> {
  __$$ScanResultImplCopyWithImpl(
      _$ScanResultImpl _value, $Res Function(_$ScanResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? barcode = null,
    Object? timestamp = null,
    Object? type = null,
    Object? drinkId = freezed,
    Object? drinkName = freezed,
    Object? found = freezed,
  }) {
    return _then(_$ScanResultImpl(
      barcode: null == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ScanResultType,
      drinkId: freezed == drinkId
          ? _value.drinkId
          : drinkId // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkName: freezed == drinkName
          ? _value.drinkName
          : drinkName // ignore: cast_nullable_to_non_nullable
              as String?,
      found: freezed == found
          ? _value.found
          : found // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$ScanResultImpl implements _ScanResult {
  const _$ScanResultImpl(
      {required this.barcode,
      required this.timestamp,
      required this.type,
      this.drinkId,
      this.drinkName,
      this.found});

  @override
  final String barcode;
  @override
  final DateTime timestamp;
  @override
  final ScanResultType type;
  @override
  final String? drinkId;
  @override
  final String? drinkName;
  @override
  final bool? found;

  @override
  String toString() {
    return 'ScanResult(barcode: $barcode, timestamp: $timestamp, type: $type, drinkId: $drinkId, drinkName: $drinkName, found: $found)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanResultImpl &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.drinkId, drinkId) || other.drinkId == drinkId) &&
            (identical(other.drinkName, drinkName) ||
                other.drinkName == drinkName) &&
            (identical(other.found, found) || other.found == found));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, barcode, timestamp, type, drinkId, drinkName, found);

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      __$$ScanResultImplCopyWithImpl<_$ScanResultImpl>(this, _$identity);
}

abstract class _ScanResult implements ScanResult {
  const factory _ScanResult(
      {required final String barcode,
      required final DateTime timestamp,
      required final ScanResultType type,
      final String? drinkId,
      final String? drinkName,
      final bool? found}) = _$ScanResultImpl;

  @override
  String get barcode;
  @override
  DateTime get timestamp;
  @override
  ScanResultType get type;
  @override
  String? get drinkId;
  @override
  String? get drinkName;
  @override
  bool? get found;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
