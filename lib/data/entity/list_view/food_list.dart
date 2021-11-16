

import 'package:json_annotation/json_annotation.dart';
part 'food_list.g.dart';

@JsonSerializable(createToJson: false)
class FoodListData {
  FoodListData(
      this.meals,
      this.menu,
      // this.visit,
      this.dietType,
      this.isFasting,
      );

  @JsonKey(name: 'meals')
  final List<Meals> meals;

  @JsonKey(name: 'menu')
  final Menu menu;
  //
  // @JsonKey(name: 'visit')
  // final Visit visit;

  @JsonKey(name: 'diet_type')
  final DietType dietType;

  @JsonKey(name: 'is_fasting')
  final boolean isFasting;

  factory FoodListData.fromJson(Map<String, dynamic> json) =>
      _$FoodListDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Meals {
  Meals(
      this.id,
      this.title,
      this.mealTypeId,
      this.icon,
      this.isForFasting,
      this.order,
      this.startAt,
      this.endAt,
      this.description,
      // this.patternIndex,
      // this.dietTypeId,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'meal_type_id')
  final int mealTypeId;

  @JsonKey(name: 'icon')
  final String? icon;

  @JsonKey(name: 'is_for_fasting')
  final boolean isForFasting;

  @JsonKey(name: 'order')
  final int order;

  @JsonKey(name: 'start_at')
  final String? startAt;

  @JsonKey(name: 'end_at')
  final String? endAt;

  @JsonKey(name: 'description')
  final String? description;

  // @JsonKey(name: 'pattern_index')
  // final int patternIndex;
  //
  // @JsonKey(name: 'diet_type_id')
  // final int dietTypeId;

  Food? food;
  Food? newFood;

  factory Meals.fromJson(Map<String, dynamic> json) =>
      _$MealsFromJson(json);
}

@JsonSerializable(createToJson: false)
class Menu{
  Menu(
      this.id,
      this.title,
      this.description,
      this.dietTypeId,
      this.menuTypeId,
      this.menuTermId,
      this.isCalorieBased,
      this.isPrepared,
      this.order,
      this.menuDays,
      this.foods,
      this.startedAt,
      this.expiredAt,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'diet_type_id')
  final int dietTypeId;

  @JsonKey(name: 'menu_type_id')
  final int menuTypeId;

  @JsonKey(name: 'menu_term_id')
  final int menuTermId;

  @JsonKey(name: 'is_calory_based')
  final boolean isCalorieBased;

  @JsonKey(name: 'is_prepared')
  final boolean isPrepared;

  @JsonKey(name: 'order')
  final int order;

  @JsonKey(name: 'menu_days')
  final int menuDays;

  @JsonKey(name: 'foods')
  final List<Food> foods;

  @JsonKey(name: 'started_at')
  final String startedAt;

  @JsonKey(name: 'expired_at')
  final String expiredAt;

  factory Menu.fromJson(Map<String, dynamic> json) =>
      _$MenuFromJson(json);
}

@JsonSerializable()
class Food{
  Food(
      this.id,
      this.title,
      this.code,
      this.description,
      this.ratios,
      this.freeFoods,
      this.freeFoodsItems,
      this.pivot,
      this.foodItems,
      );

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'code')
  final int? code;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'ratios')
  final List<Ratio>? ratios;

  @JsonKey(name: 'free_foods')
  final List? freeFoods;

  @JsonKey(name: 'free_foods_items')
  final List? freeFoodsItems;

  @JsonKey(name: 'pivot')
  final Pivot? pivot;

  @JsonKey(name: 'food_items')
  final List<FoodItem>? foodItems;

  // String? fullTitle;

  factory Food.fromJson(Map<String, dynamic> json) =>
      _$FoodFromJson(json);

  Map<String, dynamic> toJson() => _$FoodToJson(this);
}

@JsonSerializable()
class Ratio {
  Ratio(
      this.subCalorieId,
      this.subCalorieValue,
      this.ratioFoodItems,
      );

  @JsonKey(name: 'sub_calory_id')
  final int? subCalorieId;

  @JsonKey(name: 'sub_calory_value')
  final int? subCalorieValue;

  @JsonKey(name: 'food_items')
  final List<RatioFoodItem>? ratioFoodItems;

  factory Ratio.fromJson(Map<String, dynamic> json) =>
      _$RatioFromJson(json);

  Map<String, dynamic> toJson() => _$RatioToJson(this);
}

@JsonSerializable()
class RatioFoodItem {
  RatioFoodItem(
      this.id,
      this.title,
      this.order,
      this.amount,
      this.unitTitle,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'order')
  final int order;

  @JsonKey(name: 'amount')
  final RatioAmount? amount;

  @JsonKey(name: 'unit_title', defaultValue: '')
  String unitTitle;

  factory RatioFoodItem.fromJson(Map<String, dynamic> json) =>
      _$RatioFoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$RatioFoodItemToJson(this);
}

@JsonSerializable()
class RatioAmount {
  RatioAmount();

  @JsonKey(name: 'default_unit')
  DefaultUnit? defaultUnit;

  @JsonKey(name: 'second_unit')
  DefaultUnit? secondUnit;

  factory RatioAmount.fromJson(Map<String, dynamic> json) =>
      _$RatioAmountFromJson(json);

  Map<String, dynamic> toJson() => _$RatioAmountToJson(this);
}

@JsonSerializable()
class DefaultUnit {
  DefaultUnit(
      this.id,
      this.title,
      this.quantityInGram,
      this.amount,
      this.representational,
      );

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'quantity_in_gram')
  final double? quantityInGram;

  @JsonKey(name: 'amount')
  final double? amount;

  @JsonKey(name: 'representational')
  final dynamic representational;

  factory DefaultUnit.fromJson(Map<String, dynamic> json) =>
      _$DefaultUnitFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultUnitToJson(this);
}

//FreeFood class

@JsonSerializable()
class Pivot {
  Pivot(
      this.menuId,
      this.foodId,
      this.userId,
      this.mealId,
      this.freeFoodItemId,
      this.menuTermId,
      this.day,
      );

  @JsonKey(name: 'menu_id')
  final int menuId;

  @JsonKey(name: 'food_id')
  final int foodId;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'meal_id')
  final int mealId;

  @JsonKey(name: 'free_food_item_id')
  final int? freeFoodItemId;

  @JsonKey(name: 'menu_term_id')
  final int menuTermId;

  @JsonKey(name: 'day')
  final int day;

  factory Pivot.fromJson(Map<String, dynamic> json) =>
      _$PivotFromJson(json);

  Map<String, dynamic> toJson() => _$PivotToJson(this);
}

@JsonSerializable()
class FoodItem{
  FoodItem(
      this.id,
      this.title,
      this.calories,
      this.carbohydrates,
      this.fats,
      this.proteins,
      this.pivot,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'calories')
  final double calories;

  @JsonKey(name: 'carbohydrates')
  final double? carbohydrates;

  @JsonKey(name: 'fats')
  final double? fats;

  @JsonKey(name: 'proteins')
  final double? proteins;

  @JsonKey(name: 'pivot')
  final FoodItemPivot? pivot;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemToJson(this);
}

@JsonSerializable()
class FoodItemPivot {
  FoodItemPivot(
      this.foodId,
      this.foodItemId,
      this.order,
      this.dietTypeId,
      this.ratio,
      this.minCalorie,
      this.maxCalorie,
      );

  @JsonKey(name: 'food_id')
  final int foodId;

  @JsonKey(name: 'food_item_id')
  final int foodItemId;

  @JsonKey(name: 'order')
  final int order;

  @JsonKey(name: 'diet_type_id')
  final int? dietTypeId;

  @JsonKey(name: 'ratio')
  final double? ratio;

  @JsonKey(name: 'min_calories')
  final int minCalorie;

  @JsonKey(name: 'max_calories')
  final int maxCalorie;

  factory FoodItemPivot.fromJson(Map<String, dynamic> json) =>
      _$FoodItemPivotFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemPivotToJson(this);
}

@JsonSerializable(createToJson: false)
class Visit {
  Visit(
      this.id,
      this.termId,
      this.messageId,
      this.weight,
      this.targetWeight,
      this.height,
      this.wrist,
      this.pregnancyWeekNumber,
      this.commitment,
      this.visitedAt,
      this.expiredAt,
      this.activityLevelId,
      this.calorieId,
      this.isActive,
      this.deletedAt,
      this.calorieValue,
      this.visitDays,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'term_id')
  final int termId;

  @JsonKey(name: 'message_id')
  final int? messageId;

  @JsonKey(name: 'weight')
  final int weight;

  @JsonKey(name: 'target_weight')
  final int targetWeight;

  @JsonKey(name: 'height')
  final int height;

  @JsonKey(name: 'wrist')
  final int wrist;

  @JsonKey(name: 'pregnancy_week_number')
  final int? pregnancyWeekNumber;

  @JsonKey(name: 'commitment')
  //ToDo get the type of it
  final dynamic commitment;

  @JsonKey(name: 'visited_at')
  final String visitedAt;

  @JsonKey(name: 'expired_at')
  final String expiredAt;

  @JsonKey(name: 'activity_level_id')
  final int activityLevelId;

  @JsonKey(name: 'calory_id')
  final int calorieId;

  @JsonKey(name: 'is_active')
  final boolean isActive;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'calory_value')
  final int calorieValue;

  @JsonKey(name: 'visit_days')
  final int visitDays;

  factory Visit.fromJson(Map<String, dynamic> json) =>
      _$VisitFromJson(json);
}

@JsonSerializable(createToJson: false)
class DietType{
  DietType(
      this.id,
      this.alias,
      this.title,
      // this.isActive,
      // this.createdAt,
      // this.updatedAt,
      // this.deletedAt,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'alias')
  final String alias;

  @JsonKey(name: 'title')
  final String title;

  // @JsonKey(name: 'is_active')
  // final boolean isActive;
  //
  // @JsonKey(name: 'created_at')
  // final String? createdAt;
  //
  // @JsonKey(name: 'updated_at')
  // final String? updatedAt;
  //
  // @JsonKey(name: 'deleted_at')
  // final String? deletedAt;

  factory DietType.fromJson(Map<String, dynamic> json) =>
      _$DietTypeFromJson(json);
}

enum boolean {
@JsonValue(0)
False,
@JsonValue(1)
True,
}


