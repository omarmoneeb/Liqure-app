import '../../../../features/tasting/domain/entities/drink.dart';
import '../entities/drink_entity.dart';

extension DrinkEntityMapper on DrinkEntity {
  /// Convert DrinkEntity to domain Drink
  Drink toDomain() {
    return Drink(
      id: id,
      name: name,
      description: description,
      type: DrinkType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => DrinkType.other,
      ),
      abv: abv,
      country: country,
      barcode: barcode,
      image: imageUrl,
      created: createdAt,
      updated: updatedAt,
    );
  }
}

extension DrinkDomainMapper on Drink {
  /// Convert domain Drink to DrinkEntity
  DrinkEntity toEntity({
    DateTime? lastSyncedAt,
    bool isDeleted = false,
    bool needsSync = false,
  }) {
    return DrinkEntity(
      id: id,
      name: name,
      description: description,
      type: type.name,
      abv: abv ?? 0.0,
      country: country,
      region: null,
      distillery: null,
      barcode: barcode,
      yearProduced: null,
      price: null,
      imageUrl: image,
      createdAt: created ?? DateTime.now(),
      updatedAt: updated ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt,
      isDeleted: isDeleted,
      needsSync: needsSync,
    );
  }
  
  /// Convert domain Drink to DrinkEntity with sync fields updated
  DrinkEntity toEntityWithSync({
    required bool needsSync,
    DateTime? lastSyncedAt,
    bool isDeleted = false,
  }) {
    return DrinkEntity(
      id: id,
      name: name,
      description: description,
      type: type.name,
      abv: abv ?? 0.0,
      country: country,
      region: null,
      distillery: null,
      barcode: barcode,
      yearProduced: null,
      price: null,
      imageUrl: image,
      createdAt: created ?? DateTime.now(),
      updatedAt: updated ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt,
      isDeleted: isDeleted,
      needsSync: needsSync,
    );
  }
}