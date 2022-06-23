import 'package:json_annotation/json_annotation.dart';

part 'poll_phrases.g.dart';

@JsonSerializable()
class PollPhrases {
  @JsonKey(name: "example")
  String? example;

  int? index;

  String? text;

  bool? isSelected;

  bool? isStrength;

  PollPhrases();

  factory PollPhrases.fromJson(Map<String, dynamic> json) =>
      _$PollPhrasesFromJson(json);

  Map<String, dynamic> toJson() => _$PollPhrasesToJson(this);
}
