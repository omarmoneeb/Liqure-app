import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/pocketbase_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/cabinet_item.dart';
import '../../domain/entities/cabinet_stats.dart';
import '../../domain/repositories/cabinet_repository.dart';
import '../../data/repositories/cabinet_repository_impl.dart';

// Repository provider
final cabinetRepositoryProvider = Provider<CabinetRepository>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  return CabinetRepositoryImpl(pocketBaseClient);
});

// Cabinet items provider
final cabinetItemsProvider = FutureProvider.autoDispose<List<CabinetItem>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getCabinetItems(authState.user!.id);
});

// Cabinet items by status
final cabinetItemsByStatusProvider = FutureProvider.autoDispose
    .family<List<CabinetItem>, CabinetStatus>((ref, status) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getCabinetItemsByStatus(authState.user!.id, status);
});

// Available items (currently have and can drink)
final availableCabinetItemsProvider = FutureProvider.autoDispose<List<CabinetItem>>((ref) async {
  final items = await ref.watch(cabinetItemsProvider.future);
  return items.where((item) => item.isAvailable).toList();
});

// Wishlist items
final wishlistItemsProvider = FutureProvider.autoDispose<List<CabinetItem>>((ref) async {
  final items = await ref.watch(cabinetItemsProvider.future);
  return items.where((item) => item.isWishlist).toList();
});

// Empty/finished items
final emptyItemsProvider = FutureProvider.autoDispose<List<CabinetItem>>((ref) async {
  final items = await ref.watch(cabinetItemsProvider.future);
  return items.where((item) => item.isEmpty).toList();
});

// Low fill level items (need attention)
final lowFillLevelItemsProvider = FutureProvider.autoDispose<List<CabinetItem>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getLowFillLevelItems(authState.user!.id, threshold: 25);
});

// Recently added items
final recentlyAddedItemsProvider = FutureProvider.autoDispose<List<CabinetItem>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getRecentlyAdded(authState.user!.id, limit: 5);
});

// Cabinet stats provider
final cabinetStatsProvider = FutureProvider.autoDispose<CabinetStats>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return const CabinetStats();
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getCabinetStats(authState.user!.id);
});

// Cabinet items grouped by location
final cabinetItemsByLocationProvider = FutureProvider.autoDispose
    .family<List<CabinetItem>, StorageLocation>((ref, location) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getCabinetItemsByLocation(authState.user!.id, location);
});

// All cabinet locations with items
final cabinetLocationsProvider = FutureProvider.autoDispose<Map<StorageLocation, List<CabinetItem>>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return {};
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getCabinetItemsByLocationGrouped(authState.user!.id);
});

// User tags provider
final userTagsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getUserTags(authState.user!.id);
});

// Cabinet item by drink ID
final cabinetItemByDrinkProvider = FutureProvider.autoDispose
    .family<CabinetItem?, String>((ref, drinkId) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.user == null) {
    return null;
  }
  
  final repository = ref.watch(cabinetRepositoryProvider);
  return repository.getCabinetItemByDrink(authState.user!.id, drinkId);
});

// Mutations/Actions
class CabinetNotifier extends StateNotifier<AsyncValue<void>> {
  CabinetNotifier(this._repository) : super(const AsyncValue.data(null));
  
  final CabinetRepository _repository;
  
  Future<void> addToCabinet(CabinetItem item) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addToCabinet(item);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateItem(CabinetItem item) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateCabinetItem(item);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> removeItem(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeCabinetItem(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> markAsOpened(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAsOpened(id, DateTime.now());
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateFillLevel(String id, int fillLevel) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateFillLevel(id, fillLevel);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> markAsFinished(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAsFinished(id, DateTime.now());
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> moveToWishlist(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.moveToWishlist(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> moveFromWishlist(String id, {
    DateTime? purchaseDate,
    double? purchasePrice,
    String? purchaseStore,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.moveFromWishlist(
        id,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice,
        purchaseStore: purchaseStore,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateLocation(String id, StorageLocation location, {String? customLocation}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateLocation(id, location, customLocation: customLocation);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> addTags(String id, List<String> tags) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addTags(id, tags);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final cabinetNotifierProvider = StateNotifierProvider<CabinetNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(cabinetRepositoryProvider);
  return CabinetNotifier(repository);
});

// Helper to refresh cabinet data after mutations
void refreshCabinetData(WidgetRef ref) {
  ref.invalidate(cabinetItemsProvider);
  ref.invalidate(cabinetStatsProvider);
  ref.invalidate(availableCabinetItemsProvider);
  ref.invalidate(wishlistItemsProvider);
  ref.invalidate(emptyItemsProvider);
  ref.invalidate(lowFillLevelItemsProvider);
  ref.invalidate(recentlyAddedItemsProvider);
  ref.invalidate(cabinetLocationsProvider);
  ref.invalidate(userTagsProvider);
}