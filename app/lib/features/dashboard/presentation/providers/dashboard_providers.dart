import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../tasting/presentation/providers/tasting_providers.dart';
import '../../../tasting/domain/entities/drink.dart';
import '../../../tasting/domain/entities/rating.dart';
import '../../../tasting/domain/repositories/drinks_repository.dart';
import '../../domain/entities/user_statistics.dart';

/// Provider for comprehensive user statistics
final userStatisticsProvider = FutureProvider.autoDispose<UserStatistics>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) {
    return const UserStatistics();
  }

  // Get user ratings and basic stats
  final userRatings = await ref.watch(userRatingsProvider.future);
  final basicStats = await ref.watch(userRatingStatsProvider.future);
  
  if (userRatings.isEmpty) {
    return const UserStatistics();
  }

  // Calculate rating distribution
  final ratingDistribution = <int, int>{};
  for (final rating in userRatings) {
    final ratingValue = rating.rating.round();
    ratingDistribution[ratingValue] = (ratingDistribution[ratingValue] ?? 0) + 1;
  }

  // Get drinks for each rating to analyze collection
  final drinkStats = await _calculateDrinkStatistics(ref, userRatings);
  
  // Calculate activity statistics
  final activityStats = _calculateActivityStatistics(userRatings);
  
  // Calculate achievements
  final achievements = _calculateAchievements(userRatings, drinkStats);

  return UserStatistics(
    // Rating Statistics
    totalRatings: userRatings.length,
    averageRating: basicStats['averageRating']?.toDouble() ?? 0.0,
    highestRating: basicStats['highestRating']?.toDouble() ?? 0.0,
    lowestRating: basicStats['lowestRating']?.toDouble() ?? 0.0,
    ratingDistribution: ratingDistribution,
    
    // Collection Statistics
    drinksRated: userRatings.length,
    typeBreakdown: drinkStats['typeBreakdown'] ?? {},
    countryBreakdown: drinkStats['countryBreakdown'] ?? {},
    uniqueCountries: drinkStats['uniqueCountries'] ?? 0,
    
    // Activity Statistics
    ratingsThisMonth: activityStats['thisMonth'] ?? 0,
    ratingsThisWeek: activityStats['thisWeek'] ?? 0,
    currentStreak: activityStats['currentStreak'] ?? 0,
    longestStreak: activityStats['longestStreak'] ?? 0,
    
    // Preferences
    favoriteType: drinkStats['favoriteType'],
    favoriteCountry: drinkStats['favoriteCountry'],
    averageAbv: drinkStats['averageAbv'] ?? 0.0,
    
    // Achievements
    achievements: achievements,
    totalAchievements: achievements.length,
  );
});

/// Provider for recent user activity
final userRecentActivityProvider = FutureProvider.autoDispose<List<Rating>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) {
    return [];
  }

  final allRatings = await ref.watch(userRatingsProvider.future);
  
  // Sort by creation date and take last 10
  final sortedRatings = List<Rating>.from(allRatings)
    ..sort((a, b) {
      final aDate = a.created ?? DateTime.now();
      final bDate = b.created ?? DateTime.now();
      return bDate.compareTo(aDate);
    });
  
  return sortedRatings.take(10).toList();
});

/// Provider for user's favorite drink types
final userFavoriteTypesProvider = FutureProvider.autoDispose<List<MapEntry<DrinkType, int>>>((ref) async {
  final stats = await ref.watch(userStatisticsProvider.future);
  
  final sortedTypes = stats.typeBreakdown.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  return sortedTypes.take(5).toList();
});

/// Helper function to calculate drink-related statistics
Future<Map<String, dynamic>> _calculateDrinkStatistics(
  Ref ref, 
  List<Rating> userRatings
) async {
  final typeBreakdown = <DrinkType, int>{};
  final countryBreakdown = <String, int>{};
  final abvValues = <double>[];
  
  // Get drinks repository to fetch drink details
  final drinksRepository = ref.watch(drinksRepositoryProvider);
  
  // Fetch drink details for each rating
  for (final rating in userRatings) {
    try {
      if (rating.drinkId != null) {
        final drink = await drinksRepository.getDrinkById(rating.drinkId!);
        
        if (drink != null) {
          // Count drink types
          typeBreakdown[drink.type] = (typeBreakdown[drink.type] ?? 0) + 1;
          
          // Count countries
          if (drink.country != null && drink.country!.isNotEmpty) {
            countryBreakdown[drink.country!] = (countryBreakdown[drink.country!] ?? 0) + 1;
          }
          
          // Collect ABV values
          if (drink.abv != null && drink.abv! > 0) {
            abvValues.add(drink.abv!);
          }
        }
      }
    } catch (e) {
      print('Error fetching drink details for rating ${rating.id}: $e');
      // Continue processing other ratings even if one fails
    }
  }
  
  // Calculate favorite type and country
  DrinkType? favoriteType;
  String? favoriteCountry;
  
  if (typeBreakdown.isNotEmpty) {
    favoriteType = typeBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  if (countryBreakdown.isNotEmpty) {
    favoriteCountry = countryBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  final averageAbv = abvValues.isNotEmpty 
      ? abvValues.reduce((a, b) => a + b) / abvValues.length 
      : 0.0;

  return {
    'typeBreakdown': typeBreakdown,
    'countryBreakdown': countryBreakdown,
    'uniqueCountries': countryBreakdown.length,
    'favoriteType': favoriteType,
    'favoriteCountry': favoriteCountry,
    'averageAbv': averageAbv,
  };
}

/// Helper function to calculate activity statistics
Map<String, int> _calculateActivityStatistics(List<Rating> userRatings) {
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);
  final thisWeek = now.subtract(const Duration(days: 7));
  
  var ratingsThisMonth = 0;
  var ratingsThisWeek = 0;
  
  for (final rating in userRatings) {
    final created = rating.created ?? DateTime.now();
    
    if (created.isAfter(thisMonth)) {
      ratingsThisMonth++;
    }
    
    if (created.isAfter(thisWeek)) {
      ratingsThisWeek++;
    }
  }
  
  // Calculate streaks (simplified)
  // In a full implementation, you'd calculate consecutive days with ratings
  final currentStreak = ratingsThisWeek > 0 ? 1 : 0;
  final longestStreak = ratingsThisMonth; // Simplified calculation
  
  return {
    'thisMonth': ratingsThisMonth,
    'thisWeek': ratingsThisWeek,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
  };
}

/// Helper function to calculate user achievements
List<String> _calculateAchievements(
  List<Rating> userRatings, 
  Map<String, dynamic> drinkStats
) {
  final achievements = <String>[];
  final totalRatings = userRatings.length;
  final uniqueCountries = drinkStats['uniqueCountries'] ?? 0;
  
  // Rating milestone achievements
  if (totalRatings >= 1) achievements.add('First Rating');
  if (totalRatings >= 10) achievements.add('Getting Started');
  if (totalRatings >= 25) achievements.add('Enthusiast');
  if (totalRatings >= 50) achievements.add('Connoisseur');
  if (totalRatings >= 100) achievements.add('Expert');
  if (totalRatings >= 250) achievements.add('Master');
  
  // Country exploration achievements
  if (uniqueCountries >= 3) achievements.add('World Explorer');
  if (uniqueCountries >= 5) achievements.add('Globe Trotter');
  if (uniqueCountries >= 10) achievements.add('International Palate');
  
  // Type variety achievements
  final typesCount = (drinkStats['typeBreakdown'] as Map<DrinkType, int>?)?.length ?? 0;
  if (typesCount >= 3) achievements.add('Diverse Taste');
  if (typesCount >= 5) achievements.add('Versatile Palate');
  if (typesCount >= 8) achievements.add('Spirit Scholar');
  
  return achievements;
}