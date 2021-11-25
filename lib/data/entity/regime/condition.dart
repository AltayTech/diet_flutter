import 'package:json_annotation/json_annotation.dart';
part 'condition.g.dart';

@JsonSerializable(createFactory: false)
class ConditionRequestData {
  @JsonKey(name: "activity_level_id")
  int? activityLevelId;

  @JsonKey(name: "diet_type_id")
  int? dietTypeId;

  @JsonKey(name: "package_id")
  int? packageId;

  @JsonKey(name: "diet_history_id")
  int? dietHistoryId;

  @JsonKey(name: "diet_goal_id")
  int? dietGoalId;

  ConditionRequestData();

  Map<String, dynamic> toJson() => _$ConditionRequestDataToJson(this);
}
