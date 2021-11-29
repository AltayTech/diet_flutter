// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryCode _$CountryCodeFromJson(Map<String, dynamic> json) => CountryCode()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..code = json['code'] as String?
  ..isoCode = json['iso_code'] as String?
  ..iso3 = json['iso3'] as String?;

Map<String, dynamic> _$CountryCodeToJson(CountryCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'iso_code': instance.isoCode,
      'iso3': instance.iso3,
    };
