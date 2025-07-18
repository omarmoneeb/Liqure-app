import 'package:floor/floor.dart';
import '../converters/date_time_converter.dart';

@Entity(tableName: 'drinks')
@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
class DrinkEntity {
  @PrimaryKey()
  final String id;
  
  final String name;
  final String? description;
  final String type; // DrinkType enum as string
  final double abv;
  final String? country;
  final String? region;
  final String? distillery;
  final String? barcode;
  final int? yearProduced;
  final double? price;
  final String? imageUrl;
  
  // Sync fields
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final bool isDeleted;
  final bool needsSync;
  
  const DrinkEntity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.abv,
    this.country,
    this.region,
    this.distillery,
    this.barcode,
    this.yearProduced,
    this.price,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.isDeleted = false,
    this.needsSync = false,
  });
  
  DrinkEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    double? abv,
    String? country,
    String? region,
    String? distillery,
    String? barcode,
    int? yearProduced,
    double? price,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    bool? isDeleted,
    bool? needsSync,
  }) {
    return DrinkEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      abv: abv ?? this.abv,
      country: country ?? this.country,
      region: region ?? this.region,
      distillery: distillery ?? this.distillery,
      barcode: barcode ?? this.barcode,
      yearProduced: yearProduced ?? this.yearProduced,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
    );
  }
  
  @override
  String toString() {
    return 'DrinkEntity(id: $id, name: $name, type: $type, needsSync: $needsSync)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrinkEntity && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}