import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
class VersionData {
  @JsonKey(name: "ios")
  Version? ios;
  @JsonKey(name: "android")
  Version? android;

  VersionData();

  factory VersionData.fromJson(Map<String, dynamic> json) => _$VersionDataFromJson(json);

  Map<String, dynamic> toJson() => _$VersionDataToJson(this);
}

@JsonSerializable()
class Version {
  @JsonKey(name: "version_code")
  int? versionCode;

  @JsonKey(name: "force_update")
  int? forceUpdate;

  @JsonKey(name: "force_update_version" ,defaultValue: 1)
  int? forceUpdateVersion;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "version_name")
  String? versionName;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "iapps")
  String? iapps;

  @JsonKey(name: "sibapp")
  String? sibapp;

  @JsonKey(name: "google")
  String? google;

  Version();

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
