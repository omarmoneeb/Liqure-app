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

/// Utility provider to refresh dashboard data after rating changes
final dashboardRefreshProvider = Provider<void Function()>((ref) {
  return () {
    print('🔄 Dashboard: Refreshing all dashboard data');
    ref.invalidate(userStatisticsProvider);
    ref.invalidate(userRecentActivityProvider);
    ref.invalidate(userFavoriteTypesProvider);
    print('🔄 Dashboard: All providers invalidated');
  };
});

/// Provider for performance-optimized statistics using enhanced repository methods
final optimizedUserStatisticsProvider = FutureProvider.autoDispose<UserStatistics>((ref) async {
  print('📊 Dashboard: optimizedUserStatisticsProvider called');
  
  try {
    final authState = ref.watch(authProvider);
    if (authState.user == null) {
      print('❌ Dashboard: No authenticated user');
      return const UserStatistics();
    }

    final userId = authState.user!.id;
    print('📊 Dashboard: Getting optimized statistics for user: $userId');

    // Use the new optimized aggregate stats method for better performance
    final ratingsRepository = ref.read(ratingsRepositoryProvider);
    final aggregateStats = await ratingsRepository.getUserAggregateStats(userId);
    print('📊 Dashboard: Retrieved aggregate stats in single optimized query');

    // Get recent activity efficiently for activity calculations
    final recentRatings = await ratingsRepository.getRecentRatings(userId, limit: 100);
    final activityStats = _calculateActivityStatistics(recentRatings);
    print('📊 Dashboard: Calculated activity statistics');

    // Extract data from aggregate stats (from single optimized query)
    final totalRatings = aggregateStats['totalRatings'] as int? ?? 0;
    final averageRating = aggregateStats['averageRating'] as double? ?? 0.0;
    final highestRating = aggregateStats['highestRating'] as double? ?? 0.0;
    final lowestRating = aggregateStats['lowestRating'] as double? ?? 0.0;
    final uniqueDrinks = aggregateStats['uniqueDrinks'] as int? ?? 0;
    final uniqueCountries = aggregateStats['uniqueCountries'] as int? ?? 0;
    
    final typeBreakdownRaw = aggregateStats['drinkTypeBreakdown'] as Map<String, int>? ?? {};
    final countryBreakdownRaw = aggregateStats['countryBreakdown'] as Map<String, int>? ?? {};
    final ratingDistribution = aggregateStats['ratingDistribution'] as Map<int, int>? ?? {};
    final favoriteTypeStr = aggregateStats['favoriteType'] as String?;
    final favoriteCountry = aggregateStats['favoriteCountry'] as String?;

    // Convert type breakdown to proper enum mapping
    final typeBreakdown = <DrinkType, int>{};
    for (final entry in typeBreakdownRaw.entries) {
      try {
        final drinkType = DrinkType.values.firstWhere((type) => type.name == entry.key);
        typeBreakdown[drinkType] = entry.value;
      } catch (e) {
        print('⚠️ Dashboard: Unknown drink type: ${entry.key}');
      }
    }

    // Convert favorite type string to enum
    DrinkType? favoriteType;
    if (favoriteTypeStr != null) {
      try {
        favoriteType = DrinkType.values.firstWhere((type) => type.name == favoriteTypeStr);
      } catch (e) {
        print('⚠️ Dashboard: Unknown favorite type: $favoriteTypeStr');
      }
    }

    // Calculate achievements with optimized data
    final achievements = _calculateAchievements(recentRatings, {
      'uniqueDrinks': uniqueDrinks,
      'typeBreakdown': typeBreakdown,
      'countryBreakdown': countryBreakdownRaw,
      'favoriteType': favoriteType,
      'favoriteCountry': favoriteCountry,
      'averageAbv': 0.0, // TODO: Add ABV calculation to aggregate stats
    });

    // Return comprehensive statistics built from optimized single queries
    final statistics = UserStatistics(
      totalRatings: totalRatings,
      averageRating: averageRating,
      drinksRated: uniqueDrinks,
      uniqueCountries: uniqueCountries,
      favoriteType: favoriteType,
      favoriteCountry: favoriteCountry,
      typeBreakdown: typeBreakdown,
      countryBreakdown: countryBreakdownRaw,
      ratingDistribution: ratingDistribution,
      ratingsThisWeek: activityStats['thisWeek'] as int? ?? 0,
      ratingsThisMonth: activityStats['thisMonth'] as int? ?? 0,
      currentStreak: activityStats['currentStreak'] as int? ?? 0,
      longestStreak: activityStats['longestStreak'] as int? ?? 0,
      achievements: achievements,
      totalAchievements: achievements.length,
      averageAbv: 0.0, // TODO: Add ABV calculation to aggregate stats
      highestRating: highestRating,
      lowestRating: lowestRating,
    );

    print('📊 Dashboard: Final optimized statistics calculated successfully');
    return statistics;
  } catch (e, stackTrace) {
    print('❌ Dashboard: Error in optimizedUserStatisticsProvider: $e');
    print('❌ Dashboard: StackTrace: $stackTrace');
    throw Exception('Failed to load optimized user statistics: $e');
  }
});

/// Helper function to calculate drink-related statistics
/// OPTIMIZED: Uses batch fetching instead of N+1 queries
Future<Map<String, dynamic>> _calculateDrinkStatistics(
  Ref ref, 
  List<Rating> userRatings
) async {
  print('📊 Dashboard: Calculating drink statistics for ${userRatings.length} ratings');
  
  final typeBreakdown = <DrinkType, int>{};
  final countryBreakdown = <String, int>{};
  final abvValues = <double>[];
  
  if (userRatings.isEmpty) {
    return {
      'typeBreakdown': typeBreakdown,
      'countryBreakdown': countryBreakdown,
      'averageAbv': 0.0,
      'uniqueCountries': 0,
      'favoriteType': null,
      'favoriteCountry': null,
    };
  }
  
  // Get drinks repository to fetch drink details
  final drinksRepository = ref.watch(drinksRepositoryProvider);
  
  // Extract unique drink IDs from ratings
  final drinkIds = userRatings
      .where((rating) => rating.drinkId != null)
      .map((rating) => rating.drinkId!)
      .toSet()
      .toList();
  
  print('📊 Dashboard: Fetching ${drinkIds.length} unique drinks in batch');
  
  // OPTIMIZATION: Fetch all drinks in a single batch query instead of N+1 queries
  final drinksMap = await drinksRepository.getBatchDrinks(drinkIds);
  
  print('📊 Dashboard: Successfully fetched ${drinksMap.length} drinks');
  
  // Process each rating with the fetched drinks
  for (final rating in userRatings) {
    try {
      if (rating.drinkId != null) {
        final drink = drinksMap[rating.drinkId!];
        
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
      print('Error processing rating ${rating.id}: $e');
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