import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
class Version {
  @JsonKey(name: "version_code")
  int? versionCode;

  @JsonKey(name: "force_update")
  bool? forceUpdate;

  @JsonKey(name: "force_version_code", defaultValue: "100")
  String? forceUpdateVersion;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "version_name")
  String? versionName;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "url")
  String? url;

  Version();

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
