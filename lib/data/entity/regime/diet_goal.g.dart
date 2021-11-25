// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietGoalData _$DietGoalDataFromJson(Map<String, dynamic> json) => DietGoalData(
      (json['items'] as List<dynamic>)
          .map((e) => DietGoal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

DietGoal _$DietGoalFromJson(Map<String, dynamic> json) => DietGoal(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String?,
    );
