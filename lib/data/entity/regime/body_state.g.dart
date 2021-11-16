// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyState _$BodyStateFromJson(Map<String, dynamic> json) => BodyState()
  ..weight = json['weight']
  ..height = json['height']
  ..wrist = json['wrist']
  ..waist = json['waist']
  ..birthDate = json['birth_date'] as String?
  ..hip = json['hip']
  ..bfp = json['bfp']
  ..bmi = json['bmi']
  ..whr = json['whr']
  ..gender = $enumDecodeNullable(_$GenderTypeEnumMap, json['gender'])
  ..multiBirth = json['multi_birth_num']
  ..pregnancyWeek = json['pregnancy_week_number'];

Map<String, dynamic> _$BodyStateToJson(BodyState instance) => <String, dynamic>{
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
    };

const _$GenderTypeEnumMap = {
  GenderType.Female: 0,
  GenderType.Male: 1,
};
