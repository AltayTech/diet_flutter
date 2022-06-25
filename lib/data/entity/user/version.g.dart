// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version()
  ..versionCode = json['version_code'] as String?
  ..forceUpdate = json['force_update'] as bool?
  ..forceUpdateVersion = json['force_version_code'] as String? ?? '100'
  ..title = json['title'] as String?
  ..versionName = json['version_name'] as String?
  ..description = json['description'] as String?
  ..url = json['url'] as String?;

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'version_code': instance.versionCode,
      'force_update': instance.forceUpdate,
      'force_version_code': instance.forceUpdateVersion,
      'title': instance.title,
      'version_name': instance.versionName,
      'description': instance.description,
      'url': instance.url,
    };
