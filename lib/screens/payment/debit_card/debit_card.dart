import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/payment/debit_card/card_info.dart';
import 'package:behandam/screens/payment/debit_card/card_owner_box.dart';
import 'package:behandam/screens/payment/debit_card/payment_date.dart';
import 'package:behandam/screens/payment/provider.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class DebitCardPage extends StatefulWidget {
  const DebitCardPage({Key? key}) : super(key: key);

  @override
  State<DebitCardPage> createState() => _DebitCardPageState();
}

class _DebitCardPageState extends ResourcefulState<DebitCardPage> {
  late PaymentBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PaymentBloc();
    bloc.getLastInvoice();

    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      VxNavigator.of(context).clearAndPush(Uri.parse('/$event'));
    });

    bloc.popLoading.listen((event) {
      VxNavigator.of(context).pop();
    });

    bloc.selectedDateType.listen((event) {
      if (event == PaymentDate.today) {
        bloc.invoice!.payedAt = DateTime.now().toString().substring(0, 10);
      }
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardOwnerBoxWidget(),
                  Space(height: 4.h),
                  CardInfoWidget(),
                  Space(height: 2.h),
                  PaymentDateWidget(),
                  Space(height: 2.h),
                  registerPaymentInfo()
                ]);
          }
          return Center(child: Progress());
        },
      ),
    );
  }

  Widget registerPaymentInfo() {
    return Center(
      child: SubmitButton(
        label: intl.submitOfflinePayment,
        onTap: () {
          if (!bloc.invoice!.cardOwner.isNullOrEmpty ||
              !bloc.invoice!.cardNum.isNullOrEmpty ||
              !bloc.invoice!.payedAt.isNullOrEmpty) {
            DialogUtils.showDialogProgress(context: context);
            bloc.newPayment(bloc.invoice!);
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
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}