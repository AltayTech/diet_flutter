// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckStatus _$CheckStatusFromJson(Map<String, dynamic> json) => CheckStatus()
  ..next = json['next'] as String?
  ..message = json['message'] as String?
  ..isExist = json['existed'] as bool?
  ..otpInfo = json['otp_info'] == null
      ? null
      : OtpInfo.fromJson(json['otp_info'] as Map<String, dynamic>);

Map<String, dynamic> _$CheckStatusToJson(CheckStatus instance) =>
    <String, dynamic>{
      'next': instance.next,
      'message': instance.message,
      'existed': instance.isExist,
      'otp_info': instance.otpInfo,
    };

OtpInfo _$OtpInfoFromJson(Map<String, dynamic> json) => OtpInfo()
  ..whatsappInfo = json['whatsapp_info'] == null
      ? null
      : WhatsappInfo.fromJson(json['whatsapp_info'] as Map<String, dynamic>)
  ..telegramInfo = json['telegram_info'] == null
      ? null
      : WhatsappInfo.fromJson(json['telegram_info'] as Map<String, dynamic>);

Map<String, dynamic> _$OtpInfoToJson(OtpInfo instance) => <String, dynamic>{
      'whatsapp_info': instance.whatsappInfo,
      'telegram_info': instance.telegramInfo,
    };

WhatsappInfo _$WhatsappInfoFromJson(Map<String, dynamic> json) => WhatsappInfo()
  ..botMobile = json['botMobile'] as String?
  ..botStatus = json['botStatus'] as String? ?? '0'
  ..botStartText = json['botStartText'] as String?;

Map<String, dynamic> _$WhatsappInfoToJson(WhatsappInfo instance) =>
    <String, dynamic>{
      'botMobile': instance.botMobile,
      'botStatus': instance.botStatus,
      'botStartText': instance.botStartText,
    };
