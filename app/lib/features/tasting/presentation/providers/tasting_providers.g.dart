// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasting_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrinksFilterImpl _$$DrinksFilterImplFromJson(Map<String, dynamic> json) =>
    _$DrinksFilterImpl(
      search: json['search'] as String?,
      searchFields: (json['searchFields'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SearchFieldEnumMap, e))
              .toList() ??
          const [SearchField.name],
      type: $enumDecodeNullable(_$DrinkTypeEnumMap, json['type']),
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DrinkTypeEnumMap, e))
          .toList(),
      minAbv: (json['minAbv'] as num?)?.toDouble(),
      maxAbv: (json['maxAbv'] as num?)?.toDouble(),
      country: json['country'] as String?,
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      maxRating: (json['maxRating'] as num?)?.toDouble(),
      onlyRated: json['onlyRated'] as bool?,
      onlyUnrated: json['onlyUnrated'] as bool?,
      sortBy: $enumDecodeNullable(_$SortByEnumMap, json['sortBy']) ??
          SortBy.created,
      sortDirection:
          $enumDecodeNullable(_$SortDirectionEnumMap, json['sortDirection']) ??
              SortDirection.descending,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['perPage'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$$DrinksFilterImplToJson(_$DrinksFilterImpl instance) =>
    <String, dynamic>{
      'search': instance.search,
      'searchFields':
          instance.searchFields.map((e) => _$SearchFieldEnumMap[e]!).toList(),
      'type': _$DrinkTypeEnumMap[instance.type],
      'types': instance.types?.map((e) => _$DrinkTypeEnumMap[e]!).toList(),
      'minAbv': instance.minAbv,
      'maxAbv': instance.maxAbv,
      'country': instance.country,
      'countries': instance.countries,
      'minRating': instance.minRating,
      'maxRating': instance.maxRating,
      'onlyRated': instance.onlyRated,
      'onlyUnrated': instance.onlyUnrated,
      'sortBy': _$SortByEnumMap[instance.sortBy]!,
      'sortDirection': _$SortDirectionEnumMap[instance.sortDirection]!,
      'page': instance.page,
      'perPage': instance.perPage,
    };

const _$SearchFieldEnumMap = {
  SearchField.name: 'name',
  SearchField.description: 'description',
  SearchField.country: 'country',
  SearchField.barcode: 'barcode',
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

const _$SortByEnumMap = {
  SortBy.name: 'name',
  SortBy.abv: 'abv',
  SortBy.rating: 'rating',
  SortBy.created: 'created',
  SortBy.country: 'country',
};

const _$SortDirectionEnumMap = {
  SortDirection.ascending: 'ascending',
  SortDirection.descending: 'descending',
};
