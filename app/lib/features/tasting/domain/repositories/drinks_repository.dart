import 'package:flutter/material.dart';
import '../entities/drink.dart';

abstract class DrinksRepository {
  /// Get all drinks with optional filtering (legacy method)
  Future<List<Drink>> getDrinks({
    String? search,
    DrinkType? type,
    int? page,
    int? perPage,
  });
  
  /// Get drinks with enhanced filtering
  Future<List<Drink>> getDrinksWithFilter(dynamic filter);
  
  /// Get drink by ID
  Future<Drink?> getDrinkById(String id);
  
  /// Search drinks by barcode
  Future<Drink?> getDrinkByBarcode(String barcode);
  
  /// Create new drink
  Future<Drink> createDrink(Drink drink);
  
  /// Update existing drink
  Future<Drink> updateDrink(Drink drink);
  
  /// Delete drink
  Future<void> deleteDrink(String id);
  
  /// Get popular drinks (most rated)
  Future<List<Drink>> getPopularDrinks({int limit = 10});
  
  /// Get recently added drinks
  Future<List<Drink>> getRecentDrinks({int limit = 10});
  
  /// Get multiple drinks by IDs in a single batch operation
  Future<Map<String, Drink>> getBatchDrinks(List<String> ids);
  
  /// Get drinks with aggregated statistics
  Future<List<Map<String, dynamic>>> getDrinksWithStats({
    List<String>? drinkIds,
    String? userId,
    DrinkType? type,
    int? limit,
  });
  
  /// Get aggregate statistics for drinks
  Future<Map<String, dynamic>> getDrinkAggregateStats({
    List<String>? drinkIds,
    String? userId,
    DateTimeRange? dateRange,
  });
}