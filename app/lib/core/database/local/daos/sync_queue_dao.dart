import 'package:floor/floor.dart';
import '../entities/sync_queue_entity.dart';

@dao
abstract class SyncQueueDao {
  @Query('SELECT * FROM sync_queue ORDER BY createdAt ASC')
  Future<List<SyncQueueEntity>> getAllPendingSyncs();
  
  @Query('SELECT * FROM sync_queue WHERE entityType = :entityType ORDER BY createdAt ASC')
  Future<List<SyncQueueEntity>> getPendingSyncsByType(String entityType);
  
  @Query('SELECT * FROM sync_queue WHERE entityId = :entityId AND entityType = :entityType')
  Future<SyncQueueEntity?> getPendingSyncForEntity(String entityId, String entityType);
  
  @Query('SELECT * FROM sync_queue WHERE retryCount < :maxRetries ORDER BY createdAt ASC LIMIT :limit')
  Future<List<SyncQueueEntity>> getRetryableSyncs(int maxRetries, int limit);
  
  @Query('SELECT COUNT(*) FROM sync_queue')
  Future<int?> getPendingSyncCount();
  
  @Query('SELECT COUNT(*) FROM sync_queue WHERE entityType = :entityType')
  Future<int?> getPendingSyncCountByType(String entityType);
  
  @Query('SELECT COUNT(*) FROM sync_queue WHERE retryCount >= :maxRetries')
  Future<int?> getFailedSyncCount(int maxRetries);
  
  @insert
  Future<void> insertSyncItem(SyncQueueEntity syncItem);
  
  @insert
  Future<void> insertSyncItems(List<SyncQueueEntity> syncItems);
  
  @update
  Future<void> updateSyncItem(SyncQueueEntity syncItem);
  
  @delete
  Future<void> deleteSyncItem(SyncQueueEntity syncItem);
  
  @Query('DELETE FROM sync_queue WHERE id = :id')
  Future<void> deleteSyncItemById(String id);
  
  @Query('DELETE FROM sync_queue WHERE entityId = :entityId AND entityType = :entityType')
  Future<void> deleteSyncItemsForEntity(String entityId, String entityType);
  
  @Query('UPDATE sync_queue SET retryCount = retryCount + 1, lastAttemptAt = :attemptTime, error = :error WHERE id = :id')
  Future<void> incrementRetryCount(String id, DateTime attemptTime, String error);
  
  @Query('DELETE FROM sync_queue WHERE retryCount >= :maxRetries AND createdAt < :before')
  Future<void> cleanupFailedSyncs(int maxRetries, DateTime before);
  
  @Query('DELETE FROM sync_queue WHERE createdAt < :before')
  Future<void> cleanupOldSyncs(DateTime before);
  
  // Batch operations
  @Query('SELECT * FROM sync_queue WHERE entityType = :entityType AND operation = :operation ORDER BY createdAt ASC LIMIT :batchSize')
  Future<List<SyncQueueEntity>> getBatchSyncs(String entityType, String operation, int batchSize);
  
  // Simplified summary queries (Floor doesn't support Map return types)
  @Query('SELECT DISTINCT entityType FROM sync_queue ORDER BY entityType')
  Future<List<String>> getDistinctEntityTypes();
  
  @Query('SELECT DISTINCT operation FROM sync_queue ORDER BY operation')
  Future<List<String>> getDistinctOperations();
}