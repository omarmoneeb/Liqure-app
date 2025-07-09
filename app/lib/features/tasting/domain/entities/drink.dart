import 'package:freezed_annotation/freezed_annotation.dart';

part 'drink.freezed.dart';

enum DrinkType {
  whiskey,
  bourbon,
  scotch,
  vodka,
  gin,
  rum,
  tequila,
  mezcal,
  liqueur,
  wine,
  beer,
  cocktail,
  other
}

@freezed
class Drink with _$Drink {
  const factory Drink({
    required String id,
    required String name,
    required DrinkType type,
    double? abv,
    String? country,
    String? barcode,
    String? image,
    String? description,
    DateTime? created,
    DateTime? updated,
  }) = _Drink;
}