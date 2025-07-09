import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/drink.dart';
import '../../domain/entities/rating.dart';
import '../../domain/repositories/drinks_repository.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../../data/repositories/drinks_repository_impl.dart';
import '../../data/repositories/ratings_repository_impl.dart';
import '../../../../core/network/pocketbase_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'tasting_providers.freezed.dart';
part 'tasting_providers.g.dart';

// Repository providers
final drinksRepositoryProvider = Provider<DrinksRepository>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  return DrinksRepositoryImpl(pocketBaseClient);
});

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  return RatingsRepositoryImpl(pocketBaseClient);
});

// Drinks providers
final drinksProvider = FutureProvider.autoDispose.family<List<Drink>, DrinksFilter?>((ref, filter) async {
  print('🎯 DrinksProvider: Starting with filter: $filter');
  print('🎯 DrinksProvider: search=${filter?.search}, type=${filter?.type}');
  
  // Keep alive for 60 seconds to prevent unnecessary recreations
  ref.keepAlive();
  
  final repository = ref.watch(drinksRepositoryProvider);
  print('🎯 DrinksProvider: Got repository, calling getDrinks...');
  
  try {
    final drinks = await repository.getDrinks(
      search: filter?.search,
      type: filter?.type,
      page: filter?.page ?? 1,
      perPage: filter?.perPage ?? 50,
    );
    
    print('🎯 DrinksProvider: Successfully got ${drinks.length} drinks from repository');
    return drinks;
  } catch (e, stackTrace) {
    print('❌ DrinksProvider: Error getting drinks: $e');
    print('❌ DrinksProvider: Stack trace: $stackTrace');
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

// Filter class for drinks
@freezed
class DrinksFilter with _$DrinksFilter {
  const factory DrinksFilter({
    String? search,
    DrinkType? type,
    @Default(1) int page,
    @Default(50) int perPage,
  }) = _DrinksFilter;
  
  factory DrinksFilter.fromJson(Map<String, dynamic> json) => _$DrinksFilterFromJson(json);
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
}

final drinkNotifierProvider = StateNotifierProvider<DrinkNotifier, AsyncValue<Drink?>>((ref) {
  final repository = ref.watch(drinksRepositoryProvider);
  return DrinkNotifier(repository);
});

final ratingNotifierProvider = StateNotifierProvider<RatingNotifier, AsyncValue<Rating?>>((ref) {
  final repository = ref.watch(ratingsRepositoryProvider);
  return RatingNotifier(repository);
});