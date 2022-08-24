import 'package:behandam/data/entity/user/user_information.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_sickness.g.dart';

@JsonSerializable()
class UserSickness {
  @JsonKey(name: "sickness_note")
  String? sicknessNote;

  @JsonKey(name: "user_sicknesses")
  List<Sickness>? userSicknesses;

  @JsonKey(name: "categories")
  List<CategorySickness>? sickness_categories;

  @JsonKey(name: "sicknesses")
  List<dynamic>? sicknesses;

  @JsonKey(name: "specials")
  List<dynamic>? specials;

  UserSickness();

  factory UserSickness.fromJson(Map<String, dynamic> json) => _$UserSicknessFromJson(json);

  Map<String, dynamic> toJson() => _$UserSicknessToJson(this);
}

@JsonSerializable()
class Sickness {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  Sickness();

  factory Sickness.fromJson(Map<String, dynamic> json) => _$SicknessFromJson(json);

  Map<String, dynamic> toJson() => _$SicknessToJson(this);
}

@JsonSerializable()
class CategorySickness {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "children")
  List<Sickness>? children;

  @JsonKey(name: "sicknesses")
  List<CategorySickness>? sicknesses;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  @JsonKey(name: "media")
  Media? media;

  @JsonKey(name: "bar_color")
  var barColor;
  @JsonKey(name: "bg_color")
  var bgColor;
  @JsonKey(name: "shadow")
  var shadow;
  @JsonKey(name: "tick")
  var tick;
  @JsonKey(name: "order")
  int? order;

  CategorySickness();

  factory CategorySickness.fromJson(Map<String, dynamic> json) => _$CategorySicknessFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySicknessToJson(this);
}

@JsonSerializable()
class UserSicknessSpecial {
  @JsonKey(name: "user_specials")
  List<SicknessSpecial>? userSpecials;

  @JsonKey(name: "specials")
  List<SicknessSpecial>? specials;

  UserSicknessSpecial();

  factory UserSicknessSpecial.fromJson(Map<String, dynamic> json) =>
      _$UserSicknessSpecialFromJson(json);

  Map<String, dynamic> toJson() => _$UserSicknessSpecialToJson(this);
}

@JsonSerializable()
class SicknessSpecial {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "parent_id")
  int? parentId;

  @JsonKey(name: "order")
  int? order;

  @JsonKey(name: "children")
  List<SicknessSpecial>? children;

  @JsonKey(name: "selected", defaultValue: false)
  bool? isSelected;

  @JsonKey(name: "bar_color")
  var barColor;
  @JsonKey(name: "bg_color")
  var bgColor;
  @JsonKey(name: "shadow")
  var shadow;
  @JsonKey(name: "tick")
  var tick;

  SicknessSpecial();

  factory SicknessSpecial.fromJson(Map<String, dynamic> json) => _$SicknessSpecialFromJson(json);

  Map<String, dynamic> toJson() => _$SicknessSpecialToJson(this);
}
