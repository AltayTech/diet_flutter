import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/pay_diamond.dart';
import 'package:behandam/screens/widget/toolbar.dart';
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
          appBar: Toolbar(titleBar: intl.paymentFail),
          body: StreamBuilder(
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
        ));
  }

  Widget content(ProductType type) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TouchMouseScrollable(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 80.h,
            ),
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: context.textDirectionOfLocale,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageUtils.fromLocal(
                  'assets/images/bill/fail.svg',
                  width: 20.w,
                  height: 20.w,
                ),
                Space(height: 1.h),
                titlePaymentFail(),
                Space(
                  height: 2.h,
                ),
                buttonShowInformation(),
                Space(height: 2.h),
                informationInvoice(),
                Space(height: 3.h),
                if (type != ProductType.SHOP) buttonRetryPayment() else buttonBackToShop(),
                Space(height: 3.h),
              ],
            ),
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
          bloc.invoice?.note ?? intl.failForAdmin,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget noteInvoiceReject() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 1.5.w,
        vertical: 1.h,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            height: 8.h,
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
                padding:
                    EdgeInsets.only(right: context.isRtl ? 7.w : 0, left: context.isRtl ? 0 : 7.w),
                child: Text(
                  bloc.invoice?.note ?? intl.failForAdmin,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  textDirection: context.textDirectionOfLocale,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: AppColors.colorTextApp, fontWeight: FontWeight.w700, fontSize: 10.sp),
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
    );
  }

  Widget buttonShowInformation() {
    return Directionality(
      textDirection: context.textDirectionOfLocale,
      child: Container(
        width: 50.w,
        child: FlatButton.icon(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
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
    );
  }

  Widget informationInvoice() {
    return StreamBuilder(
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
                    bloc.invoice!.payedAt != null && bloc.invoice!.payedAt!.length > 0
                        ? DateTimeUtils.gregorianToJalaliYMD(bloc.invoice!.payedAt!)
                        : '',
                    false),
                item(
                    intl.amount,
                    bloc.invoice!.amount != null &&
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
    );
  }

  Widget buttonBackToShop() {
    return Directionality(
      textDirection: context.textDirectionOfLocale,
      child: FlatButton(
        minWidth: 80.w,
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 3.w,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: AppColors.primary,
              width: 0.25.w,
            )),
        onPressed: () {
          context.vxNav.popToRoot();
        },
        child: Text(
          intl.backToShop,
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget buttonRetryPayment() {
    return Directionality(
      textDirection: context.textDirectionOfLocale,
      child: ElevatedButton(
        onPressed: () {
          if (navigator.currentConfiguration!.path.contains("subscription") ||
              navigator.currentConfiguration!.path.contains("shop")) {
            MemoryApp.analytics!.logEvent(name: "total_payment_fail");
            //context.vxNav.push(Uri.parse('/${bloc.path ?? ''}'));
            context.vxNav.pop();
          } else {
            context.vxNav.clearAndPush(Uri.parse(Routes.listView));
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
    // TODO: implement onRetryLoadingPage
    super.onRetryLoadingPage();
    bloc.sendRequest();
  }
}
