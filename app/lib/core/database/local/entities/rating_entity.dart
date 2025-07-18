import 'package:floor/floor.dart';
import '../converters/date_time_converter.dart';

@Entity(tableName: 'ratings')
@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
class RatingEntity {
  @PrimaryKey()
  final String id;
  
  final String drinkId;
  final String userId;
  final double overall;
  final double? nose;
  final double? taste; 
  final double? finish;
  final String? notes;
  final String? occasion;
  final String? mood;
  final String? location;
  
  // Sync fields
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final bool isDeleted;
  final bool needsSync;
  
  const RatingEntity({
    required this.id,
    required this.drinkId,
    required this.userId,
    required this.overall,
    this.nose,
    this.taste,
    this.finish,
    this.notes,
    this.occasion,
    this.mood,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.isDeleted = false,
    this.needsSync = false,
  });
  
  RatingEntity copyWith({
    String? id,
    String? drinkId,
    String? userId,
    double? overall,
    double? nose,
    double? taste,
    double? finish,
    String? notes,
    String? occasion,
    String? mood,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    bool? isDeleted,
    bool? needsSync,
  }) {
    return RatingEntity(
      id: id ?? this.id,
      drinkId: drinkId ?? this.drinkId,
      userId: userId ?? this.userId,
      overall: overall ?? this.overall,
      nose: nose ?? this.nose,
      taste: taste ?? this.taste,
      finish: finish ?? this.finish,
      notes: notes ?? this.notes,
      occasion: occasion ?? this.occasion,
      mood: mood ?? this.mood,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
    );
  }
  
  @override
  String toString() {
    return 'RatingEntity(id: $id, drinkId: $drinkId, overall: $overall, needsSync: $needsSync)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RatingEntity && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}