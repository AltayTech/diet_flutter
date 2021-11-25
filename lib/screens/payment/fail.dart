import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';

import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:logifan/widgets/space.dart';

import 'package:sizer/sizer.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bloc.dart';
import 'provider.dart';

class PaymentFailScreen extends StatefulWidget {
  const PaymentFailScreen({Key? key}) : super(key: key);

  @override
  _PaymentFailScreenState createState() => _PaymentFailScreenState();
}

class _PaymentFailScreenState
    extends ResourcefulState<PaymentFailScreen> {
  late PaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = PaymentBloc();
    // bloc.getLastInvoice();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaymentProvider(bloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.paymentSuccess),
          body: StreamBuilder(
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
        ));
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 80.h,
          ),
          decoration: AppDecorations.boxSmall.copyWith(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: context.textDirectionOfLocale,
            children: [
              Space(
                height: 2.h,
              ),
              ImageUtils.fromLocal(
                'assets/images/bill/success_pay.svg',
                width: 40.w,
                height: 50.w,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 3.h),
              Row(
                textDirection: context.textDirectionOfLocaleInversed,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    intl.paymentSuccessLabel,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: AppColors.primaryVariantLight),
                  ),
                  SizedBox(width: 3.w),
                  ImageUtils.fromLocal(
                    'assets/images/bill/happy_face.svg',
                    width: 7.w,
                    height: 7.w,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              Space(
                height: 2.h,
              ),
              Directionality(
                textDirection: context.textDirectionOfLocaleInversed,
                child: FlatButton.icon(
                  padding: EdgeInsets.symmetric(
                    vertical: 3.h,
                    horizontal: 3.w,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Color.fromRGBO(178, 178, 178, 1),
                        width: 0.2.w,
                      )),
                  onPressed: () {
                    bloc.setShowInformation();
                  },
                  icon: ImageUtils.fromLocal(
                    'assets/images/bill/info.svg',
                    width: 7.w,
                    height: 7.w,
                  ),
                  label: Text(
                    intl.paymentInformation,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              Space(height: 2.h),
              StreamBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w,
                        vertical: 2.h,
                      ),
                      child: Column(
                        children: [
                          item(intl.refId, bloc.invoice!.refId ?? '', false),
                          item(
                              intl.paymentDate,
                              bloc.invoice!.payedAt != null &&
                                      bloc.invoice!.payedAt!.length > 0
                                  ? DateTimeUtils.gregorianToJalaliYMD(
                                      bloc.invoice!.payedAt!)
                                  : '',
                              false),
                          item(
                              intl.amount,
                              bloc.invoice!.amount != null &&
                                      bloc.invoice!.amount.toString().length > 0
                                  ? double.parse(
                                          bloc.invoice!.amount.toString())
                                      .toStringAsFixed(0)
                                      .seRagham()
                                  : '',
                              true),
                          item(intl.mobile,
                              MemoryApp.userInformation?.mobile ?? '', false),
                        ],
                      ),
                    );
                  } else
                    return Container();
                },
                stream: bloc.showInformation,
              ),
              Space(height: 3.h),
              Text(
                intl.useFromList,
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: AppColors.labelTextColor),
              ),
              Space(height: 3.h),
              SubmitButton(
                  label: intl.confirmContinue,
                  onTap: () {
                    VxNavigator.of(context)
                        .clearAndPush(Uri.parse('/${bloc.path}'));
                  })
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
            show ? '$value ${intl.toman}' : value ?? '',
            textDirection: context.textDirectionOfLocale,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.labelTextColor),
          ),
        ),
        Expanded(
          child: Text(
            title ?? '',
            textDirection: context.textDirectionOfLocale,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.caption,
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
