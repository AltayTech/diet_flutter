// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalInfoData _$PhysicalInfoDataFromJson(Map<String, dynamic> json) =>
    PhysicalInfoData()
      ..weight = (json['weight'] as num?)?.toDouble() ?? 70.5
      ..height = json['height'] as int? ?? 170
      ..wrist = json['wrist'] as int? ?? 20
      ..waist = json['waist'] as int?
      ..birthDate = json['birth_date'] as String?
      ..hip = json['hip'] as int?
      ..bfp = (json['bfp'] as num?)?.toDouble()
      ..bmi = (json['bmi'] as num?)?.toDouble()
      ..whr = (json['whr'] as num?)?.toDouble()
      ..gender = $enumDecodeNullable(_$GenderTypeEnumMap, json['gender'])
      ..multiBirth = json['multi_birth_num'] as int? ?? 1
      ..pregnancyWeek = json['pregnancy_week_number'] as int? ?? 15
      ..targetWeight = (json['target_weight'] as num?)?.toDouble()
      ..kilo = json['kilo'] as int?
      ..gram = json['gram'] as int?;

Map<String, dynamic> _$PhysicalInfoDataToJson(PhysicalInfoData instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'height': instance.height,
      'wrist': instance.wrist,
      'waist': instance.waist,
      'birth_date': instance.birthDate,
      'hip': instance.hip,
      'bfp': instance.bfp,
      'bmi': instance.bmi,
      'whr': instance.whr,
      'gender': _$GenderTypeEnumMap[instance.gender],
      'multi_birth_num': instance.multiBirth,
      'pregnancy_week_number': instance.pregnancyWeek,
      'target_weight': instance.targetWeight,
      'kilo': instance.kilo,
      'gram': instance.gram,
    };

const _$GenderTypeEnumMap = {
  GenderType.Female: 0,
  GenderType.Male: 1,
};
