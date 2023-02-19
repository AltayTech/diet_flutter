import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/calendar/bloc.dart';
import 'package:behandam/screens/calendar/day_item.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/dialog_close.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends ResourcefulState<CalendarPage> {
  late List<String> weekDays;
  List<DayItem> monthDays = [];
  late Jalali jalali;
  late CalendarBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CalendarBloc();
    jalali =
        Jalali.fromDateTime(DateTime.parse(Jalali.now().toDateTime().toString().substring(0, 10)));
    debugPrint('jalali jalali ${Jalali.now().toDateTime().toString().substring(0, 10)} / $jalali');
    makeCalenderDays();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    weekDays = [
      intl.saturday,
      intl.sunday,
      intl.monday,
      intl.tuesday,
      intl.wednesday,
      intl.thursday,
      intl.friday,
    ];
    debugPrint(
        'format ${jalali} / ${jalali.day} / ${jalali.monthLength} / ${jalali.withDay(1).weekDay} / ${jalali.month}');

    return Scaffold(
      appBar: Toolbar(titleBar: intl.calendar),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: bloc.loadingContent,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            return Card(
              shape: AppShapes.rectangleMedium,
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Column(
                  children: [
                    header(),
                    days(),
                    Divider(
                      height: 2.h,
                      thickness: 0.5,
                      color: AppColors.labelColor,
                    ),
                    Space(height: 2.h),
                    calendar(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void makeCalenderDays() {
    if (monthDays.isEmpty) {
      for (int i = 0; i < jalali.monthLength; i++) {
        monthDays.add(DayItem(
          jalali: jalali.withDay(i + 1),
          gregorian: Gregorian.fromJalali(jalali.withDay(i + 1)),
          types: [],
        ));
      }
      debugPrint('first day ${jalali.withDay(1).weekDay} }');
      if (jalali.withDay(1).weekDay != 1) {
        for (int i = 1; i < jalali.withDay(1).weekDay; i++) {
          final shamsi = jalali.withDay(1).addDays(-i);
          monthDays.insert(
              0,
              DayItem(
                jalali: shamsi,
                gregorian: shamsi.toGregorian(),
                types: [DayType.fade],
              ));
        }
      }
      if (jalali.withDay(jalali.monthLength).weekDay != 7) {
        for (int i = 1; i <= (7 - jalali.withDay(jalali.monthLength).weekDay); i++) {
          final shamsi = jalali.withDay(jalali.monthLength).addDays(i);
          monthDays.add(DayItem(
            jalali: shamsi,
            gregorian: Gregorian.fromJalali(shamsi),
            types: [DayType.fade],
          ));
        }
      }
      monthDays.forEach((element) {
        // element.gregorian = element.gregorian.copy(hour: 0, minute: 0, millisecond: 0);
        debugPrint('calendar days ${element.gregorian}');
      });
    }
  }

  Widget header() {
    return Row(
      children: [
        Container(
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.primary.withOpacity(0.2),
          ),
          width: 20.w,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            children: [
              Text(
                jalali.toGregorian().month == Jalali.now().toGregorian().month
                    ? DateTimeUtils.weekDayArabicName(jalali.toGregorian().formatter.wN)
                    : DateTimeUtils.weekDayArabicName(jalali.toGregorian().withDay(1).formatter.wN),
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Text(
                jalali.toGregorian().month == Jalali.now().toGregorian().month
                    ? jalali.toGregorian().day.toString()
                    : jalali.toGregorian().withDay(1).day.toString(),
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Space(width: 2.w),
        Expanded(
          child: Text(
            '${jalali.toGregorian().formatter.mN} ${jalali.toGregorian().formatter.yyyy}',
            style: typography.caption,
            textAlign: TextAlign.start,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              jalali = jalali.addMonths(-1);
              monthDays.clear();
              makeCalenderDays();
            });
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 7.w,
            color: AppColors.primary,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              jalali = jalali.addMonths(1);
              monthDays.clear();
              makeCalenderDays();
            });
          },
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 7.w,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget days() {
    return Container(
      height: 3.h,
      margin: EdgeInsets.only(top: 2.h),
      child: GridView.count(
        crossAxisCount: 7,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ...weekDays
              .map((day) => Text(
                    day,
                    style: typography.caption?.apply(
                      color: AppColors.labelColor,
                    ),
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget calendar() {
    return StreamBuilder(
      stream: bloc.calendar,
      builder: (_, AsyncSnapshot<CalendarData?> snapshot) {
        if (snapshot.hasData) {
          setTerms(snapshot.requireData?.terms);
          for (int i = 0; i < monthDays.length; i++) {
            debugPrint('month days ${monthDays[i].types}');
          }
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3.w,
            // crossAxisSpacing: 2.w,
            children: [
              ...monthDays.map((day) => dayWidget(day)).toList(),
            ],
          );
        }
        return Progress();
      },
    );
  }

  void setTerms(List<Term>? terms) {
    terms?.forEach((term) {
      debugPrint('term ${term.menus?.length} / ${term.visits?.length} ');
      findingStartEndTerm(term);
      newTermEvent(term);
      setVisits(term.visits, term.expiredAt);
      setMenus(term.menus, term.expiredAt);
      menuAlerts(term);
      alertBetweenVisits(term);
      alertDifferenceLastVisitAndTerm(term);
    });
  }

  void findingStartEndTerm(Term term) {
    final termStarts = monthDays.where(
        (element) => element.gregorian.toDateTime().toString().substring(0, 10) == term.startedAt);
    final termEnds = monthDays.where((element) =>
        element.gregorian.toDateTime().toString().substring(0, 10) ==
        (term.refundedAt == null || term.refundedAt!.isEmpty ? term.expiredAt : term.refundedAt));
    termStarts.forEach((dayItem) {
      if (!dayItem.types.contains(DayType.termStart)) dayItem.types.add(DayType.termStart);
      debugPrint('term start ${dayItem.gregorian} / ${dayItem.types}');
    });
    termEnds.forEach((dayItem) {
      if (!dayItem.types.contains(DayType.termEnd)) dayItem.types.add(DayType.termEnd);
      debugPrint('term end ${dayItem.gregorian} / ${dayItem.types}');
    });
  }

  void newTermEvent(Term term) {
    final termEndIndex = monthDays.indexWhere(
        (element) => element.gregorian.toDateTime().toString().substring(0, 10) == term.expiredAt);
    if (termEndIndex >= 0 && termEndIndex < monthDays.length - 1) {
      if (!monthDays[termEndIndex + 1].types.contains(DayType.newTerm))
        monthDays[termEndIndex + 1].types.add(DayType.newTerm);
      debugPrint('new term ${termEndIndex} / ${monthDays[termEndIndex + 1].types}');
    }
  }

  void menuAlerts(Term term) {
    if (term.menus != null) {
      listAlertDifferenceFirstMenuAndTerm(term);
      listAlertBetweenMenus(term);
      listAlertDifferenceLastMenuAndTerm(term);
    }
  }

  void listAlertDifferenceFirstMenuAndTerm(Term term) {
    if (term.menus!.length > 0 &&
        DateTime.parse(term.menus!.first.startedAt)
                .difference(DateTime.parse(term.startedAt))
                .inDays >
            1) {
      final delays = monthDays.where((element) =>
          element.gregorian.toDateTime().isAfter(DateTime.parse(term.startedAt)) &&
          element.gregorian.toDateTime().isBefore(DateTime.parse(term.menus!.first.startedAt)));
      delays.forEach((dayItem) {
        if (!dayItem.types.contains(DayType.menuAlert)) dayItem.types.add(DayType.menuAlert);
      });
    }
  }

  void listAlertBetweenMenus(Term term) {
    for (int i = 1; i < term.menus!.length; i++) {
      debugPrint(
          'difference menu ${term.menus![i - 1].expiredAt} / ${term.menus![i].startedAt}  / ${DateTime.parse(term.menus![i].startedAt).difference(DateTime.parse(term.menus![i - 1].expiredAt)).inDays}');
      if (DateTime.parse(term.menus![i].startedAt)
              .difference(DateTime.parse(term.menus![i - 1].expiredAt))
              .inDays >
          1) {
        final delays = monthDays.where((element) =>
            element.gregorian.toDateTime().isAfter(DateTime.parse(term.menus![i - 1].expiredAt)) &&
            element.gregorian.toDateTime().isBefore(DateTime.parse(term.menus![i].startedAt)));
        delays.forEach((dayItem) {
          if (!dayItem.types.contains(DayType.menuAlert)) dayItem.types.add(DayType.menuAlert);
        });
      }
    }
  }

  void listAlertDifferenceLastMenuAndTerm(Term term) {
    if (term.menus!.length > 0 &&
        DateTime.parse(term.expiredAt)
                .difference(DateTime.parse(term.menus!.last.expiredAt))
                .inDays >
            1) {
      final delays = monthDays.where((element) =>
          element.gregorian.toDateTime().isAfter(DateTime.parse(term.menus!.last.expiredAt)) &&
          element.gregorian.toDateTime().isBefore(DateTime.parse(term.expiredAt)));
      delays.forEach((dayItem) {
        if (dayItem.gregorian
                .toDateTime()
                .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
            !dayItem.types.contains(DayType.menuAlert)) {
          debugPrint(
              'menu alert ${dayItem.gregorian.toDateTime()} / ${DateTime.now()} / ${dayItem.gregorian.toDateTime().isBefore(DateTime.now())}');
          dayItem.types.add(DayType.menuAlert);
        }
      });
    }
  }

  void setVisits(List<Visit>? visits, String termExpire) {
    debugPrint('inside visit ${visits?.length}}');
    visits?.forEach((visit) {
      visitEvents(visit, termExpire);
    });
  }

  void visitEvents(Visit visit, String termExpire) {
    final visitEndIndex = monthDays.indexWhere(
        (element) => element.gregorian.toDateTime().toString().substring(0, 10) == visit.expiredAt);
    if (visitEndIndex >= 0 && visitEndIndex < monthDays.length - 1) {
      if (!monthDays[visitEndIndex + 1]
              .gregorian
              .toDateTime()
              .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
          monthDays[visitEndIndex].gregorian.toDateTime().isBefore(DateTime.parse(termExpire)) &&
          !monthDays[visitEndIndex + 1].types.contains(DayType.visit))
        monthDays[visitEndIndex + 1].types.add(DayType.visit);
      debugPrint('inside visit 2 ${visitEndIndex} / ${monthDays[visitEndIndex + 1].types}');
    }
  }

  void alertBetweenVisits(Term term) {
    if (term.visits != null) {
      for (int i = 1; i < term.visits!.length; i++) {
        // debugPrint(
        //     'difference visit ${term.visits![i - 1].expiredAt} / ${term.visits![i].visitedAt}  / ${DateTime.parse(term.visits![i].visitedAt).difference(DateTime.parse(term.visits![i - 1].expiredAt)).inDays}');
        if (DateTime.parse(term.visits![i].visitedAt)
                .difference(DateTime.parse(term.visits![i - 1].expiredAt))
                .inDays >
            1) {
          final delays = monthDays.where((element) =>
              element.gregorian
                  .toDateTime()
                  .isAfter(DateTime.parse(term.visits![i - 1].expiredAt)) &&
              element.gregorian.toDateTime().isBefore(DateTime.parse(term.visits![i].visitedAt)));
          delays.forEach((dayItem) {
            if (!dayItem.types.contains(DayType.visitAlert)) dayItem.types.add(DayType.visitAlert);
          });
        }
      }
    }
  }

  void alertDifferenceLastVisitAndTerm(Term term) {
    if (term.visits != null &&
        term.visits!.length > 0 &&
        DateTime.parse(term.expiredAt)
                .difference(DateTime.parse(term.visits!.last.expiredAt))
                .inDays >
            1) {
      final delays = monthDays.where((element) =>
          element.gregorian.toDateTime().isAfter(DateTime.parse(term.visits!.last.expiredAt)) &&
          element.gregorian.toDateTime().isBefore(DateTime.parse(term.expiredAt)));
      delays.forEach((dayItem) {
        if (dayItem.gregorian
                .toDateTime()
                .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
            !dayItem.types.contains(DayType.visitAlert)) {
          // debugPrint('menu alert ${dayItem.gregorian.toDateTime()} / ${DateTime.now()} / ${dayItem.gregorian.toDateTime().isBefore(DateTime.now())}');
          dayItem.types.add(DayType.visitAlert);
        }
      });
    }
  }

  void setMenus(List<Menu>? menus, String termExpire) {
    debugPrint('inside menu ${menus?.length}}');
    menus?.forEach((menu) {
      debugPrint(
          'menu ${jalali.toGregorian().toDateTime().toString()} / ${monthDays.where((element) => element.gregorian.toDateTime().toString().substring(0, 10) == '2021').isNotEmpty}');
      findMenuEndStart(menu);
      menuEvents(menu, termExpire);
    });
  }

  void findMenuEndStart(Menu menu) {
    final menuStarts = monthDays
        .where((element) =>
            element.gregorian.toDateTime().toString().substring(0, 10) == menu.startedAt)
        .toList();
    final menuEnds = monthDays
        .where((element) =>
            element.gregorian.toDateTime().toString().substring(0, 10) == menu.expiredAt)
        .toList();
    debugPrint('menu menu ${menu.startedAt} / ${menuStarts} / $menuEnds');
    menuStarts.forEach((dayItem) {
      if (!dayItem.types.contains(DayType.menuStart)) dayItem.types.add(DayType.menuStart);
      debugPrint('menu start ${dayItem.gregorian} / ${dayItem.types}');
    });
    menuEnds.forEach((dayItem) {
      if (!dayItem.types.contains(DayType.menuEnd)) dayItem.types.add(DayType.menuEnd);
      debugPrint('menu end ${dayItem.gregorian} / ${dayItem.types}');
    });
    if (menuStarts.isNotEmpty || menuEnds.isNotEmpty)
      menuDays(menuStarts.isEmpty && menuEnds.isNotEmpty ? monthDays.first : menuStarts.first,
          menuEnds.isEmpty && menuStarts.isNotEmpty ? monthDays.last : menuEnds.first);
  }

  void menuDays(DayItem start, DayItem end) {
    for (int i = 0; i < monthDays.length; i++) {
      if ((monthDays[i].gregorian.toDateTime().isAfter(start.gregorian.toDateTime()) &&
              monthDays[i].gregorian.toDateTime().isBefore(end.gregorian.toDateTime())) ||
          monthDays[i].gregorian.toDateTime() == start.gregorian.toDateTime() ||
          monthDays[i].gregorian.toDateTime() == end.gregorian.toDateTime()) {
        if (!monthDays[i].types.contains(DayType.menu)) monthDays[i].types.add(DayType.menu);
      }
    }
  }

  void menuEvents(Menu menu, String termExpire) {
    final menuEndIndex = monthDays.indexWhere(
        (element) => element.gregorian.toDateTime().toString().substring(0, 10) == menu.expiredAt);
    if (menuEndIndex >= 0 && menuEndIndex < monthDays.length - 1) {
      if (!monthDays[menuEndIndex + 1]
              .gregorian
              .toDateTime()
              .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
          monthDays[menuEndIndex].gregorian.toDateTime().isBefore(DateTime.parse(termExpire)) &&
          !monthDays[menuEndIndex + 1].types.contains(DayType.newList))
        monthDays[menuEndIndex + 1].types.add(DayType.newList);
      debugPrint('inside visit ${menuEndIndex} / ${monthDays[menuEndIndex + 1].types}');
    }
  }

  Widget dayWidget(DayItem day) {
    Widget? widget;
    if (day.types.contains(DayType.termStart) && day.types.contains(DayType.menuStart)) {
      widget = termMenuStart(day);
    } else if (day.types.contains(DayType.termEnd) && day.types.contains(DayType.menuEnd)) {
      widget = termMenuEnd(day);
    } else if (day.types.contains(DayType.termStart)) {
      widget = termEndStart(DayType.termStart);
    } else if (day.types.contains(DayType.termEnd)) {
      widget = termEndStart(DayType.termEnd);
    } else if (day.types.contains(DayType.menuStart) || day.types.contains(DayType.menuEnd)) {
      widget = Container(
        margin: EdgeInsets.fromLTRB(
          day.types.contains(DayType.menuStart) ? 0 : 1.w,
          1.w,
          day.types.contains(DayType.menuStart) ? 1.w : 0,
          1.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: day.types.contains(DayType.menuStart) ? AppRadius.radiusMild : Radius.zero,
            topRight: day.types.contains(DayType.menuStart) ? AppRadius.radiusMild : Radius.zero,
            bottomLeft: day.types.contains(DayType.menuEnd) ? AppRadius.radiusMild : Radius.zero,
            topLeft: day.types.contains(DayType.menuEnd) ? AppRadius.radiusMild : Radius.zero,
          ),
          color: Colors.deepPurple[100],
        ),
        child: Container(
          decoration: AppDecorations.boxMild.copyWith(
            color: Colors.deepPurple,
          ),
          child: Center(
            child: Text(
              day.jalali.day.toString(),
              style: typography.caption?.apply(
                color: AppColors.onPrimary,
                fontWeightDelta: 3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else if (day.types.contains(DayType.menu)) {
      widget = Container(
        color: Colors.deepPurple[100],
        margin: EdgeInsets.symmetric(vertical: 1.w),
        child: Center(
          child: Text(
            day.jalali.day.toString(),
            style: typography.caption?.apply(
              color: day.jalali.weekDay == 7 ? Colors.red : null,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (day.types.contains(DayType.menuAlert) || day.types.contains(DayType.visitAlert)) {
      widget = GestureDetector(
        onTap: () =>
            dialog(day.types.contains(DayType.visitAlert) ? DayType.visitAlert : DayType.menuAlert),
        child: Container(
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.warning_rounded,
                  color: AppColors.primary,
                  size: 7.w,
                ),
              ),
              Positioned(
                top: 2,
                right: 10,
                child: ImageUtils.fromLocal(
                  day.types.contains(DayType.visitAlert)
                      ? 'assets/images/diet/weight_icon.svg'
                      : 'assets/images/foodlist/advice/bulb_plus.svg',
                  width: 4.w,
                  fit: BoxFit.fitWidth,
                  color: day.types.contains(DayType.visitAlert) ? null : AppColors.warning,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      widget = Container(
        child: Center(
          child: Text(
            day.jalali.day.toString(),
            style: typography.caption?.apply(
              color: day.jalali.weekDay == 7 ? Colors.red : null,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (!day.gregorian
            .toDateTime()
            .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
        day.types.contains(DayType.visit)) {
      widget = event(DayType.visit, widget);
    } else if (!day.gregorian
            .toDateTime()
            .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
        day.types.contains(DayType.newList)) {
      widget = event(DayType.newList, widget);
    }
    if (!day.gregorian
            .toDateTime()
            .isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10))) &&
        day.types.contains(DayType.newTerm)) {
      widget = event(DayType.newTerm, widget);
    }
    if (day.gregorian.toDateTime().toString().substring(0, 10) ==
        DateTime.now().toString().substring(0, 10)) {
      widget = Stack(
        children: [
          widget,
          Positioned.fill(
              child: Container(
            decoration: AppDecorations.circle.copyWith(
              border: Border.all(color: AppColors.primary, width: 0.3.w),
            ),
            margin: EdgeInsets.all(1.w),
          )),
        ],
      );
    }
    if (day.types.contains(DayType.fade)) {
      widget = Opacity(
        opacity: 0.5,
        child: widget,
      );
    }
    return widget;
  }

  Widget termMenuStart(DayItem day) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        day.types.contains(DayType.menuStart) ? 0 : 1.w,
        1.w,
        day.types.contains(DayType.menuStart) ? 1.w : 0,
        1.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: day.types.contains(DayType.termStart) ? AppRadius.radiusMild : Radius.zero,
          topRight: day.types.contains(DayType.termStart) ? AppRadius.radiusMild : Radius.zero,
          bottomLeft: day.types.contains(DayType.termEnd) ? AppRadius.radiusMild : Radius.zero,
          topLeft: day.types.contains(DayType.termEnd) ? AppRadius.radiusMild : Radius.zero,
        ),
        color: Colors.deepPurple[100],
      ),
      child: Container(
        decoration: AppDecorations.boxMild.copyWith(
          color: Colors.deepPurple,
        ),
        // padding: EdgeInsets.all(1.w),
        child: Center(
          child: Text(
            intl.termStart,
            style: typography.caption?.apply(
              color: AppColors.onPrimary,
              fontSizeDelta: -4,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget termMenuEnd(DayItem day) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        day.types.contains(DayType.menuEnd) ? 1.w : 0,
        1.w,
        day.types.contains(DayType.menuEnd) ? 0 : 1.w,
        1.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: day.types.contains(DayType.termStart) ? AppRadius.radiusMild : Radius.zero,
          topRight: day.types.contains(DayType.termStart) ? AppRadius.radiusMild : Radius.zero,
          bottomLeft: day.types.contains(DayType.termEnd) ? AppRadius.radiusMild : Radius.zero,
          topLeft: day.types.contains(DayType.termEnd) ? AppRadius.radiusMild : Radius.zero,
        ),
        color: Colors.deepPurple[100],
      ),
      child: Container(
        decoration: AppDecorations.boxMild.copyWith(
          color: Colors.deepPurple,
        ),
        child: Center(
          child: Text(
            intl.termEnd,
            style: typography.caption?.apply(
              color: AppColors.onPrimary,
              fontSizeDelta: -4,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget termEndStart(DayType type) {
    return Container(
      decoration: AppDecorations.boxMild.copyWith(
        color: AppColors.primary,
      ),
      margin: EdgeInsets.all(1.w),
      child: Center(
        child: Text(
          type == DayType.termEnd ? intl.termEnd : intl.termStart,
          style: typography.caption?.apply(
            color: AppColors.onPrimary,
            fontSizeDelta: -4,
            heightDelta: -2,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget event(DayType type, Widget child) {
    return GestureDetector(
      onTap: () => dialog(type),
      child: Stack(
        children: [
          child,
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(
              child: Icon(
                Icons.circle,
                color: AppColors.primary,
                size: 2.w,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: FittedBox(
              child: Text(
                type == DayType.visit
                    ? intl.visit
                    : type == DayType.newList
                        ? intl.newList
                        : intl.newTerm,
                style: typography.caption?.apply(
                  color: AppColors.labelColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialog(DayType type) {
    DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          width: double.maxFinite,
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.onPrimary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DialogClose(),
              Text(
                dialogTitle(type),
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                dialogSubtitle(type),
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Space(height: 1.h),
              Container(
                child: Center(
                  child: SubmitButton(
                    onTap: () => Navigator.of(context).pop(),
                    label: intl.gotIt,
                  ),
                ),
              ),
              Space(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  String dialogTitle(DayType type) {
    String title = '';
    switch (type) {
      case DayType.visitAlert:
        title = intl.visitDelay;
        break;
      case DayType.menuAlert:
        title = intl.menuDelay;
        break;
      case DayType.visit:
        title = intl.visit;
        break;
      case DayType.newList:
        title = intl.newList;
        break;
      case DayType.newTerm:
        title = intl.newTerm;
        break;
    }
    return title;
  }

  String dialogSubtitle(DayType type) {
    String title = '';
    switch (type) {
      case DayType.visitAlert:
        title = intl.youDidNotSubmitWeight(MemoryApp.userInformation?.firstName ?? intl.user);
        break;
      case DayType.menuAlert:
        title = intl.youDidNotGetNewMenu(MemoryApp.userInformation?.firstName ?? intl.user);
        break;
      case DayType.visit:
        title = intl.visitShouldBeRenewed(MemoryApp.userInformation?.firstName ?? intl.user);
        break;
      case DayType.newList:
        title = intl.listShouldBeRenewed(MemoryApp.userInformation?.firstName ?? intl.user);
        break;
      case DayType.newTerm:
        title = intl.termShouldBeRenewed(MemoryApp.userInformation?.firstName ?? intl.user);
        break;
    }
    return title;
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
