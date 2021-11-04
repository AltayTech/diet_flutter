import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'user_information.g.dart';

@JsonSerializable()
class UserInformation {
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "gender")
  int? gender;
  @JsonKey(name: "mobile")
  String? mobile;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "country_id")
  int? countryId;
  @JsonKey(name: "city_id")
  int? cityId;

  @JsonKey(name: "province_id")
  int? provinceId;

  @JsonKey(name: "call_number")
  String? callNumber;
  @JsonKey(name: "first_name")
  String? firstName;
  @JsonKey(name: "last_name")
  String? lastName;
  @JsonKey(name: "birth_date")
  String? birthDate;

  @JsonKey(name: "is_behandam3_user")
  bool? isBehandam3;
  @JsonKey(name: "has_call")
  bool? hasCall;
  @JsonKey(name: "has_fitamin_service")
  bool? hasFitaminService;

  @JsonKey(name: "address")
  Address? address;

  @JsonKey(name: "social_media")
  List<SocialMedia>? socialMedia;

  @JsonKey(name: "media")
  Media? media;

  String get fullName => firstName == null ? '' : '$firstName $lastName';

  String get whatsApp =>
       (socialMedia == null || socialMedia![0].pivot!.link == null)
          ? ''
          : socialMedia![0].pivot!.link!;

  String get telegram =>
      (socialMedia == null || socialMedia![1].pivot!.link == null)
          ? ''
          : socialMedia![1].pivot!.link!;

  String get skype =>  (socialMedia == null || socialMedia![2].pivot!.link == null)
      ? ''
      : socialMedia![2].pivot!.link!;

  UserInformation();

  factory UserInformation.fromJson(Map<String, dynamic> json) => _$UserInformationFromJson(json);

  Map<String, dynamic> toJson() => _$UserInformationToJson(this);
}

@JsonSerializable()
class Address {
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "province_id")
  int? provinceId;

  @JsonKey(name: "city_id")
  int? cityId;

  @JsonKey(name: "zip_code")
  String? zipCode;

  Address();

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Media {
  @JsonKey(name: "url")
  String? url;

  Media();

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable()
class SocialMedia {
  @JsonKey(name: "pivot")
  PivotMedia? pivot;

  SocialMedia();

  factory SocialMedia.fromJson(Map<String, dynamic> json) => _$SocialMediaFromJson(json);

  Map<String, dynamic> toJson() => _$SocialMediaToJson(this);
}

@JsonSerializable()
class PivotMedia {
  @JsonKey(name: "link")
  String? link;

  PivotMedia();

  factory PivotMedia.fromJson(Map<String, dynamic> json) => _$PivotMediaFromJson(json);

  Map<String, dynamic> toJson() => _$PivotMediaToJson(this);
}
