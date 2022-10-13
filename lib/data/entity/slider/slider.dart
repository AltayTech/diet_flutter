import 'package:behandam/data/entity/user/user_information.dart';
import 'package:json_annotation/json_annotation.dart';

part 'slider.g.dart';

@JsonSerializable()
class Slider {
  @JsonKey(name: "items")
  List<Slider>? items;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "priority")
  int? priority;
  @JsonKey(name: "color_code")
  String? colorCode;
  @JsonKey(name: "media")
  Media? media;

  Slider();

  factory Slider.fromJson(Map<String, dynamic> json) =>
      _$SliderFromJson(json);

  Map<String, dynamic> toJson() => _$SliderToJson(this);
}

@JsonSerializable()
class SliderIntroduces {
  @JsonKey(name: "items")
  List<SliderIntroduces>? items;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "full_name")
  String? fullName;
  @JsonKey(name: "old_weight")
  double? old_weight;
  @JsonKey(name: "new_weight")
  double? new_weight;
  @JsonKey(name: "color_code")
  String? colorCode;
  @JsonKey(name: "media")
  Media? media;

  SliderIntroduces();

  factory SliderIntroduces.fromJson(Map<String, dynamic> json) =>
      _$SliderIntroducesFromJson(json);

  Map<String, dynamic> toJson() => _$SliderIntroducesToJson(this);
}