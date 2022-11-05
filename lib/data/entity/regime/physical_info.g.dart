// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalInfoData _$PhysicalInfoDataFromJson(Map<String, dynamic> json) =>
    PhysicalInfoData()
      ..weight = (json['weight'] as num?)?.toDouble() ?? 0
      ..height = json['height'] as int? ?? 0
      ..waist = json['waist'] as int?
      ..birthDate = json['birth_date'] as String?
      ..hip = json['hip'] as int?
      ..bfp = (json['bfp'] as num?)?.toDouble()
      ..bmi = (json['bmi'] as num?)?.toDouble()
      ..whr = (json['whr'] as num?)?.toDouble()
      ..gender = $enumDecodeNullable(_$GenderTypeEnumMap, json['gender']) ??
          GenderType.Female
      ..multiBirth = json['multi_birth_num'] as int? ?? 1
      ..pregnancyWeek = json['pregnancy_week_number'] as int? ?? 15
      ..targetWeight = (json['target_weight'] as num?)?.toDouble()
      ..age = json['age'] as int?
      ..pregnancyIdealWeight =
          (json['pregnancy_ideal_weight'] as num?)?.toDouble()
      ..idealWeightBasedOnPervVisit =
          (json['ideal_weight_based_on_perv_visit'] as num?)?.toDouble()
      ..daysTillChildbirth = json['days_till_childbirth'] as int?
      ..dietTypeAlias =
          $enumDecodeNullable(_$RegimeAliasEnumMap, json['diet_type_alias'])
      ..needToCall = json['need_to_call'] as bool? ?? false
      ..kilo = json['kilo'] as int?
      ..gram = json['gram'] as int?
      ..isForbidden = json['isForbidden'] as bool?
      ..mustGetNotrica = json['mustGetNotrica'] as bool?;

Map<String, dynamic> _$PhysicalInfoDataToJson(PhysicalInfoData instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'height': instance.height,
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
      'age': instance.age,
      'pregnancy_ideal_weight': instance.pregnancyIdealWeight,
      'ideal_weight_based_on_perv_visit': instance.idealWeightBasedOnPervVisit,
      'days_till_childbirth': instance.daysTillChildbirth,
      'diet_type_alias': _$RegimeAliasEnumMap[instance.dietTypeAlias],
      'need_to_call': instance.needToCall,
      'kilo': instance.kilo,
      'gram': instance.gram,
      'isForbidden': instance.isForbidden,
      'mustGetNotrica': instance.mustGetNotrica,
    };

const _$GenderTypeEnumMap = {
  GenderType.Female: 0,
  GenderType.Male: 1,
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
  RegimeAlias.WeightStabilization: 'WEIGHT_STABILIZATION',
};
