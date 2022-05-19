import 'package:behandam/app/app.dart';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/enable_discount_box.dart';
import 'package:behandam/screens/subscription/bill_payment/payment_type.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/subscription/bill_payment/purchased_subscription.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
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
  late bool isInit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    bloc = BillPaymentBloc();
    bloc.getPackagePayment();

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
    if (!isInit) {
      isInit = true;
    }
  }

  void listenBloc() {
    bloc.onlinePayment.listen((event) {
      debugPrint(
          'listen online payment ${navigator.currentConfiguration?.path}');
      if (event != null && event) {
        if (navigator.currentConfiguration!.path.contains('subscription')) {
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.billSubscriptionHistory));
        } else {
          VxNavigator.of(context).push(Uri.parse("/${bloc.path}"));
        }
      } else {
        if (event != null && !event) if (bloc.packageItem!.price!.type! == 2) {
          VxNavigator.of(context).clearAndPushAll(
              [Uri.parse(Routes.profile), Uri.parse(Routes.paymentFail)]);
        } else {
          VxNavigator.of(context).clearAndPushAll([
            Uri.parse('/reg${Routes.regimeType}'),
            Uri.parse(Routes.paymentFail)
          ]);
        }
        else
          Navigator.of(context).pop();
      }
    });

    bloc.showServerError.listen((event) {
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, intl.offError);
    });

    bloc.popDialog.listen((event) {
      Navigator.of(context).pop();
    });

    bloc.navigateTo.listen((event) {
      debugPrint('listen navigate ${event.next}');
      Payment? result = (event as NetworkResponse<Payment>).data;
      if (bloc.isOnline == PaymentType.cardToCard) {
        Navigator.of(context).pop();
        context.vxNav.push(Uri.parse(Routes.cardToCard));
        /*if (event.next!.contains('card'))
          context.vxNav.push(Uri.parse('/${(event).next}'));
        else
          context.vxNav.clearAndPush(Uri(path: '/${event.next}'));*/
      } else if (bloc.isOnline == PaymentType.online) {
        Navigator.of(context).pop();
        MemoryApp.analytics!.logEvent(name: "total_payment_online_select");
        bloc.mustCheckLastInvoice();
        Utils.launchURL(result!.url!);
      } else {
        Navigator.of(context).pop();
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
        appBar: Toolbar(titleBar: intl.newSubscription),
        body: TouchMouseScrollable(
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
        ));
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
                          DialogUtils.showDialogProgress(context: context);
                          if (navigator.currentConfiguration!.path
                              .contains('subscription'))
                            bloc.selectUserPaymentSubscription();
                          else
                            bloc.selectUserPayment();
                        } else {
                          Utils.getSnackbarMessage(
                              context, intl.checkTermsAndConditions);
                        }
                      })
                ],
              );
            }));
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
