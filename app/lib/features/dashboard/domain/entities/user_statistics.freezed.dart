// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserStatistics {
// Rating Statistics
  int get totalRatings => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  double get highestRating => throw _privateConstructorUsedError;
  double get lowestRating => throw _privateConstructorUsedError;
  Map<int, int> get ratingDistribution =>
      throw _privateConstructorUsedError; // rating -> count
// Collection Statistics
  int get drinksRated => throw _privateConstructorUsedError;
  Map<DrinkType, int> get typeBreakdown => throw _privateConstructorUsedError;
  Map<String, int> get countryBreakdown => throw _privateConstructorUsedError;
  int get uniqueCountries =>
      throw _privateConstructorUsedError; // Activity Statistics
  int get ratingsThisMonth => throw _privateConstructorUsedError;
  int get ratingsThisWeek => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak =>
      throw _privateConstructorUsedError; // Preference Statistics
  DrinkType? get favoriteType => throw _privateConstructorUsedError;
  String? get favoriteCountry => throw _privateConstructorUsedError;
  double get averageAbv =>
      throw _privateConstructorUsedError; // Achievement Statistics
  List<String> get achievements => throw _privateConstructorUsedError;
  int get totalAchievements => throw _privateConstructorUsedError;

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatisticsCopyWith<UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatisticsCopyWith<$Res> {
  factory $UserStatisticsCopyWith(
          UserStatistics value, $Res Function(UserStatistics) then) =
      _$UserStatisticsCopyWithImpl<$Res, UserStatistics>;
  @useResult
  $Res call(
      {int totalRatings,
      double averageRating,
      double highestRating,
      double lowestRating,
      Map<int, int> ratingDistribution,
      int drinksRated,
      Map<DrinkType, int> typeBreakdown,
      Map<String, int> countryBreakdown,
      int uniqueCountries,
      int ratingsThisMonth,
      int ratingsThisWeek,
      int currentStreak,
      int longestStreak,
      DrinkType? favoriteType,
      String? favoriteCountry,
      double averageAbv,
      List<String> achievements,
      int totalAchievements});
}

/// @nodoc
class _$UserStatisticsCopyWithImpl<$Res, $Val extends UserStatistics>
    implements $UserStatisticsCopyWith<$Res> {
  _$UserStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRatings = null,
    Object? averageRating = null,
    Object? highestRating = null,
    Object? lowestRating = null,
    Object? ratingDistribution = null,
    Object? drinksRated = null,
    Object? typeBreakdown = null,
    Object? countryBreakdown = null,
    Object? uniqueCountries = null,
    Object? ratingsThisMonth = null,
    Object? ratingsThisWeek = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? favoriteType = freezed,
    Object? favoriteCountry = freezed,
    Object? averageAbv = null,
    Object? achievements = null,
    Object? totalAchievements = null,
  }) {
    return _then(_value.copyWith(
      totalRatings: null == totalRatings
          ? _value.totalRatings
          : totalRatings // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      highestRating: null == highestRating
          ? _value.highestRating
          : highestRating // ignore: cast_nullable_to_non_nullable
              as double,
      lowestRating: null == lowestRating
          ? _value.lowestRating
          : lowestRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingDistribution: null == ratingDistribution
          ? _value.ratingDistribution
          : ratingDistribution // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      drinksRated: null == drinksRated
          ? _value.drinksRated
          : drinksRated // ignore: cast_nullable_to_non_nullable
              as int,
      typeBreakdown: null == typeBreakdown
          ? _value.typeBreakdown
          : typeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<DrinkType, int>,
      countryBreakdown: null == countryBreakdown
          ? _value.countryBreakdown
          : countryBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      uniqueCountries: null == uniqueCountries
          ? _value.uniqueCountries
          : uniqueCountries // ignore: cast_nullable_to_non_nullable
              as int,
      ratingsThisMonth: null == ratingsThisMonth
          ? _value.ratingsThisMonth
          : ratingsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      ratingsThisWeek: null == ratingsThisWeek
          ? _value.ratingsThisWeek
          : ratingsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteType: freezed == favoriteType
          ? _value.favoriteType
          : favoriteType // ignore: cast_nullable_to_non_nullable
              as DrinkType?,
      favoriteCountry: freezed == favoriteCountry
          ? _value.favoriteCountry
          : favoriteCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      averageAbv: null == averageAbv
          ? _value.averageAbv
          : averageAbv // ignore: cast_nullable_to_non_nullable
              as double,
      achievements: null == achievements
          ? _value.achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalAchievements: null == totalAchievements
          ? _value.totalAchievements
          : totalAchievements // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatisticsImplCopyWith<$Res>
    implements $UserStatisticsCopyWith<$Res> {
  factory _$$UserStatisticsImplCopyWith(_$UserStatisticsImpl value,
          $Res Function(_$UserStatisticsImpl) then) =
      __$$UserStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalRatings,
      double averageRating,
      double highestRating,
      double lowestRating,
      Map<int, int> ratingDistribution,
      int drinksRated,
      Map<DrinkType, int> typeBreakdown,
      Map<String, int> countryBreakdown,
      int uniqueCountries,
      int ratingsThisMonth,
      int ratingsThisWeek,
      int currentStreak,
      int longestStreak,
      DrinkType? favoriteType,
      String? favoriteCountry,
      double averageAbv,
      List<String> achievements,
      int totalAchievements});
}

/// @nodoc
class __$$UserStatisticsImplCopyWithImpl<$Res>
    extends _$UserStatisticsCopyWithImpl<$Res, _$UserStatisticsImpl>
    implements _$$UserStatisticsImplCopyWith<$Res> {
  __$$UserStatisticsImplCopyWithImpl(
      _$UserStatisticsImpl _value, $Res Function(_$UserStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRatings = null,
    Object? averageRating = null,
    Object? highestRating = null,
    Object? lowestRating = null,
    Object? ratingDistribution = null,
    Object? drinksRated = null,
    Object? typeBreakdown = null,
    Object? countryBreakdown = null,
    Object? uniqueCountries = null,
    Object? ratingsThisMonth = null,
    Object? ratingsThisWeek = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? favoriteType = freezed,
    Object? favoriteCountry = freezed,
    Object? averageAbv = null,
    Object? achievements = null,
    Object? totalAchievements = null,
  }) {
    return _then(_$UserStatisticsImpl(
      totalRatings: null == totalRatings
          ? _value.totalRatings
          : totalRatings // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      highestRating: null == highestRating
          ? _value.highestRating
          : highestRating // ignore: cast_nullable_to_non_nullable
              as double,
      lowestRating: null == lowestRating
          ? _value.lowestRating
          : lowestRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingDistribution: null == ratingDistribution
          ? _value._ratingDistribution
          : ratingDistribution // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      drinksRated: null == drinksRated
          ? _value.drinksRated
          : drinksRated // ignore: cast_nullable_to_non_nullable
              as int,
      typeBreakdown: null == typeBreakdown
          ? _value._typeBreakdown
          : typeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<DrinkType, int>,
      countryBreakdown: null == countryBreakdown
          ? _value._countryBreakdown
          : countryBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      uniqueCountries: null == uniqueCountries
          ? _value.uniqueCountries
          : uniqueCountries // ignore: cast_nullable_to_non_nullable
              as int,
      ratingsThisMonth: null == ratingsThisMonth
          ? _value.ratingsThisMonth
          : ratingsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      ratingsThisWeek: null == ratingsThisWeek
          ? _value.ratingsThisWeek
          : ratingsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteType: freezed == favoriteType
          ? _value.favoriteType
          : favoriteType // ignore: cast_nullable_to_non_nullable
              as DrinkType?,
      favoriteCountry: freezed == favoriteCountry
          ? _value.favoriteCountry
          : favoriteCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      averageAbv: null == averageAbv
          ? _value.averageAbv
          : averageAbv // ignore: cast_nullable_to_non_nullable
              as double,
      achievements: null == achievements
          ? _value._achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalAchievements: null == totalAchievements
          ? _value.totalAchievements
          : totalAchievements // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UserStatisticsImpl extends _UserStatistics {
  const _$UserStatisticsImpl(
      {this.totalRatings = 0,
      this.averageRating = 0.0,
      this.highestRating = 0.0,
      this.lowestRating = 0.0,
      final Map<int, int> ratingDistribution = const {},
      this.drinksRated = 0,
      final Map<DrinkType, int> typeBreakdown = const {},
      final Map<String, int> countryBreakdown = const {},
      this.uniqueCountries = 0,
      this.ratingsThisMonth = 0,
      this.ratingsThisWeek = 0,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.favoriteType,
      this.favoriteCountry,
      this.averageAbv = 0.0,
      final List<String> achievements = const [],
      this.totalAchievements = 0})
      : _ratingDistribution = ratingDistribution,
        _typeBreakdown = typeBreakdown,
        _countryBreakdown = countryBreakdown,
        _achievements = achievements,
        super._();

// Rating Statistics
  @override
  @JsonKey()
  final int totalRatings;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final double highestRating;
  @override
  @JsonKey()
  final double lowestRating;
  final Map<int, int> _ratingDistribution;
  @override
  @JsonKey()
  Map<int, int> get ratingDistribution {
    if (_ratingDistribution is EqualUnmodifiableMapView)
      return _ratingDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratingDistribution);
  }

// rating -> count
// Collection Statistics
  @override
  @JsonKey()
  final int drinksRated;
  final Map<DrinkType, int> _typeBreakdown;
  @override
  @JsonKey()
  Map<DrinkType, int> get typeBreakdown {
    if (_typeBreakdown is EqualUnmodifiableMapView) return _typeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_typeBreakdown);
  }

  final Map<String, int> _countryBreakdown;
  @override
  @JsonKey()
  Map<String, int> get countryBreakdown {
    if (_countryBreakdown is EqualUnmodifiableMapView) return _countryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_countryBreakdown);
  }

  @override
  @JsonKey()
  final int uniqueCountries;
// Activity Statistics
  @override
  @JsonKey()
  final int ratingsThisMonth;
  @override
  @JsonKey()
  final int ratingsThisWeek;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
// Preference Statistics
  @override
  final DrinkType? favoriteType;
  @override
  final String? favoriteCountry;
  @override
  @JsonKey()
  final double averageAbv;
// Achievement Statistics
  final List<String> _achievements;
// Achievement Statistics
  @override
  @JsonKey()
  List<String> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  @override
  @JsonKey()
  final int totalAchievements;

  @override
  String toString() {
    return 'UserStatistics(totalRatings: $totalRatings, averageRating: $averageRating, highestRating: $highestRating, lowestRating: $lowestRating, ratingDistribution: $ratingDistribution, drinksRated: $drinksRated, typeBreakdown: $typeBreakdown, countryBreakdown: $countryBreakdown, uniqueCountries: $uniqueCountries, ratingsThisMonth: $ratingsThisMonth, ratingsThisWeek: $ratingsThisWeek, currentStreak: $currentStreak, longestStreak: $longestStreak, favoriteType: $favoriteType, favoriteCountry: $favoriteCountry, averageAbv: $averageAbv, achievements: $achievements, totalAchievements: $totalAchievements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatisticsImpl &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.highestRating, highestRating) ||
                other.highestRating == highestRating) &&
            (identical(other.lowestRating, lowestRating) ||
                other.lowestRating == lowestRating) &&
            const DeepCollectionEquality()
                .equals(other._ratingDistribution, _ratingDistribution) &&
            (identical(other.drinksRated, drinksRated) ||
                other.drinksRated == drinksRated) &&
            const DeepCollectionEquality()
                .equals(other._typeBreakdown, _typeBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._countryBreakdown, _countryBreakdown) &&
            (identical(other.uniqueCountries, uniqueCountries) ||
                other.uniqueCountries == uniqueCountries) &&
            (identical(other.ratingsThisMonth, ratingsThisMonth) ||
                other.ratingsThisMonth == ratingsThisMonth) &&
            (identical(other.ratingsThisWeek, ratingsThisWeek) ||
                other.ratingsThisWeek == ratingsThisWeek) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.favoriteType, favoriteType) ||
                other.favoriteType == favoriteType) &&
            (identical(other.favoriteCountry, favoriteCountry) ||
                other.favoriteCountry == favoriteCountry) &&
            (identical(other.averageAbv, averageAbv) ||
                other.averageAbv == averageAbv) &&
            const DeepCollectionEquality()
                .equals(other._achievements, _achievements) &&
            (identical(other.totalAchievements, totalAchievements) ||
                other.totalAchievements == totalAchievements));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalRatings,
      averageRating,
      highestRating,
      lowestRating,
      const DeepCollectionEquality().hash(_ratingDistribution),
      drinksRated,
      const DeepCollectionEquality().hash(_typeBreakdown),
      const DeepCollectionEquality().hash(_countryBreakdown),
      uniqueCountries,
      ratingsThisMonth,
      ratingsThisWeek,
      currentStreak,
      longestStreak,
      favoriteType,
      favoriteCountry,
      averageAbv,
      const DeepCollectionEquality().hash(_achievements),
      totalAchievements);

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatisticsImplCopyWith<_$UserStatisticsImpl> get copyWith =>
      __$$UserStatisticsImplCopyWithImpl<_$UserStatisticsImpl>(
          this, _$identity);
}

abstract class _UserStatistics extends UserStatistics {
  const factory _UserStatistics(
      {final int totalRatings,
      final double averageRating,
      final double highestRating,
      final double lowestRating,
      final Map<int, int> ratingDistribution,
      final int drinksRated,
      final Map<DrinkType, int> typeBreakdown,
      final Map<String, int> countryBreakdown,
      final int uniqueCountries,
      final int ratingsThisMonth,
      final int ratingsThisWeek,
      final int currentStreak,
      final int longestStreak,
      final DrinkType? favoriteType,
      final String? favoriteCountry,
      final double averageAbv,
      final List<String> achievements,
      final int totalAchievements}) = _$UserStatisticsImpl;
  const _UserStatistics._() : super._();

// Rating Statistics
  @override
  int get totalRatings;
  @override
  double get averageRating;
  @override
  double get highestRating;
  @override
  double get lowestRating;
  @override
  Map<int, int> get ratingDistribution; // rating -> count
// Collection Statistics
  @override
  int get drinksRated;
  @override
  Map<DrinkType, int> get typeBreakdown;
  @override
  Map<String, int> get countryBreakdown;
  @override
  int get uniqueCountries; // Activity Statistics
  @override
  int get ratingsThisMonth;
  @override
  int get ratingsThisWeek;
  @override
  int get currentStreak;
  @override
  int get longestStreak; // Preference Statistics
  @override
  DrinkType? get favoriteType;
  @override
  String? get favoriteCountry;
  @override
  double get averageAbv; // Achievement Statistics
  @override
  List<String> get achievements;
  @override
  int get totalAchievements;

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatisticsImplCopyWith<_$UserStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
