import 'package:floor/floor.dart';
import '../entities/drink_entity.dart';

@dao
abstract class DrinkDao {
  @Query('SELECT * FROM drinks WHERE isDeleted = 0 ORDER BY createdAt DESC')
  Future<List<DrinkEntity>> getAllDrinks();
  
  @Query('SELECT * FROM drinks WHERE id = :id AND isDeleted = 0')
  Future<DrinkEntity?> getDrinkById(String id);
  
  @Query('SELECT * FROM drinks WHERE barcode = :barcode AND isDeleted = 0')
  Future<DrinkEntity?> getDrinkByBarcode(String barcode);
  
  @Query('''
    SELECT * FROM drinks 
    WHERE isDeleted = 0 
    AND (
      name LIKE :searchTerm 
      OR description LIKE :searchTerm 
      OR country LIKE :searchTerm
      OR distillery LIKE :searchTerm
    )
    ORDER BY createdAt DESC
  ''')
  Future<List<DrinkEntity>> searchDrinks(String searchTerm);
  
  @Query('SELECT * FROM drinks WHERE type = :type AND isDeleted = 0 ORDER BY name ASC')
  Future<List<DrinkEntity>> getDrinksByType(String type);
  
  @Query('SELECT * FROM drinks WHERE country = :country AND isDeleted = 0 ORDER BY name ASC')
  Future<List<DrinkEntity>> getDrinksByCountry(String country);
  
  @Query('SELECT * FROM drinks WHERE needsSync = 1')
  Future<List<DrinkEntity>> getDrinksNeedingSync();
  
  @Query('SELECT * FROM drinks WHERE lastSyncedAt IS NULL OR lastSyncedAt < :since')
  Future<List<DrinkEntity>> getDrinksNotSyncedSince(DateTime since);
  
  @Query('SELECT DISTINCT type FROM drinks WHERE isDeleted = 0 ORDER BY type ASC')
  Future<List<String>> getDistinctTypes();
  
  @Query('SELECT DISTINCT country FROM drinks WHERE isDeleted = 0 AND country IS NOT NULL ORDER BY country ASC')
  Future<List<String>> getDistinctCountries();
  
  @Query('SELECT COUNT(*) FROM drinks WHERE isDeleted = 0')
  Future<int?> getDrinksCount();
  
  @Query('SELECT COUNT(*) FROM drinks WHERE type = :type AND isDeleted = 0')
  Future<int?> getDrinksCountByType(String type);
  
  @insert
  Future<void> insertDrink(DrinkEntity drink);
  
  @insert
  Future<void> insertDrinks(List<DrinkEntity> drinks);
  
  @update
  Future<void> updateDrink(DrinkEntity drink);
  
  @update
  Future<void> updateDrinks(List<DrinkEntity> drinks);
  
  @delete
  Future<void> deleteDrink(DrinkEntity drink);
  
  @Query('UPDATE drinks SET isDeleted = 1, needsSync = 1, updatedAt = :deletedAt WHERE id = :id')
  Future<void> softDeleteDrink(String id, DateTime deletedAt);
  
  @Query('UPDATE drinks SET needsSync = 0, lastSyncedAt = :syncedAt WHERE id = :id')
  Future<void> markDrinkSynced(String id, DateTime syncedAt);
  
  @Query('UPDATE drinks SET needsSync = 1, updatedAt = :updatedAt WHERE id = :id')
  Future<void> markDrinkNeedsSync(String id, DateTime updatedAt);
  
  @Query('DELETE FROM drinks WHERE isDeleted = 1 AND lastSyncedAt IS NOT NULL AND lastSyncedAt < :before')
  Future<void> cleanupDeletedDrinks(DateTime before);
  
  // Advanced filtering queries - using separate methods since Floor doesn't support nullable params
  @Query('SELECT * FROM drinks WHERE isDeleted = 0 ORDER BY createdAt DESC LIMIT :limit OFFSET :offset')
  Future<List<DrinkEntity>> getDrinksWithLimit(int limit, int offset);
  
  @Query('SELECT * FROM drinks WHERE isDeleted = 0 AND type = :type ORDER BY createdAt DESC LIMIT :limit OFFSET :offset')
  Future<List<DrinkEntity>> getDrinksWithTypeFilter(String type, int limit, int offset);
  
  @Query('SELECT * FROM drinks WHERE isDeleted = 0 AND country = :country ORDER BY createdAt DESC LIMIT :limit OFFSET :offset')
  Future<List<DrinkEntity>> getDrinksWithCountryFilter(String country, int limit, int offset);
  
  @Query('SELECT * FROM drinks WHERE isDeleted = 0 AND abv >= :minAbv AND abv <= :maxAbv ORDER BY createdAt DESC LIMIT :limit OFFSET :offset')
  Future<List<DrinkEntity>> getDrinksWithAbvFilter(double minAbv, double maxAbv, int limit, int offset);
}