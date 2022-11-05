import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diet_preferences.g.dart';

@JsonSerializable(createToJson: false)
class DietPreferences {
  DietPreferences();

  @JsonKey(name: 'activity_levels')
  List<ActivityData>? activityLevels;

  @JsonKey(name: 'diet_histories')
  List<DietHistory>? dietHistories;

  @JsonKey(name: 'diet_goals')
  List<DietGoal>? dietGoal;

  @JsonKey(name: 'has_pregnancy_diet')
  bool? hasPregnancyDiet;

  factory DietPreferences.fromJson(Map<String, dynamic> json) =>
      _$DietPreferencesFromJson(json);
}