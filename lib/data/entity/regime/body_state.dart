import 'package:json_annotation/json_annotation.dart';
part 'body_state.g.dart';

enum GenderType {
@JsonValue(0)
Female,
@JsonValue(1)
Male,
}

@JsonSerializable()
class BodyState {
  @JsonKey(name: "weight")
  var weight;
  @JsonKey(name: "height")
  var height;
  @JsonKey(name: "wrist")
  var wrist;
  @JsonKey(name: "waist")
  var waist;
  @JsonKey(name: "birth_date")
  String? birthDate;
  @JsonKey(name: "hip")
  var hip;
  @JsonKey(name: "bfp")
  var bfp;
  @JsonKey(name: "bmi")
  var bmi;
  @JsonKey(name: "whr")
  var whr;
  @JsonKey(name: "gender")
  GenderType? gender;
  @JsonKey(name: "multi_birth_num")
  var multiBirth;
  @JsonKey(name: "pregnancy_week_number")
  var pregnancyWeek;



  BodyState();

  factory BodyState.fromJson(Map<String, dynamic> json) => _$BodyStateFromJson(json);
  Map<String, dynamic> toJson() => _$BodyStateToJson(this);
}