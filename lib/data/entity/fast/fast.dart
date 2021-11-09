import 'package:json_annotation/json_annotation.dart';
part 'fast.g.dart';

@JsonSerializable(createToJson: false)
class FastPatternData {
  FastPatternData(this.alias, this.description, this.title);

  @JsonKey(name: 'alias')
  final String alias;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'title')
  final String title;

  // @JsonKey(name: 'id')
  int? id;

  factory FastPatternData.fromJson(Map<String, dynamic> json) =>
      _$FastPatternDataFromJson(json);
}

@JsonSerializable()
class FastMenuRequestData {
  FastMenuRequestData();

  @JsonKey(name: 'date')
  String? date;

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'is_fasting')
  bool? isFasting;

  @JsonKey(name: 'pattern_index')
  int? patternId;

  @JsonKey(name: 'user_id')
  int? userId;


  Map<String, dynamic> toJson() => _$FastMenuRequestDataToJson(this);

  factory FastMenuRequestData.fromJson(Map<String, dynamic> json) =>
      _$FastMenuRequestDataFromJson(json);
}
