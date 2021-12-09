// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdviceData _$AdviceDataFromJson(Map<String, dynamic> json) => AdviceData(
      (json['admin_recommends'] as List<dynamic>?)
          ?.map((e) => AdminTypeRecommend.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['diet_type_recommends'] as List<dynamic>?)
          ?.map((e) => DietTypeRecommend.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['sickness_recommends'] as List<dynamic>?)
          ?.map(
              (e) => SicknessTypeRecommend.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['special_recommends'] as List<dynamic>?)
          ?.map((e) => SpecialTypeRecommend.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['user_sicknesses'] as List<dynamic>?)
          ?.map((e) => Sickness.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['user_specials'] as List<dynamic>?)
          ?.map((e) => Sickness.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

DietTypeRecommend _$DietTypeRecommendFromJson(Map<String, dynamic> json) =>
    DietTypeRecommend(
      json['id'] as int,
      json['text'] as String,
    );

SicknessTypeRecommend _$SicknessTypeRecommendFromJson(
        Map<String, dynamic> json) =>
    SicknessTypeRecommend(
      json['id'] as int,
      json['text'] as String,
      Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );

Pivot _$PivotFromJson(Map<String, dynamic> json) => Pivot(
      json['sickness_id'] as int?,
      json['special_id'] as int?,
    );

SpecialTypeRecommend _$SpecialTypeRecommendFromJson(
        Map<String, dynamic> json) =>
    SpecialTypeRecommend(
      json['id'] as int,
      json['text'] as String,
      Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );

AdminTypeRecommend _$AdminTypeRecommendFromJson(Map<String, dynamic> json) =>
    AdminTypeRecommend(
      json['id'] as int,
      json['text'] as String,
    );
