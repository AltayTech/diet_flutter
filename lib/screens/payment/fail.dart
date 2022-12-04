import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/pay_diamond.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bloc.dart';
import 'provider.dart';

class PaymentFailScreen extends StatefulWidget {
  const PaymentFailScreen({Key? key}) : super(key: key);

  @override
  _PaymentFailScreenState createState() => _PaymentFailScreenState();
}

class _PaymentFailScreenState extends ResourcefulState<PaymentFailScreen> {
  late PaymentBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PaymentBloc();
    bloc.getLastInvoice();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaymentProvider(bloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.paymentFail),
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
                height: 2.h,
              ),
              ImageUtils.fromLocal(
                'assets/images/bill/fail_pay.svg',
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
                    intl.paymentFailLabel,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style:
                        Theme.of(context).textTheme.headline6!.copyWith(color: Color(0xffFE5757)),
                  ),
                  SizedBox(width: 3.w),
                  ImageUtils.fromLocal(
                    'assets/images/bill/sad_face.svg',
                    width: 7.w,
                    height: 7.w,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              Space(
                height: 2.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 1.5.w,
                  vertical: 2.h,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 10.h,
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Color.fromARGB(255, 255, 231, 231),
                          child: Container(
                            child: ClipPath(
                              clipper: context.isRtl ? PayDiamond() : PayDiamondEn(),
                              child: Container(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 3.w,
                      right: 0.2.w,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: context.isRtl ? 7.w : 0, left: context.isRtl ? 0 : 7.w),
                          child: Text(
                            bloc.invoice?.note ?? intl.failForAdmin,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            textDirection: context.textDirectionOfLocale,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: AppColors.colorTextApp),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      bottom: 10,
                      child: Center(
                        child: ImageUtils.fromLocal(
                          'assets/images/bill/idea.svg',
                          fit: BoxFit.cover,
                          width: 0.08.w,
                          height: 0.08.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Space(height: 3.h),
              Directionality(
                textDirection: context.textDirectionOfLocale,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 3.h,
                        horizontal: 3.w,
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
                    /*MemoryApp.analytics!.logEvent(name: "total_payment_fail");*/
                    context.vxNav.push(Uri.parse('/${bloc.path ?? ''}'));
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 7.w,
                    color: Color.fromRGBO(178, 178, 178, 1),
                  ),
                  label: Text(
                    intl.retryPayment,
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
            show ? '$value ${intl.toman}' : value ?? '',
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
