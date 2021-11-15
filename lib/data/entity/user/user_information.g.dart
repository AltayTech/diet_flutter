// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformation _$UserInformationFromJson(Map<String, dynamic> json) =>
    UserInformation()
      ..userId = json['user_id'] as int?
      ..gender = json['gender'] as int?
      ..mobile = json['mobile'] as String?
      ..email = json['email'] as String?
      ..countryId = json['country_id'] as int?
      ..cityId = json['city_id'] as int?
      ..provinceId = json['province_id'] as int?
      ..callNumber = json['call_number'] as String?
      ..firstName = json['first_name'] as String?
      ..lastName = json['last_name'] as String?
      ..birthDate = json['birth_date'] as String?
      ..isBehandam3 = json['is_behandam3_user'] as bool?
      ..hasCall = json['has_call'] as bool?
      ..hasFitaminService = json['has_fitamin_service'] as bool?
      ..address = json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>)
      ..socialMedia = (json['social_media'] as List<dynamic>?)
          ?.map((e) => SocialMedia.fromJson(e as Map<String, dynamic>))
          .toList()
      ..media = json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>);

Map<String, dynamic> _$UserInformationToJson(UserInformation instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'gender': instance.gender,
      'mobile': instance.mobile,
      'email': instance.email,
      'country_id': instance.countryId,
      'city_id': instance.cityId,
      'province_id': instance.provinceId,
      'call_number': instance.callNumber,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'birth_date': instance.birthDate,
      'is_behandam3_user': instance.isBehandam3,
      'has_call': instance.hasCall,
      'has_fitamin_service': instance.hasFitaminService,
      'address': instance.address,
      'social_media': instance.socialMedia,
      'media': instance.media,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address()
  ..address = json['address'] as String?
  ..provinceId = json['province_id'] as int?
  ..cityId = json['city_id'] as int?
  ..zipCode = json['zip_code'] as String?;

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address': instance.address,
      'province_id': instance.provinceId,
      'city_id': instance.cityId,
      'zip_code': instance.zipCode,
    };

Media _$MediaFromJson(Map<String, dynamic> json) => Media()
  ..url = json['url'] as String?
  ..id = json['id'] as int?
  ..modelId = json['model_id'] as int?
  ..fileName = json['file_name'] as String?
  ..name = json['name'] as String?
  ..thumbUrl = json['image_thumb_url'] as String?
  ..imageUrl = json['image_url'] as String?
  ..tutorialUrl = json['tutorial_url'] as String?
  ..avatarUrl = json['avatar_url'] as String?
  ..collectionName = json['collection_name'] as String?
  ..mimeType = json['mime_type'] as String?;

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'model_id': instance.modelId,
      'file_name': instance.fileName,
      'name': instance.name,
      'image_thumb_url': instance.thumbUrl,
      'image_url': instance.imageUrl,
      'tutorial_url': instance.tutorialUrl,
      'avatar_url': instance.avatarUrl,
      'collection_name': instance.collectionName,
      'mime_type': instance.mimeType,
    };

SocialMedia _$SocialMediaFromJson(Map<String, dynamic> json) => SocialMedia()
  ..pivot = json['pivot'] == null
      ? null
      : PivotMedia.fromJson(json['pivot'] as Map<String, dynamic>);

Map<String, dynamic> _$SocialMediaToJson(SocialMedia instance) =>
    <String, dynamic>{
      'pivot': instance.pivot,
    };

PivotMedia _$PivotMediaFromJson(Map<String, dynamic> json) =>
    PivotMedia()..link = json['link'] as String?;

Map<String, dynamic> _$PivotMediaToJson(PivotMedia instance) =>
    <String, dynamic>{
      'link': instance.link,
    };
