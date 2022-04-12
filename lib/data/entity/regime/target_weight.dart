import 'package:json_annotation/json_annotation.dart';

part 'target_weight.g.dart';

@JsonSerializable(createToJson: false)
class TargetWeight {
  @JsonKey(name: "ask_to_change_target_weight")
  bool? askToChangeTargetWeight;
  @JsonKey(name: "bmi_diff")
  double? bmiDiff;
  @JsonKey(name: "body_status")
  BodyStatus? bodyStatus;
  @JsonKey(name: "target_weight")
  int? targetWeight;
  @JsonKey(name: "weight")
  int? weight;

  TargetWeight();

  factory TargetWeight.fromJson(Map<String, dynamic> json) => _$TargetWeightFromJson(json);
}

@JsonSerializable(createToJson: false)
class BodyStatus {
  BodyStatus(this.title, this.description);

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'description')
  final String? description;

  factory BodyStatus.fromJson(Map<String, dynamic> json) =>
      _$BodyStatusFromJson(json);
}
