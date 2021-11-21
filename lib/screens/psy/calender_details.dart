import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/data/entity/psy/calender.dart';
import 'package:behandam/data/entity/psy/plan.dart';
import 'package:behandam/screens/psy/calender.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CalenderDetails extends StatefulWidget {
  const CalenderDetails({Key? key}) : super(key: key);

  @override
  _CalenderDetailsState createState() => _CalenderDetailsState();
}

class _CalenderDetailsState extends State<CalenderDetails> {
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
  late CalenderOutput calendarData;
  List<SelectedTime>? advisersPerDay = [];
  PSYCalenderScreen calenderScreen = PSYCalenderScreen();
  // final datesBloc = DatesBloc();
  // final _eventStreamController = StreamController<dateType>();
  // StreamSink<dateType> get eventSink => _eventStreamController.sink;
  // Stream<dateType> get eventStream => _eventStreamController.stream;

  @override
  void initState() {
    super.initState();
    // eventStream.listen((event) {
    //   if(event == dateType.previous)
    //    getCalender(daysAgo);
    //   if(event == dateType.later)
    //    getCalender(daysLater);
    // });
    calender = getCalender(Jalali.now());
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
    RestApiClient().client?.getCalendar(start, end).then((value) {
      calendarData = value;
      calendarData.admins = calendarData.data!.admins;
      calendarData.packages = calendarData.data!.packages;
      calendarData.dates = calendarData.data!.dates;
      dates?.addAll(calendarData.dates!);
      setState(() {
        disabledClick = false;
        if (jour != Jalali.now()) disabledClickPre = false;
      });
      return dates;
    }).catchError((error) {});
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
      var admin = calendarData.admins!
          .firstWhere((admin) => admin.adminId == plan.adminId);
      var package = calendarData.packages!
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
    // final dateClock = BlocProvider.of<DatesBloc>(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
              height: 40.0,
              child: Text(
                  daysLater.formatter.mN == daysLater.addDays(-10).formatter.mN ? daysLater.formatter.mN : daysAgo.formatter.mN + '/' + daysLater.formatter.mN,
                  style: TextStyle(color: Color(0xff693BD8)))),
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
              TextButton.icon(
                  onPressed: disabledClick
                      ? null
                      : () {
                    // eventSink.add(dateType.later);
                    getCalender(daysLater);
                  },
                  icon: Icon(Icons.navigate_before,color: Colors.white),
                  label: Text(' روز آینده 10 ',
                      style: TextStyle(color: Color(0xff693BD8)))),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                    onPressed: disabledClickPre
                        ? null
                        : () {
                      // eventSink.add(dateType.previous);
                      getCalender(daysAgo);
                    },
                    icon: Icon(Icons.navigate_before,color: Colors.white),
                    label: Text(' روز گذشته 10',
                        style: TextStyle(color: Color(0xff693BD8)))),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.white70),
              child: Column(
                children: [
                  FractionallySizedBox(
                      widthFactor: 0.25,
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                          child: Container(
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: theme.dividerColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2.5)),
                              )))),
                  if (!flag1)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: flag2
                              ? Text(
                              "زمانی برای نمایش موجود نیست تاریخ دیگری انتخاب کنید")
                              : Text(
                            'برای مشاهده زمان های قابل رزرو یک تاریخ از تقویم بالا انتخاب کنید',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        )),
                  if (flag1) calenderScreen.ADShow(context, advisersPerDay),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
