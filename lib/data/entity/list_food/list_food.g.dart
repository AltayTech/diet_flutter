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
          ?.map((e) => ListFood.fromJson(e as Map<String, dynamic>))
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

ListFood _$ListFoodFromJson(Map<String, dynamic> json) => ListFood(
      json['id'] as int?,
      json['title'] as String?,
      json['description'] as String?,
      (json['free_food_items'] as List<dynamic>?)
          ?.map((e) => ListFoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['food_items'] as List<dynamic>?)
          ?.map((e) => ListFoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListFoodToJson(ListFood instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'free_food_items': instance.freeFoodItems,
      'food_items': instance.foodItems,
    };

ListFoodItem _$ListFoodItemFromJson(Map<String, dynamic> json) => ListFoodItem(
      json['title'] as String,
    );

Map<String, dynamic> _$ListFoodItemToJson(ListFoodItem instance) =>
    <String, dynamic>{
      'title': instance.title,
    };
