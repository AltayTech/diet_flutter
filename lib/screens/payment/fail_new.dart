import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/pay_diamond.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bloc.dart';
import 'provider.dart';

class PaymentFailNewScreen extends StatefulWidget {
  const PaymentFailNewScreen({Key? key}) : super(key: key);

  @override
  _PaymentFailScreenState createState() => _PaymentFailScreenState();
}

class _PaymentFailScreenState extends ResourcefulState<PaymentFailNewScreen> {
  late PaymentBloc bloc;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;

      bloc = PaymentBloc();
      bloc.setProductType();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaymentProvider(bloc,
        child: Scaffold(
          body: SafeArea(
            child: StreamBuilder(
                stream: bloc.waiting,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == false) {
                    return StreamBuilder<ProductType?>(
                        stream: bloc.productType,
                        builder: (context, type) {
                          if (type.data != null)
                            return Column(children: [
                              Expanded(child: content(type.data!)),
                              if (!navigator.currentConfiguration!.path.contains("subscription"))
                                BottomNav(
                                    currentTab: type == ProductType.SHOP
                                        ? BottomNavItem.SHOP
                                        : BottomNavItem.DIET)
                            ]);
                          else
                            return Space();
                        });
                  } else {
                    return SpinKitCircle(
                      size: 7.w,
                      color: AppColors.primary,
                    );
                  }
                }),
          ),
        ));
  }

  Widget content(ProductType type) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: context.textDirectionOfLocale,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Space(height: 3.h),
                ImageUtils.fromLocal(
                  'assets/images/bill/fail.svg',
                  width: 25.w,
                  height: 25.w,
                ),
                Space(height: 1.h),
                titlePaymentFail(),
                if (bloc.invoice?.note != null)
                  Space(
                    height: 3.h,
                  ),
                if (bloc.invoice?.note != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 70.w,
                        child: ImageUtils.fromLocal(
                          'assets/images/bill/back_fail_billing.svg',
                          width: 70.w,
                          height: 30.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        child: Text(intl.mobile,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.caption!),
                        top: 2.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text(MemoryApp.userInformation!=null ?MemoryApp.userInformation!.mobile! : '********',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: AppColors.priceColor)),
                        top: 5.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text(intl.theCauseOfTheExpert,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w400, color: Color(0xff959499))),
                        top: 15.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Text(bloc.invoice!.note!,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.w500,fontSize: 10.sp)),
                        ),
                        top: 18.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                    ],
                  ),
                Space(height: 3.h),
               buttonRetryPayment() ,
                Space(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget titlePaymentFail() {
    return Column(
      textDirection: context.textDirectionOfLocaleInversed,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          intl.paymentFail,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.red),
        ),
        Text(
         intl.failForAdmin,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget buttonRetryPayment() {
    return Directionality(
      textDirection: context.textDirectionOfLocale,
      child: ElevatedButton(
        onPressed: () {
          if (navigator.currentConfiguration!.path.contains("subscription")) {
            MemoryApp.analytics!.logEvent(name: "total_payment_fail");
            context.vxNav.pop();
          } else {
            context.vxNav.push(Uri.parse(bloc.path!));
          }
        },
        child: Text(
          intl.backToPayment,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.button!.copyWith(color: AppColors.primary),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(80.w, 8.h)),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: 2.h,
            horizontal: 3.w,
          )),
          backgroundColor: MaterialStateProperty.all(Color(0x11ffffff)),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(
                color: AppColors.primary,
                width: 0.25.w,
              ))),
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
  void onRetryLoadingPage() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryLoadingPage();
    bloc.sendRequest();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryAfterNoInternet();
  }
}
