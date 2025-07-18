import 'package:flutter/material.dart';
import '../../domain/entities/drink.dart';
import '../../domain/repositories/drinks_repository.dart';
import '../models/drink_model.dart';
import '../../../../core/network/pocketbase_client.dart';
import '../../presentation/providers/tasting_providers.dart';

class DrinksRepositoryImpl implements DrinksRepository {
  final PocketBaseClient _pocketBaseClient;
  
  DrinksRepositoryImpl(this._pocketBaseClient);
  
  @override
  Future<List<Drink>> getDrinks({
    String? search,
    DrinkType? type,
    int? page,
    int? perPage,
  }) async {
    print('🍺 DrinksRepository: Starting getDrinks()');
    print('🍺 DrinksRepository: search=$search, type=$type, page=$page, perPage=$perPage');
    
    try {
      final filters = <String>[];
      
      if (search != null && search.isNotEmpty) {
        filters.add('name ~ "${search}"');
      }
      
      if (type != null) {
        filters.add('type = "${type.name}"');
      }
      
      final filterString = filters.isNotEmpty ? filters.join(' && ') : '';
      print('🍺 DrinksRepository: filterString="$filterString"');
      
      print('🍺 DrinksRepository: Making API call to PocketBase...');
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: page ?? 1,
            perPage: perPage ?? 50,
            filter: filterString,
            sort: '-created',
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('⏰ DrinksRepository: API call timed out after 10 seconds');
              throw Exception('API request timed out');
            },
          );
      
      print('🍺 DrinksRepository: API call successful! Got ${records.items.length} records');
      
      final drinks = records.items
          .map((record) => DrinkModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
      
      print('🍺 DrinksRepository: Converted to ${drinks.length} Drink entities');
      return drinks;
    } catch (e) {
      print('❌ DrinksRepository: Error in getDrinks(): $e');
      print('❌ DrinksRepository: Error type: ${e.runtimeType}');
      throw Exception('Failed to get drinks: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Drink>> getDrinksWithFilter(dynamic filter) async {
    final drinksFilter = filter as DrinksFilter;
    print('🔍 DrinksRepository: Enhanced getDrinksWithFilter()');
    print('🔍 DrinksRepository: filter=$drinksFilter');
    
    try {
      final filters = <String>[];
      
      // Text search across multiple fields
      if (drinksFilter.search != null && drinksFilter.search!.isNotEmpty) {
        final searchFields = drinksFilter.searchFields;
        final searchTerms = <String>[];
        
        for (final field in searchFields) {
          switch (field) {
            case SearchField.name:
              searchTerms.add('name ~ "${drinksFilter.search}"');
              break;
            case SearchField.description:
              searchTerms.add('description ~ "${drinksFilter.search}"');
              break;
            case SearchField.country:
              searchTerms.add('country ~ "${drinksFilter.search}"');
              break;
            case SearchField.barcode:
              searchTerms.add('barcode = "${drinksFilter.search}"');
              break;
          }
        }
        
        if (searchTerms.isNotEmpty) {
          filters.add('(${searchTerms.join(' || ')})');
        }
      }
      
      // Type filtering
      if (drinksFilter.type != null) {
        filters.add('type = "${drinksFilter.type!.name}"');
      } else if (drinksFilter.types != null && drinksFilter.types!.isNotEmpty) {
        final typeFilters = drinksFilter.types!.map((type) => 'type = "${type.name}"').toList();
        filters.add('(${typeFilters.join(' || ')})');
      }
      
      // ABV range filtering
      if (drinksFilter.minAbv != null) {
        filters.add('abv >= ${drinksFilter.minAbv}');
        print('🔍 Repository: Added ABV min filter: abv >= ${drinksFilter.minAbv}');
      }
      if (drinksFilter.maxAbv != null) {
        filters.add('abv <= ${drinksFilter.maxAbv}');
        print('🔍 Repository: Added ABV max filter: abv <= ${drinksFilter.maxAbv}');
      }
      
      // Country filtering
      if (drinksFilter.country != null) {
        filters.add('country = "${drinksFilter.country}"');
      } else if (drinksFilter.countries != null && drinksFilter.countries!.isNotEmpty) {
        final countryFilters = drinksFilter.countries!.map((country) => 'country = "$country"').toList();
        filters.add('(${countryFilters.join(' || ')})');
      }
      
      // Note: Rating-based filtering (onlyRated, onlyUnrated, minRating, maxRating) 
      // is now handled client-side in the provider layer to avoid complex database joins.
      // The provider fetches ratings separately and applies filtering in memory.
      // This ensures better separation of concerns and easier maintenance.
      
      final filterString = filters.isNotEmpty ? filters.join(' && ') : '';
      
      // Build sort string
      String sortString = _buildSortString(drinksFilter.sortBy, drinksFilter.sortDirection);
      
      print('🔍 DrinksRepository: filterString="$filterString"');
      print('🔍 DrinksRepository: sortString="$sortString"');
      
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: drinksFilter.page,
            perPage: drinksFilter.perPage,
            filter: filterString,
            sort: sortString,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('⏰ DrinksRepository: Enhanced API call timed out after 10 seconds');
              throw Exception('API request timed out');
            },
          );
      
      print('🔍 DrinksRepository: Enhanced API call successful! Got ${records.items.length} records');
      
      final drinks = records.items
          .map((record) => DrinkModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
      
      print('🔍 DrinksRepository: Converted to ${drinks.length} Drink entities');
      return drinks;
    } catch (e) {
      print('❌ DrinksRepository: Error in getDrinksWithFilter(): $e');
      throw Exception('Failed to get drinks with filter: ${e.toString()}');
    }
  }
  
  String _buildSortString(SortBy sortBy, SortDirection direction) {
    final prefix = direction == SortDirection.ascending ? '+' : '-';
    
    switch (sortBy) {
      case SortBy.name:
        return '${prefix}name';
      case SortBy.abv:
        return '${prefix}abv';
      case SortBy.created:
        return '${prefix}created';
      case SortBy.country:
        return '${prefix}country';
      case SortBy.rating:
        // For rating, we'll need to handle this differently since it requires aggregation
        // For now, fallback to created date
        return '${prefix}created';
    }
  }
  
  @override
  Future<Drink?> getDrinkById(String id) async {
    print('🔍 DrinksRepository: getDrinkById called with id="$id"');
    try {
      // Use getList with filter instead of getOne to bypass permission restrictions
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: 1,
            perPage: 1,
            filter: 'id = "$id"',
          );
      
      if (records.items.isEmpty) {
        print('🔍 DrinksRepository: No drink found with id="$id"');
        return null;
      }
      
      print('🔍 DrinksRepository: Successfully got record for id="$id"');
      final drink = DrinkModel.fromPocketBase(records.items.first.toJson()).toEntity();
      print('🔍 DrinksRepository: Converted to drink: ${drink.id} - ${drink.name}');
      return drink;
    } catch (e) {
      print('❌ DrinksRepository: Error getting drink by id="$id": $e');
      return null;
    }
  }
  
  @override
  Future<Drink?> getDrinkByBarcode(String barcode) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: 1,
            perPage: 1,
            filter: 'barcode = "${barcode}"',
          );
      
      if (records.items.isEmpty) {
        return null;
      }
      
      return DrinkModel.fromPocketBase(records.items.first.toJson()).toEntity();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Drink> createDrink(Drink drink) async {
    try {
      final drinkModel = DrinkModel.fromEntity(drink);
      final data = {
        'name': drinkModel.name,
        'type': drinkModel.type,
        'abv': drinkModel.abv,
        'country': drinkModel.country,
        'barcode': drinkModel.barcode,
        'description': drinkModel.description,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('drinks')
          .create(body: data);
      
      return DrinkModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      throw Exception('Failed to create drink: ${e.toString()}');
    }
  }
  
  @override
  Future<Drink> updateDrink(Drink drink) async {
    try {
      final drinkModel = DrinkModel.fromEntity(drink);
      final data = {
        'name': drinkModel.name,
        'type': drinkModel.type,
        'abv': drinkModel.abv,
        'country': drinkModel.country,
        'barcode': drinkModel.barcode,
        'description': drinkModel.description,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('drinks')
          .update(drink.id, body: data);
      
      return DrinkModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      throw Exception('Failed to update drink: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteDrink(String id) async {
    try {
      await _pocketBaseClient.instance
          .collection('drinks')
          .delete(id);
    } catch (e) {
      throw Exception('Failed to delete drink: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Drink>> getPopularDrinks({int limit = 10}) async {
    try {
      // For now, just return recent drinks
      // TODO: Implement proper popularity ranking based on ratings
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: 1,
            perPage: limit,
            sort: '-created',
          );
      
      return records.items
          .map((record) => DrinkModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular drinks: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Drink>> getRecentDrinks({int limit = 10}) async {
    try {
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: 1,
            perPage: limit,
            sort: '-created',
          );
      
      return records.items
          .map((record) => DrinkModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent drinks: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, Drink>> getBatchDrinks(List<String> ids) async {
    print('🍺 DrinksRepository: getBatchDrinks called with ${ids.length} IDs');
    try {
      if (ids.isEmpty) return {};
      
      // Create filter for multiple IDs using OR conditions
      final idFilters = ids.map((id) => 'id = "$id"').join(' || ');
      final filterString = '($idFilters)';
      
      print('🍺 DrinksRepository: Batch filter: $filterString');
      
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: 1,
            perPage: ids.length, // Ensure we get all requested drinks
            filter: filterString,
          );
      
      print('🍺 DrinksRepository: Batch query returned ${records.items.length} records');
      
      final drinks = <String, Drink>{};
      for (final record in records.items) {
        final drink = DrinkModel.fromPocketBase(record.toJson()).toEntity();
        drinks[drink.id] = drink;
      }
      
      return drinks;
    } catch (e) {
      print('❌ DrinksRepository: Error in getBatchDrinks(): $e');
      throw Exception('Failed to get batch drinks: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getDrinksWithStats({
    List<String>? drinkIds,
    String? userId,
    DrinkType? type,
    int? limit,
  }) async {
    try {
      final filters = <String>[];
      
      if (drinkIds != null && drinkIds.isNotEmpty) {
        final idFilters = drinkIds.map((id) => 'id = "$id"').join(' || ');
        filters.add('($idFilters)');
      }
      
      if (type != null) {
        filters.add('type = "${type.name}"');
      }
      
      final filterString = filters.isNotEmpty ? filters.join(' && ') : '';
      
      // For now, fetch drinks and calculate stats separately
      // In a production setup, this would be optimized with database views or stored procedures
      final records = await _pocketBaseClient.instance
          .collection('drinks')
          .getList(
            page: 1,
            perPage: limit ?? 100,
            filter: filterString,
            sort: '-created',
          );
      
      final results = <Map<String, dynamic>>[];
      
      for (final record in records.items) {
        final drink = DrinkModel.fromPocketBase(record.toJson()).toEntity();
        
        // Get basic rating statistics for the drink
        final ratingsQuery = await _pocketBaseClient.instance
            .collection('ratings')
            .getList(
              filter: 'drink = "${drink.id}"',
              perPage: 500, // Reasonable limit for rating count
            );
        
        final ratings = ratingsQuery.items.map((r) => r.data['rating'] as double?).where((r) => r != null).cast<double>().toList();
        
        final avgRating = ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : null;
        
        results.add({
          'drink': drink,
          'averageRating': avgRating,
          'ratingCount': ratings.length,
          'hasUserRating': userId != null ? await _hasUserRating(drink.id, userId) : false,
        });
      }
      
      return results;
    } catch (e) {
      throw Exception('Failed to get drinks with stats: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getDrinkAggregateStats({
    List<String>? drinkIds,
    String? userId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final filters = <String>[];
      
      if (drinkIds != null && drinkIds.isNotEmpty) {
        final idFilters = drinkIds.map((id) => 'drink = "$id"').join(' || ');
        filters.add('($idFilters)');
      }
      
      if (userId != null) {
        filters.add('user = "$userId"');
      }
      
      if (dateRange != null) {
        final startDate = dateRange.start.toIso8601String();
        final endDate = dateRange.end.toIso8601String();
        filters.add('created >= "$startDate" && created <= "$endDate"');
      }
      
      final filterString = filters.isNotEmpty ? filters.join(' && ') : '';
      
      // Fetch all relevant ratings
      final ratingsQuery = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: filterString,
            perPage: 500,
            expand: 'drink',
          );
      
      // Calculate aggregate statistics
      final ratings = ratingsQuery.items.map((r) => r.data['rating'] as double?).where((r) => r != null).cast<double>().toList();
      final drinkTypeCount = <String, int>{};
      final countryCount = <String, int>{};
      
      for (final item in ratingsQuery.items) {
        final drinkData = item.expand?['drink']?.first;
        if (drinkData != null) {
          final type = drinkData.data['type'] as String?;
          final country = drinkData.data['country'] as String?;
          
          if (type != null) {
            drinkTypeCount[type] = (drinkTypeCount[type] ?? 0) + 1;
          }
          if (country != null && country.isNotEmpty) {
            countryCount[country] = (countryCount[country] ?? 0) + 1;
          }
        }
      }
      
      return {
        'totalRatings': ratings.length,
        'averageRating': ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0.0,
        'minRating': ratings.isNotEmpty ? ratings.reduce((a, b) => a < b ? a : b) : 0.0,
        'maxRating': ratings.isNotEmpty ? ratings.reduce((a, b) => a > b ? a : b) : 0.0,
        'drinkTypeBreakdown': drinkTypeCount,
        'countryBreakdown': countryCount,
        'uniqueDrinks': drinkIds?.length ?? ratingsQuery.items.map((r) => r.data['drink']).toSet().length,
      };
    } catch (e) {
      throw Exception('Failed to get drink aggregate stats: ${e.toString()}');
    }
  }
  
  Future<bool> _hasUserRating(String drinkId, String userId) async {
    try {
      final ratingsQuery = await _pocketBaseClient.instance
          .collection('ratings')
          .getList(
            filter: 'drink = "$drinkId" && user = "$userId"',
            perPage: 1,
          );
      
      return ratingsQuery.items.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}