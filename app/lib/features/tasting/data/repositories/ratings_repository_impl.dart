import '../../domain/entities/rating.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../models/rating_model.dart';
import '../../../../core/network/pocketbase_client.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  final PocketBaseClient _pocketBaseClient;
  
  RatingsRepositoryImpl(this._pocketBaseClient);
  
  @override
  Future<List<Rating>> getUserRatings(String userId, {
    int? page,
    int? perPage,
  }) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            page: page ?? 1,
            perPage: perPage ?? 50,
            filter: 'user = "${userId}"',
            sort: '-created',
            expand: 'drink',
          );
      
      return records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get user ratings: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Rating>> getDrinkRatings(String drinkId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'drink = "${drinkId}"',
            sort: '-created',
            expand: 'user',
          );
      
      return records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get drink ratings: ${e.toString()}');
    }
  }
  
  @override
  Future<Rating?> getRatingById(String id) async {
    try {
      final record = await _pocketBaseClient.instance
          .collection('ratings')
          .getOne(id);
      
      return RatingModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Rating?> getUserDrinkRating(String userId, String drinkId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            page: 1,
            perPage: 1,
            filter: 'user = "${userId}" && drink = "${drinkId}"',
          );
      
      if (records.items.isEmpty) {
        return null;
      }
      
      return RatingModel.fromPocketBase(records.items.first.toJson()).toEntity();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Rating> createRating(Rating rating) async {
    try {
      final ratingModel = RatingModel.fromEntity(rating);
      final data = {
        'user': ratingModel.user,
        'drink': ratingModel.drink,
        'score': ratingModel.score,
        'note': ratingModel.note,
        'photos': ratingModel.photos,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('ratings')
          .create(body: data);
      
      return RatingModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      throw Exception('Failed to create rating: ${e.toString()}');
    }
  }
  
  @override
  Future<Rating> updateRating(Rating rating) async {
    try {
      final ratingModel = RatingModel.fromEntity(rating);
      final data = {
        'score': ratingModel.score,
        'note': ratingModel.note,
        'photos': ratingModel.photos,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('ratings')
          .update(rating.id, body: data);
      
      return RatingModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      throw Exception('Failed to update rating: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteRating(String id) async {
    try {
      await _pocketBaseClient.instance
          .collection('ratings')
          .delete(id);
    } catch (e) {
      throw Exception('Failed to delete rating: ${e.toString()}');
    }
  }
  
  @override
  Future<double?> getDrinkAverageRating(String drinkId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'drink = "${drinkId}"',
            perPage: 500, // Get all ratings for this drink
          );
      
      if (records.items.isEmpty) {
        return null;
      }
      
      final ratings = records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()))
          .toList();
      
      final totalScore = ratings.fold<double>(0, (sum, rating) => sum + rating.score);
      return totalScore / ratings.length;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Rating>> getRecentRatings(String userId, {int limit = 10}) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            page: 1,
            perPage: limit,
            filter: 'user = "${userId}"',
            sort: '-created',
            expand: 'drink',
          );
      
      return records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent ratings: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getUserRatingStats(String userId) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'user = "${userId}"',
            perPage: 500, // Get all user ratings
          );
      
      final ratings = records.items
          .map((record) => RatingModel.fromPocketBase(record.toJson()))
          .toList();
      
      if (ratings.isEmpty) {
        return {
          'totalRatings': 0,
          'averageRating': 0.0,
          'highestRating': 0.0,
          'lowestRating': 0.0,
        };
      }
      
      final scores = ratings.map((r) => r.score).toList();
      final averageRating = scores.reduce((a, b) => a + b) / scores.length;
      
      return {
        'totalRatings': ratings.length,
        'averageRating': averageRating,
        'highestRating': scores.reduce((a, b) => a > b ? a : b),
        'lowestRating': scores.reduce((a, b) => a < b ? a : b),
      };
    } catch (e) {
      throw Exception('Failed to get user rating stats: ${e.toString()}');
    }
  }
}