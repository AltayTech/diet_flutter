import 'package:json_annotation/json_annotation.dart';
part 'activity_level.g.dart';

@JsonSerializable(createToJson: false)
class ActivityLevelData {
  ActivityLevelData(this.items);

  @JsonKey(name: 'items')
  final List<ActivityData> items;

  factory ActivityLevelData.fromJson(Map<String, dynamic> json) =>
      _$ActivityLevelDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class ActivityData {
  ActivityData(this.id, this.title, this.description,);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  factory ActivityData.fromJson(Map<String, dynamic> json) =>
      _$ActivityDataFromJson(json);
}