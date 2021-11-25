import 'package:json_annotation/json_annotation.dart';
part 'diet_history.g.dart';

@JsonSerializable(createToJson: false)
class DietHistoryData {
  DietHistoryData(this.items);

  @JsonKey(name: 'items')
  final List<DietHistory> items;

  factory DietHistoryData.fromJson(Map<String, dynamic> json) =>
      _$DietHistoryDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class DietHistory {
  DietHistory(this.id, this.title, this.description,);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  factory DietHistory.fromJson(Map<String, dynamic> json) =>
      _$DietHistoryFromJson(json);
}