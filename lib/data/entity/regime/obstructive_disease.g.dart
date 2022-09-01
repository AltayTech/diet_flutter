// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obstructive_disease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObstructiveDisease _$ObstructiveDiseaseFromJson(Map<String, dynamic> json) =>
    ObstructiveDisease()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..isSelected = json['selected'] as bool? ?? false
      ..diseasesIds = json['diseases_ids'] as List<dynamic>?;

Map<String, dynamic> _$ObstructiveDiseaseToJson(ObstructiveDisease instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'selected': instance.isSelected,
      'diseases_ids': instance.diseasesIds,
    };

ObstructiveDiseaseCategory _$ObstructiveDiseaseCategoryFromJson(
        Map<String, dynamic> json) =>
    ObstructiveDiseaseCategory()
      ..id = json['id'] as int?
      ..categoryId = json['category_id'] as int?
      ..categoryType = json['category_type'] as int?
      ..title = json['category_title'] as String?
      ..hasMultiChoiceChildren = json['has_multichoice_children'] as bool?
      ..isSelected = json['selected'] as bool? ?? false
      ..diseases = (json['diseases'] as List<dynamic>?)
          ?.map((e) => ObstructiveDisease.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ObstructiveDiseaseCategoryToJson(
        ObstructiveDiseaseCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'category_type': instance.categoryType,
      'category_title': instance.title,
      'has_multichoice_children': instance.hasMultiChoiceChildren,
      'selected': instance.isSelected,
      'diseases': instance.diseases,
    };