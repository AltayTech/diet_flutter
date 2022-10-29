import 'package:behandam/app/app.dart';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/payment/payment_type_new.dart';
import 'package:behandam/screens/profile/profile.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/enable_discount_box.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/package_item.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widget/stepper_widget.dart';

class BillPaymentNewScreen extends StatefulWidget {
  const BillPaymentNewScreen({Key? key}) : super(key: key);

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ResourcefulState<BillPaymentNewScreen>
    with WidgetsBindingObserver {
  late BillPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addObserver(this);

    bloc = BillPaymentBloc();
    bloc.getPackagePayment();

    listenBloc();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && bloc.checkLatestInvoice) {
      if (mounted && !MemoryApp.isShowDialog) {
        DialogUtils.showDialogProgress(context: context);
        bloc.checkOnlinePayment();
      }
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
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.paymentFail));
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
        appBar: Toolbar(titleBar: intl.enterYourPackage),
        backgroundColor: AppColors.newBackgroundFlow,
        body: WillPopScope(
          onWillPop: () {
            MemoryApp.page--;
            return Future.value(true);
          },
          child: StreamBuilder<bool>(
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
                                child: StepperWidget(),
                              ),
                            ),
                            Space(height: 4.h),
                            Text(
                              intl.enterYourPackage,
                              style: typography.headline5!.copyWith(fontSize: 14.sp),
                            ),
                            Text(
                              intl.enterYourPackageDescription,
                              style: typography.overline,
                            ),
                            Space(
                              height: 2.h,
                            ),
                            packageItem(),
                            Space(height: 2.h),
                            EnableDiscountBoxWidget(),
                            Space(height: 2.h),
                            PaymentTypeWidget(),
                            rulesAndPaymentBtn()
                          ],
                        ),
                      ),
                    ),
                  );
                return Progress();
              }),
        ));
  }

  Widget packageItem() {
    return StreamBuilder(
      stream: bloc.refreshPackages,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...bloc.packageItems
                  .asMap()
                  .map((index, package) => MapEntry(
                      index,
                      Padding(
                        padding: EdgeInsets.only(
                          top: (index > 0) ? 8.0 : 0.0,
                        ),
                        child: PackageWidget(
                          onTap: () {
                            bloc.setPackageItem = package;
                          },
                          title: package.name ?? '',
                          isSelected: package.isSelected ?? false,
                          description: package.description ?? '',
                          price: '${package.price!.price}',
                          finalPrice: '${package.price!.finalPrice}',
                          maxHeight: 22.h,
                          isOurSuggestion: package.is_suggestion ?? false,
                          isBorder: true,
                          borderColor: package.barColor,
                        ),
                      )))
                  .values
                  .toList(),
              StreamBuilder<Package>(
                  stream: bloc.selectedPackage,
                  builder: (context, selectedPackage) {
                    if (selectedPackage.hasData) {
                      bloc.getServicesFilteredByPackage(selectedPackage.requireData);
                      if (bloc.servicesFilteredByPackage.length > 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Space(height: 2.h),
                            Text(
                              intl.weAreServiceMore,
                              style: typography.headline5!.copyWith(fontSize: 12.sp),
                            ),
                            Space(height: 2.h),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: bloc.servicesFilteredByPackage.length,
                              itemExtent: 15.5.h,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                ServicePackage package = bloc.servicesFilteredByPackage[index];
                                return Padding(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  child: PackageWidget.service(
                                    onTap: () {
                                      bloc.setServiceSelected(package);
                                    },
                                    title: package.name ?? '',
                                    isSelected: package.isSelected ?? false,
                                    description: package.description ?? '',
                                    price: '${package.price?.price ?? 0}',
                                    finalPrice: '${package.price?.finalPrice ?? 0}',
                                    maxHeight: 15.5.h,
                                    isOurSuggestion: false,
                                    isBorder: true,
                                    borderColor: null,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return EmptyBox();
                      }
                    }
                    return EmptyBox();
                  })
            ],
          ),
        );
      },
    );
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
    if (bloc.type == PaymentType.cardToCard && bloc.packageItemNew != null) {
      if (!bloc.isUsedDiscount &&
          (bloc.discountCode != null && bloc.discountCode!.trim().isNotEmpty)) {
        Utils.getSnackbarMessage(context, intl.offError);
      } else {
        VxNavigator.of(context).push(Uri.parse(Routes.cardToCard), params: {
          'services': bloc.servicesFilteredByPackage,
          'package': bloc.packageItemNew,
          'selectedDietTypeId': bloc.selectedDietTypeId,
          'discountCode': bloc.discountCode
        });
      }
    } else if (bloc.packageItemNew != null) {
      DialogUtils.showDialogProgress(context: context);
      bloc.selectUserPayment();
    } else {
      Utils.getSnackbarMessage(context, intl.selectPackage);
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
  void onRetryLoadingPage() {
    bloc.onRetryLoadingPage();
    bloc.getPackagePayment();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryAfterNoInternet();
  }

  @override
  void onShowMessage(String value) {
    bloc.setMessageErrorCode(value);
  }
}
