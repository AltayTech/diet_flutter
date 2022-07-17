import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable()
class CheckStatus {
  @JsonKey(name: "next")
  String? next;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "existed")
  bool? isExist;

  @JsonKey(name: "otp_info")
  OtpInfo? otpInfo;

  CheckStatus();

  factory CheckStatus.fromJson(Map<String, dynamic> json) => _$CheckStatusFromJson(json);

  Map<String, dynamic> toJson() => _$CheckStatusToJson(this);
}

@JsonSerializable()
class OtpInfo {
  @JsonKey(name: "whatsapp_info")
  WhatsappInfo? whatsappInfo;

  @JsonKey(name: "telegram_info")
  WhatsappInfo? telegramInfo;

  OtpInfo();

  factory OtpInfo.fromJson(Map<String, dynamic> json) => _$OtpInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpInfoToJson(this);
}

@JsonSerializable()
class WhatsappInfo {
  @JsonKey(name: "botMobile")
  String? botMobile;
  @JsonKey(name: "botStatus", defaultValue: '0')
  late String botStatus;

  @JsonKey(name: "botStartText")
  String? botStartText;

  bool get botStatusBool => botStatus == '1';

  WhatsappInfo();

  factory WhatsappInfo.fromJson(Map<String, dynamic> json) => _$WhatsappInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WhatsappInfoToJson(this);
}
