// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyStatus _$BodyStatusFromJson(Map<String, dynamic> json) => BodyStatus()
  ..bmi = (json['bmi'] as num?)?.toDouble()
  ..bmiStatus = json['bmi_status'] as int?
  ..isPregnancy = json['is_pregnancy'] as int?
  ..pregnancyWeight = (json['pregnancy_ideal_weight'] as num?)?.toDouble()
  ..pregnancyWeightDiff = (json['pregnancy_weight_diff'] as num?)?.toDouble()
  ..daysTillChildbirth = json['days_till_childbirth'] as int?
  ..allowedWeeksNum = json['allowed_weeks_num'] as int?
  ..normalWeight = (json['normal_weight'] as num?)?.toDouble()
  ..weightDifference = (json['weight_difference'] as num?)?.toDouble()
  ..dietDays = json['diet_days'] as int?
  ..weight = (json['weight'] as num?)?.toDouble() ?? 0
  ..height = json['height'] as int? ?? 0
  ..birthDate = json['birth_date'] as String?;

Map<String, dynamic> _$BodyStatusToJson(BodyStatus instance) =>
    <String, dynamic>{
      'bmi': instance.bmi,
      'bmi_status': instance.bmiStatus,
      'is_pregnancy': instance.isPregnancy,
      'pregnancy_ideal_weight': instance.pregnancyWeight,
      'pregnancy_weight_diff': instance.pregnancyWeightDiff,
      'days_till_childbirth': instance.daysTillChildbirth,
      'allowed_weeks_num': instance.allowedWeeksNum,
      'normal_weight': instance.normalWeight,
      'weight_difference': instance.weightDifference,
      'diet_days': instance.dietDays,
      'weight': instance.weight,
      'height': instance.height,
      'birth_date': instance.birthDate,
    };
