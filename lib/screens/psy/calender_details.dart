import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/data/entity/psy/calender.dart';
import 'package:behandam/data/entity/psy/plan.dart';
import 'package:behandam/screens/psy/calender.dart';
import 'package:behandam/screens/psy/calender_bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sizer/sizer.dart';

class CalenderDetails extends StatefulWidget {
  const CalenderDetails({Key? key}) : super(key: key);

  @override
  _CalenderDetailsState createState() => _CalenderDetailsState();
}

class _CalenderDetailsState extends ResourcefulState<CalenderDetails> {
  List<String> nDay = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه'
  ];
  Jalali daysLater = Jalali.now();
  Jalali daysAgo = Jalali.now();
  bool flag1 = false;
  bool flag2 = false;
  bool disabledClick = false;
  bool disabledClickPre = false;
  String? start;
  String? end;
  List<Plan>? dates = [];
  late Future<List<Plan>?> calender;
  List<SelectedTime>? advisersPerDay = [];
  PSYCalenderScreen calenderScreen = PSYCalenderScreen();
  late CalenderBloc calenderBloc;

  @override
  void initState() {
    super.initState();
    calenderBloc = CalenderBloc();
    calender = getCalender(Jalali.now());
    listenBloc();
  }

  void listenBloc() {
    calenderBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  Future<List<Plan>?> getCalender(Jalali jour) async {
    setState(() {
      disabledClick = true;
      disabledClickPre = true;
    });
    dates?.clear();
    daysLater = jour.addDays(10);
    daysAgo = jour.addDays(-10);
    DateTime today = jour.toGregorian().toDateTime();
    start = today.toString().substring(0, 10);
    end = today.add(Duration(days: 10)).toString().substring(0, 10);
    int weekDay = jour.weekDay;
    for (int i = 0; i < weekDay - 1; i++) {
      dates?.add(Plan());
    }
    calenderBloc.calenderMethod(start!, end!);
    dates?.addAll(calenderBloc.calenderDates!);
    // print(dates);
    setState(() {
      disabledClick = false;
      if (jour != Jalali.now()) disabledClickPre = false;
    });
    return dates;

  }

  giveInfo(String date) {
    advisersPerDay!.clear();
    var expertPlannings =
        dates!.firstWhere((element) => element.jDate == date).expertPlanning;
    if (expertPlannings!.isNotEmpty) {
      flag1 = true;
    } else {
      flag1 = false;
    }
    for (var plan in expertPlannings) {
      var admin = calenderBloc.calenderAdmins!
          .firstWhere((admin) => admin.adminId == plan.adminId);
      var package = calenderBloc.calenderPackages!
          .firstWhere((package) => admin.packageId == package.id);
      advisersPerDay!.add(SelectedTime(
        adviserId: plan.id,
        adviserName: admin.name,
        adviserImage: admin.image,
        packageId: admin.packageId,
        date: date,
        price: package.price!.price,
        duration: package.time,
        times: plan.dateTimes,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white70),
            child: Column(
              children: [
                SizedBox(
                    height: 40.0,
                    child: Text(
                        daysLater.formatter.mN == daysLater.addDays(-10).formatter.mN
                            ? daysLater.formatter.mN + ' ' + daysLater.year.toString()
                            : daysAgo.formatter.mN + ' ' + '/'  + ' ' + daysLater.formatter.mN + ' ' + daysLater.year.toString(),
                    style: TextStyle(fontSize: 12.sp),)),
                FutureBuilder(
                    future: calender,
                    // stream: datesBloc.datesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      if (disabledClick) return CircularProgressIndicator();

                      // if (snapshot.hasData)
                      return SizedBox(
                        height: 200,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              crossAxisCount: 7,
                              children: [
                                ...nDay
                                    .map((weekDay) => Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                      child: Text(weekDay,
                                          style: TextStyle(fontSize: 10))),
                                ))
                                    .toList(),
                                ...dates!
                                    .map(
                                      (date) => InkWell(
                                    onTap: () => setState(() {
                                      if (date.expertPlanning!.isNotEmpty) {
                                        giveInfo(date.jDate!);
                                      } else if (date.expertPlanning == null ||
                                          date.expertPlanning!.isEmpty) {
                                        flag1 = false;
                                        flag2 = true;
                                      }
                                    }),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            // color: item['planning'] != null ? Colors.white : null
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                    date == null ||
                                                        date.jDate == null
                                                        ? ''
                                                        : date.jDate
                                                        .toString()
                                                        .substring(8, 10),
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                SizedBox(height: 4.0),
                                                // Icon(
                                                //     Icons.circle,
                                                //     size: item['date'].length>1 && item['planning'] == null ? 8.0 : 0.0,
                                                //     color: Color(0xff693BD8))
                                                // break;
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    .toList(),
                              ]),
                        ),
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: AppColors.help,
                      child: Center(
                        child: TextButton.icon(
                            onPressed: disabledClickPre
                                ? null
                                : () {
                              // eventSink.add(dateType.previous);
                              getCalender(daysAgo);
                            },
                            icon: Icon(Icons.arrow_back,color: AppColors.accentColor),
                            label: Text(intl.previousDays,
                                style: TextStyle(color: AppColors.accentColor))),
                      ),
                    ),
                    Container(
                      color: AppColors.help,
                      child: Center(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextButton.icon(
                              onPressed: disabledClick
                                  ? null
                                  : () {
                                // eventSink.add(dateType.later);
                                getCalender(daysLater);
                              },
                              icon: Icon(Icons.arrow_back,color: AppColors.accentColor),
                              label: Text(intl.laterDays,
                                  style: TextStyle(color: AppColors.accentColor))),
                        ),
                      ),
                    ),
                  ],
                ),
            ],),
          ),
        ),
          Expanded(
            child: Column(
              children: [
                if (!flag1)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: flag2
                        ? Container(
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today_outlined,color: AppColors.arcColor),
                              Text(intl.thereIsNotTime)
                            ],
                          ),
                        )
                        : Container(
                          child: Column(
                          children: [
                            Text(intl.seeTime,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                          ),
                          )
                      )),
                if (flag1) calenderScreen.ADShow(context, advisersPerDay),
              ],
            ),
          )
        ],
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
  }
}
