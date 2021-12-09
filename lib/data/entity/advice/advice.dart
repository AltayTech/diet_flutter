import 'package:behandam/data/entity/regime/user_sickness.dart';
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
  final List<AdminTypeRecommend>? adminRecommends;

  @JsonKey(name: 'diet_type_recommends')
  final List<DietTypeRecommend>? dietTypeRecommends;

  @JsonKey(name: 'sickness_recommends')
  final List<SicknessTypeRecommend>? sicknessRecommends;

  @JsonKey(name: 'special_recommends')
  final List<SpecialTypeRecommend>? specialRecommends;

  @JsonKey(name: 'user_sicknesses')
  final List<Sickness>? userSicknesses;

  @JsonKey(name: 'user_specials')
  final List<Sickness>? userSpecials;

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

  final AdviceType type = AdviceType.diet;

  factory DietTypeRecommend.fromJson(Map<String, dynamic> json) =>
      _$DietTypeRecommendFromJson(json);
}

@JsonSerializable(createToJson: false)
class SicknessTypeRecommend {
  SicknessTypeRecommend(this.id, this.text, this.pivot);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'pivot')
  final Pivot pivot;

  final AdviceType type = AdviceType.sickness;

  factory SicknessTypeRecommend.fromJson(Map<String, dynamic> json) =>
      _$SicknessTypeRecommendFromJson(json);
}

@JsonSerializable(createToJson: false)
class Pivot{
  Pivot(this.sicknessId, this.specialId);

  @JsonKey(name: 'sickness_id')
  final int? sicknessId;

  @JsonKey(name: 'special_id')
  final int? specialId;

  factory Pivot.fromJson(Map<String, dynamic> json) =>
      _$PivotFromJson(json);
}

@JsonSerializable(createToJson: false)
class SpecialTypeRecommend {
  SpecialTypeRecommend(this.id, this.text, this.pivot);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'pivot')
  final Pivot pivot;

  final AdviceType type = AdviceType.special;

  factory SpecialTypeRecommend.fromJson(Map<String, dynamic> json) =>
      _$SpecialTypeRecommendFromJson(json);
}

@JsonSerializable(createToJson: false)
class AdminTypeRecommend {
  AdminTypeRecommend(this.id, this.text);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'text')
  final String text;

  final AdviceType type = AdviceType.admin;

  factory AdminTypeRecommend.fromJson(Map<String, dynamic> json) =>
      _$AdminTypeRecommendFromJson(json);
}

enum AdviceType {
  admin,
  diet,
  sickness,
  special,
}
