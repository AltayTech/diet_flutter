import 'package:json_annotation/json_annotation.dart';
part 'user_crm.g.dart';

@JsonSerializable()
class UserCrm {
  @JsonKey(name: "mobile")
  String? mobile;
  @JsonKey(name: "first_name")
  String? firstName;
  @JsonKey(name: "last_name")
  String? lastName;
  @JsonKey(name: "topic")
  int? topic;
  @JsonKey(name: "repository")
  int? repository;
  @JsonKey(name: "country")
  String? country;

  UserCrm();

  factory UserCrm.fromJson(Map<String, dynamic> json) => _$UserCrmFromJson(json);

  Map<String, dynamic> toJson() => _$UserCrmToJson(this);
}

@JsonSerializable()
class UserCrmResponse {
  @JsonKey(name: "message")
  String? message;

  UserCrmResponse();

  factory UserCrmResponse.fromJson(Map<String, dynamic> json) => _$UserCrmResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserCrmResponseToJson(this);
}
