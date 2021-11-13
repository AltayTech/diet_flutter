// import 'package:behandam/data/entity/list_view/food_list.dart';
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
  List<Food>? foods;

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

// @JsonSerializable(createToJson: true)
// class Food {
//   Food(
//       this.id,
//       this.title,
//       this.description,
//       );
//
//   @JsonKey(name: 'description')
//   final String? description;
//
//   @JsonKey(name: 'id')
//   final int id;
//
//   @JsonKey(name: 'title')
//   final String title;
//
//   factory Food.fromJson(Map<String, dynamic> json) =>
//       _$FoodFromJson(json);
//
//   Map<String, dynamic> toJson() => _$FoodToJson(this);
// }

