// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietPreferences _$DietPreferencesFromJson(Map<String, dynamic> json) =>
    DietPreferences()
      ..activityLevels = (json['activity_levels'] as List<dynamic>?)
          ?.map((e) => ActivityData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..dietHistories = (json['diet_histories'] as List<dynamic>?)
          ?.map((e) => DietHistory.fromJson(e as Map<String, dynamic>))
          .toList()
      ..dietGoal = (json['diet_goals'] as List<dynamic>?)
          ?.map((e) => DietGoal.fromJson(e as Map<String, dynamic>))
          .toList();
