import 'package:behandam/utils/boolean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'obstructive_disease.g.dart';

@JsonSerializable()
class ObstructiveDisease {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "has_multichoice_children")
  boolean? hasMultiChoiceChildren;

  @JsonKey(name: "categories")
  List<ObstructiveDiseaseCategory>? categories;

  ObstructiveDisease();

  factory ObstructiveDisease.fromJson(Map<String, dynamic> json) => _$ObstructiveDiseaseFromJson(json);

  Map<String, dynamic> toJson() => _$ObstructiveDiseaseToJson(this);
}

@JsonSerializable()
class ObstructiveDiseaseCategory {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  ObstructiveDiseaseCategory();

  factory ObstructiveDiseaseCategory.fromJson(Map<String, dynamic> json) => _$ObstructiveDiseaseCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ObstructiveDiseaseCategoryToJson(this);
}
