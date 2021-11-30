import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/psychology/booking.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/psychology/calender_bloc.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class PsychologyPaymentBillScreen extends StatefulWidget {
  const PsychologyPaymentBillScreen({Key? key}) : super(key: key);

  @override
  _PsychologyPaymentBillScreenState createState() => _PsychologyPaymentBillScreenState();
}

class _PsychologyPaymentBillScreenState extends ResourcefulState<PsychologyPaymentBillScreen> with WidgetsBindingObserver {
  var args;
  late CalenderBloc calenderBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    calenderBloc = CalenderBloc();
    listenBloc();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      calenderBloc.getInvoice();
      // listenBloc();
    }
  }

  void listenBloc() {
    calenderBloc.navigate.listen((event) {
      if (event as bool){
        VxNavigator.of(context).push(Uri.parse(Routes.psychologyReservedMeeting));
      } else
        VxNavigator.of(context).push(Uri.parse(Routes.psychologyCalender));
    });
    calenderBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments;
    super.build(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.condition),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(intl.factor,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,color: AppColors.penColor)),
                  SizedBox(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.grey
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,8,12,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(intl.adviserName, style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.penColor)),
                                Text(args!['name'], style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600,color: AppColors.redBar)),
                              ],
                            ),
                          ),
                          line(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,8,12,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(intl.day, style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.penColor)),
                                Text(args!['day'], style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600,color: AppColors.redBar)),
                              ],
                            ),
                          ),
                          line(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,8,12,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(intl.time, style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.penColor)),
                                Text(args!['time'], style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600,color: AppColors.redBar)),
                              ],
                            ),
                          ),
                          line(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,8,12,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(intl.date, style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.penColor)),
                                Text(args!['date'], style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600,color: AppColors.redBar)),
                              ],
                            ),
                          ),
                          line(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,8,12,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(intl.off, style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.penColor)),
                                Text((args!['price'] - args!['finalPrice']).toString(), style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600,color: AppColors.redBar)),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0,bottom: 12.0),
                                child: Column(
                                  children: [
                                    Text(intl.sum,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,color: AppColors.penColor)),
                                    SizedBox(height: 1.h),
                                    Text(args!['price'].toString(), style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,color: AppColors.redBar)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  button(AppColors.primaryVariantLight, intl.onlinePay, Size(80.w,5.h),
                          () {
                        Booking booking = Booking();
                        booking.expertPlanningId = args['sessionId'];
                        booking.packageId = args['packageId'];
                        booking.paymentTypeId = 0;
                        booking.originId = 3;
                        calenderBloc.getBook(booking);
                      }),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
  Widget line(){
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
      child: Line(color: AppColors.strongPen,height: 0.1.h),
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
