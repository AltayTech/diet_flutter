// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalenderOutput _$CalenderOutputFromJson(Map<String, dynamic> json) =>
    CalenderOutput()
      ..packages = (json['packages'] as List<dynamic>?)
          ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
          .toList()
      ..admins = (json['admins'] as List<dynamic>?)
          ?.map((e) => Admin.fromJson(e as Map<String, dynamic>))
          .toList()
      ..dates = (json['dates'] as List<dynamic>?)
          ?.map((e) => Plan.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CalenderOutputToJson(CalenderOutput instance) =>
    <String, dynamic>{
      'packages': instance.packages,
      'admins': instance.admins,
      'dates': instance.dates,
    };
