import '../../domain/entities/rating.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../models/rating_model.dart';
import '../../../../core/network/pocketbase_client.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  final PocketBaseClient _pocketBaseClient;
  
  RatingsRepositoryImpl(this._pocketBaseClient);
  
  @override
  Future<List<Rating>> getUserRatings(String userId, {
    int? page,
    int? perPage,
  }) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            page: page ?? 1,
            perPage: perPage ?? 50,
            filter: 'user = "${userId}"',
            sort: '-created',
            expand: 'drink',
          );
      
      return records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get user ratings: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Rating>> getDrinkRatings(String drinkId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'drink = "${drinkId}"',
            sort: '-created',
            expand: 'user',
          );
      
      return records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get drink ratings: ${e.toString()}');
    }
  }
  
  @override
  Future<Rating?> getRatingById(String id) async {
    try {
      final record = await _pocketBaseClient.instance
          .collection('ratings')
          .getOne(id);
      
      return RatingModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Rating?> getUserDrinkRating(String userId, String drinkId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            page: 1,
            perPage: 1,
            filter: 'user = "${userId}" && drink = "${drinkId}"',
          );
      
      if (records.items.isEmpty) {
        return null;
      }
      
      return RatingModel.fromPocketBase(records.items.first.toJson()).toEntity();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Rating> createRating(Rating rating) async {
    try {
      final ratingModel = RatingModel.fromEntity(rating);
      final data = {
        'user': ratingModel.user,
        'drink': ratingModel.drink,
        'score': ratingModel.score,
        'notes': ratingModel.notes,
        'photos': ratingModel.photos,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('ratings')
          .create(body: data);
      
      return RatingModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      throw Exception('Failed to create rating: ${e.toString()}');
    }
  }
  
  @override
  Future<Rating> updateRating(Rating rating) async {
    try {
      final ratingModel = RatingModel.fromEntity(rating);
      final data = {
        'score': ratingModel.score,
        'notes': ratingModel.notes,
        'photos': ratingModel.photos,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('ratings')
          .update(rating.id, body: data);
      
      return RatingModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      throw Exception('Failed to update rating: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteRating(String id) async {
    try {
      await _pocketBaseClient.instance
          .collection('ratings')
          .delete(id);
    } catch (e) {
      throw Exception('Failed to delete rating: ${e.toString()}');
    }
  }
  
  @override
  Future<double?> getDrinkAverageRating(String drinkId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'drink = "${drinkId}"',
            perPage: 500, // Get all ratings for this drink
          );
      
      if (records.items.isEmpty) {
        return null;
      }
      
      final ratings = records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()))
          .toList();
      
      final totalScore = ratings.fold<double>(0, (sum, rating) => sum + rating.score);
      return totalScore / ratings.length;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Rating>> getRecentRatings(String userId, {int limit = 10}) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            page: 1,
            perPage: limit,
            filter: 'user = "${userId}"',
            sort: '-created',
            expand: 'drink',
          );
      
      return records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent ratings: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getUserRatingStats(String userId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'user = "${userId}"',
            perPage: 500, // Get all user ratings
          );
      
      final ratings = records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()))
          .toList();
      
      if (ratings.isEmpty) {
        return {
          'totalRatings': 0,
          'averageRating': 0.0,
          'highestRating': 0.0,
          'lowestRating': 0.0,
        };
      }
      
      final scores = ratings.map((r) => r.score).toList();
      final averageRating = scores.reduce((a, b) => a + b) / scores.length;
      
      return {
        'totalRatings': ratings.length,
        'averageRating': averageRating,
        'highestRating': scores.reduce((a, b) => a > b ? a : b),
        'lowestRating': scores.reduce((a, b) => a < b ? a : b),
      };
    } catch (e) {
      throw Exception('Failed to get user rating stats: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getUserAggregateStats(String userId) async {
    print('📊 RatingsRepository: getUserAggregateStats called for user: $userId');
    try {
      // Fetch all ratings with drink details in a single query
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'user = "$userId"',
            perPage: 500,
            expand: 'drink', // Get drink details with each rating
            sort: '-created',
          );
      
      print('📊 RatingsRepository: Found ${records.items.length} ratings for user');
      
      if (records.items.isEmpty) {
        return {
          'totalRatings': 0,
          'averageRating': 0.0,
          'highestRating': 0.0,
          'lowestRating': 0.0,
          'drinkTypeBreakdown': <String, int>{},
          'countryBreakdown': <String, int>{},
          'ratingDistribution': <int, int>{},
          'uniqueDrinks': 0,
          'uniqueCountries': 0,
          'favoriteType': null,
          'favoriteCountry': null,
        };
      }
      
      final ratings = <double>[];
      final drinkTypeCount = <String, int>{};
      final countryCount = <String, int>{};
      final ratingDistribution = <int, int>{};
      final uniqueDrinkIds = <String>{};
      
      for (final record in records.items) {
        final rating = record.data['rating'] as double? ?? record.data['score'] as double?;
        if (rating != null) {
          ratings.add(rating);
          
          // Count rating distribution (1-5 stars)
          final roundedRating = rating.round();
          ratingDistribution[roundedRating] = (ratingDistribution[roundedRating] ?? 0) + 1;
        }
        
        // Extract drink information from expanded data
        final drinkData = record.expand?['drink']?.first;
        if (drinkData != null) {
          final drinkId = drinkData.id;
          final type = drinkData.data['type'] as String?;
          final country = drinkData.data['country'] as String?;
          
          uniqueDrinkIds.add(drinkId);
          
          if (type != null) {
            drinkTypeCount[type] = (drinkTypeCount[type] ?? 0) + 1;
          }
          
          if (country != null && country.isNotEmpty) {
            countryCount[country] = (countryCount[country] ?? 0) + 1;
          }
        }
      }
      
      // Calculate statistics
      final averageRating = ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0.0;
      final highestRating = ratings.isNotEmpty ? ratings.reduce((a, b) => a > b ? a : b) : 0.0;
      final lowestRating = ratings.isNotEmpty ? ratings.reduce((a, b) => a < b ? a : b) : 0.0;
      
      // Find favorites (most frequent)
      String? favoriteType;
      String? favoriteCountry;
      
      if (drinkTypeCount.isNotEmpty) {
        favoriteType = drinkTypeCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      }
      
      if (countryCount.isNotEmpty) {
        favoriteCountry = countryCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      }
      
      print('📊 RatingsRepository: Calculated stats - avg: $averageRating, types: ${drinkTypeCount.length}, countries: ${countryCount.length}');
      
      return {
        'totalRatings': ratings.length,
        'averageRating': averageRating,
        'highestRating': highestRating,
        'lowestRating': lowestRating,
        'drinkTypeBreakdown': drinkTypeCount,
        'countryBreakdown': countryCount,
        'ratingDistribution': ratingDistribution,
        'uniqueDrinks': uniqueDrinkIds.length,
        'uniqueCountries': countryCount.length,
        'favoriteType': favoriteType,
        'favoriteCountry': favoriteCountry,
      };
    } catch (e) {
      print('❌ RatingsRepository: Error in getUserAggregateStats(): $e');
      throw Exception('Failed to get user aggregate stats: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, Map<String, dynamic>>> getBatchDrinkStats(List<String> drinkIds) async {
    try {
      if (drinkIds.isEmpty) return {};
      
      // Create filter for multiple drink IDs
      final idFilters = drinkIds.map((id) => 'drink = "$id"').join(' || ');
      final filterString = '($idFilters)';
      
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: filterString,
            perPage: 500,
          );
      
      final drinkStats = <String, Map<String, dynamic>>{};
      
      // Initialize all drinks with empty stats
      for (final drinkId in drinkIds) {
        drinkStats[drinkId] = {
          'averageRating': null,
          'ratingCount': 0,
          'ratings': <double>[],
        };
      }
      
      // Process ratings
      for (final record in records.items) {
        final drinkId = record.data['drink'] as String?;
        final rating = record.data['rating'] as double? ?? record.data['score'] as double?;
        
        if (drinkId != null && rating != null && drinkStats.containsKey(drinkId)) {
          final stats = drinkStats[drinkId]!;
          final ratings = stats['ratings'] as List<double>;
          ratings.add(rating);
          
          stats['ratingCount'] = ratings.length;
          stats['averageRating'] = ratings.reduce((a, b) => a + b) / ratings.length;
        }
      }
      
      return drinkStats;
    } catch (e) {
      throw Exception('Failed to get batch drink stats: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getRatingsWithDrinkDetails(String userId, {
    int? limit,
    String? orderBy,
  }) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'user = "$userId"',
            perPage: limit ?? 50,
            expand: 'drink',
            sort: orderBy ?? '-created',
          );
      
      final results = <Map<String, dynamic>>[];
      
      for (final record in records.items) {
        final rating = RatingModel.fromPocketBase(record.toJson()).toEntity();
        final drinkData = record.expand?['drink']?.first;
        
        results.add({
          'rating': rating,
          'drink': drinkData?.toJson(),
          'created': record.data['created'],
          'updated': record.data['updated'],
        });
      }
      
      return results;
    } catch (e) {
      throw Exception('Failed to get ratings with drink details: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getRatingTimeSeries(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
  }) async {
    try {
      final filters = ['user = "$userId"'];
      
      if (startDate != null) {
        filters.add('created >= "${startDate.toIso8601String()}"');
      }
      
      if (endDate != null) {
        filters.add('created <= "${endDate.toIso8601String()}"');
      }
      
      final filterString = filters.join(' && ');
      
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: filterString,
            perPage: 500,
            sort: '+created',
          );
      
      // Group ratings by time period
      final groupedData = <String, List<double>>{};
      
      for (final record in records.items) {
        final createdStr = record.data['created'] as String?;
        final rating = record.data['rating'] as double? ?? record.data['score'] as double?;
        
        if (createdStr != null && rating != null) {
          final created = DateTime.parse(createdStr);
          String groupKey;
          
          switch (groupBy) {
            case 'day':
              groupKey = '${created.year}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}';
              break;
            case 'week':
              final weekStart = created.subtract(Duration(days: created.weekday - 1));
              groupKey = '${weekStart.year}-W${_getWeekOfYear(weekStart)}';
              break;
            case 'month':
            default:
              groupKey = '${created.year}-${created.month.toString().padLeft(2, '0')}';
              break;
          }
          
          groupedData.putIfAbsent(groupKey, () => []).add(rating);
        }
      }
      
      // Convert to time series format
      final timeSeries = <Map<String, dynamic>>[];
      
      for (final entry in groupedData.entries) {
        final ratings = entry.value;
        final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
        
        timeSeries.add({
          'period': entry.key,
          'averageRating': averageRating,
          'ratingCount': ratings.length,
          'totalRatings': ratings.length,
        });
      }
      
      return timeSeries;
    } catch (e) {
      throw Exception('Failed to get rating time series: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getRatingAnalytics(String userId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'user = "$userId"',
            perPage: 500,
            expand: 'drink',
            sort: '-created',
          );
      
      if (records.items.isEmpty) {
        return {
          'ratingDistribution': <int, int>{},
          'monthlyTrends': <String, double>{},
          'typePreferences': <String, double>{},
          'countryPreferences': <String, double>{},
          'ratingConsistency': 0.0,
          'activityLevel': 'low',
        };
      }
      
      final ratings = <double>[];
      final ratingDistribution = <int, int>{};
      final monthlyRatings = <String, List<double>>{};
      final typeRatings = <String, List<double>>{};
      final countryRatings = <String, List<double>>{};
      
      for (final record in records.items) {
        final rating = record.data['rating'] as double? ?? record.data['score'] as double?;
        final createdStr = record.data['created'] as String?;
        
        if (rating != null) {
          ratings.add(rating);
          
          // Rating distribution (1-5 stars)
          final roundedRating = rating.round();
          ratingDistribution[roundedRating] = (ratingDistribution[roundedRating] ?? 0) + 1;
          
          // Monthly trends
          if (createdStr != null) {
            final created = DateTime.parse(createdStr);
            final monthKey = '${created.year}-${created.month.toString().padLeft(2, '0')}';
            monthlyRatings.putIfAbsent(monthKey, () => []).add(rating);
          }
          
          // Type and country preferences
          final drinkData = record.expand?['drink']?.first;
          if (drinkData != null) {
            final type = drinkData.data['type'] as String?;
            final country = drinkData.data['country'] as String?;
            
            if (type != null) {
              typeRatings.putIfAbsent(type, () => []).add(rating);
            }
            
            if (country != null && country.isNotEmpty) {
              countryRatings.putIfAbsent(country, () => []).add(rating);
            }
          }
        }
      }
      
      // Calculate consistency (standard deviation)
      final mean = ratings.reduce((a, b) => a + b) / ratings.length;
      final variance = ratings.map((r) => (r - mean) * (r - mean)).reduce((a, b) => a + b) / ratings.length;
      final standardDeviation = variance > 0 ? 1 / (1 + variance.abs()) : 1.0; // Inverse for consistency score
      
      // Monthly trends averages
      final monthlyTrends = <String, double>{};
      for (final entry in monthlyRatings.entries) {
        monthlyTrends[entry.key] = entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
      
      // Type preferences averages
      final typePreferences = <String, double>{};
      for (final entry in typeRatings.entries) {
        typePreferences[entry.key] = entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
      
      // Country preferences averages
      final countryPreferences = <String, double>{};
      for (final entry in countryRatings.entries) {
        countryPreferences[entry.key] = entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
      
      // Activity level
      final now = DateTime.now();
      final lastMonth = now.subtract(const Duration(days: 30));
      final recentRatings = records.items.where((r) {
        final createdStr = r.data['created'] as String?;
        if (createdStr != null) {
          final created = DateTime.parse(createdStr);
          return created.isAfter(lastMonth);
        }
        return false;
      }).length;
      
      String activityLevel;
      if (recentRatings >= 20) {
        activityLevel = 'high';
      } else if (recentRatings >= 5) {
        activityLevel = 'medium';
      } else {
        activityLevel = 'low';
      }
      
      return {
        'ratingDistribution': ratingDistribution,
        'monthlyTrends': monthlyTrends,
        'typePreferences': typePreferences,
        'countryPreferences': countryPreferences,
        'ratingConsistency': standardDeviation,
        'activityLevel': activityLevel,
        'totalRatings': ratings.length,
        'averageRating': mean,
      };
    } catch (e) {
      throw Exception('Failed to get rating analytics: ${e.toString()}');
    }
  }
  
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}