import 'package:json_annotation/json_annotation.dart';
part 'reset.g.dart';

@JsonSerializable()
class Reset {
  @JsonKey(name: "password")
  String? password;

  Reset();

  factory Reset.fromJson(Map<String, dynamic> json) => _$ResetFromJson(json);
  Map<String, dynamic> toJson() => _$ResetToJson(this);
}

@JsonSerializable()
class ResetOutput {
  @JsonKey(name: "token")
  String? token;

  ResetOutput();

  factory ResetOutput.fromJson(Map<String, dynamic> json) => _$ResetOutputFromJson(json);
  Map<String, dynamic> toJson() => _$ResetOutputToJson(this);
}