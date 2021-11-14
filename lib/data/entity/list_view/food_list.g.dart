// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodListData _$FoodListDataFromJson(Map<String, dynamic> json) => FoodListData(
      (json['meals'] as List<dynamic>)
          .map((e) => Meals.fromJson(e as Map<String, dynamic>))
          .toList(),
      Menu.fromJson(json['menu'] as Map<String, dynamic>),
      Visit.fromJson(json['visit'] as Map<String, dynamic>),
      DietType.fromJson(json['diet_type'] as Map<String, dynamic>),
      $enumDecode(_$booleanEnumMap, json['is_fasting']),
    );

const _$booleanEnumMap = {
  boolean.False: 0,
  boolean.True: 1,
};

Meals _$MealsFromJson(Map<String, dynamic> json) => Meals(
      json['id'] as int,
      json['title'] as String,
      json['meal_type_id'] as int,
      json['icon'] as String?,
      $enumDecode(_$booleanEnumMap, json['is_for_fasting']),
      json['order'] as int,
      json['start_at'] as String?,
      json['end_at'] as String?,
      json['description'] as String?,
    )..food = json['food'] == null
        ? null
        : Food.fromJson(json['food'] as Map<String, dynamic>);

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String?,
      json['diet_type_id'] as int,
      json['menu_type_id'] as int,
      json['menu_term_id'] as int,
      $enumDecode(_$booleanEnumMap, json['is_calory_based']),
      $enumDecode(_$booleanEnumMap, json['is_prepared']),
      json['order'] as int,
      json['menu_days'] as int,
      (json['foods'] as List<dynamic>)
          .map((e) => Food.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['started_at'] as String,
      json['expired_at'] as String,
    );

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      json['id'] as int?,
      json['title'] as String?,
      json['code'] as int?,
      json['description'] as String?,
      (json['ratios'] as List<dynamic>?)
          ?.map((e) => Ratio.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['free_foods'] as List<dynamic>?,
      json['free_foods_items'] as List<dynamic>?,
      json['pivot'] == null
          ? null
          : Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
      (json['food_items'] as List<dynamic>?)
          ?.map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'code': instance.code,
      'description': instance.description,
      'ratios': instance.ratios,
      'free_foods': instance.freeFoods,
      'free_foods_items': instance.freeFoodsItems,
      'pivot': instance.pivot,
      'food_items': instance.foodItems,
    };

Ratio _$RatioFromJson(Map<String, dynamic> json) => Ratio(
      json['sub_calory_id'] as int?,
      json['sub_calory_value'] as int?,
      (json['food_items'] as List<dynamic>?)
          ?.map((e) => RatioFoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RatioToJson(Ratio instance) => <String, dynamic>{
      'sub_calory_id': instance.subCalorieId,
      'sub_calory_value': instance.subCalorieValue,
      'food_items': instance.ratioFoodItems,
    };

RatioFoodItem _$RatioFoodItemFromJson(Map<String, dynamic> json) =>
    RatioFoodItem(
      json['id'] as int,
      json['title'] as String,
      json['order'] as int,
      json['amount'] == null
          ? null
          : RatioAmount.fromJson(json['amount'] as Map<String, dynamic>),
      json['unit_title'] as String? ?? '',
    );

Map<String, dynamic> _$RatioFoodItemToJson(RatioFoodItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'order': instance.order,
      'amount': instance.amount,
      'unit_title': instance.unitTitle,
    };

RatioAmount _$RatioAmountFromJson(Map<String, dynamic> json) => RatioAmount()
  ..defaultUnit = json['default_unit'] == null
      ? null
      : DefaultUnit.fromJson(json['default_unit'] as Map<String, dynamic>)
  ..secondUnit = json['second_unit'] == null
      ? null
      : DefaultUnit.fromJson(json['second_unit'] as Map<String, dynamic>);

Map<String, dynamic> _$RatioAmountToJson(RatioAmount instance) =>
    <String, dynamic>{
      'default_unit': instance.defaultUnit,
      'second_unit': instance.secondUnit,
    };

DefaultUnit _$DefaultUnitFromJson(Map<String, dynamic> json) => DefaultUnit(
      json['id'] as int?,
      json['title'] as String?,
      (json['quantity_in_gram'] as num?)?.toDouble(),
      (json['amount'] as num?)?.toDouble(),
      json['representational'],
    );

Map<String, dynamic> _$DefaultUnitToJson(DefaultUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'quantity_in_gram': instance.quantityInGram,
      'amount': instance.amount,
      'representational': instance.representational,
    };

Pivot _$PivotFromJson(Map<String, dynamic> json) => Pivot(
      json['menu_id'] as int,
      json['food_id'] as int,
      json['user_id'] as int,
      json['meal_id'] as int,
      json['free_food_item_id'] as int?,
      json['menu_term_id'] as int,
      json['day'] as int,
    );

Map<String, dynamic> _$PivotToJson(Pivot instance) => <String, dynamic>{
      'menu_id': instance.menuId,
      'food_id': instance.foodId,
      'user_id': instance.userId,
      'meal_id': instance.mealId,
      'free_food_item_id': instance.freeFoodItemId,
      'menu_term_id': instance.menuTermId,
      'day': instance.day,
    };

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
      json['id'] as int,
      json['title'] as String,
      (json['calories'] as num).toDouble(),
      (json['carbohydrates'] as num?)?.toDouble(),
      (json['fats'] as num?)?.toDouble(),
      (json['proteins'] as num?)?.toDouble(),
      json['pivot'] == null
          ? null
          : FoodItemPivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'calories': instance.calories,
      'carbohydrates': instance.carbohydrates,
      'fats': instance.fats,
      'proteins': instance.proteins,
      'pivot': instance.pivot,
    };

FoodItemPivot _$FoodItemPivotFromJson(Map<String, dynamic> json) =>
    FoodItemPivot(
      json['food_id'] as int,
      json['food_item_id'] as int,
      json['order'] as int,
      json['diet_type_id'] as int?,
      (json['ratio'] as num?)?.toDouble(),
      json['min_calories'] as int,
      json['max_calories'] as int,
    );

Map<String, dynamic> _$FoodItemPivotToJson(FoodItemPivot instance) =>
    <String, dynamic>{
      'food_id': instance.foodId,
      'food_item_id': instance.foodItemId,
      'order': instance.order,
      'diet_type_id': instance.dietTypeId,
      'ratio': instance.ratio,
      'min_calories': instance.minCalorie,
      'max_calories': instance.maxCalorie,
    };

Visit _$VisitFromJson(Map<String, dynamic> json) => Visit(
      json['id'] as int,
      json['term_id'] as int,
      json['message_id'] as int?,
      json['weight'] as int,
      json['target_weight'] as int,
      json['height'] as int,
      json['wrist'] as int,
      json['pregnancy_week_number'] as int?,
      json['commitment'],
      json['visited_at'] as String,
      json['expired_at'] as String,
      json['activity_level_id'] as int,
      json['calory_id'] as int,
      $enumDecode(_$booleanEnumMap, json['is_active']),
      json['deleted_at'] as String?,
      json['calory_value'] as int,
    );

DietType _$DietTypeFromJson(Map<String, dynamic> json) => DietType(
      json['id'] as int,
      json['alias'] as String,
      json['title'] as String,
      $enumDecode(_$booleanEnumMap, json['is_active']),
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['deleted_at'] as String?,
    );