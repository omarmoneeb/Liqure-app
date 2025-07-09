import '../entities/drink.dart';

abstract class DrinksRepository {
  /// Get all drinks with optional filtering
  Future<List<Drink>> getDrinks({
    String? search,
    DrinkType? type,
    int? page,
    int? perPage,
  });
  
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
}