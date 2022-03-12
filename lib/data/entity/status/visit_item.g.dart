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
  ..terms = (json['terms'] as List<dynamic>?)
          ?.map((e) => TermStatus.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..weightDifference = (json['weight_difference'] as num?)?.toDouble();

const _$RegimeAliasEnumMap = {
  RegimeAlias.Pregnancy: 'PREGNANCY',
  RegimeAlias.WeightLoss: 'WEIGHT_LOSS',
  RegimeAlias.WeightGain: 'WEIGHT_GAIN',
  RegimeAlias.Stabilization: 'STABILIZATION',
  RegimeAlias.Diabeties: 'DIABETES',
  RegimeAlias.Ketogenic: 'KETOGENIC',
  RegimeAlias.Sport: 'SPORTS',
  RegimeAlias.Notrica: 'NOTRICA',
  RegimeAlias.WeightStabilization: 'WEIGHT_STABILIZATION',
};

TermStatus _$TermStatusFromJson(Map<String, dynamic> json) => TermStatus()
  ..startedAt = json['started_at'] as String
  ..expiredAt = json['expired_at'] as String
  ..isActive = json['is_active'] as int?
  ..visits = (json['visits'] as List<dynamic>?)
      ?.map((e) => VisitStatus.fromJson(e as Map<String, dynamic>))
      .toList();

VisitStatus _$VisitStatusFromJson(Map<String, dynamic> json) => VisitStatus()
  ..weight = (json['weight'] as num).toDouble()
  ..visitedAt = json['visited_at'] as String;
