// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Help _$HelpFromJson(Map<String, dynamic> json) => Help()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..helpers = (json['helpers'] as List<dynamic>?)
      ?.map((e) => Help.fromJson(e as Map<String, dynamic>))
      .toList()
  ..media = (json['media'] as List<dynamic>?)
      ?.map((e) => Help.fromJson(e as Map<String, dynamic>))
      .toList()
  ..createdAt = json['created_at'] as String?
  ..updatedAt = json['updated_at'] as String?
  ..modelId = json['model_id'] as int?
  ..modelType = json['model_type'] as String?
  ..order = json['order'] as int?
  ..body = json['body'] as String?
  ..url = json['url'] as String?;

Map<String, dynamic> _$HelpToJson(Help instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'helpers': instance.helpers,
      'media': instance.media,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'model_id': instance.modelId,
      'model_type': instance.modelType,
      'order': instance.order,
      'body': instance.body,
      'url': instance.url,
    };
