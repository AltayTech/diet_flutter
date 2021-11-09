// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FastPatternData _$FastPatternDataFromJson(Map<String, dynamic> json) =>
    FastPatternData(
      json['alias'] as String,
      json['description'] as String,
      json['title'] as String,
    )..id = json['id'] as int?;

FastMenuRequestData _$FastMenuRequestDataFromJson(Map<String, dynamic> json) =>
    FastMenuRequestData()
      ..date = json['date'] as String?
      ..id = json['id'] as int?
      ..isFasting = json['is_fasting'] as bool?
      ..patternId = json['pattern_index'] as int?
      ..userId = json['user_id'] as int?;

Map<String, dynamic> _$FastMenuRequestDataToJson(
        FastMenuRequestData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'id': instance.id,
      'is_fasting': instance.isFasting,
      'pattern_index': instance.patternId,
      'user_id': instance.userId,
    };
