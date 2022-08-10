import 'package:behandam/app/app.dart';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/payment/payment_type_new.dart';
import 'package:behandam/screens/profile/profile.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/enable_discount_box.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/package_item.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_checkbox.dart';
import 'package:behandam/widget/stepper.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class BillPaymentNewScreen extends StatefulWidget {
  const BillPaymentNewScreen({Key? key}) : super(key: key);

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ResourcefulState<BillPaymentNewScreen>
    with WidgetsBindingObserver {
  late BillPaymentBloc bloc;
  late ProgressTimeline _progressTimeline;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _progressTimeline = ProgressTimeline(
      states: [
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
      ],
      height: 6.h,
      width: 45.w,
      checkedIcon: ImageUtils.fromLocal("assets/images/physical_report/checked_step.svg",
          width: 7.w, height: 7.w, fit: BoxFit.fill),
      currentIcon: ImageUtils.fromLocal("assets/images/physical_report/current_step.svg",
          width: 7.w, height: 7.w, fit: BoxFit.fill),
      failedIcon: ImageUtils.fromLocal("assets/images/physical_report/checked_step.svg",
          width: 7.w, height: 7.w, fit: BoxFit.fill),
      uncheckedIcon: ImageUtils.fromLocal("assets/images/physical_report/none_step.svg",
          width: 4.w, height: 4.w, fit: BoxFit.fill),
      iconSize: 7.w,
      connectorLength: 8.w,
      connectorColorSelected: AppColors.primary,
      connectorWidth: 4,
      connectorColor: Color(0xffC9D1E1),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        _progressTimeline.gotoStage(2);
      });
    });

    bloc = BillPaymentBloc();
    if (navigator.currentConfiguration!.path.contains('subscription')) {
      bloc.getReservePackagePayment();
    } else {
      bloc.getPackagePayment();
    }

    listenBloc();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && bloc.checkLatestInvoice) {
      if (mounted) {
        DialogUtils.showDialogProgress(context: context);
      }

      bloc.checkOnlinePayment();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void listenBloc() {
    bloc.onlinePayment.listen((event) {
      debugPrint('listen online payment ${navigator.currentConfiguration?.path}');
      if (event != null && event) {
        MemoryApp.isShowDialog = false;
        if (navigator.currentConfiguration!.path.contains('subscription')) {
          VxNavigator.of(context).clearAndPushAll([
            Uri.parse(Routes.profile),
            Uri.parse(Routes.billSubscriptionHistory),
            Uri.parse(Routes.subscriptionPaymentOnlineSuccess)
          ]);
          eventBus.fire(true);
        } else {
          VxNavigator.of(context).clearAndPush(Uri.parse("/${bloc.path}"));
        }
      } else {
        MemoryApp.isShowDialog = false;
        if (event != null && !event) {
          if (bloc.packageItemNew!.type! == 2) {
            VxNavigator.of(context).clearAndPushAll([
              Uri.parse(Routes.profile),
              Uri.parse(Routes.billSubscriptionHistory),
              Uri.parse(Routes.subscriptionPaymentOnlineFail)
            ]);
          } else {
            VxNavigator.of(context).clearAndPush(Uri.parse(Routes.paymentFail));
          }
        } else
          Navigator.of(context).pop();
      }
    });

    bloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, intl.offError);
    });

    bloc.popDialog.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
    });

    bloc.navigateTo.listen((event) {
      debugPrint('listen navigate ${event.next}');
      Payment? result;
      try {
        result = (event as NetworkResponse<Payment>).data;
      } catch (e) {}
      if (bloc.type == PaymentType.online && result?.url != null) {
        MemoryApp.analytics!.logEvent(name: "total_payment_online_select");
        bloc.mustCheckLastInvoice();
        Utils.launchURL(result!.url!);
      } else if (bloc.type == PaymentType.cardToCard) {
        context.vxNav.push(Uri.parse(Routes.cardToCard));
      } else if (event.next != null) {
        if (navigator.currentConfiguration!.path.contains('subscription')) {
          VxNavigator.of(context).clearAndPushAll([
            Uri.parse(Routes.profile),
            Uri.parse(Routes.billSubscriptionHistory),
            Uri.parse('/${event.next}'),
          ]);
        } else
          context.vxNav.push(Uri(path: '/${event.next}'));
      } else {
        Utils.getSnackbarMessage(context, event.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BillPaymentProvider(bloc, child: body());
  }

  Widget body() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.paymentFinalBill),
        backgroundColor: AppColors.newBackgroundFlow,
        body: StreamBuilder<bool>(
            stream: bloc.waiting,
            builder: (context, waiting) {
              if (waiting.hasData && !waiting.requireData)
                return TouchMouseScrollable(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: Center(
                              child: _progressTimeline,
                            ),
                          ),
                          Text(
                            intl.enterYourPackage,
                            style: typography.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            intl.enterYourPackageDescription,
                            style: typography.overline,
                          ),
                          Space(
                            height: 2.h,
                          ),
                          StreamBuilder(
                            stream: bloc.refreshPackages,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  ...bloc.packageItems
                                      .asMap()
                                      .map((index, package) => MapEntry(
                                          index,
                                          Padding(
                                            padding: EdgeInsets.only(top: (index > 0) ? 8.0 : 0.0,left: 8,right: 8),
                                            child: PackageWidget(
                                                onTap: () {
                                                  bloc.setPackageItem = package;
                                                },
                                                title: package.name ?? '',
                                                isSelected: package.isSelected ?? false,
                                                description: package.description ?? '',
                                                price: '${package.price}',
                                                finalPrice: '${package.finalPrice}',
                                                maxHeight: 22.h,
                                                isOurSuggestion: package.is_suggestion,
                                                isBorder: true,borderColor: package.barColor,
                                            ),
                                          )))
                                      .values
                                      .toList(),
                                  Space(height: 2.h,),
                                  Text(
                                    intl.enterYourPackage,
                                    style: typography.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  ...bloc.packageItems
                                      .asMap()
                                      .map((index, package) => MapEntry(
                                      index,
                                      Padding(
                                        padding: EdgeInsets.only(top: (index > 0) ? 8.0 : 0.0,left: 8,right: 8),
                                        child: PackageWidget(
                                          onTap: () {
                                            bloc.setPackageItem = package;
                                          },
                                          title: package.name ?? '',
                                          isSelected: package.isSelected ?? false,
                                          description: package.description ?? '',
                                          price: '${package.price}',
                                          finalPrice: '${package.finalPrice}',
                                          maxHeight: 22.h,
                                          isOurSuggestion: package.is_suggestion,
                                          isBorder: true,borderColor: package.barColor,
                                        ),
                                      )))
                                      .values
                                      .toList()
                                ],
                              );
                            },
                          ),
                          Space(height: 1.h),
                          EnableDiscountBoxWidget(),
                          Space(
                            height: 1.h,
                          ),
                          PaymentTypeWidget(),
                          rulesAndPaymentBtn()
                        ],
                      ),
                    ),
                  ),
                );
              return Progress();
            }));
  }

  Widget rulesAndPaymentBtn() {
    return Container(
        child: StreamBuilder<bool>(
            initialData: false,
            stream: bloc.checkedRules,
            builder: (context, checkedRules) {
              return Column(
                children: [
                  CustomCheckBox(
                      //title: intl.ruleCheckBox,
                      value: checkedRules.requireData,
                      onChange: (value) => bloc.setCheckedRules = value!),
                  SubmitButton(
                      label: intl.confirmAndPay,
                      onTap: () {
                        if (checkedRules.requireData) {
                          next();
                        } else {
                          Utils.getSnackbarMessage(context, intl.checkTermsAndConditions);
                        }
                      })
                ],
              );
            }));
  }

  void next() {
    if (navigator.currentConfiguration!.path.contains('subscription') &&
        bloc.type != PaymentType.cardToCard) {
      DialogUtils.showDialogProgress(context: context);
      bloc.selectUserPaymentSubscription();
    } else if (navigator.currentConfiguration!.path.contains('subscription') &&
        bloc.type == PaymentType.cardToCard) {
      if (!bloc.isUsedDiscount &&
          (bloc.discountCode != null && bloc.discountCode!.trim().isNotEmpty)) {
        Utils.getSnackbarMessage(context, intl.offError);
      } else {
        VxNavigator.of(context).push(Uri.parse(Routes.cardToCardSubscription),
            params: {'package': bloc.packageItem, 'discountCode': bloc.discountCode});
      }
    } else if (bloc.type == PaymentType.cardToCard) {
      if (!bloc.isUsedDiscount &&
          (bloc.discountCode != null && bloc.discountCode!.trim().isNotEmpty)) {
        Utils.getSnackbarMessage(context, intl.offError);
      } else {
        VxNavigator.of(context).push(Uri.parse(Routes.cardToCard),
            params: {'package': bloc.packageItem, 'discountCode': bloc.discountCode});
      }
    } else {
      DialogUtils.showDialogProgress(context: context);
      bloc.selectUserPayment();
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addObserver(this);

    bloc.dispose();
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
    if (navigator.currentConfiguration!.path.contains('subscription')) {
      bloc.getReservePackagePayment();
    } else {
      bloc.getPackagePayment();
    }
  }

  @override
  void onShowMessage(String value) {
    bloc.setMessageErrorCode(value);
  }
}
