// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitItem _$VisitItemFromJson(Map<String, dynamic> json) => VisitItem()
  ..dietType = $enumDecodeNullable(_$RegimeAliasEnumMap, json['diet_type'])
  ..physicalInfo = json['physical_info'] == null
      ? null
      : PhysicalInfoData.fromJson(json['physical_info'] as Map<String, dynamic>)
  ..visits = json['visits'] as List<dynamic>?
  ..weightDifference = (json['weight_difference'] as num?)?.toDouble();

Map<String, dynamic> _$VisitItemToJson(VisitItem instance) => <String, dynamic>{
      'diet_type': _$RegimeAliasEnumMap[instance.dietType],
      'physical_info': instance.physicalInfo,
      'visits': instance.visits,
      'weight_difference': instance.weightDifference,
    };

const _$RegimeAliasEnumMap = {
  RegimeAlias.Pregnansy: 'PREGNANCY',
  RegimeAlias.WeightLoss: 'WEIGHT_LOSS',
  RegimeAlias.WeightGain: 'WEIGHT_GAIN',
  RegimeAlias.Stabilization: 'STABILIZATION',
  RegimeAlias.Diabeties: 'DIABETES',
  RegimeAlias.Ketogenic: 'KETOGENIC',
  RegimeAlias.Sport: 'SPORTS',
  RegimeAlias.Notrica: 'NOTRICA',
};
