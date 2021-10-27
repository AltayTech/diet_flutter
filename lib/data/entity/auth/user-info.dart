import 'package:json_annotation/json_annotation.dart';
part 'user-info.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "mobile")
  String? mobile;
  @JsonKey(name: "password")
  String? password;
  @JsonKey(name: "verification_code")
  String? code;
  @JsonKey(name: "route_name")
  String? routeName;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}