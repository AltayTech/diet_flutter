import 'package:json_annotation/json_annotation.dart';
part 'advice.g.dart';

@JsonSerializable(createToJson: false)
class AdviceData {
  AdviceData(
    this.adminRecommends,
    this.dietTypeRecommends,
    this.sicknessRecommends,
    this.specialRecommends,
    this.userSicknesses,
    this.userSpecials,
  );

  @JsonKey(name: 'admin_recommends')
  final List? adminRecommends;

  @JsonKey(name: 'diet_type_recommends')
  final List<DietTypeRecommend>? dietTypeRecommends;

  @JsonKey(name: 'sickness_recommends')
  final List? sicknessRecommends;

  @JsonKey(name: 'special_recommends')
  final List? specialRecommends;

  @JsonKey(name: 'user_sicknesses')
  final List? userSicknesses;

  @JsonKey(name: 'user_specials')
  final List? userSpecials;

  factory AdviceData.fromJson(Map<String, dynamic> json) =>
      _$AdviceDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class DietTypeRecommend {
  DietTypeRecommend(this.id, this.text);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'text')
  final String text;

  final AdviceType type = AdviceType.Diet;

  factory DietTypeRecommend.fromJson(Map<String, dynamic> json) =>
      _$DietTypeRecommendFromJson(json);
}

enum AdviceType {
  Admin,
  Diet,
  Sickness,
  Special,
}
