import '../../../../features/tasting/domain/entities/rating.dart';
import '../entities/rating_entity.dart';

extension RatingEntityMapper on RatingEntity {
  /// Convert RatingEntity to domain Rating
  Rating toDomain() {
    return Rating(
      id: id,
      drinkId: drinkId,
      userId: userId,
      rating: overall,
      notes: notes,
      photos: null, // Photos not stored locally yet
      created: createdAt,
      updated: updatedAt,
    );
  }
}

extension RatingDomainMapper on Rating {
  /// Convert domain Rating to RatingEntity
  RatingEntity toEntity({
    DateTime? lastSyncedAt,
    bool isDeleted = false,
    bool needsSync = false,
  }) {
    return RatingEntity(
      id: id,
      drinkId: drinkId,
      userId: userId,
      overall: rating,
      nose: null,
      taste: null,
      finish: null,
      notes: notes,
      occasion: null,
      mood: null,
      location: null,
      createdAt: created ?? DateTime.now(),
      updatedAt: updated ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt,
      isDeleted: isDeleted,
      needsSync: needsSync,
    );
  }
  
  /// Convert domain Rating to RatingEntity with sync fields updated
  RatingEntity toEntityWithSync({
    required bool needsSync,
    DateTime? lastSyncedAt,
    bool isDeleted = false,
  }) {
    return RatingEntity(
      id: id,
      drinkId: drinkId,
      userId: userId,
      overall: rating,
      nose: null,
      taste: null,
      finish: null,
      notes: notes,
      occasion: null,
      mood: null,
      location: null,
      createdAt: created ?? DateTime.now(),
      updatedAt: updated ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt,
      isDeleted: isDeleted,
      needsSync: needsSync,
    );
  }
}