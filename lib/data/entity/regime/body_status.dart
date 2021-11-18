import 'package:json_annotation/json_annotation.dart';
part 'body_status.g.dart';

@JsonSerializable()
class BodyStatus {
  @JsonKey(name: "bmi")
  var bmi;
  @JsonKey(name: "bmi_status")
  int? bmiStatus;
  @JsonKey(name: "is_pregnancy")
  int? isPregnancy;
  @JsonKey(name: "pregnancy_ideal_weight")
  var pregnancyWeight;
  @JsonKey(name: "pregnancy_weight_diff")
  var pregnancyWeightDiff;
  @JsonKey(name: "days_till_childbirth")
  int? daysTillChildbirth;
  @JsonKey(name: "allowed_weeks_num")
  int? allowedWeeksNum;
  @JsonKey(name: "normal_weight")
  var normalWeight;
  @JsonKey(name: "weight_difference")
  var weightDifference;
  @JsonKey(name: "diet_days")
  int? dietDays;

  BodyStatus();

  factory BodyStatus.fromJson(Map<String, dynamic> json) => _$BodyStatusFromJson(json);
  Map<String, dynamic> toJson() => _$BodyStatusToJson(this);
}