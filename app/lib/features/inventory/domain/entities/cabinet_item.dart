import 'package:freezed_annotation/freezed_annotation.dart';

part 'cabinet_item.freezed.dart';

enum CabinetStatus {
  available,      // Currently have the bottle
  empty,          // Finished the bottle
  wishlist,       // Want to buy
  discontinued,   // No longer available
}

enum StorageLocation {
  mainShelf,
  topShelf,
  bottomShelf,
  cabinet,
  cellar,
  bar,
  kitchen,
  other,
}

@freezed
class CabinetItem with _$CabinetItem {
  const factory CabinetItem({
    required String id,
    required String drinkId,
    required String userId,
    required CabinetStatus status,
    
    // Physical details
    required DateTime addedAt,
    DateTime? purchaseDate,
    DateTime? openedDate,
    DateTime? finishedDate,
    
    // Storage and organization
    @Default(StorageLocation.mainShelf) StorageLocation location,
    String? customLocation,
    int? quantity,
    
    // Purchase information
    double? purchasePrice,
    String? purchaseStore,
    String? purchaseNotes,
    
    // Condition and notes
    @Default(100) int fillLevel, // Percentage 0-100
    String? personalNotes,
    List<String>? tags,
    
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CabinetItem;
  
  const CabinetItem._();
  
  /// Check if the item is currently available to drink
  bool get isAvailable => status == CabinetStatus.available && fillLevel > 0;
  
  /// Check if the item is on the wishlist
  bool get isWishlist => status == CabinetStatus.wishlist;
  
  /// Check if the item is finished/empty
  bool get isEmpty => status == CabinetStatus.empty || fillLevel <= 0;
  
  /// Get display location name
  String get displayLocation {
    if (customLocation != null && customLocation!.isNotEmpty) {
      return customLocation!;
    }
    
    switch (location) {
      case StorageLocation.mainShelf:
        return 'Main Shelf';
      case StorageLocation.topShelf:
        return 'Top Shelf';
      case StorageLocation.bottomShelf:
        return 'Bottom Shelf';
      case StorageLocation.cabinet:
        return 'Cabinet';
      case StorageLocation.cellar:
        return 'Cellar';
      case StorageLocation.bar:
        return 'Bar';
      case StorageLocation.kitchen:
        return 'Kitchen';
      case StorageLocation.other:
        return 'Other';
    }
  }
  
  /// Get status display text
  String get statusDisplayText {
    switch (status) {
      case CabinetStatus.available:
        return isEmpty ? 'Empty' : 'Available';
      case CabinetStatus.empty:
        return 'Empty';
      case CabinetStatus.wishlist:
        return 'Wishlist';
      case CabinetStatus.discontinued:
        return 'Discontinued';
    }
  }
  
  /// Get fill level description
  String get fillLevelDescription {
    if (fillLevel >= 90) return 'Full';
    if (fillLevel >= 75) return 'Nearly Full';
    if (fillLevel >= 50) return 'Half Full';
    if (fillLevel >= 25) return 'Quarter Full';
    if (fillLevel > 0) return 'Nearly Empty';
    return 'Empty';
  }
  
  /// Calculate how long the bottle has been owned
  Duration? get ownedDuration {
    final startDate = purchaseDate ?? addedAt;
    final endDate = finishedDate ?? DateTime.now();
    return endDate.difference(startDate);
  }
  
  /// Calculate how long the bottle was open before finishing
  Duration? get consumptionDuration {
    if (openedDate == null) return null;
    final endDate = finishedDate ?? DateTime.now();
    return endDate.difference(openedDate!);
  }
}