import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bloc.dart';
import 'provider.dart';

class PaymentWaitNewScreen extends StatefulWidget {
  const PaymentWaitNewScreen({Key? key}) : super(key: key);

  @override
  _PaymentWaitNewScreenState createState() => _PaymentWaitNewScreenState();
}

class _PaymentWaitNewScreenState extends ResourcefulState<PaymentWaitNewScreen> {
  late PaymentBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PaymentBloc();
    bloc.checkLastInvoice();
    blocListener();
  }

  void blocListener() {
    bloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
    bloc.navigateTo.listen((event) {
      context.vxNav.clearAndPush(Uri.parse('/$event'));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaymentProvider(bloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.paymentWait),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: bloc.waiting,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == false) {
                      return content();
                    } else {
                      return Progress();
                    }
                  },
                ),
              ),
              if (!navigator.currentConfiguration!.path.contains('subscription'))
                BottomNav(currentTab: BottomNavItem.DIET),
            ],
          ),
        ));
  }

  Widget content() {
    return Container(
      width: double.infinity,
      height: 97.h,
      decoration: BoxDecoration(
          image: ImageUtils.decorationImage("assets/images/background.png", fit: BoxFit.fill)),
      child: TouchMouseScrollable(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 80.h,
            ),
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: context.textDirectionOfLocale,
              children: [
                Space(
                  height: 3.h,
                ),
                ImageUtils.fromLocal(
                  'assets/images/bill/success.svg',
                  width: 30.w,
                  height: 30.w,
                ),
                Space(height: 1.h),
                Text(
                  intl.paymentSuccess,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: typography.headline6!.copyWith(color: AppColors.primaryVariantLight),
                ),
                Text(
                  intl.paymentCardToCardSuccessLabel,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: typography.caption,
                ),
                Space(
                  height: 2.h,
                ),
                Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    ImageUtils.fromLocal(
                      'assets/images/bill/back_billing.svg',
                      width: 70.w,
                      height: 53.h,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      child: Text(intl.amountPaid,
                          textAlign: TextAlign.center, softWrap: true, style: typography.caption!),
                      top: 4.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: RichText(
                        textAlign: TextAlign.center,
                        softWrap: true,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: ' ${intl.toman}',
                                  style: typography.caption!.copyWith(
                                      color: AppColors.priceColor, fontWeight: FontWeight.w700))
                            ],
                            text: '${bloc.invoice!.amount!.toInt()}'.seRagham(),
                            style: typography.headline6!.copyWith(color: AppColors.priceColor)),
                      ),
                      top: 8.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(intl.waitingForSuccessPayment,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: typography.caption!.copyWith(color: AppColors.redDate)),
                      top: 25.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(intl.paymentStatusForLastTime,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: typography.caption!.copyWith(fontSize: 10.sp)),
                      top: 30.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                  ],
                ),
                Space(
                  height: 3.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void onRetryAfterMaintenance() {
    bloc.checkLastInvoice();
  }

  @override
  void onRetryAfterNoInternet() {
    bloc.checkLastInvoice();
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {}
}
