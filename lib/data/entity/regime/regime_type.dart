import 'package:behandam/base/utils.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'regime_type.g.dart';

@JsonSerializable()
class RegimeType {
  @JsonKey(name: "count")
  int? count;
  @JsonKey(name: "items")
  List<RegimeType>? items;
  @JsonKey(name: "alias")
  RegimeAlias? alias;
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
  @JsonKey(name: "diet_type_id")
  int? dietId;

  RegimeType();

  bool get isActiveItem => isActive == '1';

  Color get color => Utils.getColor(alias);

  String get icon => Utils.getIcon(alias);

  factory RegimeType.fromJson(Map<String, dynamic> json) =>
      _$RegimeTypeFromJson(json);

  Map<String, dynamic> toJson() => _$RegimeTypeToJson(this);
}

enum RegimeAlias {
  @JsonValue("PREGNANCY")
  Pregnansy,
  @JsonValue("WEIGHT_LOSS")
  WeightLoss,
  @JsonValue("WEIGHT_GAIN")
  WeightGain,
  @JsonValue("STABILIZATION")
  Stabilization,
  @JsonValue("DIABETES")
  Diabeties,
  @JsonValue("KETOGENIC")
  Ketogenic,
  @JsonValue("SPORTS")
  Sport,
  @JsonValue("NOTRICA")
  Notrica,
}
