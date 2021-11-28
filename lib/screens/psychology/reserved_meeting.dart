import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/psychology/reserved_meeting.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/psychology/calender_bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class PsychologyReservedMeetingScreen extends StatefulWidget {
  const PsychologyReservedMeetingScreen({Key? key}) : super(key: key);

  @override
  _PsychologyReservedMeetingScreenState createState() => _PsychologyReservedMeetingScreenState();
}

class _PsychologyReservedMeetingScreenState extends ResourcefulState<PsychologyReservedMeetingScreen> {
  late CalenderBloc calenderBloc;


  @override
  void initState() {
    super.initState();
    calenderBloc = CalenderBloc();
    listenBloc();
  }

  void listenBloc() {
    calenderBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    calenderBloc.getHistory();
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.myMeeting),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // height: 50.h,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(intl.myMeeting),
                  SizedBox(height: 2.h),
                Container(
                          child: StreamBuilder(
                              stream: calenderBloc.meetingDate,
                              builder: (context, AsyncSnapshot<List<HistoryOutput>> snapshot){
                                if(snapshot.hasData)
                                  return Column(
                                    children: [
                                      ...snapshot.data!.map((meeting) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(meeting.date!),
                                                    Row(
                                                      children: [
                                                        Text(intl.hour),
                                                        Text(meeting.expertPlanning!.startTime!.substring(0,5)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Text(intl.meetingWith,style: TextStyle(fontSize: 12.sp,color: AppColors.penColor)),
                                                Text(meeting.expertPlanning!.name!,style: TextStyle(fontSize: 14.sp,color: AppColors.penColor)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )).toList(),
                                    ],
                                  );
                                else
                                  return Center(
                                      child: Container(
                                          width: 15.w,
                                          height: 15.w,
                                          child: CircularProgressIndicator(
                                              color: Colors.grey, strokeWidth: 1.0)));
                              }),
                        )

                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          VxNavigator.of(context).pop();
        },
        label: Container(
            width:50.w,
            height:10.h,
            child: Center(child: Text(intl.sessionReserve))),
        backgroundColor: AppColors.btnColor,
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
    ));
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
