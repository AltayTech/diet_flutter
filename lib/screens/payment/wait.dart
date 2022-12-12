import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/src/extensions.dart';

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
                height: 1.h,
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
                    intl.paymentWaitLabel,
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
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Color.fromRGBO(178, 178, 178, 1),
                        width: 0.2.w,
                      )),
                  child: TextButton.icon(
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
                        horizontal: 2.w,
                        vertical: 2.h,
                      ),
                      child: Column(
                        children: [
                          item(intl.refId, bloc.invoice?.refId ?? '', false),
                          item(
                              intl.paymentDate,
                              bloc.invoice?.payedAt != null && bloc.invoice!.payedAt!.length > 0
                                  ? DateTimeUtils.gregorianToJalaliYMD(bloc.invoice!.payedAt!)
                                  : '',
                              false),
                          item(
                              intl.amount,
                              bloc.invoice?.amount != null &&
                                      bloc.invoice!.amount.toString().length > 0 &&
                                      bloc.invoice!.amount! > 0
                                  ? double.parse(bloc.invoice!.amount.toString())
                                      .toStringAsFixed(0)
                                      .seRagham()
                                  : intl.free,
                              true),
                          item(intl.mobile, MemoryApp.userInformation?.mobile ?? '', false),
                        ],
                      ),
                    );
                  } else
                    return Container();
                },
                stream: bloc.showInformation,
              ),
              Space(height: 2.h),
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
                      intl.paymentStatusForLastTime,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      intl.waitingForSuccessPayment,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Space(height: 3.h),
              Directionality(
                textDirection: context.textDirectionOfLocale,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 2.w,
                      ),
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(178, 178, 178, 1),
                          width: 0.25.w,
                        ))),
                  ),
                  onPressed: () {
                    bloc.checkLastInvoice();
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 7.w,
                    color: Color.fromRGBO(178, 178, 178, 1),
                  ),
                  label: Text(
                    intl.checkPayment,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: AppColors.labelTextColor),
                  ),
                ),
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
            show ? (value!.contains(intl.free) ? value : '$value ${intl.toman}') : value ?? '',
            textDirection: context.textDirectionOfLocale,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold, color: AppColors.labelTextColor),
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
