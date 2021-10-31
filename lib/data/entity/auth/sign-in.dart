import 'package:json_annotation/json_annotation.dart';
part 'sign-in.g.dart';

@JsonSerializable()
class SignIn {
  @JsonKey(name: "token")
  String? token;

  SignIn();

  factory SignIn.fromJson(Map<String, dynamic> json) => _$SignInFromJson(json);
  Map<String, dynamic> toJson() => _$SignInToJson(this);
}