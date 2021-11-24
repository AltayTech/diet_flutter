// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserved_meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryOutput _$HistoryOutputFromJson(Map<String, dynamic> json) =>
    HistoryOutput()
      ..dates = (json['dates'] as List<dynamic>?)
          ?.map((e) => HistoryOutput.fromJson(e as Map<String, dynamic>))
          .toList()
      ..date = json['date'] as String?
      ..expertPlanning = json['expert_plannings'] == null
          ? null
          : History.fromJson(json['expert_plannings'] as Map<String, dynamic>);

Map<String, dynamic> _$HistoryOutputToJson(HistoryOutput instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'date': instance.date,
      'expert_plannings': instance.expertPlanning,
    };

History _$HistoryFromJson(Map<String, dynamic> json) => History()
  ..id = json['id'] as int?
  ..adminId = json['admin_id'] as int?
  ..name = json['name'] as String?
  ..startTime = json['start_time'] as String?;

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'id': instance.id,
      'admin_id': instance.adminId,
      'name': instance.name,
      'start_time': instance.startTime,
    };
