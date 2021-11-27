// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverviewData _$OverviewDataFromJson(Map<String, dynamic> json) => OverviewData(
      json['id'] as int?,
      json['activity_level'] == null
          ? null
          : ActivityData.fromJson(
              json['activity_level'] as Map<String, dynamic>),
      json['diet_goal'] == null
          ? null
          : DietGoal.fromJson(json['diet_goal'] as Map<String, dynamic>),
      json['diet_history'] == null
          ? null
          : DietHistory.fromJson(json['diet_history'] as Map<String, dynamic>),
    );
