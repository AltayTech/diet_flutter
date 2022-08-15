import 'package:behandam/utils/boolean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sickness.g.dart';

@JsonSerializable()
class Sickness {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "has_multichoice_children")
  boolean? hasMultiChoiceChildren;

  @JsonKey(name: "categories")
  List<SicknessCategory>? categories;

  Sickness();

  factory Sickness.fromJson(Map<String, dynamic> json) => _$SicknessFromJson(json);

  Map<String, dynamic> toJson() => _$SicknessToJson(this);
}

@JsonSerializable()
class SicknessCategory {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  SicknessCategory();

  factory SicknessCategory.fromJson(Map<String, dynamic> json) => _$SicknessCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SicknessCategoryToJson(this);
}
