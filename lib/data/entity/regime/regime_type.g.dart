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
  ..alias = json['alias'] as String?
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
      'alias': instance.alias,
      'calories_count': instance.caloriesCount,
      'is_active': instance.isActive,
      'id': instance.id,
      'meals_count': instance.mealsCount,
      'title': instance.title,
      'diet_type_id': instance.dietId,
    };
