
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:json_annotation/json_annotation.dart';
part 'menu.g.dart';

@JsonSerializable(createToJson: false)
class MenuData {
  MenuData(
      this.count,
      this.items,
      this.sum,
      );

  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'items')
  final List<MenuType> items;

  @JsonKey(name: 'sum')
  final int sum;

  factory MenuData.fromJson(Map<String, dynamic> json) =>
      _$MenuDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class MenuType {
  MenuType(
      this.id,
      this.order,
      this.title,
      this.menus,
      );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'menus')
  final List<Menu> menus;

  @JsonKey(name: 'order')
  final int order;

  @JsonKey(name: 'title')
  final String title;

  factory MenuType.fromJson(Map<String, dynamic> json) =>
      _$MenuTypeFromJson(json);
}