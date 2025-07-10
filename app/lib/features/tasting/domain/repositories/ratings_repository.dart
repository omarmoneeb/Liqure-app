import '../entities/rating.dart';

abstract class RatingsRepository {
  /// Get all ratings for a user
  Future<List<Rating>> getUserRatings(String userId, {
    int? page,
    int? perPage,
  });
  
  /// Get all ratings for a drink
  Future<List<Rating>> getDrinkRatings(String drinkId);
  
  /// Get rating by ID
  Future<Rating?> getRatingById(String id);
  
  /// Get user's rating for a specific drink
  Future<Rating?> getUserDrinkRating(String userId, String drinkId);
  
  /// Create new rating
  Future<Rating> createRating(Rating rating);
  
  /// Update existing rating
  Future<Rating> updateRating(Rating rating);
  
  /// Delete rating
  Future<void> deleteRating(String id);
  
  /// Get average rating for a drink
  Future<double?> getDrinkAverageRating(String drinkId);
  
  /// Get user's recent ratings
  Future<List<Rating>> getRecentRatings(String userId, {int limit = 10});
  
  /// Get rating statistics for user
  Future<Map<String, dynamic>> getUserRatingStats(String userId);
  
  /// Get comprehensive user statistics with better performance
  Future<Map<String, dynamic>> getUserAggregateStats(String userId);
  
  /// Get batch rating statistics for multiple drinks
  Future<Map<String, Map<String, dynamic>>> getBatchDrinkStats(List<String> drinkIds);
  
  /// Get ratings with drink details in a single query
  Future<List<Map<String, dynamic>>> getRatingsWithDrinkDetails(String userId, {
    int? limit,
    String? orderBy,
  });
  
  /// Get time-series rating data for analytics
  Future<List<Map<String, dynamic>>> getRatingTimeSeries(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy, // 'day', 'week', 'month'
  });
  
  /// Get rating distribution and analytics
  Future<Map<String, dynamic>> getRatingAnalytics(String userId);
}