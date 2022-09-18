import 'package:json_annotation/json_annotation.dart';
part 'body_status.g.dart';

@JsonSerializable()
class BodyStatus {
  @JsonKey(name: "bmi")
  double? bmi;
  @JsonKey(name: "bmi_status")
  int? bmiStatus;
  @JsonKey(name: "is_pregnancy")
  int? isPregnancy;
  @JsonKey(name: "pregnancy_ideal_weight")
  double? pregnancyWeight;
  @JsonKey(name: "pregnancy_weight_diff")
  double? pregnancyWeightDiff;
  @JsonKey(name: "days_till_childbirth")
  int? daysTillChildbirth;
  @JsonKey(name: "allowed_weeks_num")
  int? allowedWeeksNum;
  @JsonKey(name: "normal_weight")
  double? normalWeight;
  @JsonKey(name: "weight_difference")
  double? weightDifference;
  @JsonKey(name: "diet_days")
  int? dietDays;
  @JsonKey(name: "weight", defaultValue: 0)
  double? weight;
  @JsonKey(name: "height", defaultValue: 0)
  int? height;
  @JsonKey(name: "birth_date")
  String? birthDate;

  BodyStatus();

  factory BodyStatus.fromJson(Map<String, dynamic> json) => _$BodyStatusFromJson(json);
  Map<String, dynamic> toJson() => _$BodyStatusToJson(this);
}