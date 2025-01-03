// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitItem _$VisitItemFromJson(Map<String, dynamic> json) => VisitItem()
  ..dietType = $enumDecodeNullable(_$RegimeAliasEnumMap, json['diet_type'])
  ..dietTypeName = json['diet_type_name'] == null
      ? null
      : RegimeTypeName.fromJson(json['diet_type_name'] as Map<String, dynamic>)
  ..physicalInfo = json['physical_info'] == null
      ? null
      : PhysicalInfoData.fromJson(json['physical_info'] as Map<String, dynamic>)
  ..visits = (json['visits'] as List<dynamic>?)
          ?.map((e) => Visit.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..weightDifference = (json['weight_difference'] as num?)?.toDouble();

Map<String, dynamic> _$VisitItemToJson(VisitItem instance) => <String, dynamic>{
      'diet_type': _$RegimeAliasEnumMap[instance.dietType],
      'diet_type_name': instance.dietTypeName,
      'physical_info': instance.physicalInfo,
      'visits': instance.visits,
      'weight_difference': instance.weightDifference,
    };

const _$RegimeAliasEnumMap = {
  RegimeAlias.Pregnancy: 'PREGNANCY',
  RegimeAlias.WeightLoss: 'WEIGHT_LOSS',
  RegimeAlias.WeightGain: 'WEIGHT_GAIN',
  RegimeAlias.Stabilization: 'STABILIZATION',
  RegimeAlias.Diabeties: 'DIABETES',
  RegimeAlias.Ketogenic: 'KETOGENIC',
  RegimeAlias.Sport: 'SPORTS',
  RegimeAlias.Notrica: 'NOTRICA',
};
