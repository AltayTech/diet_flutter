import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bloc.dart';
import 'provider.dart';

class PaymentWaitScreen extends StatefulWidget {
  const PaymentWaitScreen({Key? key}) : super(key: key);

  @override
  _PaymentWaitScreenState createState() => _PaymentWaitScreenState();
}

class _PaymentWaitScreenState extends ResourcefulState<PaymentWaitScreen> {
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
                      return SpinKitCircle(
                        size: 7.w,
                        color: AppColors.primary,
                      );
                    }
                  },
                ),
              ),
              BottomNav(currentTab: BottomNavItem.DIET),
            ],
          ),
        ));
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TouchMouseScrollable(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: AppDecorations.boxSmall.copyWith(
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: context.textDirectionOfLocale,
                  children: [
                    Space(
                      height: 1.h,
                    ),
                    ImageUtils.fromLocal(
                      'assets/images/bill/success_pay.svg',
                      width: 30.w,
                      height: 35.w,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      textDirection: context.textDirectionOfLocaleInversed,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          intl.paymentWaitLabel,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: typography.caption!
                              .copyWith(color: AppColors.primaryVariantLight),
                        ),
                        SizedBox(width: 3.w),
                        ImageUtils.fromLocal(
                          'assets/images/bill/happy_face.svg',
                          width: 3.w,
                          height: 3.h,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Space(
                      height: 4.h,
                    ),
                    Text(
                      intl.amountPaid,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style:
                          typography.caption!.copyWith(color: AppColors.greyDate),
                    ),
                    Text.rich(
                        TextSpan(
                            text: bloc.invoice?.amount != null &&
                                    bloc.invoice!.amount.toString().length > 0 &&
                                    bloc.invoice!.amount! > 0
                                ? double.parse(bloc.invoice!.amount.toString())
                                    .toStringAsFixed(0)
                                    .seRagham()
                                : intl.free,
                            style: typography.headline5!
                                .copyWith(color: AppColors.priceGreenColor),
                            children: <InlineSpan>[
                              TextSpan(
                                text: bloc.invoice?.amount != null &&
                                        bloc.invoice!.amount.toString().length >
                                            0 &&
                                        bloc.invoice!.amount! > 0
                                    ? ' ' + intl.toman
                                    : '',
                                style: typography.caption!.copyWith(
                                    color: AppColors.priceGreenColor,
                                    fontSize: 10.sp),
                              )
                            ]),
                        textAlign: TextAlign.center),
                    Space(height: 1.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w,
                        vertical: 2.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            intl.waitingForSuccessPayment,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: typography.caption!
                                .copyWith(color: AppColors.redDate),
                          ),
                          Space(height: 2.h),
                          Text(
                            intl.paymentStatusForLastTime,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: typography.caption!.copyWith(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                    Space(height: 2.h),
                  ],
                ),
              ),
              Space(height: 2.h),
              SubmitButton(
                onTap: () {
                  bloc.checkLastInvoice();
                },
                icon: Icon(
                  Icons.refresh,
                  size: 7.w,
                  color: Colors.white,
                ),
                label: intl.checkPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(String? title, String? value, bool show) {
    return Row(
      textDirection: context.textDirectionOfLocaleInversed,
      children: [
        Expanded(
          child: Text(
            show
                ? (value!.contains(intl.free) ? value : '$value ${intl.toman}')
                : value ?? '',
            textDirection: context.textDirectionOfLocale,
            textAlign: TextAlign.start,
            style: typography.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.labelTextColor),
          ),
        ),
        Expanded(
          child: Text(
            title ?? '',
            textDirection: context.textDirectionOfLocale,
            textAlign: TextAlign.start,
            style: typography.caption,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
  void onShowMessage(String value) {}
}
