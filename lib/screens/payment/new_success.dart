import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

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
        body: SafeArea(
          child: Column(
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
      ),
    );
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
                      height: 53.h,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      child: Text(intl.amountPaid,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context).textTheme.caption!),
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
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                      color: AppColors.priceColor, fontWeight: FontWeight.w700))
                            ],
                            text: '${bloc.invoice!.amount!.toInt()}'.seRagham(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: AppColors.priceColor)),
                      ),
                      top: 8.h,
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
                      top: 20.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(bloc.invoice!.refId!,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.w500)),
                      top: 23.h,
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
                      top: 28.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(DateTimeUtils.gregorianToJalali(bloc.invoice!.verifiedAt!),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.w500)),
                      top: 31.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(intl.hour,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.w400, color: Color(0xff959499))),
                      top: 36.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(DateTimeUtils.getTime(bloc.invoice!.verifiedAt!),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.w500)),
                      top: 39.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(intl.mobile,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.w400, color: Color(0xff959499))),
                      top: 44.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    Positioned(
                      child: Text(MemoryApp.userInformation?.mobile ?? '******',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.w500)),
                      top: 47.h,
                      left: 10.w,
                      right: 10.w,
                    )
                  ],
                ),
                Space(
                  height: 3.h,
                ),
                CustomButton(AppColors.primary, intl.completeInformationAndGetDiet, Size(80.w, 6.h),
                    () {
                  VxNavigator.of(context).push(Uri.parse(bloc.path ?? Routes.listView));
                }),
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
  void onRetryLoadingPage() {

    bloc.onRetryLoadingPage();
    bloc.sendRequest();
  }

  @override
  void onRetryAfterNoInternet() {
    bloc.onRetryAfterNoInternet();
  }
}
