import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../local/app_database.dart';
import '../sync/sync_service.dart';
import '../local/repositories/offline_drinks_repository.dart';
import '../local/repositories/offline_ratings_repository.dart';
import '../../../features/tasting/domain/repositories/drinks_repository.dart';
import '../../../features/tasting/domain/repositories/ratings_repository.dart';
import '../../../features/tasting/data/repositories/drinks_repository_impl.dart';
import '../../../features/tasting/data/repositories/ratings_repository_impl.dart';
import '../../../core/network/pocketbase_client.dart';

/// Provider for the Floor database instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('AppDatabase must be initialized in main()');
});

/// Provider for connectivity service
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider for the remote drinks repository (PocketBase)
final remoteDrinksRepositoryProvider = Provider<DrinksRepository>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  return DrinksRepositoryImpl(pocketBaseClient);
});

/// Provider for the remote ratings repository (PocketBase)
final remoteRatingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  return RatingsRepositoryImpl(pocketBaseClient);
});

/// Provider for the sync service
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final remoteDrinksRepo = ref.watch(remoteDrinksRepositoryProvider);
  final remoteRatingsRepo = ref.watch(remoteRatingsRepositoryProvider);
  final connectivity = ref.watch(connectivityProvider);
  
  return SyncService(
    database: database,
    drinksRepository: remoteDrinksRepo,
    ratingsRepository: remoteRatingsRepo,
    connectivity: connectivity,
  );
});

/// Provider for the offline-capable drinks repository
final offlineDrinksRepositoryProvider = Provider<DrinksRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final remoteRepo = ref.watch(remoteDrinksRepositoryProvider);
  final syncService = ref.watch(syncServiceProvider);
  return OfflineDrinksRepository(
    database: database,
    remoteRepository: remoteRepo,
    syncService: syncService,
    connectivity: ref.watch(connectivityProvider),
  );
});

/// Provider for the offline-capable ratings repository
final offlineRatingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final remoteRepo = ref.watch(remoteRatingsRepositoryProvider);
  final syncService = ref.watch(syncServiceProvider);
  return OfflineRatingsRepository(
    database: database,
    remoteRepository: remoteRepo,
    syncService: syncService,
    connectivity: ref.watch(connectivityProvider),
  );
});

/// Provider for sync status (temporarily disabled)
// final syncStatusProvider = StreamProvider<SyncStatus>((ref) async* {
//   final syncService = ref.watch(syncServiceProvider);
//   
//   // Emit initial status
//   yield await syncService.getSyncStatus();
//   
//   // Set up periodic status updates
//   await for (final _ in Stream.periodic(const Duration(seconds: 10))) {
//     yield await syncService.getSyncStatus();
//   }
// });

/// Provider for network connectivity status (temporarily disabled)
// final connectivityStatusProvider = StreamProvider<bool>((ref) {
//   final connectivity = ref.watch(connectivityProvider);
//   
//   return connectivity.onConnectivityChanged.map((results) {
//     // connectivity_plus returns List<ConnectivityResult>
//     return !results.contains(ConnectivityResult.none);
//   });
// });

/// Initialize the database and sync service
/// This should be called from main() with a proper database override
Future<AppDatabase> initializeDatabase() async {
  if (kDebugMode) {
    debugPrint('🗄️ DatabaseProviders: Initializing database...');
  }
  
  try {
    // Create database instance
    final database = await AppDatabase.create();
    
    if (kDebugMode) {
      debugPrint('✅ DatabaseProviders: Database initialized');
    }
    return database;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('❌ DatabaseProviders: Failed to initialize database: $e');
    }
    rethrow;
  }
}

/// Initialize sync service - call after database provider is overridden
Future<void> initializeSyncService(WidgetRef ref) async {
  if (kDebugMode) {
    debugPrint('🔄 DatabaseProviders: Initializing sync service...');
  }
  
  try {
    final syncService = ref.read(syncServiceProvider);
    await syncService.initialize();
    
    if (kDebugMode) {
      debugPrint('✅ DatabaseProviders: Sync service initialized');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('❌ DatabaseProviders: Failed to initialize sync service: $e');
    }
    rethrow;
  }
}

/// Cleanup database resources (temporarily disabled)
// Future<void> cleanupDatabase(WidgetRef ref) async {
//   print('🗄️ DatabaseProviders: Cleaning up database...');
//   
//   try {
//     final syncService = ref.read(syncServiceProvider);
//     syncService.dispose();
//     
//     // Note: Floor databases are automatically closed when app terminates
//     print('✅ DatabaseProviders: Database cleanup completed');
//   } catch (e) {
//     print('❌ DatabaseProviders: Error during cleanup: $e');
//   }
// }