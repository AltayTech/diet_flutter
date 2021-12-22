import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit_item.g.dart';

@JsonSerializable()
class VisitItem {
  VisitItem();

  @JsonKey(name: 'diet_type')
  RegimeAlias? dietType;

  @JsonKey(name: 'physical_info')
  PhysicalInfoData? physicalInfo;

  @JsonKey(name: 'visits', defaultValue: [])
  late List<Visit> visits;

  @JsonKey(name: 'weight_difference')
  double? weightDifference;

  double? get firstWeight => visits.length > 0 ? visits[0].weight! : 0;

  double? get lostWeight =>
      visits.length > 0 ? visits[visits.length - 1].weight! - visits[0].weight! : 0;

  double? get minWeight => _minWeight! - 10;

  double? get maxWeight => _maxWeight! + 10;

  double? _minWeight;
  double? _maxWeight;

  setMaxMinWeight() {
    if (visits.length > 0) {
      _maxWeight = visits[0].weight!;
      _minWeight = visits[0].weight!;
      for (int i = 0; i < visits.length; i++) {
        if (visits[i].weight! > _maxWeight!) {
          _maxWeight = visits[i].weight!;
        }
        if (visits[i].weight! < _minWeight!) {
          _minWeight = visits[i].weight!;
        }
      }
    } else {
      _minWeight = 0;
      _maxWeight = 90;
    }
  }

  factory VisitItem.fromJson(Map<String, dynamic> json) => _$VisitItemFromJson(json);

  Map<String, dynamic> toJson() => _$VisitItemToJson(this);
}
