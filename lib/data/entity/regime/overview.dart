
import 'package:json_annotation/json_annotation.dart';

import 'activity_level.dart';
import 'diet_goal.dart';
import 'diet_history.dart';
part 'overview.g.dart';

@JsonSerializable(createToJson: false)
class OverviewData {
  OverviewData(
    this.id,
    this.activityLevel,
    this.dietGoal,
    this.dietHistory,
  );

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'activity_level')
  final ActivityData? activityLevel;

  @JsonKey(name: 'diet_goal')
  final DietGoal? dietGoal;

  @JsonKey(name: 'diet_history')
  final DietHistory? dietHistory;

  factory OverviewData.fromJson(Map<String, dynamic> json) =>
      _$OverviewDataFromJson(json);
}
