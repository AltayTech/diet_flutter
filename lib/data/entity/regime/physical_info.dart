import 'package:json_annotation/json_annotation.dart';
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
  @JsonKey(name: "gender")
  GenderType? gender;
  @JsonKey(name: "multi_birth_num", defaultValue: 1)
  int? multiBirth;
  @JsonKey(name: "pregnancy_week_number", defaultValue: 15)
  int? pregnancyWeek;

  int? kilo;
  int? gram;

  PhysicalInfoData();

  factory PhysicalInfoData.fromJson(Map<String, dynamic> json) => _$PhysicalInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalInfoDataToJson(this);
}