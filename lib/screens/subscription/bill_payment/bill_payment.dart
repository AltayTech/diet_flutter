import 'package:behandam/app/app.dart';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/enable_discount_box.dart';
import 'package:behandam/screens/subscription/bill_payment/payment_type.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/subscription/bill_payment/purchased_subscription.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/widget/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({Key? key}) : super(key: key);

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ResourcefulState<BillPaymentScreen>
    with WidgetsBindingObserver {
  late BillPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

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
      debugPrint(
          'listen online payment ${navigator.currentConfiguration?.path}');
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
        if (event != null && !event) if (bloc.packageItem!.price!.type! == 2) {
          VxNavigator.of(context).clearAndPushAll([
            Uri.parse(Routes.profile),
            Uri.parse(Routes.billSubscriptionHistory),
            Uri.parse(Routes.subscriptionPaymentOnlineFail)
          ]);
        } else {
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.paymentFail));
        }
        else
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
      Payment? result = (event as NetworkResponse<Payment>).data;
      if (navigator.currentConfiguration!.path.contains('subscription')) {
        VxNavigator.of(context).clearAndPushAll([
          Uri.parse(Routes.profile),
          Uri.parse(Routes.billSubscriptionHistory),
          Uri.parse(Routes.cardToCardSubscription),
        ]);
      } else if (event.next != null) {
        context.vxNav.push(Uri(path: '/${event.next}'));
      } else if (bloc.isOnline == PaymentType.cardToCard) {
        context.vxNav.push(Uri.parse(Routes.cardToCard));
      } else if (bloc.isOnline == PaymentType.online) {
        MemoryApp.analytics!.logEvent(name: "total_payment_online_select");
        bloc.mustCheckLastInvoice();
        Utils.launchURL(result!.url!);
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
        body: StreamBuilder<bool>(
            stream: bloc.waiting,
            builder: (context, waiting) {
              if (waiting.hasData &&
                  !waiting.requireData &&
                  bloc.packageItem != null)
                return TouchMouseScrollable(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PurchasedSubscriptionWidget(),
                        Space(height: 1.h),
                        EnableDiscountBoxWidget(),
                        PaymentTypeWidget(),
                        rulesAndPaymentBtn()
                      ],
                    ),
                  ),
                );
              return Progress();
            }));
  }

  Widget rulesAndPaymentBtn() {
    return Container(
        margin: EdgeInsets.all(2.w),
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
                          Utils.getSnackbarMessage(
                              context, intl.checkTermsAndConditions);
                        }
                      })
                ],
              );
            }));
  }

  void next() {
    DialogUtils.showDialogProgress(context: context);
    if (navigator.currentConfiguration!.path.contains('subscription') &&
        bloc.isOnline != PaymentType.cardToCard) {
      bloc.selectUserPaymentSubscription();
    } else if (navigator.currentConfiguration!.path.contains('subscription') &&
        bloc.isOnline == PaymentType.cardToCard) {
      VxNavigator.of(context).push(Uri.parse(Routes.cardToCardSubscription), params: bloc.packageItem);
    } else {
      bloc.selectUserPayment();
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance!.addObserver(this);

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
    // TODO: implement onRetryLoadingPage
    bloc.getPackagePayment();
  }

  @override
  void onShowMessage(String value) {}
}
