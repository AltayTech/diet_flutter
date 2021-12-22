// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionData _$VersionDataFromJson(Map<String, dynamic> json) => VersionData()
  ..ios = json['ios'] == null
      ? null
      : Version.fromJson(json['ios'] as Map<String, dynamic>)
  ..android = json['android'] == null
      ? null
      : Version.fromJson(json['android'] as Map<String, dynamic>);

Map<String, dynamic> _$VersionDataToJson(VersionData instance) =>
    <String, dynamic>{
      'ios': instance.ios,
      'android': instance.android,
    };

Version _$VersionFromJson(Map<String, dynamic> json) => Version()
  ..versionCode = json['version_code'] as String?
  ..forceUpdate = json['force_update'] as int?
  ..forceUpdateVersion = json['force_update_version'] as int? ?? 1
  ..title = json['title'] as String?
  ..versionName = json['version_name'] as String?
  ..description = json['description'] as String?
  ..iapps = json['iapps'] as String?
  ..sibapp = json['sibapp'] as String?
  ..google = json['google'] as String?;

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'version_code': instance.versionCode,
      'force_update': instance.forceUpdate,
      'force_update_version': instance.forceUpdateVersion,
      'title': instance.title,
      'version_name': instance.versionName,
      'description': instance.description,
      'iapps': instance.iapps,
      'sibapp': instance.sibapp,
      'google': instance.google,
    };
