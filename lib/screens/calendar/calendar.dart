import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/screens/calendar/bloc.dart';
import 'package:behandam/screens/calendar/day_item.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
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
    jalali = Jalali.now();
    makeCalenderDays();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          builder: (_, AsyncSnapshot<bool> snapshot){
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
                      color: AppColors.lableColor,
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
          types: [DayType.usual],
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
        for (int i = 1;
        i <= (7 - jalali.withDay(jalali.monthLength).weekDay);
        i++) {
          final shamsi = jalali.withDay(jalali.monthLength).addDays(i);
          monthDays.add(DayItem(
            jalali: shamsi,
            gregorian: Gregorian.fromJalali(shamsi),
            types: [DayType.fade],
          ));
        }
      }
    }
  }

  Widget header() {
    return Row(
      children: [
        Container(
          color: AppColors.primary.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Column(
            children: [
              Text(
                jalali.month == Jalali.now().month ? jalali.formatter.wN : jalali.withDay(1).formatter.wN,
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Text(
                jalali.month == Jalali.now().month ? jalali.day.toString() : jalali.withDay(1).day.toString(),
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Space(width: 2.w),
        Expanded(
          child: Text(
            '${jalali.formatter.mN} ${jalali.formatter.yyyy}',
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
                      color: AppColors.lableColor,
                    ),
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget calendar(){
    return StreamBuilder(
      stream: bloc.calendar,
      builder: (_, AsyncSnapshot<CalendarData?> snapshot){
        if(snapshot.hasData) {
          debugPrint(
              'snapshot  / ${snapshot.requireData?.terms[0].visits?.length}');
          setTerms(snapshot.requireData?.terms);
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ...monthDays
                  .map((day) =>
                  Text(
                    day.jalali.day.toString(),
                    style: typography.caption?.apply(
                      color: AppColors.lableColor,
                    ),
                    textAlign: TextAlign.center,
                  ))
                  .toList(),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  void setTerms(List<Term>? terms){
    terms?.forEach((term) {
      // debugPrint('term ${term.menus?.length} ');
      // final termStarts = monthDays.where((element) => element.gregorian.toDateTime().toString().substring(0, 10) == term.startedAt);
      // final termEnds = monthDays.where((element) => element.gregorian.toDateTime().toString().substring(0, 10) == term.expiredAt);
      // termStarts.forEach((dayItem) {
      //   if(!dayItem.types.contains(DayType.termStart)) dayItem.types.add(DayType.termStart);
      //   debugPrint('term start ${dayItem.gregorian} / ${dayItem.types}');
      // });
      // termEnds.forEach((dayItem) {
      //   if(!dayItem.types.contains(DayType.termEnd)) dayItem.types.add(DayType.termEnd);
      //   debugPrint('term end ${dayItem.gregorian} / ${dayItem.types}');
      // });
      // setMenus(term.menus);
    });
  }

  void setMenus(List<Menu>? menus){
    debugPrint('inside menu ${menus?.length}}');
    menus?.forEach((menu) {
      debugPrint('menu ${jalali.toGregorian().toDateTime().toString()} / ${monthDays.where((element) => element.gregorian.toDateTime().toString().substring(0, 10) == '2021').isNotEmpty}');
      // final menuStarts = monthDays.where((element) => element.gregorian.toDateTime().toString().substring(0, 10) == menu.startedAt);
      // final menuEnds = monthDays.where((element) => element.gregorian.toDateTime().toString().substring(0, 10) == menu.expiredAt);
      // menuStarts.forEach((dayItem) {
      //   if(!dayItem.types.contains(DayType.menuStart)) dayItem.types.add(DayType.menuStart);
      //   debugPrint('menu start ${dayItem.gregorian} / ${dayItem.types}');
      // });
      // menuEnds.forEach((dayItem) {
      //   if(!dayItem.types.contains(DayType.menuEnd)) dayItem.types.add(DayType.menuEnd);
      //   debugPrint('menu end ${dayItem.gregorian} / ${dayItem.types}');
      // });
    });
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
}
