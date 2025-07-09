// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrinkModelImpl _$$DrinkModelImplFromJson(Map<String, dynamic> json) =>
    _$DrinkModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      abv: (json['abv'] as num?)?.toDouble(),
      country: json['country'] as String?,
      barcode: json['barcode'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$DrinkModelImplToJson(_$DrinkModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'abv': instance.abv,
      'country': instance.country,
      'barcode': instance.barcode,
      'image': instance.image,
      'description': instance.description,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
