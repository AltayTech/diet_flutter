import 'package:json_annotation/json_annotation.dart';
part 'daily_message.g.dart';

@JsonSerializable()
class DailyMessageTemplate {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "data")
  List<TemplateData>? data;

  DailyMessageTemplate();

  factory DailyMessageTemplate.fromJson(Map<String, dynamic> json) =>
      _$DailyMessageTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMessageTemplateToJson(this);
}

@JsonSerializable()
class TemplateData {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "template_id")
  int? templateId;
  @JsonKey(name: "alter_text")
  String? alterText;
  @JsonKey(name: "order")
  int? order;
  @JsonKey(name: "media")
  List<TemplateMedia>? media;

  TemplateData();

  factory TemplateData.fromJson(Map<String, dynamic> json) =>
      _$TemplateDataFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateDataToJson(this);
}

@JsonSerializable()
class TemplateMedia {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "file_name")
  String? fileName;
  @JsonKey(name: "mime_type")
  String? mimeType;
  @JsonKey(name: "size")
  int? size;
  // @JsonKey(name: "generated_conversions")
  // List<Conversions>? generatedConversions;
  @JsonKey(name: "medium_urls")
  Url? mediumUrls;
  @JsonKey(name: "medium_type")
  int? mediumType;

  TemplateMedia();

  factory TemplateMedia.fromJson(Map<String, dynamic> json) =>
      _$TemplateMediaFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateMediaToJson(this);
}

@JsonSerializable()
class Conversions {
  @JsonKey(name: "small")
  bool? small;
  @JsonKey(name: "medium")
  bool? medium;

  Conversions();

  factory Conversions.fromJson(Map<String, dynamic> json) =>
      _$ConversionsFromJson(json);

  Map<String, dynamic> toJson() => _$ConversionsToJson(this);
}

@JsonSerializable()
class Url {
  @JsonKey(name: "url")
  String? url;
  // @JsonKey(name: "thumb_url")
  // List<Conversions>? thumbUrl;

  Url();

  factory Url.fromJson(Map<String, dynamic> json) =>
      _$UrlFromJson(json);

  Map<String, dynamic> toJson() => _$UrlToJson(this);
}