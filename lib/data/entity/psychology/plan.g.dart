// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan()
  ..id = json['id'] as int?
  ..expertPlanning = (json['expert_plannings'] as List<dynamic>?)
      ?.map((e) => Planning.fromJson(e as Map<String, dynamic>))
      .toList()
  ..date = json['date'] as String?
  ..jDate = json['jdate'] as String?
  ..isHoliday = json['is_holiday'] as int?;

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'expert_plannings': instance.expertPlanning,
      'date': instance.date,
      'jdate': instance.jDate,
      'is_holiday': instance.isHoliday,
    };

Planning _$PlanningFromJson(Map<String, dynamic> json) => Planning()
  ..adminId = json['admin_id'] as int?
  ..dateTimes = (json['date_times'] as List<dynamic>?)
      ?.map((e) => Planning.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..startTime = json['start_time'] as String?
  ..endTime = json['end_time'] as String?;

Map<String, dynamic> _$PlanningToJson(Planning instance) => <String, dynamic>{
      'admin_id': instance.adminId,
      'date_times': instance.dateTimes,
      'id': instance.id,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
