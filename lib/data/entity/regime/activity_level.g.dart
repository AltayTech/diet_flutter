// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityLevelData _$ActivityLevelDataFromJson(Map<String, dynamic> json) =>
    ActivityLevelData(
      (json['items'] as List<dynamic>)
          .map((e) => ActivityData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) => ActivityData(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String?,
    );
