import 'package:json_annotation/json_annotation.dart';
part 'regime_type.g.dart';

@JsonSerializable()
class RegimeType {
  @JsonKey(name: "count")
  int? count;
  @JsonKey(name: "items")
  List<RegimeType>? items;
  @JsonKey(name: "alias")
  String? alias;
  @JsonKey(name: "calories_count")
  int? caloriesCount;
  @JsonKey(name: "is_active")
  String? isActive;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "meals_count")
  int? mealsCount;
  @JsonKey(name: "title")
  String? title;

  RegimeType();

  factory RegimeType.fromJson(Map<String, dynamic> json) => _$RegimeTypeFromJson(json);
  Map<String, dynamic> toJson() => _$RegimeTypeToJson(this);
}