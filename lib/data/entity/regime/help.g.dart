// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Help _$HelpFromJson(Map<String, dynamic> json) => Help()
  ..id = json['id'] as int?
  ..helpers = (json['helpers'] as List<dynamic>?)
      ?.map((e) => Help.fromJson(e as Map<String, dynamic>))
      .toList()
  ..body = json['body'] as String?
  ..createdAt = json['created_at'] as String?
  ..modelId = json['model_id'] as int?
  ..modelType = json['model_type'] as String?
  ..order = json['order'] as int?
  ..updatedAt = json['updated_at'] as String?;

Map<String, dynamic> _$HelpToJson(Help instance) => <String, dynamic>{
      'id': instance.id,
      'helpers': instance.helpers,
      'body': instance.body,
      'created_at': instance.createdAt,
      'model_id': instance.modelId,
      'model_type': instance.modelType,
      'order': instance.order,
      'updated_at': instance.updatedAt,
    };
