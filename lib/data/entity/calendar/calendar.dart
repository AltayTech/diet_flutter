import 'package:json_annotation/json_annotation.dart';
part 'calendar.g.dart';

@JsonSerializable(createToJson: false)
class CalendarData {
  CalendarData(this.terms);

  @JsonKey(name: 'terms')
  final List<Term> terms;

  factory CalendarData.fromJson(Map<String, dynamic> json) =>
      _$CalendarDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Term {
  Term(
    this.id,
    this.userId,
    this.dietTypeId,
    this.packageId,
    this.paymentId,
    this.dietHistoryId,
    this.dietGoalId,
    this.fileNumber,
    this.callNum,
    this.startedAt,
    this.expiredAt,
    this.extraDays,
    this.isStopped,
    this.isActive,
    this.remainingVisits,
    this.originId,
    this.refundedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isCallEnabled,
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

  @JsonKey(name: 'payment_id')
  final int paymentId;

  @JsonKey(name: 'diet_history_id')
  final int dietHistoryId;

  @JsonKey(name: 'diet_goal_id')
  final int dietGoalId;

  @JsonKey(name: 'file_number')
  final int fileNumber;

  @JsonKey(name: 'call_num')
  final int callNum;

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

  @JsonKey(name: 'origin_id')
  final int originId;

  @JsonKey(name: 'refunded_at')
  final String? refundedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'is_call_enabled')
  final bool isCallEnabled;

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
    this.termId,
    this.weight,
    this.targetWeight,
    this.wrist,
    this.height,
    this.pregnancyWeekNumber,
    this.visitedAt,
    this.expiredAt,
    this.isActive,
    this.visitDays,
  );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'term_id')
  final int termId;

  @JsonKey(name: 'weight')
  final double weight;

  @JsonKey(name: 'target_weight')
  final double targetWeight;

  @JsonKey(name: 'height')
  final int height;

  @JsonKey(name: 'wrist')
  final int wrist;

  @JsonKey(name: 'pregnancy_week_number')
  final int? pregnancyWeekNumber;

  @JsonKey(name: 'visited_at')
  final String visitedAt;

  @JsonKey(name: 'expired_at')
  final String expiredAt;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'visit_days')
  final int visitDays;

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);
}

@JsonSerializable(createToJson: false)
class Menu {
  Menu(
    this.id,
    this.menuId,
    this.termId,
    this.fromDay,
    this.toDay,
    this.startedAt,
    this.expiredAt,
    this.menuDays,
    this.menuTitle,
  );

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'menu_id')
  final int menuId;

  @JsonKey(name: 'term_id')
  final int termId;

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

  @JsonKey(name: 'menu_title')
  final String menuTitle;

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
}
