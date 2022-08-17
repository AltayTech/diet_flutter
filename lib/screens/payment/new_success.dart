import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

import 'bloc.dart';
import 'provider.dart';

class PaymentSuccessNewScreen extends StatefulWidget {
  const PaymentSuccessNewScreen({Key? key}) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends ResourcefulState<PaymentSuccessNewScreen> {
  late PaymentBloc bloc;
  bool isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
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

    return PaymentProvider(
      bloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: intl.paymentSuccess),
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
            StreamBuilder<ProductType>(
              stream: bloc.productType,
              initialData: ProductType.DIET,
              builder: (context, type) {
                if (type.hasData && type.data != ProductType.SUBSCRIPTION)
                  return BottomNav(
                      currentTab:
                          type == ProductType.DIET ? BottomNavItem.SHOP : BottomNavItem.DIET);
                else
                  return EmptyBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      width: double.infinity,
      height: 97.h,
      decoration: BoxDecoration(
          image: ImageUtils.decorationImage("assets/images/background.png",
              fit: BoxFit.fill)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TouchMouseScrollable(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80.h,
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
                    'assets/images/bill/success.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                  Space(height: 1.h),
                  Text(
                    intl.paymentSuccess,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: AppColors.primaryVariantLight),
                  ),
                  Text(
                    intl.paymentSuccessLabel,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context).textTheme.caption,
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
                        height: 40.h,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        child: Text(intl.amountPaid,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.caption!),
                        top: 2.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text('30000 تومان',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: AppColors.priceColor)),
                        top: 6.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text(intl.refId,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w400, color: Color(0xff959499))),
                        top: 16.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text('33543453',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w500)),
                        top: 19.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text(intl.date,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w400, color: Color(0xff959499))),
                        top: 24.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text('1400/05/22',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w500)),
                        top: 27.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text(intl.time,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w400, color: Color(0xff959499))),
                        top: 32.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      Positioned(
                        child: Text('14:30',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w500)),
                        top: 35.h,
                        left: 10.w,
                        right: 10.w,
                      )
                    ],
                  ),
                ],
              ),
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
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    bloc.sendRequest();
  }
}
