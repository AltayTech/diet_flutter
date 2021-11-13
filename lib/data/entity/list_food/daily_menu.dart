import 'package:json_annotation/json_annotation.dart';
part 'daily_menu.g.dart';

@JsonSerializable(createFactory: false)
class DailyMenuRequestData {
  DailyMenuRequestData(this.foods);

  @JsonKey(name: 'foods')
  final List<DailyFood> foods;

  Map<String, dynamic> toJson() => _$DailyMenuRequestDataToJson(this);
}

@JsonSerializable(createFactory: false)
class DailyFood {
  DailyFood(
      this.id,
      this.mealId,
      this.day,
      this.freeFoodItemId,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'meal_id')
  final int mealId;

  @JsonKey(name: 'day')
  final int day;

  @JsonKey(name: 'free_food_item_id')
  final int? freeFoodItemId;

  Map<String, dynamic> toJson() => _$DailyFoodToJson(this);
}