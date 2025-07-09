import '../../domain/entities/drink.dart';
import '../../domain/repositories/drinks_repository.dart';
import '../models/drink_model.dart';
import '../../../../core/network/pocketbase_client.dart';

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
  Future<Drink?> getDrinkById(String id) async {
    try {
      final record = await _pocketBaseClient.instance
          .collection('drinks')
          .getOne(id);
      
      return DrinkModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
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
}