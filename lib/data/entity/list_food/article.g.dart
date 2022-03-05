// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleVideo _$ArticleVideoFromJson(Map<String, dynamic> json) => ArticleVideo()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..date = json['date'] as String?;

Map<String, dynamic> _$ArticleVideoToJson(ArticleVideo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
    };

TimeRequest _$TimeRequestFromJson(Map<String, dynamic> json) => TimeRequest()
  ..started_at = json['started_at'] as String?
  ..expired_at = json['expired_at'] as String?;

Map<String, dynamic> _$TimeRequestToJson(TimeRequest instance) =>
    <String, dynamic>{
      'started_at': instance.started_at,
      'expired_at': instance.expired_at,
    };
