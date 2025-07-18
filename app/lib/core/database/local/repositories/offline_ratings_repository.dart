import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../../../../features/tasting/domain/entities/rating.dart';
import '../../../../features/tasting/domain/repositories/ratings_repository.dart';
import '../app_database.dart';
import '../mappers/rating_mapper.dart';
import '../../sync/sync_service.dart';

/// Offline-capable ratings repository that combines local and remote data
class OfflineRatingsRepository implements RatingsRepository {
  final AppDatabase _database;
  final RatingsRepository _remoteRepository;
  final SyncService _syncService;
  final Connectivity _connectivity;
  
  OfflineRatingsRepository({
    required AppDatabase database,
    required RatingsRepository remoteRepository,
    required SyncService syncService,
    required Connectivity connectivity,
  }) : _database = database,
       _remoteRepository = remoteRepository,
       _syncService = syncService,
       _connectivity = connectivity;
  
  /// Check if device is online
  Future<bool> get _isOnline async {
    final connectivity = await _connectivity.checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }
  
  @override
  Future<List<Rating>> getUserRatings(String userId, {
    int? page,
    int? perPage,
  }) async {
    try {
      // Get from local cache
      final localRatings = await _database.ratingDao.getRatingsByUserId(userId);
      
      // Apply pagination
      final startIndex = page != null ? (page - 1) * (perPage ?? 50) : 0;
      final endIndex = startIndex + (perPage ?? 50);
      final paginatedLocal = localRatings.skip(startIndex).take(endIndex - startIndex).toList();
      
      // If online, try to sync latest data
      if (await _isOnline) {
        try {
          final remoteRatings = await _remoteRepository.getUserRatings(userId, page: page, perPage: perPage);
          
          // Update local cache with remote data
          await _updateLocalCache(remoteRatings);
          
          // Return fresh local data
          final updatedLocal = await _database.ratingDao.getRatingsByUserId(userId);
          final paginatedUpdated = updatedLocal.skip(startIndex).take(endIndex - startIndex).toList();
          return paginatedUpdated.map((e) => e.toDomain()).toList();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote fetch failed, using local data: $e');
          }
        }
      }
      
      return paginatedLocal.map((e) => e.toDomain()).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting user ratings: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<List<Rating>> getDrinkRatings(String drinkId) async {
    try {
      // Get from local cache
      final localRatings = await _database.ratingDao.getRatingsByDrinkId(drinkId);
      
      // If online, try to get latest from remote
      if (await _isOnline) {
        try {
          final remoteRatings = await _remoteRepository.getDrinkRatings(drinkId);
          
          // Update local cache
          for (final rating in remoteRatings) {
            final existing = await _database.ratingDao.getRatingById(rating.id);
            if (existing == null) {
              await _database.ratingDao.insertRating(rating.toEntity(
                lastSyncedAt: DateTime.now(),
              ));
            } else if (!existing.needsSync) {
              await _database.ratingDao.updateRating(rating.toEntity(
                lastSyncedAt: DateTime.now(),
              ));
            }
          }
          
          // Return updated local data
          final updatedLocal = await _database.ratingDao.getRatingsByDrinkId(drinkId);
          return updatedLocal.map((e) => e.toDomain()).toList();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote fetch failed for drink $drinkId: $e');
          }
        }
      }
      
      return localRatings.map((e) => e.toDomain()).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting ratings for drink $drinkId: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Rating?> getRatingById(String id) async {
    try {
      // Check local first
      final localRating = await _database.ratingDao.getRatingById(id);
      if (localRating != null) {
        return localRating.toDomain();
      }
      
      // If not found locally and online, try remote
      if (await _isOnline) {
        try {
          final remoteRating = await _remoteRepository.getRatingById(id);
          if (remoteRating != null) {
            // Cache locally
            await _database.ratingDao.insertRating(remoteRating.toEntity(
              lastSyncedAt: DateTime.now(),
            ));
            return remoteRating;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote fetch failed for rating $id: $e');
          }
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting rating $id: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Rating?> getUserDrinkRating(String userId, String drinkId) async {
    try {
      // Check local first
      final localRating = await _database.ratingDao.getUserRatingForDrink(drinkId, userId);
      if (localRating != null) {
        return localRating.toDomain();
      }
      
      // If not found locally and online, try remote
      if (await _isOnline) {
        try {
          final remoteRating = await _remoteRepository.getUserDrinkRating(userId, drinkId);
          if (remoteRating != null) {
            // Cache locally
            await _database.ratingDao.insertRating(remoteRating.toEntity(
              lastSyncedAt: DateTime.now(),
            ));
            return remoteRating;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote fetch failed for user rating: $e');
          }
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting user rating: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Rating> createRating(Rating rating) async {
    try {
      // Save locally first
      final ratingEntity = rating.toEntity(needsSync: true);
      await _database.ratingDao.insertRating(ratingEntity);
      
      // Queue for sync
      await _syncService.queueRatingSync(rating.id, 'create');
      
      if (kDebugMode) {
        debugPrint('📝 OfflineRatingsRepository: Created rating ${rating.id} locally, queued for sync');
      }
      return rating;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error creating rating: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Rating> updateRating(Rating rating) async {
    try {
      // Update locally first
      final ratingEntity = rating.toEntity(
        needsSync: true,
        lastSyncedAt: null, // Reset sync status
      );
      await _database.ratingDao.updateRating(ratingEntity);
      
      // Queue for sync
      await _syncService.queueRatingSync(rating.id, 'update');
      
      if (kDebugMode) {
        debugPrint('📝 OfflineRatingsRepository: Updated rating ${rating.id} locally, queued for sync');
      }
      return rating;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error updating rating: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<void> deleteRating(String id) async {
    try {
      // Soft delete locally
      await _database.ratingDao.softDeleteRating(id, DateTime.now());
      
      // Queue for sync
      await _syncService.queueRatingSync(id, 'delete');
      
      if (kDebugMode) {
        debugPrint('📝 OfflineRatingsRepository: Deleted rating $id locally, queued for sync');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error deleting rating: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<double?> getDrinkAverageRating(String drinkId) async {
    try {
      // Use local data for analytics (faster)
      final averageRating = await _database.ratingDao.getAverageRatingForDrink(drinkId);
      
      // If online and no local data, try remote
      if (averageRating == null && await _isOnline) {
        try {
          final remoteAverage = await _remoteRepository.getDrinkAverageRating(drinkId);
          return remoteAverage;
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote average rating fetch failed: $e');
          }
          return null;
        }
      }
      
      return averageRating;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting average rating: $e');
      }
      return null; // Return null instead of rethrowing to prevent crashes
    }
  }
  
  @override
  Future<List<Rating>> getRecentRatings(String userId, {int limit = 10}) async {
    try {
      final localRatings = await _database.ratingDao.getRecentRatingsByUser(userId, limit);
      
      // If online, try to get latest from remote
      if (await _isOnline) {
        try {
          final remoteRatings = await _remoteRepository.getRecentRatings(userId, limit: limit);
          await _updateLocalCache(remoteRatings);
          
          final updatedLocal = await _database.ratingDao.getRecentRatingsByUser(userId, limit);
          return updatedLocal.map((e) => e.toDomain()).toList();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote recent ratings fetch failed: $e');
          }
        }
      }
      
      return localRatings.map((e) => e.toDomain()).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting recent ratings: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Map<String, dynamic>> getUserRatingStats(String userId) async {
    return getUserAggregateStats(userId);
  }
  
  @override
  Future<Map<String, dynamic>> getUserAggregateStats(String userId) async {
    try {
      // Calculate from local data
      final totalRatings = await _database.ratingDao.getUserRatingCount(userId) ?? 0;
      final averageRating = await _database.ratingDao.getUserAverageRating(userId) ?? 0.0;
      final minRating = await _database.ratingDao.getUserMinRating(userId) ?? 0.0;
      final maxRating = await _database.ratingDao.getUserMaxRating(userId) ?? 0.0;
      
      // If online and no local data, try remote
      if (totalRatings == 0 && await _isOnline) {
        try {
          final remoteStats = await _remoteRepository.getUserAggregateStats(userId);
          return remoteStats;
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote stats fetch failed: $e');
          }
        }
      }
      
      return {
        'totalRatings': totalRatings,
        'averageRating': averageRating,
        'minRating': minRating,
        'maxRating': maxRating,
        'offline': totalRatings > 0 && !await _isOnline,
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting user stats: $e');
      }
      // Return safe defaults instead of rethrowing
      return {
        'totalRatings': 0,
        'averageRating': 0.0,
        'minRating': 0.0,
        'maxRating': 0.0,
        'offline': false,
      };
    }
  }
  
  @override
  Future<Map<String, Map<String, dynamic>>> getBatchDrinkStats(List<String> drinkIds) async {
    try {
      final stats = <String, Map<String, dynamic>>{};
      
      for (final drinkId in drinkIds) {
        final avgRating = await _database.ratingDao.getAverageRatingForDrink(drinkId);
        final ratingCount = await _database.ratingDao.getDrinkRatingCount(drinkId) ?? 0;
        
        stats[drinkId] = {
          'averageRating': avgRating ?? 0.0,
          'totalRatings': ratingCount,
        };
      }
      
      // If online, try to get remote stats for missing data
      if (await _isOnline && stats.values.any((stat) => stat['totalRatings'] == 0)) {
        try {
          final remoteStats = await _remoteRepository.getBatchDrinkStats(drinkIds);
          remoteStats.forEach((drinkId, remoteStat) {
            if (stats[drinkId]?['totalRatings'] == 0) {
              stats[drinkId] = remoteStat;
            }
          });
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote batch stats fetch failed: $e');
          }
        }
      }
      
      return stats;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting batch drink stats: $e');
      }
      // Return safe defaults instead of rethrowing
      final safeStats = <String, Map<String, dynamic>>{};
      for (final drinkId in drinkIds) {
        safeStats[drinkId] = {
          'averageRating': 0.0,
          'totalRatings': 0,
        };
      }
      return safeStats;
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getRatingsWithDrinkDetails(String userId, {
    int? limit,
    String? orderBy,
  }) async {
    try {
      // Get ratings from local database
      final ratings = await _database.ratingDao.getRecentRatingsByUser(userId, limit ?? 50);
      
      // Map to result format with drink details
      final results = <Map<String, dynamic>>[];
      for (final rating in ratings) {
        // Get drink details
        final drink = await _database.drinkDao.getDrinkById(rating.drinkId);
        if (drink != null) {
          results.add({
            'id': rating.id,
            'drinkId': rating.drinkId,
            'userId': rating.userId,
            'overall': rating.overall,
            'notes': rating.notes,
            'createdAt': rating.createdAt.toIso8601String(),
            'drinkName': drink.name,
            'drinkType': drink.type,
            'drinkBrand': drink.distillery ?? '',
          });
        }
      }
      
      // If online and no local data, try remote
      if (results.isEmpty && await _isOnline) {
        try {
          return await _remoteRepository.getRatingsWithDrinkDetails(userId, limit: limit, orderBy: orderBy);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote ratings with details fetch failed: $e');
          }
        }
      }
      
      return results;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting ratings with drink details: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getRatingTimeSeries(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
  }) async {
    try {
      // For offline mode, return simple time series from local data
      final ratings = await _database.ratingDao.getRatingsByUserId(userId);
      
      final filteredRatings = ratings.where((rating) {
        if (startDate != null && rating.createdAt.isBefore(startDate)) return false;
        if (endDate != null && rating.createdAt.isAfter(endDate)) return false;
        return true;
      }).toList();
      
      // Group by date (simplified for offline)
      final Map<String, List<dynamic>> grouped = {};
      for (final rating in filteredRatings) {
        final key = rating.createdAt.toIso8601String().split('T')[0]; // Group by day
        grouped.putIfAbsent(key, () => []).add(rating);
      }
      
      final timeSeries = grouped.entries.map((entry) => {
        'date': entry.key,
        'count': entry.value.length,
        'averageRating': entry.value.map((r) => r.overall).reduce((a, b) => a + b) / entry.value.length,
      }).toList();
      
      // If online, try to get better data from remote
      if (await _isOnline) {
        try {
          return await _remoteRepository.getRatingTimeSeries(userId, 
            startDate: startDate, 
            endDate: endDate, 
            groupBy: groupBy
          );
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote time series fetch failed: $e');
          }
        }
      }
      
      return timeSeries;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting rating time series: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<Map<String, dynamic>> getRatingAnalytics(String userId) async {
    try {
      // Calculate analytics from local data
      final totalRatings = await _database.ratingDao.getUserRatingCount(userId) ?? 0;
      final avgRating = await _database.ratingDao.getUserAverageRating(userId) ?? 0.0;
      final ratings = await _database.ratingDao.getRatingsByUserId(userId);
      
      // Calculate rating distribution with null safety
      final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final rating in ratings) {
        try {
          final score = rating.overall.round().clamp(1, 5);
          distribution[score] = (distribution[score] ?? 0) + 1;
        } catch (e) {
          // Skip ratings with invalid overall scores
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Skipping rating with invalid overall score: $e');
          }
        }
      }
      
      final analytics = {
        'totalRatings': totalRatings,
        'averageRating': avgRating,
        'distribution': distribution,
        'offline': true,
      };
      
      // If online, try to get better analytics from remote
      if (await _isOnline) {
        try {
          return await _remoteRepository.getRatingAnalytics(userId);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ OfflineRatingsRepository: Remote analytics fetch failed: $e');
          }
        }
      }
      
      return analytics;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ OfflineRatingsRepository: Error getting rating analytics: $e');
      }
      // Return safe defaults instead of rethrowing
      return {
        'totalRatings': 0,
        'averageRating': 0.0,
        'distribution': <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        'offline': true,
      };
    }
  }
  
  /// Update local cache with remote data
  Future<void> _updateLocalCache(List<Rating> remoteRatings) async {
    for (final rating in remoteRatings) {
      try {
        // Check if rating exists locally
        final existing = await _database.ratingDao.getRatingById(rating.id);
        
        if (existing == null) {
          // Insert new rating
          await _database.ratingDao.insertRating(rating.toEntity(
            lastSyncedAt: DateTime.now(),
          ));
        } else if (!existing.needsSync) {
          // Update only if local version doesn't need sync (avoid conflicts)
          await _database.ratingDao.updateRating(rating.toEntity(
            lastSyncedAt: DateTime.now(),
          ));
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ OfflineRatingsRepository: Error updating local cache for rating ${rating.id}: $e');
        }
      }
    }
  }
}