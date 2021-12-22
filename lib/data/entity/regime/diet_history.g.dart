// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietHistoryData _$DietHistoryDataFromJson(Map<String, dynamic> json) =>
    DietHistoryData(
      (json['items'] as List<dynamic>)
          .map((e) => DietHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

DietHistory _$DietHistoryFromJson(Map<String, dynamic> json) => DietHistory(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String?,
    );
