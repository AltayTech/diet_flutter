// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_provice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityProvinceModel _$CityProvinceModelFromJson(Map<String, dynamic> json) =>
    CityProvinceModel()
      ..allCities = (json['cities'] as List<dynamic>)
          .map((e) => CityProvince.fromJson(e as Map<String, dynamic>))
          .toList()
      ..provinces = (json['provinces'] as List<dynamic>)
          .map((e) => CityProvince.fromJson(e as Map<String, dynamic>))
          .toList()
      ..cities = (json['all_cities'] as List<dynamic>?)
          ?.map((e) => CityProvince.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CityProvinceModelToJson(CityProvinceModel instance) =>
    <String, dynamic>{
      'cities': instance.allCities,
      'provinces': instance.provinces,
      'all_cities': instance.cities,
    };

CityProvince _$CityProvinceFromJson(Map<String, dynamic> json) => CityProvince()
  ..name = json['name'] as String?
  ..id = json['id'] as int
  ..provinceId = json['province_id'] as int?;

Map<String, dynamic> _$CityProvinceToJson(CityProvince instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'province_id': instance.provinceId,
    };
