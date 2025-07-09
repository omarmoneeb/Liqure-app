// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasting_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrinksFilterImpl _$$DrinksFilterImplFromJson(Map<String, dynamic> json) =>
    _$DrinksFilterImpl(
      search: json['search'] as String?,
      type: $enumDecodeNullable(_$DrinkTypeEnumMap, json['type']),
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['perPage'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$$DrinksFilterImplToJson(_$DrinksFilterImpl instance) =>
    <String, dynamic>{
      'search': instance.search,
      'type': _$DrinkTypeEnumMap[instance.type],
      'page': instance.page,
      'perPage': instance.perPage,
    };

const _$DrinkTypeEnumMap = {
  DrinkType.whiskey: 'whiskey',
  DrinkType.bourbon: 'bourbon',
  DrinkType.scotch: 'scotch',
  DrinkType.vodka: 'vodka',
  DrinkType.gin: 'gin',
  DrinkType.rum: 'rum',
  DrinkType.tequila: 'tequila',
  DrinkType.mezcal: 'mezcal',
  DrinkType.liqueur: 'liqueur',
  DrinkType.wine: 'wine',
  DrinkType.beer: 'beer',
  DrinkType.cocktail: 'cocktail',
  DrinkType.other: 'other',
};
