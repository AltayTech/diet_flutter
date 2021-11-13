// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListFoodData _$ListFoodDataFromJson(Map<String, dynamic> json) => ListFoodData(
      json['count'] as int,
      Items.fromJson(json['items'] as Map<String, dynamic>),
      json['sum'] as int,
    );

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      (json['foods'] as List<dynamic>?)
          ?.map((e) => Food.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'foods': instance.foods,
      'tags': instance.tags,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String?,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'title': instance.title,
    };
