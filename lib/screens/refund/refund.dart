import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/refund/bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class RefundScreen extends StatefulWidget {
  RefundScreen({Key? key}) : super(key: key);

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends ResourcefulState<RefundScreen> {
  late RefundBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = RefundBloc();
    bloc.getTermPackage();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      appBar: Toolbar(
        titleBar: intl.refund,
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            bloc.date = DateTimeUtils.gregorianToJalali(
                DateTime.parse(MemoryApp.termPackage!.term!.startedAt.replaceAll(RegExp('-'), ''))
                    .add(Duration(days: MemoryApp.termPackage?.package!.refundDeadline ?? 0))
                    .toString());
            bloc.setCanRefund(MemoryApp.termPackage!.canRefund ?? false);
            if (MemoryApp.refundItem!.items!.isEmpty) {
              if (!bloc.canRefundValue) {
                bloc.message = intl.descriptionRefund(bloc.date!);
              } else
                bloc.setCanRefund(true);
            } else {
              bloc.message = MemoryApp.refundItem!.items![0].refundStatus!.text;
              bloc.setCanRefund(false);
            }
            return StreamBuilder(
              stream: bloc.canRefund,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Color.fromARGB(255, 245, 245, 245),
                        width: 100.w,
                        height: 80.h,
                        padding: EdgeInsets.only(
                          left: 4.w,
                          right: 3.w,
                          top: 3.h,
                          bottom: 6.h,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 2.h),
                                  Image.asset(
                                    'assets/images/diet/refund.png',
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 3.h),
                                  RichText(
                                      textAlign: TextAlign.center,
                                      textDirection: context.textDirectionOfLocale,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${MemoryApp.userInformation?.firstName ?? intl.user} ${intl.babe}،',
                                          // text: 'کاربر عزیز',
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                        TextSpan(
                                          text: intl.dietDiscontent,
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                        TextSpan(
                                          text: bloc.date,
                                          style: Theme.of(context).textTheme.caption!.copyWith(
                                              color: Colors.redAccent, fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                            text: intl.requestRefundPaymentLabel,
                                            style: Theme.of(context).textTheme.caption!)
                                      ])),
                                  SizedBox(height: 5.h),
                                  SubmitButton(
                                    onTap: () {
                                      VxNavigator.of(context).push(Uri.parse(Routes.refundVerify));
                                    },
                                    label: intl.acceptRefundPayment,
                                  ),
                                  SizedBox(height: 3.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        padding: EdgeInsets.only(
                          left: 4.w,
                          right: 3.w,
                          top: 3.h,
                          bottom: 6.h,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              width: double.maxFinite,
                              height: 85.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 2.h),
                                  Image.asset(
                                    'assets/images/diet/refund.png',
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 3.h),
                                  RichText(
                                      textAlign: TextAlign.center,
                                      textDirection: context.textDirectionOfLocale,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${MemoryApp.userInformation?.firstName ?? intl.user} ${intl.babe}.',
                                          // text: 'کاربر عزیز',
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                        TextSpan(
                                          text: bloc.message,
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ])),
                                  SizedBox(height: 5.h),
                                  Container(
                                      height: 6.5.h,
                                      width: 55.w,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          intl.back,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          textDirection: context.textDirectionOfLocale,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.black54),
                                        ),
                                      )),
                                  SizedBox(height: 3.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: Progress(),
            );
          }
        },
        stream: bloc.waiting,
      ),
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
