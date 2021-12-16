import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/data/entity/psychology/plan.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/psychology/calender_bloc.dart';
import 'package:behandam/screens/psychology/show_advisor.dart';
import 'package:behandam/screens/utility/modal.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

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

  ADShow(List<SelectedTime>? info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 540,
        child: ListView.builder(
            shrinkWrap: false,
            itemCount: info!.length,
            itemBuilder: (_, index) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: info[index].adviserImage == null
                          ? ImageUtils.fromLocal('assets/images/profile/psychology.svg',
                              width: 20.w, height: 7.h)
                          : ImageUtils.fromNetwork(
                              FlavorConfig.instance.variables["baseUrlFile"] +
                                  info[index].adviserImage,
                              width: 20.w,
                              height: 10.h),
                      title: Text(info[index].adviserName!),
                      subtitle: Text(
                        info[index].role!,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 25.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.help,
                            ),
                            child: Center(
                              child: Text("${info[index].duration.toString() + intl.min} ",
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.redBar)),
                            ),
                          ),
                          Space(width: 5.w),
                          Container(
                            width: 25.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.stableType,
                            ),
                            child: Center(
                              child: Text("${info[index].finalPrice.toString() + intl.currency} ",
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.greenRuler)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Space(height: 2.h),
                    line(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(intl.selectYourPhoneSession, style: TextStyle(fontSize: 10.sp)),
                          Text(DateTimeUtils.dateToDetail(info[index].date!),
                              style: TextStyle(fontSize: 12.sp, color: AppColors.redBar)),
                        ],
                      ),
                    ),
                    ButtonBar(
                        buttonPadding: EdgeInsets.all(0.0),
                        alignment: MainAxisAlignment.start,
                        children: [
                          ...info[index].times!.map((item) {
                            return Padding(
                                padding: EdgeInsets.only(right: 12.0, left: 12.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    showModal(context, info[index], item);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(AppColors.grey),
                                    foregroundColor: MaterialStateProperty.all(AppColors.onSurface),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                  child: Text(item.startTime.toString().substring(0, 5)),
                                ));
                          }).toList(),
                        ])
                  ],
                ),
              );
            }),
      ),
    );
  }

  showModal(BuildContext ctx, SelectedTime info, Planning item) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      context: ctx,
      builder: (_) {
        return Popover(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        width: 10.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: AppColors.help,
                        ),
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: AppColors.redBar))),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: info.adviserImage == null
                        ? ImageUtils.fromLocal('assets/images/profile/psychology.svg',
                            width: 20.w, height: 7.h)
                        : ImageUtils.fromNetwork(
                            FlavorConfig.instance.variables["baseUrlFile"] + info.adviserImage,
                            width: 20.w,
                            height: 10.h),
                  ),
                  Column(
                    children: [
                      Text(info.adviserName!),
                      Text(info.role!),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intl.sessionDuration, style: TextStyle(fontSize: 12.sp)),
                    Text("${info.duration.toString() + intl.min} ",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariantLight)),
                  ],
                ),
              ),
              line(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intl.day, style: TextStyle(fontSize: 12.sp)),
                    Text(DateTimeUtils.dateToNamesOfDay(info.date!),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariantLight)),
                  ],
                ),
              ),
              line(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intl.time, style: TextStyle(fontSize: 12.sp)),
                    Text(item.startTime.toString().substring(0, 5),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariantLight)),
                  ],
                ),
              ),
              line(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intl.date, style: TextStyle(fontSize: 12.sp)),
                    Text(info.date!,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariantLight)),
                  ],
                ),
              ),
              line(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intl.price, style: TextStyle(fontSize: 12.sp)),
                    Text("${info.finalPrice.toString() + intl.currency} ",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariantLight)),
                  ],
                ),
              ),
              Space(height: 2.h),
              button(AppColors.btnColor, intl.reserveThisTime, Size(70.w, 5.h), () {
                ctx.vxNav.push(Uri.parse(Routes.psychologyTerms), params: {
                  'sessionId': item.id,
                  'packageId': info.packageId,
                  'name': info.adviserName,
                  'price': info.price,
                  'finalPrice': info.finalPrice,
                  'day': DateTimeUtils.dateToNamesOfDay(info.date!),
                  'date': DateTimeUtils.dateToDetail(info.date!),
                  'time': item.startTime.toString().substring(0, 5),
                });
              }),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(70.w, 5.h)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(AppColors.penColor),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                ),
                child:
                    Text(intl.iDoNot, style: TextStyle(color: AppColors.penColor, fontSize: 16.sp)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget line() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
      child: Line(color: AppColors.strongPen, height: 0.1.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.redBar,
            title: Text(intl.determineTime),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios), onPressed: () => VxNavigator.of(context).pop())),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.white70),
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
                    StreamBuilder(
                        stream: calenderBloc.data,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);

                          if (snapshot.hasData)
                            return SizedBox(
                              height: 250,
                              child: GridView.count(
                                  primary: false,
                                  padding: const EdgeInsets.all(20),
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
                                              } else if (date.expertPlanning == null ||
                                                  date.expertPlanning!.isEmpty) {
                                                calenderBloc.flag1 = false;
                                                calenderBloc.flag2 = true;
                                              }
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: AppColors.penColor.withOpacity(0.1)),
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                            DateTimeUtils.dateToNamesOfDay(
                                                                date.date!),
                                                            style: TextStyle(fontSize: 8.sp))),
                                                    Text(
                                                        date == null || date.jDate == null
                                                            ? ''
                                                            : date.jDate
                                                                .toString()
                                                                .substring(8, 10),
                                                        style: TextStyle(
                                                            fontSize: 10.sp, color: Colors.black)),
                                                    SizedBox(height: 4.0),
                                                    Icon(Icons.circle,
                                                        size: date.expertPlanning == null ||
                                                                date.expertPlanning!.isEmpty
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
                          else
                            return Center(
                                child: Container(
                                    width: 15.w,
                                    height: 15.w,
                                    child: CircularProgressIndicator(
                                        color: Colors.grey, strokeWidth: 1.0)));
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14.sp, color: AppColors.onSurface),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: AppColors.redBar,
                                ),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(text: "${intl.reserve}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
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
                                          onPressed: snapshot.data == true || snapshot.data == null
                                              ? null
                                              : () => calenderBloc.getCalender(previous.data!),
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
                        Container(
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
                                            onPressed:
                                                snapshot.data == true || snapshot.data == null
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
                      ],
                    ),
                  ],
                ),
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
                                          button(AppColors.btnColor, intl.showFirstFreeTime,
                                              Size(80.w, 4.h), () {
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
                if (calenderBloc.flag1) ADShow(calenderBloc.advisersPerDay),
              ],
            )
          ],
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
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
