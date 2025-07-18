// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CabinetItemModel _$CabinetItemModelFromJson(Map<String, dynamic> json) =>
    CabinetItemModel(
      id: json['id'] as String,
      drinkId: json['drinkId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      openedDate: json['openedDate'] == null
          ? null
          : DateTime.parse(json['openedDate'] as String),
      finishedDate: json['finishedDate'] == null
          ? null
          : DateTime.parse(json['finishedDate'] as String),
      location: json['location'] as String? ?? 'mainShelf',
      customLocation: json['customLocation'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      purchaseStore: json['purchaseStore'] as String?,
      purchaseNotes: json['purchaseNotes'] as String?,
      fillLevel: (json['fillLevel'] as num?)?.toInt() ?? 100,
      personalNotes: json['personalNotes'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CabinetItemModelToJson(CabinetItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'drinkId': instance.drinkId,
      'userId': instance.userId,
      'status': instance.status,
      'addedAt': instance.addedAt.toIso8601String(),
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'openedDate': instance.openedDate?.toIso8601String(),
      'finishedDate': instance.finishedDate?.toIso8601String(),
      'location': instance.location,
      'customLocation': instance.customLocation,
      'quantity': instance.quantity,
      'purchasePrice': instance.purchasePrice,
      'purchaseStore': instance.purchaseStore,
      'purchaseNotes': instance.purchaseNotes,
      'fillLevel': instance.fillLevel,
      'personalNotes': instance.personalNotes,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
