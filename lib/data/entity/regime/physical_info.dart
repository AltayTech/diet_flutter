import 'package:json_annotation/json_annotation.dart';

import 'regime_type.dart';

part 'physical_info.g.dart';

enum GenderType {
  @JsonValue(0)
  Female,
  @JsonValue(1)
  Male,
}

@JsonSerializable()
class PhysicalInfoData {
  @JsonKey(name: "weight", defaultValue: 70.5)
  double? weight;
  @JsonKey(name: "height", defaultValue: 170)
  int? height;
  @JsonKey(name: "wrist", defaultValue: 20)
  int? wrist;
  @JsonKey(name: "waist")
  int? waist;
  @JsonKey(name: "birth_date")
  String? birthDate;
  @JsonKey(name: "hip")
  int? hip;
  @JsonKey(name: "bfp")
  double? bfp;
  @JsonKey(name: "bmi")
  double? bmi;
  @JsonKey(name: "whr")
  double? whr;
  @JsonKey(name: "gender", defaultValue: GenderType.Female)
  GenderType? gender;
  @JsonKey(name: "multi_birth_num", defaultValue: 1)
  int? multiBirth;
  @JsonKey(name: "pregnancy_week_number", defaultValue: 15)
  int? pregnancyWeek;
  @JsonKey(name: "target_weight")
  double? targetWeight;
  @JsonKey(name: "age")
  int? age;
  @JsonKey(name: "pregnancy_ideal_weight")
  double? pregnancyIdealWeight;
  @JsonKey(name: "ideal_weight_based_on_perv_visit")
  double? idealWeightBasedOnPervVisit;
  @JsonKey(name: "days_till_childbirth")
  int? daysTillChildbirth;
  @JsonKey(name: "diet_type_alias")
  RegimeAlias? dietTypeAlias;

  @JsonKey(name: "need_to_call", defaultValue: false)
  bool? needToCall;

  int? kilo;
  int? gram;
  bool? isForbidden = false;
  bool? mustGetNotrica = false;

  PhysicalInfoData();

  factory PhysicalInfoData.fromJson(Map<String, dynamic> json) => _$PhysicalInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalInfoDataToJson(this);
}
