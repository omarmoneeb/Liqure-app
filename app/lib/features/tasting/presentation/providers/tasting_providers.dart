import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/drink.dart';
import '../../domain/entities/rating.dart';
import '../../domain/repositories/drinks_repository.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/database/providers/database_providers.dart';

part 'tasting_providers.freezed.dart';
part 'tasting_providers.g.dart';

// Enums for enhanced filtering
enum SortBy {
  name,
  abv,
  rating,
  created,
  country,
}

enum SortDirection {
  ascending,
  descending,
}

enum SearchField {
  name,
  description,
  country,
  barcode,
}

// Repository providers - now using offline-capable repositories
final drinksRepositoryProvider = Provider<DrinksRepository>((ref) {
  return ref.watch(offlineDrinksRepositoryProvider);
});

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  return ref.watch(offlineRatingsRepositoryProvider);
});

// Enhanced drinks provider with rating support
final drinksProvider = FutureProvider.autoDispose.family<List<Drink>, DrinksFilter?>((ref, filter) async {
  final actualFilter = filter ?? const DrinksFilter();
  if (kDebugMode) {
    debugPrint('🎯 Enhanced DrinksProvider: Starting with filter: $actualFilter');
    debugPrint('🎯 Enhanced DrinksProvider: activeFilters=${actualFilter.activeFilterCount}');
  }
  
  // Keep alive for 60 seconds to prevent unnecessary recreations
  ref.keepAlive();
  
  final drinksRepository = ref.watch(drinksRepositoryProvider);
  final ratingsRepository = ref.watch(ratingsRepositoryProvider);
  
  if (kDebugMode) {
    debugPrint('🎯 Enhanced DrinksProvider: Got repositories, calling enhanced getDrinksWithFilter...');
  }
  
  try {
    // Get drinks from repository (without rating filters applied at DB level)
    final drinks = await drinksRepository.getDrinksWithFilter(actualFilter);
    if (kDebugMode) {
      debugPrint('🎯 Enhanced DrinksProvider: Got ${drinks.length} drinks from repository');
    }
    
    // Apply client-side rating filtering if rating filters are active
    if (_hasRatingFilters(actualFilter)) {
      if (kDebugMode) {
        debugPrint('🎯 Enhanced DrinksProvider: Applying client-side rating filters...');
      }
      
      // Get all ratings for these drinks
      final drinkIds = drinks.map((d) => d.id).toList();
      final ratingsMap = await _getDrinkRatingsMap(ratingsRepository, drinkIds);
      
      // Filter drinks based on rating criteria
      final filteredDrinks = _applyRatingFilters(drinks, ratingsMap, actualFilter);
      
      if (kDebugMode) {
        debugPrint('🎯 Enhanced DrinksProvider: After rating filtering: ${filteredDrinks.length} drinks');
      }
      return filteredDrinks;
    }
    
    if (kDebugMode) {
      debugPrint('🎯 Enhanced DrinksProvider: No rating filters, returning ${drinks.length} drinks');
    }
    return drinks;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('❌ Enhanced DrinksProvider: Error getting drinks: $e');
      debugPrint('❌ Enhanced DrinksProvider: Stack trace: $stackTrace');
    }
    rethrow;
  }
});

// Helper function to check if rating filters are active
bool _hasRatingFilters(DrinksFilter filter) {
  return filter.minRating != null || 
         filter.maxRating != null || 
         filter.onlyRated == true || 
         filter.onlyUnrated == true;
}

// Helper function to get ratings for drinks
Future<Map<String, List<Rating>>> _getDrinkRatingsMap(
  RatingsRepository ratingsRepository, 
  List<String> drinkIds
) async {
  final ratingsMap = <String, List<Rating>>{};
  
  // Get ratings for all drinks in batches to avoid too many API calls
  for (final drinkId in drinkIds) {
    try {
      final ratings = await ratingsRepository.getDrinkRatings(drinkId);
      ratingsMap[drinkId] = ratings;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to get ratings for drink $drinkId: $e');
      }
      ratingsMap[drinkId] = [];
    }
  }
  
  return ratingsMap;
}

// Helper function to apply rating filters client-side
List<Drink> _applyRatingFilters(
  List<Drink> drinks, 
  Map<String, List<Rating>> ratingsMap, 
  DrinksFilter filter
) {
  return drinks.where((drink) {
    final ratings = ratingsMap[drink.id] ?? [];
    final hasRatings = ratings.isNotEmpty;
    
    // Calculate average rating if ratings exist
    double? averageRating;
    if (hasRatings) {
      final totalRating = ratings.fold<double>(0, (sum, rating) => sum + rating.rating);
      averageRating = totalRating / ratings.length;
    }
    
    // Apply onlyRated filter
    if (filter.onlyRated == true && !hasRatings) {
      return false;
    }
    
    // Apply onlyUnrated filter
    if (filter.onlyUnrated == true && hasRatings) {
      return false;
    }
    
    // Apply rating range filters
    if (filter.minRating != null || filter.maxRating != null) {
      // If drink has no ratings, exclude it from rating range filters
      if (!hasRatings) {
        return false;
      }
      
      if (filter.minRating != null && averageRating! < filter.minRating!) {
        return false;
      }
      
      if (filter.maxRating != null && averageRating! > filter.maxRating!) {
        return false;
      }
    }
    
    return true;
  }).toList();
}

// Legacy drinks provider for backward compatibility
final legacyDrinksProvider = FutureProvider.autoDispose.family<List<Drink>, DrinksFilter?>((ref, filter) async {
  if (kDebugMode) {
    debugPrint('🎯 Legacy DrinksProvider: Starting with filter: $filter');
    debugPrint('🎯 Legacy DrinksProvider: search=${filter?.search}, type=${filter?.type}');
  }
  
  ref.keepAlive();
  
  final repository = ref.watch(drinksRepositoryProvider);
  
  try {
    final drinks = await repository.getDrinks(
      search: filter?.search,
      type: filter?.type,
      page: filter?.page ?? 1,
      perPage: filter?.perPage ?? 50,
    );
    
    if (kDebugMode) {
      debugPrint('🎯 Legacy DrinksProvider: Successfully got ${drinks.length} drinks from repository');
    }
    return drinks;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('❌ Legacy DrinksProvider: Error getting drinks: $e');
    }
    rethrow;
  }
});

final drinkByIdProvider = FutureProvider.autoDispose.family<Drink?, String>((ref, id) async {
  final repository = ref.watch(drinksRepositoryProvider);
  return repository.getDrinkById(id);
});

final popularDrinksProvider = FutureProvider.autoDispose<List<Drink>>((ref) async {
  final repository = ref.watch(drinksRepositoryProvider);
  return repository.getPopularDrinks(limit: 10);
});

final recentDrinksProvider = FutureProvider.autoDispose<List<Drink>>((ref) async {
  final repository = ref.watch(drinksRepositoryProvider);
  return repository.getRecentDrinks(limit: 10);
});

// Ratings providers
final userRatingsProvider = FutureProvider.autoDispose<List<Rating>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getUserRatings(authState.user!.id);
});

final drinkRatingsProvider = FutureProvider.autoDispose.family<List<Rating>, String>((ref, drinkId) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getDrinkRatings(drinkId);
});

final drinkAverageRatingProvider = FutureProvider.autoDispose.family<double?, String>((ref, drinkId) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getDrinkAverageRating(drinkId);
});

final userDrinkRatingProvider = FutureProvider.autoDispose.family<Rating?, String>((ref, drinkId) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) {
    return null;
  }
  
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getUserDrinkRating(authState.user!.id, drinkId);
});

final recentRatingsProvider = FutureProvider.autoDispose<List<Rating>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) {
    return [];
  }
  
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getRecentRatings(authState.user!.id, limit: 5);
});

final userRatingStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) {
    return {};
  }
  
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getUserRatingStats(authState.user!.id);
});

// Enhanced filter class for drinks
@freezed
class DrinksFilter with _$DrinksFilter {
  const factory DrinksFilter({
    // Text search
    String? search,
    @Default([SearchField.name]) List<SearchField> searchFields,
    
    // Basic filters  
    DrinkType? type,
    List<DrinkType>? types, // Multi-select
    
    // Range filters
    double? minAbv,
    double? maxAbv,
    
    // Location filters
    String? country,
    List<String>? countries,
    
    // Rating filters
    double? minRating,
    double? maxRating,
    bool? onlyRated,
    bool? onlyUnrated,
    
    // Sorting
    @Default(SortBy.created) SortBy sortBy,
    @Default(SortDirection.descending) SortDirection sortDirection,
    
    // Pagination
    @Default(1) int page,
    @Default(50) int perPage,
  }) = _DrinksFilter;
  
  factory DrinksFilter.fromJson(Map<String, dynamic> json) => _$DrinksFilterFromJson(json);
  
  const DrinksFilter._();
  
  // Helper methods for filter state
  bool get hasActiveFilters {
    return search != null && search!.isNotEmpty ||
           type != null ||
           (types != null && types!.isNotEmpty) ||
           minAbv != null ||
           maxAbv != null ||
           country != null ||
           (countries != null && countries!.isNotEmpty) ||
           minRating != null ||
           maxRating != null ||
           onlyRated == true ||
           onlyUnrated == true;
  }
  
  int get activeFilterCount {
    int count = 0;
    if (search != null && search!.isNotEmpty) count++;
    if (type != null || (types != null && types!.isNotEmpty)) count++;
    if (minAbv != null || maxAbv != null) count++;
    if (country != null || (countries != null && countries!.isNotEmpty)) count++;
    if (minRating != null || maxRating != null) count++;
    if (onlyRated == true || onlyUnrated == true) count++;
    return count;
  }
  
  DrinksFilter clearAllFilters() {
    return const DrinksFilter();
  }
}

// State notifiers for creating/updating entities
class DrinkNotifier extends StateNotifier<AsyncValue<Drink?>> {
  final DrinksRepository _repository;
  
  DrinkNotifier(this._repository) : super(const AsyncValue.data(null));
  
  Future<void> createDrink(Drink drink) async {
    state = const AsyncValue.loading();
    try {
      final createdDrink = await _repository.createDrink(drink);
      state = AsyncValue.data(createdDrink);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> updateDrink(Drink drink) async {
    state = const AsyncValue.loading();
    try {
      final updatedDrink = await _repository.updateDrink(drink);
      state = AsyncValue.data(updatedDrink);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

class RatingNotifier extends StateNotifier<AsyncValue<Rating?>> {
  final RatingsRepository _repository;
  
  RatingNotifier(this._repository) : super(const AsyncValue.data(null));
  
  Future<void> createRating(Rating rating) async {
    state = const AsyncValue.loading();
    try {
      final createdRating = await _repository.createRating(rating);
      state = AsyncValue.data(createdRating);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> updateRating(Rating rating) async {
    state = const AsyncValue.loading();
    try {
      final updatedRating = await _repository.updateRating(rating);
      state = AsyncValue.data(updatedRating);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> deleteRating(String ratingId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRating(ratingId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final drinkNotifierProvider = StateNotifierProvider<DrinkNotifier, AsyncValue<Drink?>>((ref) {
  final repository = ref.watch(drinksRepositoryProvider);
  return DrinkNotifier(repository);
});

final ratingNotifierProvider = StateNotifierProvider<RatingNotifier, AsyncValue<Rating?>>((ref) {
  final repository = ref.watch(ratingsRepositoryProvider);
  return RatingNotifier(repository);
});

/// Shared filter state provider for cross-page navigation
class DrinksFilterNotifier extends StateNotifier<DrinksFilter> {
  DrinksFilterNotifier() : super(const DrinksFilter());

  void updateFilter(DrinksFilter filter) {
    state = filter;
  }

  void resetFilter() {
    state = const DrinksFilter();
  }

  void setTypeFilter(DrinkType type) {
    state = state.copyWith(type: type);
  }

  void setCountryFilter(String country) {
    state = state.copyWith(country: country);
  }

  void setRatingFilter({double? minRating, double? maxRating}) {
    state = state.copyWith(minRating: minRating, maxRating: maxRating);
  }

  void setOnlyRatedFilter() {
    state = state.copyWith(onlyRated: true, onlyUnrated: false);
  }
}

final drinksFilterProvider = StateNotifierProvider<DrinksFilterNotifier, DrinksFilter>((ref) {
  return DrinksFilterNotifier();
});