import 'package:json_annotation/json_annotation.dart';

part 'target_weight.g.dart';

@JsonSerializable(createToJson: false)
class TargetWeight {
  @JsonKey(name: "ask_to_change_target_weight")
  bool? askToChangeTargetWeight;
  @JsonKey(name: "bmi_diff")
  double? bmiDiff;
  @JsonKey(name: "body_status")
  BodyStatusTarget? bodyStatus;
  @JsonKey(name: "target_weight")
  double? targetWeight;
  @JsonKey(name: "weight")
  double? weight;

  TargetWeight();

  factory TargetWeight.fromJson(Map<String, dynamic> json) => _$TargetWeightFromJson(json);
}

@JsonSerializable(createToJson: false)
class BodyStatusTarget {
  BodyStatusTarget(this.title, this.description);

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'description')
  final String? description;

  factory BodyStatusTarget.fromJson(Map<String, dynamic> json) =>
      _$BodyStatusTargetFromJson(json);
}
