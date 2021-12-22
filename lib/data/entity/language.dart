import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable(createFactory: false)
class ChangeLanguageRequestData {
  ChangeLanguageRequestData(this.language);

  @JsonKey(name: 'Language')
  final UserLanguage language;

  Map<String, dynamic> toJson() => _$ChangeLanguageRequestDataToJson(this);
}

enum UserLanguage {
  @JsonValue(0)
  farsi,
  @JsonValue(1)
  english,
  @JsonValue(2)
  arabic
}
