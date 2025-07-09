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
}