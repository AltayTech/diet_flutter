// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetWeight _$TargetWeightFromJson(Map<String, dynamic> json) => TargetWeight()
  ..askToChangeTargetWeight = json['ask_to_change_target_weight'] as bool?
  ..bmiDiff = (json['bmi_diff'] as num?)?.toDouble()
  ..bodyStatus = json['body_status'] == null
      ? null
      : BodyStatusTarget.fromJson(json['body_status'] as Map<String, dynamic>)
  ..targetWeight = (json['target_weight'] as num?)?.toDouble()
  ..weight = (json['weight'] as num?)?.toDouble();

BodyStatusTarget _$BodyStatusTargetFromJson(Map<String, dynamic> json) =>
    BodyStatusTarget(
      json['title'] as String?,
      json['description'] as String?,
    );
