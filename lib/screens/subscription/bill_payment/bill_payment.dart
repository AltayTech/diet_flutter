import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/enable_discount_box.dart';
import 'package:behandam/screens/subscription/bill_payment/payment_type.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/subscription/bill_payment/purchased_subscription.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({Key? key}) : super(key: key);

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ResourcefulState<BillPaymentScreen> {
  late BillPaymentBloc bloc;
  late PackageItem packageItem;
  late bool isInit=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(!isInit) {
      packageItem = ModalRoute
          .of(context)!
          .settings
          .arguments as PackageItem;
      isInit=true;
      bloc = BillPaymentBloc();
      bloc.setPackageItem(packageItem);
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BillPaymentProvider(bloc, child: body());
  }

  Widget body() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.selectPackageToolbar),
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
      child: Column(children: [
        StreamBuilder<bool>(
            stream: bloc.checkedRules,
            builder: (context, checkedRules) {
              if (checkedRules.hasData)
                return Directionality(
                  textDirection: context.textDirectionOfLocaleInversed,
                  child: CheckboxListTile(
                    title: Text(intl.ruleCheckBox,style: typography.caption!.copyWith(fontSize: 10.sp)),
                    autofocus: false,
                    activeColor: AppColors.priceGreenColor,
                    checkColor: Colors.white,
                    selected: checkedRules.requireData,
                    value: checkedRules.requireData,
                    onChanged: (value) {
                      bloc.setCheckedRules = value!;
                    },
                  ),
                );/*CustomCheckBox(
                    title: intl.ruleCheckBox,
                    value: checkedRules.requireData,
                    onChange: (value) => bloc.setCheckedRules = value!);*/
              return CustomCheckBox(
                  title: intl.ruleCheckBox,
                  value: false,
                  onChange: (value) => bloc.setCheckedRules = value!);
            }),
        SubmitButton(label: intl.confirmAndPay, onTap: () {})
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();

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
  }

  @override
  void onShowMessage(String value) {}
}
