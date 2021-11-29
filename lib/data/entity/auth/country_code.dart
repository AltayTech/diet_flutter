import 'package:json_annotation/json_annotation.dart';
part 'country_code.g.dart';

@JsonSerializable()
class CountryCode {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "code")
  String? code;
  @JsonKey(name: "iso_code")
  String? isoCode;
  @JsonKey(name: "iso3")
  String? iso3;

  CountryCode();

  factory CountryCode.fromJson(Map<String, dynamic> json) => _$CountryCodeFromJson(json);
  Map<String, dynamic> toJson() => _$CountryCodeToJson(this);
}