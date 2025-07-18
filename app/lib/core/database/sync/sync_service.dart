import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';
import '../local/entities/sync_queue_entity.dart';
import '../local/mappers/drink_mapper.dart';
import '../local/mappers/rating_mapper.dart';
import '../../../features/tasting/domain/repositories/drinks_repository.dart';
import '../../../features/tasting/domain/repositories/ratings_repository.dart';

class SyncService {
  final AppDatabase _database;
  final DrinksRepository _drinksRepository;
  final RatingsRepository _ratingsRepository;
  final Connectivity _connectivity;
  final _uuid = const Uuid();
  
  // Sync configuration
  static const int _maxRetries = 3;
  static const Duration _syncInterval = Duration(minutes: 5);
  static const Duration _retryDelay = Duration(seconds: 30);
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  SyncService({
    required AppDatabase database,
    required DrinksRepository drinksRepository,
    required RatingsRepository ratingsRepository,
    required Connectivity connectivity,
  }) : _database = database,
       _drinksRepository = drinksRepository,
       _ratingsRepository = ratingsRepository,
       _connectivity = connectivity;
  
  /// Initialize sync service and start periodic syncing
  Future<void> initialize() async {
    if (kDebugMode) {
      debugPrint('🔄 SyncService: Initializing...');
    }
    
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      if (isConnected && !_isSyncing) {
        _triggerSync();
      }
    });
    
    // Start periodic sync timer
    _syncTimer = Timer.periodic(_syncInterval, (_) => _triggerSync());
    
    // Perform initial sync if connected
    final connectivity = await _connectivity.checkConnectivity();
    final isConnected = connectivity != ConnectivityResult.none;
    if (isConnected) {
      _triggerSync();
    }
    
    if (kDebugMode) {
      debugPrint('🔄 SyncService: Initialized successfully');
    }
  }
  
  /// Dispose sync service and cleanup resources
  void dispose() {
    if (kDebugMode) {
      debugPrint('🔄 SyncService: Disposing...');
    }
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
  
  /// Trigger a sync operation
  Future<void> _triggerSync() async {
    if (_isSyncing) {
      if (kDebugMode) {
        debugPrint('🔄 SyncService: Sync already in progress, skipping');
      }
      return;
    }
    
    try {
      _isSyncing = true;
      await _performSync();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ SyncService: Sync error: $e');
      }
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Force a manual sync
  Future<void> forceSync() async {
    if (kDebugMode) {
      debugPrint('🔄 SyncService: Force sync requested');
    }
    await _triggerSync();
  }
  
  /// Check if device is online
  Future<bool> isOnline() async {
    final connectivity = await _connectivity.checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }
  
  /// Get sync status information
  Future<SyncStatus> getSyncStatus() async {
    final pendingCount = await _database.syncQueueDao.getPendingSyncCount() ?? 0;
    final failedCount = await _database.syncQueueDao.getFailedSyncCount(_maxRetries) ?? 0;
    final online = await isOnline();
    
    return SyncStatus(
      isPending: pendingCount > 0,
      pendingCount: pendingCount,
      failedCount: failedCount,
      isOnline: online,
      isSyncing: _isSyncing,
      lastSyncAttempt: DateTime.now(), // TODO: Store last sync time
    );
  }
  
  /// Queue a drink for sync
  Future<void> queueDrinkSync(String drinkId, String operation, [Map<String, dynamic>? payload]) async {
    final syncItem = SyncQueueEntity(
      id: _uuid.v4(),
      entityType: 'drink',
      entityId: drinkId,
      operation: operation,
      payload: payload != null ? jsonEncode(payload) : null,
      createdAt: DateTime.now(),
    );
    
    await _database.syncQueueDao.insertSyncItem(syncItem);
    if (kDebugMode) {
      debugPrint('📝 SyncService: Queued drink sync - $operation for $drinkId');
    }
    
    // Try immediate sync if online
    if (await isOnline()) {
      _triggerSync();
    }
  }
  
  /// Queue a rating for sync
  Future<void> queueRatingSync(String ratingId, String operation, [Map<String, dynamic>? payload]) async {
    final syncItem = SyncQueueEntity(
      id: _uuid.v4(),
      entityType: 'rating',
      entityId: ratingId,
      operation: operation,
      payload: payload != null ? jsonEncode(payload) : null,
      createdAt: DateTime.now(),
    );
    
    await _database.syncQueueDao.insertSyncItem(syncItem);
    if (kDebugMode) {
      debugPrint('📝 SyncService: Queued rating sync - $operation for $ratingId');
    }
    
    // Try immediate sync if online
    if (await isOnline()) {
      _triggerSync();
    }
  }
  
  /// Perform the actual sync operation
  Future<void> _performSync() async {
    if (!await isOnline()) {
      if (kDebugMode) {
        debugPrint('🔄 SyncService: Offline, skipping sync');
      }
      return;
    }
    
    if (kDebugMode) {
      debugPrint('🔄 SyncService: Starting sync...');
    }
    
    try {
      // Get pending sync items
      final pendingSyncs = await _database.syncQueueDao.getRetryableSyncs(_maxRetries, 50);
      
      if (pendingSyncs.isEmpty) {
        if (kDebugMode) {
          debugPrint('🔄 SyncService: No pending syncs');
        }
        return;
      }
      
      if (kDebugMode) {
        debugPrint('🔄 SyncService: Processing ${pendingSyncs.length} pending syncs');
      }
      
      // Process each sync item
      for (final syncItem in pendingSyncs) {
        await _processSyncItem(syncItem);
      }
      
      if (kDebugMode) {
        debugPrint('🔄 SyncService: Sync completed successfully');
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ SyncService: Sync failed: $e');
      }
      rethrow;
    }
  }
  
  /// Process an individual sync item
  Future<void> _processSyncItem(SyncQueueEntity syncItem) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 SyncService: Processing ${syncItem.entityType}:${syncItem.operation} for ${syncItem.entityId}');
      }
      
      bool success = false;
      
      switch (syncItem.entityType) {
        case 'drink':
          success = await _processDrinkSync(syncItem);
          break;
        case 'rating':
          success = await _processRatingSync(syncItem);
          break;
        default:
          if (kDebugMode) {
            debugPrint('❌ SyncService: Unknown entity type: ${syncItem.entityType}');
          }
          success = false;
      }
      
      if (success) {
        // Remove successful sync from queue
        await _database.syncQueueDao.deleteSyncItem(syncItem);
        if (kDebugMode) {
          debugPrint('✅ SyncService: Successfully synced ${syncItem.entityType}:${syncItem.entityId}');
        }
      } else {
        // Increment retry count
        await _database.syncQueueDao.incrementRetryCount(
          syncItem.id, 
          DateTime.now(), 
          'Sync failed'
        );
        if (kDebugMode) {
          debugPrint('⚠️ SyncService: Failed to sync ${syncItem.entityType}:${syncItem.entityId}, retry count: ${syncItem.retryCount + 1}');
        }
      }
      
    } catch (e) {
      // Increment retry count with error message
      await _database.syncQueueDao.incrementRetryCount(
        syncItem.id, 
        DateTime.now(), 
        e.toString()
      );
      if (kDebugMode) {
        debugPrint('❌ SyncService: Error processing sync ${syncItem.entityType}:${syncItem.entityId}: $e');
      }
    }
  }
  
  /// Process drink sync operations
  Future<bool> _processDrinkSync(SyncQueueEntity syncItem) async {
    try {
      switch (syncItem.operation) {
        case 'create':
        case 'update':
          final drinkEntity = await _database.drinkDao.getDrinkById(syncItem.entityId);
          if (drinkEntity == null) {
            if (kDebugMode) {
              debugPrint('⚠️ SyncService: Drink ${syncItem.entityId} not found in local database');
            }
            return false;
          }
          
          final drink = drinkEntity.toDomain();
          
          if (syncItem.operation == 'create') {
            await _drinksRepository.createDrink(drink);
          } else {
            await _drinksRepository.updateDrink(drink);
          }
          
          // Mark as synced in local database
          await _database.drinkDao.markDrinkSynced(syncItem.entityId, DateTime.now());
          return true;
          
        case 'delete':
          await _drinksRepository.deleteDrink(syncItem.entityId);
          return true;
          
        default:
          if (kDebugMode) {
            debugPrint('❌ SyncService: Unknown drink operation: ${syncItem.operation}');
          }
          return false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ SyncService: Error syncing drink ${syncItem.entityId}: $e');
      }
      return false;
    }
  }
  
  /// Process rating sync operations
  Future<bool> _processRatingSync(SyncQueueEntity syncItem) async {
    try {
      switch (syncItem.operation) {
        case 'create':
        case 'update':
          final ratingEntity = await _database.ratingDao.getRatingById(syncItem.entityId);
          if (ratingEntity == null) {
            if (kDebugMode) {
              debugPrint('⚠️ SyncService: Rating ${syncItem.entityId} not found in local database');
            }
            return false;
          }
          
          final rating = ratingEntity.toDomain();
          
          if (syncItem.operation == 'create') {
            await _ratingsRepository.createRating(rating);
          } else {
            await _ratingsRepository.updateRating(rating);
          }
          
          // Mark as synced in local database
          await _database.ratingDao.markRatingSynced(syncItem.entityId, DateTime.now());
          return true;
          
        case 'delete':
          await _ratingsRepository.deleteRating(syncItem.entityId);
          return true;
          
        default:
          if (kDebugMode) {
            debugPrint('❌ SyncService: Unknown rating operation: ${syncItem.operation}');
          }
          return false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ SyncService: Error syncing rating ${syncItem.entityId}: $e');
      }
      return false;
    }
  }
  
  /// Cleanup old and failed sync items
  Future<void> cleanup() async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    
    // Remove failed syncs older than a week
    await _database.syncQueueDao.cleanupFailedSyncs(_maxRetries, weekAgo);
    
    // Remove old synced items from local storage
    await _database.drinkDao.cleanupDeletedDrinks(weekAgo);
    await _database.ratingDao.cleanupDeletedRatings(weekAgo);
    
    if (kDebugMode) {
      debugPrint('🧹 SyncService: Cleanup completed');
    }
  }
}

/// Sync status information
class SyncStatus {
  final bool isPending;
  final int pendingCount;
  final int failedCount;
  final bool isOnline;
  final bool isSyncing;
  final DateTime lastSyncAttempt;
  
  const SyncStatus({
    required this.isPending,
    required this.pendingCount,
    required this.failedCount,
    required this.isOnline,
    required this.isSyncing,
    required this.lastSyncAttempt,
  });
  
  @override
  String toString() {
    return 'SyncStatus(pending: $pendingCount, failed: $failedCount, online: $isOnline, syncing: $isSyncing)';
  }
}