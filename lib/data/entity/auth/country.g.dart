// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..code = json['code'] as String?
  ..isoCode = json['iso_code'] as String?
  ..iso3 = json['iso3'] as String?
  ..flag = json['flag'] as String?;

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'iso_code': instance.isoCode,
      'iso3': instance.iso3,
      'flag': instance.flag,
    };
