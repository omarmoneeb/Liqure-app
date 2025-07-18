import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cabinet_item.dart';

part 'cabinet_item_model.g.dart';

@JsonSerializable()
class CabinetItemModel {
  final String id;
  final String drinkId;
  final String userId;
  final String status;
  
  // Physical details
  final DateTime addedAt;
  final DateTime? purchaseDate;
  final DateTime? openedDate;
  final DateTime? finishedDate;
  
  // Storage and organization
  final String location;
  final String? customLocation;
  final int? quantity;
  
  // Purchase information
  final double? purchasePrice;
  final String? purchaseStore;
  final String? purchaseNotes;
  
  // Condition and notes
  final int fillLevel;
  final String? personalNotes;
  final List<String>? tags;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const CabinetItemModel({
    required this.id,
    required this.drinkId,
    required this.userId,
    required this.status,
    required this.addedAt,
    this.purchaseDate,
    this.openedDate,
    this.finishedDate,
    this.location = 'mainShelf',
    this.customLocation,
    this.quantity,
    this.purchasePrice,
    this.purchaseStore,
    this.purchaseNotes,
    this.fillLevel = 100,
    this.personalNotes,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CabinetItemModel.fromJson(Map<String, dynamic> json) => _$CabinetItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CabinetItemModelToJson(this);
  
  factory CabinetItemModel.fromPocketBase(Map<String, dynamic> json) {
    return CabinetItemModel(
      id: json['id'] as String,
      drinkId: json['drink_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      addedAt: _parseDateTime(json['added_at']) ?? DateTime.now(),
      purchaseDate: _parseDateTime(json['purchase_date']),
      openedDate: _parseDateTime(json['opened_date']),
      finishedDate: _parseDateTime(json['finished_date']),
      location: json['location'] as String? ?? 'mainShelf',
      customLocation: json['custom_location'] as String?,
      quantity: json['quantity'] as int?,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      purchaseStore: json['purchase_store'] as String?,
      purchaseNotes: json['purchase_notes'] as String?,
      fillLevel: json['fill_level'] as int? ?? 100,
      personalNotes: json['personal_notes'] as String?,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List) 
          : null,
      createdAt: _parseDateTime(json['created']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated']) ?? DateTime.now(),
    );
  }

  /// Safe date parsing with fallback for invalid formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    final dateString = value.toString().trim();
    if (dateString.isEmpty) return null;
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // Try alternative formats
      try {
        // Handle common date formats
        if (dateString.contains('T')) {
          // ISO 8601 format
          return DateTime.parse(dateString);
        } else if (dateString.contains(' ')) {
          // Handle formats like "2024-01-01 12:00:00"
          return DateTime.parse(dateString.replaceAll(' ', 'T'));
        }
      } catch (e2) {
        // If all parsing fails, return null
        print('⚠️ CabinetItemModel: Unable to parse date "$dateString": $e2');
        return null;
      }
    }
    return null;
  }
  
  Map<String, dynamic> toPocketBase() {
    return {
      'drink_id': drinkId,
      'user_id': userId,
      'status': status,
      'added_at': addedAt.toIso8601String(),
      'purchase_date': purchaseDate?.toIso8601String(),
      'opened_date': openedDate?.toIso8601String(),
      'finished_date': finishedDate?.toIso8601String(),
      'location': location, // location is already a string in the model
      'custom_location': customLocation,
      'quantity': quantity,
      'purchase_price': purchasePrice,
      'purchase_store': purchaseStore,
      'purchase_notes': purchaseNotes,
      'fill_level': fillLevel,
      'personal_notes': personalNotes,
      'tags': tags,
    };
  }
  
  CabinetItem toEntity() {
    return CabinetItem(
      id: id,
      drinkId: drinkId,
      userId: userId,
      status: _stringToCabinetStatus(status),
      addedAt: addedAt,
      purchaseDate: purchaseDate,
      openedDate: openedDate,
      finishedDate: finishedDate,
      location: _stringToStorageLocation(location),
      customLocation: customLocation,
      quantity: quantity,
      purchasePrice: purchasePrice,
      purchaseStore: purchaseStore,
      purchaseNotes: purchaseNotes,
      fillLevel: fillLevel,
      personalNotes: personalNotes,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  factory CabinetItemModel.fromEntity(CabinetItem entity) {
    return CabinetItemModel(
      id: entity.id,
      drinkId: entity.drinkId,
      userId: entity.userId,
      status: entity.status.name,
      addedAt: entity.addedAt,
      purchaseDate: entity.purchaseDate,
      openedDate: entity.openedDate,
      finishedDate: entity.finishedDate,
      location: _storageLocationToString(entity.location),
      customLocation: entity.customLocation,
      quantity: entity.quantity,
      purchasePrice: entity.purchasePrice,
      purchaseStore: entity.purchaseStore,
      purchaseNotes: entity.purchaseNotes,
      fillLevel: entity.fillLevel,
      personalNotes: entity.personalNotes,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
  
  static CabinetStatus _stringToCabinetStatus(String status) {
    switch (status) {
      case 'available':
        return CabinetStatus.available;
      case 'empty':
        return CabinetStatus.empty;
      case 'wishlist':
        return CabinetStatus.wishlist;
      case 'discontinued':
        return CabinetStatus.discontinued;
      default:
        return CabinetStatus.available;
    }
  }
  
  static StorageLocation _stringToStorageLocation(String location) {
    switch (location) {
      case 'main_shelf':
        return StorageLocation.mainShelf;
      case 'wine_fridge':
        return StorageLocation.topShelf; // Map wine_fridge to topShelf
      case 'bar_cart':
        return StorageLocation.bar;
      case 'storage_room':
        return StorageLocation.cellar; // Map storage_room to cellar
      case 'custom':
        return StorageLocation.other;
      // Legacy camelCase support for backward compatibility
      case 'mainShelf':
        return StorageLocation.mainShelf;
      case 'topShelf':
        return StorageLocation.topShelf;
      case 'bottomShelf':
        return StorageLocation.bottomShelf;
      case 'cabinet':
        return StorageLocation.cabinet;
      case 'cellar':
        return StorageLocation.cellar;
      case 'bar':
        return StorageLocation.bar;
      case 'kitchen':
        return StorageLocation.kitchen;
      case 'other':
        return StorageLocation.other;
      default:
        return StorageLocation.mainShelf;
    }
  }
  
  static String _storageLocationToString(StorageLocation location) {
    switch (location) {
      case StorageLocation.mainShelf:
        return 'main_shelf';
      case StorageLocation.topShelf:
        return 'wine_fridge'; // Map topShelf to wine_fridge 
      case StorageLocation.bottomShelf:
        return 'main_shelf'; // Map bottomShelf to main_shelf
      case StorageLocation.cabinet:
        return 'main_shelf'; // Map cabinet to main_shelf
      case StorageLocation.cellar:
        return 'storage_room'; // Map cellar to storage_room
      case StorageLocation.bar:
        return 'bar_cart'; // Map bar to bar_cart
      case StorageLocation.kitchen:
        return 'main_shelf'; // Map kitchen to main_shelf
      case StorageLocation.other:
        return 'custom';
    }
  }
}