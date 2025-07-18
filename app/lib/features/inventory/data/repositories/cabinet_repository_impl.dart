import 'package:uuid/uuid.dart';
import '../../../../core/network/pocketbase_client.dart';
import '../../domain/entities/cabinet_item.dart';
import '../../domain/entities/cabinet_stats.dart';
import '../../domain/repositories/cabinet_repository.dart';
import '../models/cabinet_item_model.dart';

class CabinetRepositoryImpl implements CabinetRepository {
  final PocketBaseClient _pocketBaseClient;
  final _uuid = const Uuid();
  
  CabinetRepositoryImpl(this._pocketBaseClient);
  
  @override
  Future<List<CabinetItem>> getCabinetItems(String userId) async {
    print('🗄️ CabinetRepository: Getting cabinet items for user: $userId');
    
    try {
      final records = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getList(
            filter: 'user_id = "$userId"',
            sort: '-created',
            perPage: 500,
          );
      
      final items = records.items
          .map((record) => CabinetItemModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
      
      print('🗄️ CabinetRepository: Found ${items.length} cabinet items');
      return items;
    } catch (e) {
      print('❌ CabinetRepository: Error getting cabinet items: $e');
      // Return empty list instead of throwing to prevent crashes in offline mode
      return [];
    }
  }
  
  @override
  Future<List<CabinetItem>> getCabinetItemsByStatus(String userId, CabinetStatus status) async {
    print('🗄️ CabinetRepository: Getting cabinet items by status: ${status.name}');
    
    try {
      final records = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getList(
            filter: 'user_id = "$userId" && status = "${status.name}"',
            sort: '-created',
            perPage: 500,
          );
      
      final items = records.items
          .map((record) => CabinetItemModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
      
      print('🗄️ CabinetRepository: Found ${items.length} ${status.name} items');
      return items;
    } catch (e) {
      print('❌ CabinetRepository: Error getting items by status: $e');
      throw Exception('Failed to get cabinet items by status: ${e.toString()}');
    }
  }
  
  @override
  Future<List<CabinetItem>> getCabinetItemsByLocation(String userId, StorageLocation location) async {
    print('🗄️ CabinetRepository: Getting cabinet items by location: ${location.name}');
    
    try {
      final records = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getList(
            filter: 'user_id = "$userId" && location = "${location.name}"',
            sort: '-created',
            perPage: 500,
          );
      
      final items = records.items
          .map((record) => CabinetItemModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
      
      print('🗄️ CabinetRepository: Found ${items.length} items in ${location.name}');
      return items;
    } catch (e) {
      print('❌ CabinetRepository: Error getting items by location: $e');
      throw Exception('Failed to get cabinet items by location: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem?> getCabinetItemById(String id) async {
    print('🗄️ CabinetRepository: Getting cabinet item by ID: $id');
    
    try {
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getOne(id);
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error getting cabinet item by ID: $e');
      return null;
    }
  }
  
  @override
  Future<CabinetItem?> getCabinetItemByDrink(String userId, String drinkId) async {
    print('🗄️ CabinetRepository: Getting cabinet item for drink: $drinkId');
    
    try {
      final records = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getList(
            filter: 'user_id = "$userId" && drink_id = "$drinkId"',
            perPage: 1,
          );
      
      if (records.items.isEmpty) {
        return null;
      }
      
      return CabinetItemModel.fromPocketBase(records.items.first.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error getting cabinet item by drink: $e');
      return null;
    }
  }
  
  @override
  Future<List<CabinetItem>> searchCabinetItems(String userId, String query) async {
    print('🗄️ CabinetRepository: Searching cabinet items: $query');
    
    try {
      // Search in personal notes, purchase store, purchase notes, and tags
      final filter = '''
        user_id = "$userId" && (
          personal_notes ~ "$query" ||
          purchase_store ~ "$query" ||
          purchase_notes ~ "$query" ||
          tags ~ "$query"
        )
      ''';
      
      final records = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getList(
            filter: filter,
            sort: '-created',
            perPage: 100,
          );
      
      final items = records.items
          .map((record) => CabinetItemModel.fromPocketBase(record.toJson()).toEntity())
          .toList();
      
      print('🗄️ CabinetRepository: Found ${items.length} matching items');
      return items;
    } catch (e) {
      print('❌ CabinetRepository: Error searching cabinet items: $e');
      throw Exception('Failed to search cabinet items: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> addToCabinet(CabinetItem item) async {
    print('🗄️ CabinetRepository: Adding item to cabinet: ${item.drinkId}');
    
    try {
      final model = CabinetItemModel.fromEntity(item);
      final data = model.toPocketBase();
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .create(body: data);
      
      final createdItem = CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
      print('✅ CabinetRepository: Successfully added item to cabinet');
      return createdItem;
    } catch (e) {
      print('❌ CabinetRepository: Error adding item to cabinet: $e');
      throw Exception('Failed to add item to cabinet: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> updateCabinetItem(CabinetItem item) async {
    print('🗄️ CabinetRepository: Updating cabinet item: ${item.id}');
    
    try {
      final model = CabinetItemModel.fromEntity(item);
      final data = model.toPocketBase();
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(item.id, body: data);
      
      final updatedItem = CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
      print('✅ CabinetRepository: Successfully updated cabinet item');
      return updatedItem;
    } catch (e) {
      print('❌ CabinetRepository: Error updating cabinet item: $e');
      throw Exception('Failed to update cabinet item: ${e.toString()}');
    }
  }
  
  @override
  Future<void> removeCabinetItem(String id) async {
    print('🗄️ CabinetRepository: Removing cabinet item: $id');
    
    try {
      await _pocketBaseClient.instance
          .collection('cabinet_items')
          .delete(id);
      
      print('✅ CabinetRepository: Successfully removed cabinet item');
    } catch (e) {
      print('❌ CabinetRepository: Error removing cabinet item: $e');
      throw Exception('Failed to remove cabinet item: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> markAsOpened(String id, DateTime openedDate) async {
    print('🗄️ CabinetRepository: Marking item as opened: $id');
    
    try {
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: {
            'opened_date': openedDate.toIso8601String(),
          });
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error marking item as opened: $e');
      throw Exception('Failed to mark item as opened: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> updateFillLevel(String id, int fillLevel) async {
    print('🗄️ CabinetRepository: Updating fill level for item: $id to $fillLevel%');
    
    try {
      final updateData = <String, dynamic>{
        'fill_level': fillLevel,
      };
      
      // If fill level is 0, mark as empty
      if (fillLevel <= 0) {
        updateData['status'] = 'empty';
        updateData['finished_date'] = DateTime.now().toIso8601String();
      } else {
        // If previously empty and now has fill level, mark as available
        updateData['status'] = 'available';
      }
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: updateData);
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error updating fill level: $e');
      throw Exception('Failed to update fill level: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> markAsFinished(String id, DateTime finishedDate) async {
    print('🗄️ CabinetRepository: Marking item as finished: $id');
    
    try {
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: {
            'status': 'empty',
            'fill_level': 0,
            'finished_date': finishedDate.toIso8601String(),
          });
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error marking item as finished: $e');
      throw Exception('Failed to mark item as finished: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> moveToWishlist(String id) async {
    print('🗄️ CabinetRepository: Moving item to wishlist: $id');
    
    try {
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: {
            'status': 'wishlist',
          });
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error moving item to wishlist: $e');
      throw Exception('Failed to move item to wishlist: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> moveFromWishlist(String id, {
    DateTime? purchaseDate,
    double? purchasePrice,
    String? purchaseStore,
  }) async {
    print('🗄️ CabinetRepository: Moving item from wishlist: $id');
    
    try {
      final updateData = <String, dynamic>{
        'status': 'available',
        'fill_level': 100,
        'added_at': DateTime.now().toIso8601String(),
      };
      
      if (purchaseDate != null) {
        updateData['purchase_date'] = purchaseDate.toIso8601String();
      }
      if (purchasePrice != null) {
        updateData['purchase_price'] = purchasePrice;
      }
      if (purchaseStore != null) {
        updateData['purchase_store'] = purchaseStore;
      }
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: updateData);
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error moving item from wishlist: $e');
      throw Exception('Failed to move item from wishlist: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> updateLocation(String id, StorageLocation location, {String? customLocation}) async {
    print('🗄️ CabinetRepository: Updating item location: $id to ${location.name}');
    
    try {
      final updateData = {
        'location': location.name,
        'custom_location': customLocation,
      };
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: updateData);
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error updating item location: $e');
      throw Exception('Failed to update item location: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> addTags(String id, List<String> tags) async {
    print('🗄️ CabinetRepository: Adding tags to item: $id');
    
    try {
      // Get current item to merge tags
      final currentRecord = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getOne(id);
      
      final currentTags = List<String>.from(currentRecord.toJson()['tags'] ?? []);
      final mergedTags = {...currentTags, ...tags}.toList();
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: {
            'tags': mergedTags,
          });
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error adding tags: $e');
      throw Exception('Failed to add tags: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetItem> removeTags(String id, List<String> tags) async {
    print('🗄️ CabinetRepository: Removing tags from item: $id');
    
    try {
      // Get current item to filter tags
      final currentRecord = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .getOne(id);
      
      final currentTags = List<String>.from(currentRecord.toJson()['tags'] ?? []);
      final filteredTags = currentTags.where((tag) => !tags.contains(tag)).toList();
      
      final record = await _pocketBaseClient.instance
          .collection('cabinet_items')
          .update(id, body: {
            'tags': filteredTags,
          });
      
      return CabinetItemModel.fromPocketBase(record.toJson()).toEntity();
    } catch (e) {
      print('❌ CabinetRepository: Error removing tags: $e');
      throw Exception('Failed to remove tags: ${e.toString()}');
    }
  }
  
  @override
  Future<CabinetStats> getCabinetStats(String userId) async {
    print('🗄️ CabinetRepository: Getting cabinet stats for user: $userId');
    
    try {
      final items = await getCabinetItems(userId);
      
      // Calculate basic counts
      final totalItems = items.length;
      final availableItems = items.where((item) => item.status == CabinetStatus.available && item.fillLevel > 0).length;
      final emptyItems = items.where((item) => item.status == CabinetStatus.empty || item.fillLevel <= 0).length;
      final wishlistItems = items.where((item) => item.status == CabinetStatus.wishlist).length;
      
      // Group by location
      final itemsByLocation = <StorageLocation, int>{};
      for (final item in items) {
        itemsByLocation[item.location] = (itemsByLocation[item.location] ?? 0) + 1;
      }
      
      // Calculate value metrics
      final itemsWithPrice = items.where((item) => item.purchasePrice != null).toList();
      final totalValue = itemsWithPrice.fold(0.0, (sum, item) => sum + (item.purchasePrice ?? 0));
      final averagePrice = itemsWithPrice.isNotEmpty ? totalValue / itemsWithPrice.length : 0.0;
      final prices = itemsWithPrice.map((item) => item.purchasePrice!).toList();
      final highestPrice = prices.isNotEmpty ? prices.reduce((a, b) => a > b ? a : b) : 0.0;
      final lowestPrice = prices.isNotEmpty ? prices.reduce((a, b) => a < b ? a : b) : 0.0;
      
      // Fill level analytics
      final fullBottles = items.where((item) => item.fillLevel >= 90).length;
      final partialBottles = items.where((item) => item.fillLevel > 0 && item.fillLevel < 90).length;
      final emptyBottles = items.where((item) => item.fillLevel <= 0).length;
      final averageFillLevel = items.isNotEmpty 
          ? items.fold(0, (sum, item) => sum + item.fillLevel) / items.length 
          : 0.0;
      
      // Time analytics
      final now = DateTime.now();
      final thisMonthStart = DateTime(now.year, now.month, 1);
      final itemsAddedThisMonth = items.where((item) => item.addedAt.isAfter(thisMonthStart)).length;
      final itemsFinishedThisMonth = items
          .where((item) => item.finishedDate != null && item.finishedDate!.isAfter(thisMonthStart))
          .length;
      
      return CabinetStats(
        totalItems: totalItems,
        availableItems: availableItems,
        emptyItems: emptyItems,
        wishlistItems: wishlistItems,
        itemsByLocation: itemsByLocation,
        totalValue: totalValue,
        averagePrice: averagePrice,
        highestPrice: highestPrice,
        lowestPrice: lowestPrice,
        fullBottles: fullBottles,
        partialBottles: partialBottles,
        emptyBottles: emptyBottles,
        averageFillLevel: averageFillLevel,
        oldestPurchase: items
            .where((item) => item.purchaseDate != null)
            .map((item) => item.purchaseDate!)
            .fold<DateTime?>(null, (oldest, date) => oldest == null || date.isBefore(oldest) ? date : oldest),
        newestPurchase: items
            .where((item) => item.purchaseDate != null)
            .map((item) => item.purchaseDate!)
            .fold<DateTime?>(null, (newest, date) => newest == null || date.isAfter(newest) ? date : newest),
        itemsAddedThisMonth: itemsAddedThisMonth,
        itemsFinishedThisMonth: itemsFinishedThisMonth,
      );
    } catch (e) {
      print('❌ CabinetRepository: Error getting cabinet stats: $e');
      // Return empty stats instead of throwing to prevent crashes
      return CabinetStats(
        totalItems: 0,
        availableItems: 0,
        emptyItems: 0,
        wishlistItems: 0,
        itemsByLocation: {},
        totalValue: 0.0,
        averagePrice: 0.0,
        highestPrice: 0.0,
        lowestPrice: 0.0,
        fullBottles: 0,
        partialBottles: 0,
        emptyBottles: 0,
        averageFillLevel: 0.0,
        oldestPurchase: null,
        newestPurchase: null,
        itemsAddedThisMonth: 0,
        itemsFinishedThisMonth: 0,
      );
    }
  }
  
  // Implement other methods with placeholder functionality for now
  @override
  Future<Map<StorageLocation, List<CabinetItem>>> getCabinetItemsByLocationGrouped(String userId) async {
    final items = await getCabinetItems(userId);
    final grouped = <StorageLocation, List<CabinetItem>>{};
    
    for (final item in items) {
      grouped.putIfAbsent(item.location, () => []).add(item);
    }
    
    return grouped;
  }
  
  @override
  Future<Map<CabinetStatus, List<CabinetItem>>> getCabinetItemsByStatusGrouped(String userId) async {
    final items = await getCabinetItems(userId);
    final grouped = <CabinetStatus, List<CabinetItem>>{};
    
    for (final item in items) {
      grouped.putIfAbsent(item.status, () => []).add(item);
    }
    
    return grouped;
  }
  
  @override
  Future<List<CabinetItem>> getRecentlyAdded(String userId, {int limit = 10}) async {
    final items = await getCabinetItems(userId);
    items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return items.take(limit).toList();
  }
  
  @override
  Future<List<CabinetItem>> getRecentlyFinished(String userId, {int limit = 10}) async {
    final items = await getCabinetItems(userId);
    final finished = items.where((item) => item.finishedDate != null).toList();
    finished.sort((a, b) => b.finishedDate!.compareTo(a.finishedDate!));
    return finished.take(limit).toList();
  }
  
  @override
  Future<List<CabinetItem>> getLowFillLevelItems(String userId, {int threshold = 25}) async {
    final items = await getCabinetItems(userId);
    return items.where((item) => item.fillLevel <= threshold && item.fillLevel > 0).toList();
  }
  
  @override
  Future<List<CabinetItem>> getCabinetItemsByTags(String userId, List<String> tags) async {
    final items = await getCabinetItems(userId);
    return items.where((item) {
      if (item.tags == null) return false;
      return tags.any((tag) => item.tags!.contains(tag));
    }).toList();
  }
  
  @override
  Future<List<String>> getUserTags(String userId) async {
    final items = await getCabinetItems(userId);
    final allTags = <String>{};
    
    for (final item in items) {
      if (item.tags != null) {
        allTags.addAll(item.tags!);
      }
    }
    
    return allTags.toList()..sort();
  }
  
  @override
  Future<List<CabinetItem>> bulkUpdateItems(List<CabinetItem> items) async {
    final updatedItems = <CabinetItem>[];
    
    for (final item in items) {
      try {
        final updated = await updateCabinetItem(item);
        updatedItems.add(updated);
      } catch (e) {
        print('⚠️ CabinetRepository: Failed to update item ${item.id}: $e');
      }
    }
    
    return updatedItems;
  }
  
  @override
  Future<Map<String, dynamic>> exportCabinetData(String userId) async {
    final items = await getCabinetItems(userId);
    final stats = await getCabinetStats(userId);
    
    return {
      'exportedAt': DateTime.now().toIso8601String(),
      'userId': userId,
      'totalItems': items.length,
      'items': items.map((item) => CabinetItemModel.fromEntity(item).toJson()).toList(),
      'stats': {
        'totalItems': stats.totalItems,
        'availableItems': stats.availableItems,
        'totalValue': stats.totalValue,
      },
    };
  }
  
  @override
  Future<List<CabinetItem>> importCabinetData(String userId, Map<String, dynamic> data) async {
    final itemsData = data['items'] as List<dynamic>? ?? [];
    final importedItems = <CabinetItem>[];
    
    for (final itemData in itemsData) {
      try {
        final item = CabinetItemModel.fromJson(itemData as Map<String, dynamic>).toEntity();
        // Create new item with new ID and user ID
        final newItem = item.copyWith(
          id: _uuid.v4(),
          userId: userId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        final created = await addToCabinet(newItem);
        importedItems.add(created);
      } catch (e) {
        print('⚠️ CabinetRepository: Failed to import item: $e');
      }
    }
    
    return importedItems;
  }
}