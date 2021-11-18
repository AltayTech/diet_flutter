// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_sickness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSickness _$UserSicknessFromJson(Map<String, dynamic> json) => UserSickness()
  ..sicknessNote = json['sickness_note'] as String?
  ..userSicknesses = (json['user_sicknesses'] as List<dynamic>?)
      ?.map((e) => Sickness.fromJson(e as Map<String, dynamic>))
      .toList()
  ..sickness_categories = (json['sickness_categories'] as List<dynamic>?)
      ?.map((e) => CategorySickness.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UserSicknessToJson(UserSickness instance) =>
    <String, dynamic>{
      'sickness_note': instance.sicknessNote,
      'user_sicknesses': instance.userSicknesses,
      'sickness_categories': instance.sickness_categories,
    };

Sickness _$SicknessFromJson(Map<String, dynamic> json) => Sickness()
  ..id = json['id'] as int?
  ..title = json['title'] as String?;

Map<String, dynamic> _$SicknessToJson(Sickness instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

CategorySickness _$CategorySicknessFromJson(Map<String, dynamic> json) =>
    CategorySickness()
      ..id = json['id'] as int?
      ..children = (json['children'] as List<dynamic>?)
          ?.map((e) => Sickness.fromJson(e as Map<String, dynamic>))
          .toList()
      ..sicknesses = (json['sicknesses'] as List<dynamic>?)
          ?.map((e) => CategorySickness.fromJson(e as Map<String, dynamic>))
          .toList()
      ..title = json['title'] as String?
      ..isSelected = json['selected'] as bool? ?? false
      ..media = json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>)
      ..barColor = json['bar_color']
      ..bgColor = json['bg_color']
      ..shadow = json['shadow']
      ..tick = json['tick'];

Map<String, dynamic> _$CategorySicknessToJson(CategorySickness instance) =>
    <String, dynamic>{
      'id': instance.id,
      'children': instance.children,
      'sicknesses': instance.sicknesses,
      'title': instance.title,
      'selected': instance.isSelected,
      'media': instance.media,
      'bar_color': instance.barColor,
      'bg_color': instance.bgColor,
      'shadow': instance.shadow,
      'tick': instance.tick,
    };
