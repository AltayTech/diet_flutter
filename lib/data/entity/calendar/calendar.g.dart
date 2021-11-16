// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarData _$CalendarDataFromJson(Map<String, dynamic> json) => CalendarData(
      (json['terms'] as List<dynamic>)
          .map((e) => Term.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Term _$TermFromJson(Map<String, dynamic> json) => Term(
      json['id'] as int,
      json['user_id'] as int,
      json['diet_type_id'] as int,
      json['package_id'] as int,
      json['payment_id'] as int,
      json['diet_history_id'] as int,
      json['diet_goal_id'] as int,
      json['file_number'] as int,
      json['call_num'] as int,
      json['started_at'] as String,
      json['expired_at'] as String,
      json['extra_days'] as int,
      json['is_stopped'] as int,
      json['is_active'] as int,
      json['remaining_visits'] as int,
      json['origin_id'] as int,
      json['refunded_at'] as String?,
      json['created_at'] as String,
      json['updated_at'] as String,
      json['deleted_at'] as String?,
      json['is_call_enabled'] as bool,
      (json['visits'] as List<dynamic>?)
          ?.map((e) => Visit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Visit _$VisitFromJson(Map<String, dynamic> json) => Visit(
      json['visited_at'] as String,
    );

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      json['id'] as int,
      json['menu_id'] as int,
      json['is_prepared_menu'] as int,
      json['term_id'] as int,
      json['from_day'] as int,
      json['to_day'] as int,
      json['started_at'] as String,
      json['expired_at'] as String,
      json['menu_days'] as int,
      json['menu_title'] as String,
    );
