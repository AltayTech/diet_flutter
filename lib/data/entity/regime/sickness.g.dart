// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sickness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sickness _$SicknessFromJson(Map<String, dynamic> json) => Sickness()
  ..id = json['id'] as int?
  ..title = json['title'] as int?
  ..hasMultiChoiceChildren =
      $enumDecodeNullable(_$booleanEnumMap, json['has_multichoice_children'])
  ..categories = (json['categories'] as List<dynamic>?)
      ?.map((e) => SicknessCategory.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$SicknessToJson(Sickness instance) => <String, dynamic>{
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

SicknessCategory _$SicknessCategoryFromJson(Map<String, dynamic> json) =>
    SicknessCategory()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..isSelected = json['selected'] as bool? ?? false;

Map<String, dynamic> _$SicknessCategoryToJson(SicknessCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'selected': instance.isSelected,
    };
