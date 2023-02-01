// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regime_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegimeType _$RegimeTypeFromJson(Map<String, dynamic> json) => RegimeType()
  ..count = json['count'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => RegimeType.fromJson(e as Map<String, dynamic>))
      .toList()
  ..alias = $enumDecodeNullable(_$RegimeAliasEnumMap, json['alias'])
  ..caloriesCount = json['calories_count'] as int?
  ..isActive = json['is_active'] as String?
  ..id = json['id'] as String?
  ..mealsCount = json['meals_count'] as int?
  ..title = json['title'] as String?
  ..dietId = json['diet_type_id'] as int?;

Map<String, dynamic> _$RegimeTypeToJson(RegimeType instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items,
      'alias': _$RegimeAliasEnumMap[instance.alias],
      'calories_count': instance.caloriesCount,
      'is_active': instance.isActive,
      'id': instance.id,
      'meals_count': instance.mealsCount,
      'title': instance.title,
      'diet_type_id': instance.dietId,
    };

const _$RegimeAliasEnumMap = {
  RegimeAlias.Pregnancy: 'PREGNANCY',
  RegimeAlias.WeightLoss: 'WEIGHT_LOSS',
  RegimeAlias.WeightGain: 'WEIGHT_GAIN',
  RegimeAlias.Stabilization: 'STABILIZATION',
  RegimeAlias.Diabeties: 'DIABETES',
  RegimeAlias.Ketogenic: 'KETOGENIC',
  RegimeAlias.Sport: 'SPORTS',
  RegimeAlias.Notrica: 'NOTRICA',
};

RegimeTypeName _$RegimeTypeNameFromJson(Map<String, dynamic> json) =>
    RegimeTypeName()
      ..index = json['index'] as int?
      ..name = json['name'] as String?
      ..persianName = json['persian_name'] as String?;

Map<String, dynamic> _$RegimeTypeNameToJson(RegimeTypeName instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'persian_name': instance.persianName,
    };
