import 'package:floor/floor.dart';
import '../entities/rating_entity.dart';

@dao
abstract class RatingDao {
  @Query('SELECT * FROM ratings WHERE isDeleted = 0 ORDER BY createdAt DESC')
  Future<List<RatingEntity>> getAllRatings();
  
  @Query('SELECT * FROM ratings WHERE id = :id AND isDeleted = 0')
  Future<RatingEntity?> getRatingById(String id);
  
  @Query('SELECT * FROM ratings WHERE drinkId = :drinkId AND isDeleted = 0 ORDER BY createdAt DESC')
  Future<List<RatingEntity>> getRatingsByDrinkId(String drinkId);
  
  @Query('SELECT * FROM ratings WHERE userId = :userId AND isDeleted = 0 ORDER BY createdAt DESC')
  Future<List<RatingEntity>> getRatingsByUserId(String userId);
  
  @Query('SELECT * FROM ratings WHERE drinkId = :drinkId AND userId = :userId AND isDeleted = 0')
  Future<RatingEntity?> getUserRatingForDrink(String drinkId, String userId);
  
  @Query('SELECT * FROM ratings WHERE needsSync = 1')
  Future<List<RatingEntity>> getRatingsNeedingSync();
  
  @Query('SELECT * FROM ratings WHERE lastSyncedAt IS NULL OR lastSyncedAt < :since')
  Future<List<RatingEntity>> getRatingsNotSyncedSince(DateTime since);
  
  @Query('SELECT AVG(overall) FROM ratings WHERE drinkId = :drinkId AND isDeleted = 0 AND overall IS NOT NULL')
  Future<double?> getAverageRatingForDrink(String drinkId);
  
  @Query('SELECT COUNT(*) FROM ratings WHERE drinkId = :drinkId AND isDeleted = 0')
  Future<int?> getRatingCountForDrink(String drinkId);
  
  @Query('SELECT COUNT(*) FROM ratings WHERE userId = :userId AND isDeleted = 0')
  Future<int?> getRatingCountForUser(String userId);
  
  @Query('''
    SELECT * FROM ratings 
    WHERE userId = :userId AND isDeleted = 0 
    AND createdAt >= :startDate AND createdAt <= :endDate
    ORDER BY createdAt DESC
  ''')
  Future<List<RatingEntity>> getUserRatingsInDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
  
  @Query('''
    SELECT AVG(overall) FROM ratings 
    WHERE userId = :userId AND isDeleted = 0 AND overall IS NOT NULL
  ''')
  Future<double?> getAverageRatingForUser(String userId);
  
  @Query('''
    SELECT * FROM ratings 
    WHERE userId = :userId AND isDeleted = 0
    AND overall >= :minRating
    ORDER BY overall DESC, createdAt DESC
    LIMIT :limit
  ''')
  Future<List<RatingEntity>> getTopRatedByUser(
    String userId,
    double minRating,
    int limit,
  );
  
  @Query('''
    SELECT * FROM ratings 
    WHERE userId = :userId AND isDeleted = 0
    ORDER BY createdAt DESC
    LIMIT :limit
  ''')
  Future<List<RatingEntity>> getRecentRatingsByUser(String userId, int limit);
  
  @insert
  Future<void> insertRating(RatingEntity rating);
  
  @insert
  Future<void> insertRatings(List<RatingEntity> ratings);
  
  @update
  Future<void> updateRating(RatingEntity rating);
  
  @update
  Future<void> updateRatings(List<RatingEntity> ratings);
  
  @delete
  Future<void> deleteRating(RatingEntity rating);
  
  @Query('UPDATE ratings SET isDeleted = 1, needsSync = 1, updatedAt = :deletedAt WHERE id = :id')
  Future<void> softDeleteRating(String id, DateTime deletedAt);
  
  @Query('UPDATE ratings SET needsSync = 0, lastSyncedAt = :syncedAt WHERE id = :id')
  Future<void> markRatingSynced(String id, DateTime syncedAt);
  
  @Query('UPDATE ratings SET needsSync = 1, updatedAt = :updatedAt WHERE id = :id')
  Future<void> markRatingNeedsSync(String id, DateTime updatedAt);
  
  @Query('DELETE FROM ratings WHERE isDeleted = 1 AND lastSyncedAt IS NOT NULL AND lastSyncedAt < :before')
  Future<void> cleanupDeletedRatings(DateTime before);
  
  // Analytics queries - simplified return types
  @Query('SELECT COUNT(*) FROM ratings WHERE userId = :userId AND isDeleted = 0')
  Future<int?> getUserRatingCount(String userId);
  
  @Query('SELECT AVG(overall) FROM ratings WHERE userId = :userId AND isDeleted = 0 AND overall IS NOT NULL')
  Future<double?> getUserAverageRating(String userId);
  
  @Query('SELECT MIN(overall) FROM ratings WHERE userId = :userId AND isDeleted = 0 AND overall IS NOT NULL')
  Future<double?> getUserMinRating(String userId);
  
  @Query('SELECT MAX(overall) FROM ratings WHERE userId = :userId AND isDeleted = 0 AND overall IS NOT NULL')
  Future<double?> getUserMaxRating(String userId);
  
  @Query('SELECT COUNT(*) FROM ratings WHERE drinkId = :drinkId AND isDeleted = 0')
  Future<int?> getDrinkRatingCount(String drinkId);
  
  // Complex queries with joins need to be implemented differently in Floor
  // This will be handled at the repository level by combining queries
}