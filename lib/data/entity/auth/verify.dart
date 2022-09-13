import 'package:json_annotation/json_annotation.dart';
part 'verify.g.dart';

@JsonSerializable()
class VerificationCode {
  @JsonKey(name: "mobile")
  String? mobile;
  @JsonKey(name: "channel")
  String? channel;
  @JsonKey(name: "verification_code")
  String? verifyCode;
  @JsonKey(name: "reset_pass")
  bool? resetPass;
  @JsonKey(name: "route_name")
  String? routeName;
  @JsonKey(name: "country_id")
  int? countryId;

  VerificationCode();

  factory VerificationCode.fromJson(Map<String, dynamic> json) => _$VerificationCodeFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationCodeToJson(this);
}

@JsonSerializable()
class VerifyOutput {
  @JsonKey(name: "verified")
  bool? verified;
  @JsonKey(name: "token")
  String? token;


  VerifyOutput();

  factory VerifyOutput.fromJson(Map<String, dynamic> json) => _$VerifyOutputFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOutputToJson(this);
}