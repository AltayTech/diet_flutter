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
      json['started_at'] as String,
      json['expired_at'] as String,
      json['extra_days'] as int,
      json['is_stopped'] as int,
      json['is_active'] as int,
      json['remaining_visits'] as int,
      json['refunded_at'] as String?,
      json['created_at'] as String,
      (json['visits'] as List<dynamic>?)
          ?.map((e) => Visit.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['menus'] as List<dynamic>?)
          ?.map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Visit _$VisitFromJson(Map<String, dynamic> json) => Visit(
      json['id'] as int,
      json['visited_at'] as String,
      json['expired_at'] as String,
    );

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      json['id'] as int,
      json['menu_id'] as int,
      json['from_day'] as int,
      json['to_day'] as int,
      json['started_at'] as String,
      json['expired_at'] as String,
      json['menu_days'] as int,
    );

TermPackage _$TermPackageFromJson(Map<String, dynamic> json) => TermPackage()
  ..term = json['term'] == null
      ? null
      : Term.fromJson(json['term'] as Map<String, dynamic>)
  ..package = json['package'] == null
      ? null
      : PackageItem.fromJson(json['package'] as Map<String, dynamic>)
  ..showRefundLink = json['show_refund_link'] as bool?
  ..canRefund = json['can_refund'] as bool?
  ..subscriptionTermData = json['subscription_data'] == null
      ? null
      : SubscriptionTermData.fromJson(
          json['subscription_data'] as Map<String, dynamic>);
