import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../../../../features/tasting/domain/entities/drink.dart';
import '../../../../features/tasting/domain/repositories/drinks_repository.dart';
import '../app_database.dart';
import '../entities/drink_entity.dart';
import '../mappers/drink_mapper.dart';
import '../../sync/sync_service.dart';

/// Offline-capable drinks repository that combines local and remote data
class OfflineDrinksRepository implements DrinksRepository {
  final AppDatabase _database;
  final DrinksRepository _remoteRepository;
  final SyncService _syncService;
  final Connectivity _connectivity;
  
  OfflineDrinksRepository({
    required AppDatabase database,
    required DrinksRepository remoteRepository,
    required SyncService syncService,
    required Connectivity connectivity,
  }) : _database = database,
       _remoteRepository = remoteRepository,
       _syncService = syncService,
       _connectivity = connectivity;
  
  /// Check if device is online
  Future<bool> get _isOnline async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  @override
  Future<List<Drink>> getDrinks({
    String? search,
    DrinkType? type,
    int? page,
    int? perPage,
  }) async {
    try {
      // Try local first
      final localDrinks = await _getLocalDrinks(
        search: search,
        type: type,
        limit: perPage,
        offset: page != null ? (page - 1) * (perPage ?? 50) : 0,
      );
      
      // If online, try to sync latest data
      if (await _isOnline) {
        try {
          final remoteDrinks = await _remoteRepository.getDrinks(
            search: search,
            type: type,
            page: page,
            perPage: perPage,
          );
          
          // Update local cache with remote data
          await _updateLocalCache(remoteDrinks);
          
          // Return fresh local data
          return await _getLocalDrinks(
            search: search,
            type: type,
            limit: perPage,
            offset: page != null ? (page - 1) * (perPage ?? 50) : 0,
          );
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineDrinksRepository: Remote fetch failed, using local data: $e');
          }
        }
      }
      
      return localDrinks;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineDrinksRepository: Error getting drinks: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<List<Drink>> getDrinksWithFilter(dynamic filter) async {
    // TODO: Implement proper filtering based on DrinksFilter
    // For now, delegate to basic getDrinks
    return getDrinks();
  }
  
  @override
  Future<Drink?> getDrinkById(String id) async {
    try {
      // Check local first
      final localDrink = await _database.drinkDao.getDrinkById(id);
      if (localDrink != null) {
        return localDrink.toDomain();
      }
      
      // If not found locally and online, try remote
      if (await _isOnline) {
        try {
          final remoteDrink = await _remoteRepository.getDrinkById(id);
          if (remoteDrink != null) {
            // Cache locally
            await _database.drinkDao.insertDrink(remoteDrink.toEntity(
              lastSyncedAt: DateTime.now(),
            ));
            return remoteDrink;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineDrinksRepository: Remote fetch failed for drink $id: $e');
          }
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineDrinksRepository: Error getting drink $id: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Drink?> getDrinkByBarcode(String barcode) async {
    try {
      // Check local first
      final localDrink = await _database.drinkDao.getDrinkByBarcode(barcode);
      if (localDrink != null) {
        return localDrink.toDomain();
      }
      
      // If not found locally and online, try remote
      if (await _isOnline) {
        try {
          final remoteDrink = await _remoteRepository.getDrinkByBarcode(barcode);
          if (remoteDrink != null) {
            // Cache locally
            await _database.drinkDao.insertDrink(remoteDrink.toEntity(
              lastSyncedAt: DateTime.now(),
            ));
            return remoteDrink;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineDrinksRepository: Remote fetch failed for barcode $barcode: $e');
          }
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineDrinksRepository: Error getting drink by barcode $barcode: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Drink> createDrink(Drink drink) async {
    try {
      // Save locally first
      final drinkEntity = drink.toEntity(needsSync: true);
      await _database.drinkDao.insertDrink(drinkEntity);
      
      // Queue for sync
      await _syncService.queueDrinkSync(drink.id, 'create');
      
      if (kDebugMode) {
        debugPrint('📝 OfflineDrinksRepository: Created drink ${drink.id} locally, queued for sync');
      }
      return drink;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineDrinksRepository: Error creating drink: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Drink> updateDrink(Drink drink) async {
    try {
      // Update locally first
      final drinkEntity = drink.toEntity(
        needsSync: true,
        lastSyncedAt: null, // Reset sync status
      );
      await _database.drinkDao.updateDrink(drinkEntity);
      
      // Queue for sync
      await _syncService.queueDrinkSync(drink.id, 'update');
      
      if (kDebugMode) {
        debugPrint('📝 OfflineDrinksRepository: Updated drink ${drink.id} locally, queued for sync');
      }
      return drink;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineDrinksRepository: Error updating drink: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<void> deleteDrink(String id) async {
    try {
      // Soft delete locally
      await _database.drinkDao.softDeleteDrink(id, DateTime.now());
      
      // Queue for sync
      await _syncService.queueDrinkSync(id, 'delete');
      
      if (kDebugMode) {
        debugPrint('📝 OfflineDrinksRepository: Deleted drink $id locally, queued for sync');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineDrinksRepository: Error deleting drink: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<List<Drink>> getPopularDrinks({int limit = 10}) async {
    // For now, return recent drinks from local cache
    // TODO: Implement proper popularity ranking
    final entities = await _database.drinkDao.getDrinksWithLimit(limit, 0);
    return entities.map((e) => e.toDomain()).toList();
  }
  
  @override
  Future<List<Drink>> getRecentDrinks({int limit = 10}) async {
    final entities = await _database.drinkDao.getDrinksWithLimit(limit, 0);
    return entities.map((e) => e.toDomain()).toList();
  }
  
  @override
  Future<Map<String, Drink>> getBatchDrinks(List<String> ids) async {
    final result = <String, Drink>{};
    
    // Get from local cache
    for (final id in ids) {
      final entity = await _database.drinkDao.getDrinkById(id);
      if (entity != null) {
        result[id] = entity.toDomain();
      }
    }
    
    // If some not found and online, try remote
    final missingIds = ids.where((id) => !result.containsKey(id)).toList();
    if (missingIds.isNotEmpty && await _isOnline) {
      try {
        final remoteDrinks = await _remoteRepository.getBatchDrinks(missingIds);
        
        // Cache remote drinks locally
        for (final entry in remoteDrinks.entries) {
          await _database.drinkDao.insertDrink(entry.value.toEntity(
            lastSyncedAt: DateTime.now(),
          ));
          result[entry.key] = entry.value;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ OfflineDrinksRepository: Remote batch fetch failed: $e');
        }
      }
    }
    
    return result;
  }
  
  @override
  Future<List<Map<String, dynamic>>> getDrinksWithStats({
    List<String>? drinkIds,
    String? userId,
    DrinkType? type,
    int? limit,
  }) async {
    // TODO: Implement offline stats calculation
    if (await _isOnline) {
      try {
        return await _remoteRepository.getDrinksWithStats(
          drinkIds: drinkIds,
          userId: userId,
          type: type,
          limit: limit,
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ OfflineDrinksRepository: Remote stats fetch failed: $e');
        }
      }
    }
    
    // Fallback to basic drink list
    final drinks = await getDrinks(type: type);
    return drinks.take(limit ?? 50).map((drink) => {
      'id': drink.id,
      'name': drink.name,
      'type': drink.type.name,
      'abv': drink.abv,
      'country': drink.country,
    }).toList();
  }
  
  @override
  Future<Map<String, dynamic>> getDrinkAggregateStats({
    List<String>? drinkIds,
    String? userId,
    dynamic dateRange,
  }) async {
    // TODO: Implement offline aggregate stats
    if (await _isOnline) {
      try {
        return await _remoteRepository.getDrinkAggregateStats(
          drinkIds: drinkIds,
          userId: userId,
          dateRange: dateRange,
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ OfflineDrinksRepository: Remote aggregate stats fetch failed: $e');
        }
      }
    }
    
    // Fallback stats
    final totalDrinks = await _database.drinkDao.getDrinksCount() ?? 0;
    return {
      'totalDrinks': totalDrinks,
      'offline': true,
    };
  }
  
  /// Get drinks from local database
  Future<List<Drink>> _getLocalDrinks({
    String? search,
    DrinkType? type,
    int? limit,
    int? offset,
  }) async {
    late final List<DrinkEntity> entities;
    
    if (search != null && search.isNotEmpty) {
      entities = await _database.drinkDao.searchDrinks('%$search%');
    } else if (type != null) {
      entities = await _database.drinkDao.getDrinksByType(type.name);
    } else {
      entities = await _database.drinkDao.getDrinksWithLimit(
        limit ?? 50,
        offset ?? 0,
      );
    }
    
    return entities.map((e) => e.toDomain()).toList();
  }
  
  /// Update local cache with remote data
  Future<void> _updateLocalCache(List<Drink> remoteDrinks) async {
    for (final drink in remoteDrinks) {
      try {
        // Check if drink exists locally
        final existing = await _database.drinkDao.getDrinkById(drink.id);
        
        if (existing == null) {
          // Insert new drink
          await _database.drinkDao.insertDrink(drink.toEntity(
            lastSyncedAt: DateTime.now(),
          ));
        } else if (!existing.needsSync) {
          // Update only if local version doesn't need sync (avoid conflicts)
          await _database.drinkDao.updateDrink(drink.toEntity(
            lastSyncedAt: DateTime.now(),
          ));
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ OfflineDrinksRepository: Error updating local cache for drink ${drink.id}: $e');
        }
      }
    }
  }
}