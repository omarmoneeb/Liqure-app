import 'package:freezed_annotation/freezed_annotation.dart';
import 'cabinet_item.dart';

part 'cabinet_stats.freezed.dart';

@freezed
class CabinetStats with _$CabinetStats {
  const factory CabinetStats({
    // Overall counts
    @Default(0) int totalItems,
    @Default(0) int availableItems,
    @Default(0) int emptyItems,
    @Default(0) int wishlistItems,
    
    // By location
    @Default({}) Map<StorageLocation, int> itemsByLocation,
    
    // By type/category
    @Default({}) Map<String, int> itemsByType,
    
    // Value calculations
    @Default(0.0) double totalValue,
    @Default(0.0) double averagePrice,
    @Default(0.0) double highestPrice,
    @Default(0.0) double lowestPrice,
    
    // Fill level analytics
    @Default(0) int fullBottles,     // 90-100%
    @Default(0) int partialBottles,  // 1-89%
    @Default(0) int emptyBottles,    // 0%
    @Default(0.0) double averageFillLevel,
    
    // Time analytics
    DateTime? oldestPurchase,
    DateTime? newestPurchase,
    @Default(0) int itemsAddedThisMonth,
    @Default(0) int itemsFinishedThisMonth,
    
    // Top items
    List<String>? topLocations,      // Most used locations
    List<String>? topTypes,          // Most collected types
    List<String>? recentActivity,    // Recent additions/changes
  }) = _CabinetStats;
  
  const CabinetStats._();
  
  /// Get the percentage of items that are available
  double get availabilityPercentage {
    if (totalItems == 0) return 0.0;
    return (availableItems / totalItems) * 100;
  }
  
  /// Get the percentage of items that are on wishlist
  double get wishlistPercentage {
    if (totalItems == 0) return 0.0;
    return (wishlistItems / totalItems) * 100;
  }
  
  /// Get the collection completion rate (not on wishlist)
  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    final nonWishlistItems = totalItems - wishlistItems;
    return (nonWishlistItems / totalItems) * 100;
  }
  
  /// Check if the cabinet is well-stocked
  bool get isWellStocked => availableItems >= 5 && averageFillLevel >= 50;
  
  /// Get a summary description of the cabinet
  String get summaryDescription {
    if (totalItems == 0) {
      return 'Your cabinet is empty. Start building your collection!';
    }
    
    if (availableItems == 0) {
      return 'All bottles are empty or on wishlist. Time to restock!';
    }
    
    if (availableItems == 1) {
      return 'You have 1 bottle available to enjoy.';
    }
    
    return 'You have $availableItems bottles available to enjoy.';
  }
  
  /// Get the most popular location
  String? get mostPopularLocation {
    if (itemsByLocation.isEmpty) return null;
    
    final sorted = itemsByLocation.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.first.key.toString().split('.').last;
  }
  
  /// Get the most collected type
  String? get mostCollectedType {
    if (itemsByType.isEmpty) return null;
    
    final sorted = itemsByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.first.key;
  }
}