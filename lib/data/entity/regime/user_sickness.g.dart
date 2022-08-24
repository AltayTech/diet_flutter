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
  ..sickness_categories = (json['categories'] as List<dynamic>?)
      ?.map((e) => CategorySickness.fromJson(e as Map<String, dynamic>))
      .toList()
  ..sicknesses = json['sicknesses'] as List<dynamic>?
  ..specials = json['specials'] as List<dynamic>?;

Map<String, dynamic> _$UserSicknessToJson(UserSickness instance) =>
    <String, dynamic>{
      'sickness_note': instance.sicknessNote,
      'user_sicknesses': instance.userSicknesses,
      'categories': instance.sickness_categories,
      'sicknesses': instance.sicknesses,
      'specials': instance.specials,
    };

Sickness _$SicknessFromJson(Map<String, dynamic> json) => Sickness()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..isSelected = json['selected'] as bool? ?? false;

Map<String, dynamic> _$SicknessToJson(Sickness instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'selected': instance.isSelected,
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
      ..tick = json['tick']
      ..order = json['order'] as int?;

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
      'order': instance.order,
    };

UserSicknessSpecial _$UserSicknessSpecialFromJson(Map<String, dynamic> json) =>
    UserSicknessSpecial()
      ..userSpecials = (json['user_specials'] as List<dynamic>?)
          ?.map((e) => SicknessSpecial.fromJson(e as Map<String, dynamic>))
          .toList()
      ..specials = (json['specials'] as List<dynamic>?)
          ?.map((e) => SicknessSpecial.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserSicknessSpecialToJson(
        UserSicknessSpecial instance) =>
    <String, dynamic>{
      'user_specials': instance.userSpecials,
      'specials': instance.specials,
    };

SicknessSpecial _$SicknessSpecialFromJson(Map<String, dynamic> json) =>
    SicknessSpecial()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..parentId = json['parent_id'] as int?
      ..order = json['order'] as int?
      ..children = (json['children'] as List<dynamic>?)
          ?.map((e) => SicknessSpecial.fromJson(e as Map<String, dynamic>))
          .toList()
      ..isSelected = json['selected'] as bool? ?? false
      ..barColor = json['bar_color']
      ..bgColor = json['bg_color']
      ..shadow = json['shadow']
      ..tick = json['tick'];

Map<String, dynamic> _$SicknessSpecialToJson(SicknessSpecial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'parent_id': instance.parentId,
      'order': instance.order,
      'children': instance.children,
      'selected': instance.isSelected,
      'bar_color': instance.barColor,
      'bg_color': instance.bgColor,
      'shadow': instance.shadow,
      'tick': instance.tick,
    };
