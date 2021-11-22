// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdviceData _$AdviceDataFromJson(Map<String, dynamic> json) => AdviceData(
      json['admin_recommends'] as List<dynamic>?,
      (json['diet_type_recommends'] as List<dynamic>?)
          ?.map((e) => DietTypeRecommend.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['sickness_recommends'] as List<dynamic>?,
      json['special_recommends'] as List<dynamic>?,
      json['user_sicknesses'] as List<dynamic>?,
      json['user_specials'] as List<dynamic>?,
    );

DietTypeRecommend _$DietTypeRecommendFromJson(Map<String, dynamic> json) =>
    DietTypeRecommend(
      json['id'] as int,
      json['text'] as String,
    );
