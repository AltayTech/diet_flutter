
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:json_annotation/json_annotation.dart';
part 'list_food.g.dart';

@JsonSerializable(createToJson: false)
class ListFoodData {
  ListFoodData(
      this.count,
      this.items,
      this.sum,
      );

  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'items')
  final Items items;

  @JsonKey(name: 'sum')
  final int sum;

  factory ListFoodData.fromJson(Map<String, dynamic> json) =>
      _$ListFoodDataFromJson(json);
}

@JsonSerializable()
class Items {
  Items(
      this.foods,
      this.tags,
      );

  @JsonKey(name: 'foods')
  List<ListFood>? foods;

  @JsonKey(name: 'tags')
  final List<Tag> tags;

  factory Items.fromJson(Map<String, dynamic> json) =>
      _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class Tag {
  Tag(
      this.id,
      this.title,
      this.description,
      );

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  factory Tag.fromJson(Map<String, dynamic> json) =>
      _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@JsonSerializable()
class ListFood{
  ListFood(
      this.id,
      this.title,
      this.description,
      // this.freeFoods,
      this.freeFoodItems,
      this.foodItems,
      );

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'description')
  final String? description;

  // @JsonKey(name: 'free_foods')
  // final String? freeFoods;

  @JsonKey(name: 'free_food_items')
  List<ListFoodItem>? freeFoodItems;

  @JsonKey(name: 'food_items')
  final List<ListFoodItem>? foodItems;

  ListFoodItem? selectedFreeFood;

  factory ListFood.fromJson(Map<String, dynamic> json) =>
      _$ListFoodFromJson(json);

  Map<String, dynamic> toJson() => _$ListFoodToJson(this);
}

@JsonSerializable()
class ListFoodItem{
  ListFoodItem(
      this.id,
      this.title,
      // this.order,
      // this.amount,
      // this.fats,
      // this.proteins,
      // this.pivot,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  // @JsonKey(name: 'order')
  // final int order;

  // @JsonKey(name: 'amount')
  // final String amount;

  // @JsonKey(name: 'fats')
  // final double? fats;
  //
  // @JsonKey(name: 'proteins')
  // final double? proteins;
  //
  // @JsonKey(name: 'pivot')
  // final FoodItemPivot? pivot;

  factory ListFoodItem.fromJson(Map<String, dynamic> json) =>
      _$ListFoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListFoodItemToJson(this);
}

