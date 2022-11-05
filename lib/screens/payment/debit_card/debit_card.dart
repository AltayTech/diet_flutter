import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/payment/debit_card/card_info.dart';
import 'package:behandam/screens/payment/debit_card/card_owner_box.dart';
import 'package:behandam/screens/payment/debit_card/payment_date.dart';
import 'package:behandam/screens/payment/provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class DebitCardPage extends StatefulWidget {
  const DebitCardPage({Key? key}) : super(key: key);

  @override
  State<DebitCardPage> createState() => _DebitCardPageState();
}

class _DebitCardPageState extends ResourcefulState<DebitCardPage> {
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

      var arg = ModalRoute.of(context)!.settings.arguments as Map;
      if (!navigator.currentConfiguration!.path.contains('subscription')) {
        bloc.setServices = arg['services'] as List<ServicePackage>;
        bloc.setPackage = arg['package'] as Package;
        bloc.setSelectedDietTypeId = arg['selectedDietTypeId'] as int?;
      } else {
        bloc.setPackageItem = arg['package'] as PackageItem;
      }
      bloc.discountCode = arg['discountCode'] as String?;

      if (bloc.discountCode != null) bloc.changeUseDiscount();
      // call new service
      bloc.getBankAccountActiveCard();

      listenBloc();
    }
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      if (navigator.currentConfiguration!.path.contains('subscription')) {
        VxNavigator.of(context).clearAndPushAll(
            [Uri.parse(Routes.profile), Uri.parse(Routes.subscriptionPaymentCardWait)]);
      } else {
        VxNavigator.of(context).clearAndPush(Uri.parse('/$event'));
      }
    });

    bloc.popLoading.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
    });

    bloc.selectedDateType.listen((event) {
      if (event == PaymentDate.today) {
        bloc.invoice!.payedAt = DateTime.now().toString().substring(0, 10);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PaymentProvider(
      bloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: intl.paymentCardToCard),
        body: TouchMouseScrollable(
          child: SingleChildScrollView(
            child: body(),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: StreamBuilder(
        stream: bloc.waiting,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && !snapshot.data!) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CardOwnerBoxWidget(),
              Space(height: 4.h),
              CardInfoWidget(),
              Space(height: 2.h),
              PaymentDateWidget(),
              Space(height: 2.h),
              registerPaymentInfo()
            ]);
          }
          return Container(height: 80.h, child: Center(child: Progress()));
        },
      ),
    );
  }

  Widget registerPaymentInfo() {
    return Center(
      child: SubmitButton(
        label: intl.submitOfflinePayment,
        onTap: () {
          if (!bloc.invoice!.cardOwner.isNullOrEmpty &&
              !bloc.invoice!.cardNum.isNullOrEmpty &&
              !bloc.invoice!.payedAt.isNullOrEmpty) {
            if (bloc.invoice!.cardNum!.length == 4) {
              DialogUtils.showDialogProgress(context: context);
              if (navigator.currentConfiguration!.path.contains('subscription')) {
                bloc.userPaymentCardToCardSubscription(bloc.invoice!);
              } else {
                bloc.newPayment(bloc.invoice!);
              }
            } else {
              Utils.getSnackbarMessage(context, intl.lastFourDigitsCardNumberIncorrect);
            }
          } else {
            Utils.getSnackbarMessage(context, intl.fillAllField);
          }
        },
        size: Size(80.w, 6.h),
      ),
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryAfterNoInternet();
    if (navigator.currentConfiguration!.path.contains('subscription')) {
      bloc.userPaymentCardToCardSubscription(bloc.invoice!);
    } else {
      bloc.newPayment(bloc.invoice!);
    }
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
    bloc.onRetryLoadingPage();
    bloc.getBankAccountActiveCard();
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
