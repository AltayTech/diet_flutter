import 'package:json_annotation/json_annotation.dart';
part 'country-code.g.dart';

@JsonSerializable()
class CountryCode {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "code")
  String? code;

  CountryCode();

  factory CountryCode.fromJson(Map<String, dynamic> json) => _$CountryCodeFromJson(json);
  Map<String, dynamic> toJson() => _$CountryCodeToJson(this);
}