import 'package:json_annotation/json_annotation.dart';
part 'register.g.dart';

@JsonSerializable()
class Register {
  @JsonKey(name: "first_name")
  String? firstName;
  @JsonKey(name: "last_name")
  String? lastName;
  @JsonKey(name: "mobile")
  String? mobile;
  @JsonKey(name: "password")
  String? password;
  @JsonKey(name: "code")
  String? verifyCode;
  @JsonKey(name: "gender")
  bool? gender;
  @JsonKey(name: "country_id")
  int? countryId;
  @JsonKey(name: "app_id")
  String? appId;
  // @JsonKey(name: "route_name")
  // String? routeName;

  Register();

  factory Register.fromJson(Map<String, dynamic> json) => _$RegisterFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterToJson(this);
}

@JsonSerializable()
class RegisterOutput {
  @JsonKey(name: "token")
  String? token;

  RegisterOutput();

  factory RegisterOutput.fromJson(Map<String, dynamic> json) => _$RegisterOutputFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterOutputToJson(this);
}