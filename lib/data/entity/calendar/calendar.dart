import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar.g.dart';

@JsonSerializable(createToJson: false)
class CalendarData {
  CalendarData(this.terms);

  @JsonKey(name: 'terms')
  final List<Term> terms;

  factory CalendarData.fromJson(Map<String, dynamic> json) => _$CalendarDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Term {
  Term(
    this.id,
    this.userId,
    this.dietTypeId,
    this.packageId,
    this.startedAt,
    this.expiredAt,
    this.extraDays,
    this.isStopped,
    this.isActive,
    this.remainingVisits,
    this.refundedAt,
    this.createdAt,
    this.visits,
    this.menus,
  );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'diet_type_id')
  final int dietTypeId;

  @JsonKey(name: 'package_id')
  final int packageId;



  @JsonKey(name: 'started_at')
  final String startedAt;

  @JsonKey(name: 'expired_at')
  final String expiredAt;

  @JsonKey(name: 'extra_days')
  final int extraDays;

  @JsonKey(name: 'is_stopped')
  final int isStopped;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'remaining_visits')
  final int remainingVisits;

  @JsonKey(name: 'refunded_at')
  final String? refundedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;


  @JsonKey(name: 'visits')
  List<Visit>? visits;

  @JsonKey(name: 'menus')
  List<Menu>? menus;

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
}

@JsonSerializable(createToJson: false)
class Visit {
  Visit(
    this.id,
    this.visitedAt,
    this.expiredAt,
  );

  @JsonKey(name: 'id')
  final int id;


  @JsonKey(name: 'visited_at')
  final String visitedAt;

  @JsonKey(name: 'expired_at')
  final String expiredAt;


  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);
}

@JsonSerializable(createToJson: false)
class Menu {
  Menu(
    this.id,
    this.menuId,
    this.fromDay,
    this.toDay,
    this.startedAt,
    this.expiredAt,
    this.menuDays
  );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'menu_id')
  final int menuId;

  @JsonKey(name: 'from_day')
  final int fromDay;

  @JsonKey(name: 'to_day')
  final int toDay;

  @JsonKey(name: 'started_at')
  final String startedAt;

  @JsonKey(name: 'expired_at')
  final String expiredAt;

  @JsonKey(name: 'menu_days')
  final int menuDays;

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
}

@JsonSerializable(createToJson: false)
class TermPackage {
  @JsonKey(name: 'term')
  Term? term;

  @JsonKey(name: 'package')
  PackageItem? package;

  @JsonKey(name: 'show_refund_link')
  bool? showRefundLink;
  @JsonKey(name: 'can_refund')
  bool? canRefund;

  TermPackage();

  factory TermPackage.fromJson(Map<String, dynamic> json) => _$TermPackageFromJson(json);
}
