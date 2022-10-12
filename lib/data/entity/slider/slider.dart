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
  @JsonKey(name: "media")
  Media? media;

  Slider();

  factory Slider.fromJson(Map<String, dynamic> json) =>
      _$SliderFromJson(json);

  Map<String, dynamic> toJson() => _$SliderToJson(this);
}