import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/psychology/calender.dart';
import 'package:behandam/data/entity/psychology/plan.dart';
import 'package:behandam/extensions/list.dart';
import 'package:behandam/screens/psychology/calender_bloc.dart';
import 'package:behandam/screens/psychology/show_adviser.dart';
import 'package:behandam/screens/psychology/show_modal.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'calendar_provider.dart';

class PsychologyCalenderScreen extends StatefulWidget {
  const PsychologyCalenderScreen({Key? key}) : super(key: key);

  @override
  _PsychologyCalenderScreenState createState() => _PsychologyCalenderScreenState();
}

class _PsychologyCalenderScreenState extends ResourcefulState<PsychologyCalenderScreen> {
  late Future<List<Plan>?> calender;
  late CalenderBloc calenderBloc;

  @override
  void initState() {
    super.initState();
    calenderBloc = CalenderBloc();
    calenderBloc.getCalender(Jalali.now());
    listenBloc();
  }

  @override
  void dispose() {
    calenderBloc.dispose();
    super.dispose();
  }

  void listenBloc() {
    calenderBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CalendarProvider(
      calenderBloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: intl.determineTime),
        body: SafeArea(
          child: TouchMouseScrollable(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white70),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 40.0,
                            child: StreamBuilder(
                                stream: calenderBloc.daysAgo,
                                builder: (context, AsyncSnapshot<Jalali> daysAgo) {
                                  return StreamBuilder(
                                    stream: calenderBloc.daysLater,
                                    builder: (context, AsyncSnapshot<Jalali> daysLater) {
                                      if (daysAgo.hasData && daysLater.hasData)
                                        return Text(
                                            daysLater.data!.formatter.mN ==
                                                    daysLater.data!.addDays(-10).formatter.mN
                                                ? daysLater.data!.formatter.mN +
                                                    ' ' +
                                                    daysLater.data!.year.toString()
                                                : daysAgo.data!.formatter.mN +
                                                    ' ' +
                                                    '/' +
                                                    ' ' +
                                                    daysLater.data!.formatter.mN +
                                                    ' ' +
                                                    daysLater.data!.year.toString(),
                                            style: TextStyle(fontSize: 12.sp));
                                      else
                                        return Center(
                                            child: Container(
                                                width: 15.w, height: 15.w, child: Progress()));
                                    },
                                  );
                                })),
                        StreamBuilder<bool>(
                            stream: calenderBloc.waiting,
                            builder: (context, waiting) {
                              if (waiting.hasData && waiting.data == false)
                                return Container(
                                  child: StreamBuilder<CalenderOutput>(
                                      stream: calenderBloc.data,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) debugPrint('${snapshot.error}');

                                        if (snapshot.hasData &&
                                            snapshot.data!.dates.isNotNullOrNotEmpty) {
                                          return SizedBox(
                                            height: 250,
                                            child: GridView.count(
                                                primary: false,
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 16, left: 16, bottom: 16),
                                                crossAxisSpacing: 2,
                                                mainAxisSpacing: 2,
                                                crossAxisCount: 4,
                                                children: [
                                                  ...calenderBloc.dates!
                                                      .map(
                                                        (date) => InkWell(
                                                          onTap: () => setState(() {
                                                            if (date.expertPlanning!.isNotEmpty) {
                                                              calenderBloc.giveInfo(date.jDate!);
                                                            } else if (date.expertPlanning ==
                                                                    null ||
                                                                date.expertPlanning!.isEmpty) {
                                                              calenderBloc.flag1 = false;
                                                              calenderBloc.flag2 = true;
                                                            }
                                                          }),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(10),
                                                                color: AppColors.penColor
                                                                    .withOpacity(0.1)),
                                                            padding: const EdgeInsets.all(8),
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Center(
                                                                      child: Text(
                                                                          DateTimeUtils
                                                                              .dateToNamesOfDay(
                                                                                  date.date!),
                                                                          style: TextStyle(
                                                                              fontSize: 8.sp))),
                                                                  Text(
                                                                      date.jDate == null
                                                                          ? ''
                                                                          : date.jDate
                                                                              .toString()
                                                                              .substring(8, 10),
                                                                      style: TextStyle(
                                                                          fontSize: 10.sp,
                                                                          color: Colors.black)),
                                                                  SizedBox(height: 4.0),
                                                                  Icon(Icons.circle,
                                                                      size: date.expertPlanning ==
                                                                                  null ||
                                                                              date.expertPlanning!
                                                                                  .isEmpty
                                                                          ? 8.0
                                                                          : 0.0,
                                                                      color: AppColors.redBar)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ]),
                                          );
                                        } else
                                          return Center(child: Text(intl.psychologistNoTimeToBook));
                                      }),
                                );
                              else
                                return Center(child: Progress());
                            }),
                        Space(height: 1.h),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: AppColors.redBar,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: typography.caption!.copyWith(color: AppColors.onSurface),
                                  children: [
                                    TextSpan(text: ' '),
                                    TextSpan(text: "${intl.reserve}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Space(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Container(
                                width: 40.w,
                                color: AppColors.help,
                                child: Center(
                                  child: StreamBuilder(
                                    stream: calenderBloc.disabledClickPre,
                                    builder: (context, snapshot) {
                                      // print('statusAgo: ${snapshot.data}');
                                      return StreamBuilder(
                                          stream: calenderBloc.daysAgo,
                                          builder: (context, AsyncSnapshot<Jalali> previous) {
                                            return TextButton.icon(
                                                onPressed: snapshot.data == true ||
                                                        snapshot.data == null
                                                    ? null
                                                    : () =>
                                                        calenderBloc.getCalender(previous.data!),
                                                icon: Icon(Icons.arrow_back,
                                                    color: snapshot.data == true
                                                        ? AppColors.strongPen
                                                        : AppColors.accentColor),
                                                label: Text(intl.previousDays,
                                                    style: TextStyle(
                                                        color: snapshot.data == true
                                                            ? AppColors.strongPen
                                                            : AppColors.accentColor)));
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Container(
                                width: 40.w,
                                color: AppColors.help,
                                child: Center(
                                  child: StreamBuilder(
                                    stream: calenderBloc.disabledClick,
                                    builder: (context, snapshot) {
                                      // print("day: ${DateTimeUtils.convertToJalali(calenderBloc.jour)}");
                                      return StreamBuilder(
                                          stream: calenderBloc.daysLater,
                                          builder: (context, AsyncSnapshot<Jalali> later) {
                                            return Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: TextButton.icon(
                                                  onPressed: snapshot.data == true ||
                                                          snapshot.data == null
                                                      ? null
                                                      : () => calenderBloc.getCalender(later.data!),
                                                  icon: Icon(Icons.arrow_back,
                                                      color: snapshot.data == true
                                                          ? AppColors.strongPen
                                                          : AppColors.accentColor),
                                                  label: Text(intl.laterDays,
                                                      style: TextStyle(
                                                          color: snapshot.data == true
                                                              ? AppColors.strongPen
                                                              : AppColors.accentColor))),
                                            );
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (!calenderBloc.flag1)
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: calenderBloc.flag2
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                    width: 18.w,
                                                    height: 8.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      color: AppColors.help,
                                                    ),
                                                    child: Center(
                                                      child: ImageUtils.fromLocal(
                                                          'assets/images/foodlist/archive/event.svg',
                                                          width: 10.w,
                                                          height: 5.h),
                                                    )),
                                                SizedBox(height: 2.h),
                                                Text(intl.thereIsNotTime),
                                                CustomButton(AppColors.btnColor,
                                                    intl.showFirstFreeTime, Size(80.w, 4.h), () {
                                                  List data = calenderBloc.findFirstFreeTime();
                                                  if (data.length > 0)
                                                    showModal(context, data[0], data[0].times[0]);
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Column(
                                          children: [
                                            ImageUtils.fromLocal(
                                                'assets/images/foodlist/archive/event.svg',
                                                color: AppColors.strongPen,
                                                width: 10.w,
                                                height: 5.h),
                                            Text(
                                              intl.seeTime,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          ],
                                        ),
                                      ))),
                      if (calenderBloc.flag1) ADShow(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    calenderBloc.onRetryLoadingPage();
    calenderBloc.getCalender(Jalali.now());
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
