// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMessageTemplate _$DailyMessageTemplateFromJson(
        Map<String, dynamic> json) =>
    DailyMessageTemplate()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..data = (json['data'] as List<dynamic>?)
          ?.map((e) => TemplateData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$DailyMessageTemplateToJson(
        DailyMessageTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'data': instance.data,
    };

TemplateData _$TemplateDataFromJson(Map<String, dynamic> json) => TemplateData()
  ..id = json['id'] as int?
  ..templateId = json['template_id'] as int?
  ..alterText = json['alter_text'] as String?
  ..order = json['order'] as int?
  ..media = (json['media'] as List<dynamic>?)
      ?.map((e) => TemplateMedia.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TemplateDataToJson(TemplateData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'template_id': instance.templateId,
      'alter_text': instance.alterText,
      'order': instance.order,
      'media': instance.media,
    };

TemplateMedia _$TemplateMediaFromJson(Map<String, dynamic> json) =>
    TemplateMedia()
      ..id = json['id'] as int?
      ..name = json['name'] as String?
      ..fileName = json['file_name'] as String?
      ..mimeType = json['mime_type'] as String?
      ..size = json['size'] as int?
      ..mediumUrls = json['medium_urls'] == null
          ? null
          : Url.fromJson(json['medium_urls'] as Map<String, dynamic>)
      ..mediumType = json['medium_type'] as int?;

Map<String, dynamic> _$TemplateMediaToJson(TemplateMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'medium_urls': instance.mediumUrls,
      'medium_type': instance.mediumType,
    };

Conversions _$ConversionsFromJson(Map<String, dynamic> json) => Conversions()
  ..small = json['small'] as bool?
  ..medium = json['medium'] as bool?;

Map<String, dynamic> _$ConversionsToJson(Conversions instance) =>
    <String, dynamic>{
      'small': instance.small,
      'medium': instance.medium,
    };

Url _$UrlFromJson(Map<String, dynamic> json) =>
    Url()..url = json['url'] as String?;

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'url': instance.url,
    };
