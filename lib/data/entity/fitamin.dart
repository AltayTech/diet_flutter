import 'package:json_annotation/json_annotation.dart';
part 'fitamin.g.dart';

@JsonSerializable()
class Fitamin {
  @JsonKey(name: "url")
  String? url;

  Fitamin();

  factory Fitamin.fromJson(Map<String, dynamic> json) => _$FitaminFromJson(json);
  Map<String, dynamic> toJson() => _$FitaminToJson(this);
}