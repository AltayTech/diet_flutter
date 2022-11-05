// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_phrases.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollPhrases _$PollPhrasesFromJson(Map<String, dynamic> json) => PollPhrases()
  ..surveyCauses = (json['survey_causes'] as List<dynamic>?)
      ?.map((e) => PollPhrases.fromJson(e as Map<String, dynamic>))
      .toList()
  ..surveyRates = (json['survey_rates'] as List<dynamic>?)
      ?.map((e) => SurveyRates.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..cause = json['cause'] as String?
  ..isActive = $enumDecodeNullable(_$booleanEnumMap, json['isActive'])
  ..isPositive = $enumDecodeNullable(_$booleanEnumMap, json['is_positive']);

Map<String, dynamic> _$PollPhrasesToJson(PollPhrases instance) =>
    <String, dynamic>{
      'survey_causes': instance.surveyCauses,
      'survey_rates': instance.surveyRates,
      'id': instance.id,
      'cause': instance.cause,
      'isActive': _$booleanEnumMap[instance.isActive],
      'is_positive': _$booleanEnumMap[instance.isPositive],
    };

const _$booleanEnumMap = {
  boolean.False: 0,
  boolean.True: 1,
};

SurveyRates _$SurveyRatesFromJson(Map<String, dynamic> json) => SurveyRates()
  ..id = json['id'] as int?
  ..title = json['title'] as String?;

Map<String, dynamic> _$SurveyRatesToJson(SurveyRates instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

CallRateRequest _$CallRateRequestFromJson(Map<String, dynamic> json) =>
    CallRateRequest()
      ..callId = json['call_id'] as int?
      ..userRate = json['user_rate'] as int?
      ..isContactedMe = json['is_contacted_me'] as bool?
      ..surveyCauseIds = (json['survey_cause_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList();

Map<String, dynamic> _$CallRateRequestToJson(CallRateRequest instance) =>
    <String, dynamic>{
      'call_id': instance.callId,
      'user_rate': instance.userRate,
      'is_contacted_me': instance.isContactedMe,
      'survey_cause_ids': instance.surveyCauseIds,
    };
