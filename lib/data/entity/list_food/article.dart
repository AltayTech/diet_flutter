import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class ArticleVideo {
  ArticleVideo();

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'date')
  String? date;

  Map<String, dynamic> toJson() => _$ArticleVideoToJson(this);

  factory ArticleVideo.fromJson(Map<String, dynamic> json) => _$ArticleVideoFromJson(json);
}

@JsonSerializable()
class TimeRequest {
  @JsonKey(name: 'started_at')
  String? started_at;

  @JsonKey(name: 'expired_at')
  String? expired_at;

  TimeRequest();

  Map<String, dynamic> toJson() => _$TimeRequestToJson(this);

  factory TimeRequest.fromJson(Map<String, dynamic> json) => _$TimeRequestFromJson(json);
}
