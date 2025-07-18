import '../entities/cabinet_item.dart';
import '../entities/cabinet_stats.dart';

abstract class CabinetRepository {
  /// Get all cabinet items for a user
  Future<List<CabinetItem>> getCabinetItems(String userId);
  
  /// Get cabinet items by status
  Future<List<CabinetItem>> getCabinetItemsByStatus(String userId, CabinetStatus status);
  
  /// Get cabinet items by location
  Future<List<CabinetItem>> getCabinetItemsByLocation(String userId, StorageLocation location);
  
  /// Get cabinet item by ID
  Future<CabinetItem?> getCabinetItemById(String id);
  
  /// Get cabinet item for a specific drink
  Future<CabinetItem?> getCabinetItemByDrink(String userId, String drinkId);
  
  /// Search cabinet items
  Future<List<CabinetItem>> searchCabinetItems(String userId, String query);
  
  /// Add item to cabinet
  Future<CabinetItem> addToCabinet(CabinetItem item);
  
  /// Update cabinet item
  Future<CabinetItem> updateCabinetItem(CabinetItem item);
  
  /// Remove item from cabinet
  Future<void> removeCabinetItem(String id);
  
  /// Mark item as opened
  Future<CabinetItem> markAsOpened(String id, DateTime openedDate);
  
  /// Update fill level
  Future<CabinetItem> updateFillLevel(String id, int fillLevel);
  
  /// Mark item as finished/empty
  Future<CabinetItem> markAsFinished(String id, DateTime finishedDate);
  
  /// Move item to wishlist
  Future<CabinetItem> moveToWishlist(String id);
  
  /// Move item from wishlist to cabinet
  Future<CabinetItem> moveFromWishlist(String id, {
    DateTime? purchaseDate,
    double? purchasePrice,
    String? purchaseStore,
  });
  
  /// Update item location
  Future<CabinetItem> updateLocation(String id, StorageLocation location, {String? customLocation});
  
  /// Add tags to item
  Future<CabinetItem> addTags(String id, List<String> tags);
  
  /// Remove tags from item
  Future<CabinetItem> removeTags(String id, List<String> tags);
  
  /// Get cabinet statistics
  Future<CabinetStats> getCabinetStats(String userId);
  
  /// Get cabinet items grouped by location
  Future<Map<StorageLocation, List<CabinetItem>>> getCabinetItemsByLocationGrouped(String userId);
  
  /// Get cabinet items grouped by status
  Future<Map<CabinetStatus, List<CabinetItem>>> getCabinetItemsByStatusGrouped(String userId);
  
  /// Get recently added items
  Future<List<CabinetItem>> getRecentlyAdded(String userId, {int limit = 10});
  
  /// Get recently finished items
  Future<List<CabinetItem>> getRecentlyFinished(String userId, {int limit = 10});
  
  /// Get low fill level items (need attention)
  Future<List<CabinetItem>> getLowFillLevelItems(String userId, {int threshold = 25});
  
  /// Get items by tags
  Future<List<CabinetItem>> getCabinetItemsByTags(String userId, List<String> tags);
  
  /// Get all unique tags used by user
  Future<List<String>> getUserTags(String userId);
  
  /// Bulk update items (for batch operations)
  Future<List<CabinetItem>> bulkUpdateItems(List<CabinetItem> items);
  
  /// Export cabinet data
  Future<Map<String, dynamic>> exportCabinetData(String userId);
  
  /// Import cabinet data
  Future<List<CabinetItem>> importCabinetData(String userId, Map<String, dynamic> data);
}