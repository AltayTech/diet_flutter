// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obstructive_disease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObstructiveDisease _$ObstructiveDiseaseFromJson(Map<String, dynamic> json) =>
    ObstructiveDisease()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..hasMultiChoiceChildren = $enumDecodeNullable(
          _$booleanEnumMap, json['has_multichoice_children'])
      ..categories = (json['categories'] as List<dynamic>?)
          ?.map((e) =>
              ObstructiveDiseaseCategory.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ObstructiveDiseaseToJson(ObstructiveDisease instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'has_multichoice_children':
          _$booleanEnumMap[instance.hasMultiChoiceChildren],
      'categories': instance.categories,
    };

const _$booleanEnumMap = {
  boolean.False: 0,
  boolean.True: 1,
};

ObstructiveDiseaseCategory _$ObstructiveDiseaseCategoryFromJson(
        Map<String, dynamic> json) =>
    ObstructiveDiseaseCategory()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..isSelected = json['selected'] as bool? ?? false;

Map<String, dynamic> _$ObstructiveDiseaseCategoryToJson(
        ObstructiveDiseaseCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'selected': instance.isSelected,
    };
