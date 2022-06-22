// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_phrases.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollPhrases _$PollPhrasesFromJson(Map<String, dynamic> json) => PollPhrases()
  ..example = json['example'] as String?
  ..text = json['text'] as String?
  ..isSelected = json['isSelected'] as bool?;

Map<String, dynamic> _$PollPhrasesToJson(PollPhrases instance) =>
    <String, dynamic>{
      'example': instance.example,
      'text': instance.text,
      'isSelected': instance.isSelected,
    };
