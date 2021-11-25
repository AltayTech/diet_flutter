import 'package:json_annotation/json_annotation.dart';
part 'diet_goal.g.dart';

@JsonSerializable(createToJson: false)
class DietGoalData {
  DietGoalData(this.items);

  @JsonKey(name: 'items')
  final List<DietGoal> items;

  factory DietGoalData.fromJson(Map<String, dynamic> json) =>
      _$DietGoalDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class DietGoal {
  DietGoal(this.id, this.title, this.description,);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  factory DietGoal.fromJson(Map<String, dynamic> json) =>
      _$DietGoalFromJson(json);
}