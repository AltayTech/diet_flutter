import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit_item.g.dart';

@JsonSerializable(createToJson: false)
class VisitItem {
  VisitItem();

  @JsonKey(name: 'diet_type')
  RegimeAlias? dietType;

  @JsonKey(name: 'physical_info')
  PhysicalInfoData? physicalInfo;

  @JsonKey(name: 'terms', defaultValue: [])
  late List<TermStatus> terms;

  @JsonKey(name: 'weight_difference')
  double? weightDifference;

  factory VisitItem.fromJson(Map<String, dynamic> json) => _$VisitItemFromJson(json);
}

@JsonSerializable(createToJson: false)
class TermStatus {
  @JsonKey(name: 'started_at')
  late String startedAt;

  @JsonKey(name: 'expired_at')
  late String expiredAt;

  @JsonKey(name: 'is_active')
  int? isActive;

  @JsonKey(name: 'visits')
  List<VisitStatus>? visits;

  double? get firstWeight => (visits!.length > 0) ? visits![0].weight : 0;

  double? get lostWeight =>
      (visits!.length > 0) ? visits![visits!.length - 1].weight - visits![0].weight : 0;

  double? get minWeight => _minWeight! - 10;

  double? get maxWeight => _maxWeight! + 10;

  double? _minWeight;
  double? _maxWeight;

  setMaxMinWeight() {
    if ((visits!.length > 0)) {
      _maxWeight = visits![0].weight;
      _minWeight = visits![0].weight;
      for (int i = 0; i < visits!.length; i++) {
        if (visits![i].weight > _maxWeight!) {
          _maxWeight = visits![i].weight;
        }
        if (visits![i].weight < _minWeight!) {
          _minWeight = visits![i].weight;
        }
      }
    } else {
      _minWeight = 0;
      _maxWeight = 90;
    }
  }

  TermStatus();

  factory TermStatus.fromJson(Map<String, dynamic> json) => _$TermStatusFromJson(json);
}

@JsonSerializable(createToJson: false)
class VisitStatus {
  VisitStatus();

  @JsonKey(name: 'weight')
  late double weight;

  @JsonKey(name: 'visited_at')
  late String visitedAt;

  factory VisitStatus.fromJson(Map<String, dynamic> json) => _$VisitStatusFromJson(json);
}
