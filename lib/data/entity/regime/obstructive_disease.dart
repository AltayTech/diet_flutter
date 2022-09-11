import 'package:json_annotation/json_annotation.dart';

part 'obstructive_disease.g.dart';

@JsonSerializable()
class ObstructiveDisease {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  @JsonKey(name: "diseases_ids")
  List<dynamic>? diseasesIds;

  ObstructiveDisease();

  factory ObstructiveDisease.fromJson(Map<String, dynamic> json) =>
      _$ObstructiveDiseaseFromJson(json);

  Map<String, dynamic> toJson() => _$ObstructiveDiseaseToJson(this);
}

@JsonSerializable()
class ObstructiveDiseaseCategory {
  @JsonKey(name: "disease_categories")
  List<ObstructiveDiseaseCategory>? diseaseCategories;

  @JsonKey(name: "user_disease_ids")
  List<int>? userDiseaseIds;

  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "category_id")
  int? categoryId;

  @JsonKey(name: "disease_id", defaultValue: -1)
  late int disease_id;

  @JsonKey(name: "category_type")
  int? categoryType;

  @JsonKey(name: "category_title")
  String? title;

  @JsonKey(name: "has_multichoice_children")
  bool? hasMultiChoiceChildren;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  @JsonKey(name: "diseases")
  List<ObstructiveDisease>? diseases;

  ObstructiveDiseaseCategory();

  factory ObstructiveDiseaseCategory.fromJson(Map<String, dynamic> json) =>
      _$ObstructiveDiseaseCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ObstructiveDiseaseCategoryToJson(this);
}
