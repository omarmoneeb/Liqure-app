import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/drink.dart';

part 'drink_model.freezed.dart';
part 'drink_model.g.dart';

@freezed
class DrinkModel with _$DrinkModel {
  const factory DrinkModel({
    required String id,
    required String name,
    required String type,
    double? abv,
    String? country,
    String? barcode,
    String? image,
    String? description,
    DateTime? created,
    DateTime? updated,
  }) = _DrinkModel;

  factory DrinkModel.fromJson(Map<String, dynamic> json) => _$DrinkModelFromJson(json);
  
  const DrinkModel._();
  
  factory DrinkModel.fromPocketBase(Map<String, dynamic> json) {
    return DrinkModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      abv: json['abv']?.toDouble(),
      country: json['country'] as String?,
      barcode: json['barcode'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
    );
  }
  
  Drink toEntity() {
    return Drink(
      id: id,
      name: name,
      type: _stringTodrinkType(type),
      abv: abv,
      country: country,
      barcode: barcode,
      image: image,
      description: description,
      created: created,
      updated: updated,
    );
  }
  
  factory DrinkModel.fromEntity(Drink drink) {
    return DrinkModel(
      id: drink.id,
      name: drink.name,
      type: drink.type.name,
      abv: drink.abv,
      country: drink.country,
      barcode: drink.barcode,
      image: drink.image,
      description: drink.description,
      created: drink.created,
      updated: drink.updated,
    );
  }
  
  DrinkType _stringTodrinkType(String type) {
    return DrinkType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => DrinkType.other,
    );
  }
}