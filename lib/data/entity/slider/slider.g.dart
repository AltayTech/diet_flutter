// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slider _$SliderFromJson(Map<String, dynamic> json) => Slider()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => Slider.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..priority = json['priority'] as int?
  ..colorCode = json['color_code'] as String?
  ..media = json['media'] == null
      ? null
      : Media.fromJson(json['media'] as Map<String, dynamic>);

Map<String, dynamic> _$SliderToJson(Slider instance) => <String, dynamic>{
      'items': instance.items,
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'color_code': instance.colorCode,
      'media': instance.media,
    };

SliderIntroduces _$SliderIntroducesFromJson(Map<String, dynamic> json) =>
    SliderIntroduces()
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => SliderIntroduces.fromJson(e as Map<String, dynamic>))
          .toList()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..fullName = json['full_name'] as String?
      ..old_weight = (json['old_weight'] as num?)?.toDouble()
      ..new_weight = (json['new_weight'] as num?)?.toDouble()
      ..colorCode = json['color_code'] as String?
      ..media = json['media'] as String?;

Map<String, dynamic> _$SliderIntroducesToJson(SliderIntroduces instance) =>
    <String, dynamic>{
      'items': instance.items,
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'full_name': instance.fullName,
      'old_weight': instance.old_weight,
      'new_weight': instance.new_weight,
      'color_code': instance.colorCode,
      'media': instance.media,
    };
