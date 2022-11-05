import 'package:json_annotation/json_annotation.dart';

part 'poll_phrases.g.dart';

@JsonSerializable()
class PollPhrases {
  @JsonKey(name: "survey_causes")
  List<PollPhrases>? surveyCauses;

  @JsonKey(name: "survey_rates")
  List<SurveyRates>? surveyRates;

  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "cause")
  String? cause;

  boolean? isActive;

  @JsonKey(name: "is_positive")
  boolean? isPositive;

  PollPhrases();

  factory PollPhrases.fromJson(Map<String, dynamic> json) =>
      _$PollPhrasesFromJson(json);

  Map<String, dynamic> toJson() => _$PollPhrasesToJson(this);
}

@JsonSerializable()
class SurveyRates {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  SurveyRates();

  factory SurveyRates.fromJson(Map<String, dynamic> json) =>
      _$SurveyRatesFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyRatesToJson(this);
}

@JsonSerializable()
class CallRateRequest {
  @JsonKey(name: "call_id")
  int? callId;

  @JsonKey(name: "user_rate")
  int? userRate;

  @JsonKey(name: "is_contacted_me")
  bool? isContactedMe;

  @JsonKey(name: "survey_cause_ids")
  List<int>? surveyCauseIds;

  CallRateRequest();

  factory CallRateRequest.fromJson(Map<String, dynamic> json) =>
      _$CallRateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CallRateRequestToJson(this);
}

enum boolean {
  @JsonValue(0)
  False,
  @JsonValue(1)
  True,
}
