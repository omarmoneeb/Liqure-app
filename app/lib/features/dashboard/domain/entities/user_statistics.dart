import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../tasting/domain/entities/drink.dart';

part 'user_statistics.freezed.dart';

@freezed
class UserStatistics with _$UserStatistics {
  const factory UserStatistics({
    // Rating Statistics
    @Default(0) int totalRatings,
    @Default(0.0) double averageRating,
    @Default(0.0) double highestRating,
    @Default(0.0) double lowestRating,
    @Default({}) Map<int, int> ratingDistribution, // rating -> count
    
    // Collection Statistics
    @Default(0) int drinksRated,
    @Default({}) Map<DrinkType, int> typeBreakdown,
    @Default({}) Map<String, int> countryBreakdown,
    @Default(0) int uniqueCountries,
    
    // Activity Statistics
    @Default(0) int ratingsThisMonth,
    @Default(0) int ratingsThisWeek,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    
    // Preference Statistics
    DrinkType? favoriteType,
    String? favoriteCountry,
    @Default(0.0) double averageAbv,
    
    // Achievement Statistics
    @Default([]) List<String> achievements,
    @Default(0) int totalAchievements,
  }) = _UserStatistics;
  
  const UserStatistics._();
  
  /// Check if user has any ratings
  bool get hasRatings => totalRatings > 0;
  
  /// Get rating quality description
  String get ratingQualityDescription {
    if (averageRating >= 4.5) return 'Exceptional';
    if (averageRating >= 4.0) return 'High Standards';
    if (averageRating >= 3.5) return 'Good Taste';
    if (averageRating >= 3.0) return 'Balanced';
    return 'Critical Eye';
  }
  
  /// Get activity level description
  String get activityLevelDescription {
    if (ratingsThisMonth >= 20) return 'Very Active';
    if (ratingsThisMonth >= 10) return 'Active';
    if (ratingsThisMonth >= 5) return 'Moderate';
    if (ratingsThisMonth >= 1) return 'Light';
    return 'Just Starting';
  }
  
  /// Get most popular rating value
  int get mostCommonRating {
    if (ratingDistribution.isEmpty) return 0;
    
    var maxCount = 0;
    var mostCommon = 0;
    
    ratingDistribution.forEach((rating, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommon = rating;
      }
    });
    
    return mostCommon;
  }
}