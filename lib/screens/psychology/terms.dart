import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class PsychologyTermsScreen extends StatefulWidget {
  const PsychologyTermsScreen({Key? key}) : super(key: key);

  @override
  _PsychologyTermsScreenState createState() => _PsychologyTermsScreenState();
}

class _PsychologyTermsScreenState extends ResourcefulState<PsychologyTermsScreen> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    super.build(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.condition),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(intl.attention,style: TextStyle(fontSize: 12.sp,
                          color: AppColors.primaryVariantLight,
                          fontWeight: FontWeight.w600))),
                      ImageUtils.fromLocal('assets/images/bill/alert.svg',width: 10.w,height: 10.h),
                    ],
                  ),
                  Space(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.grey
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          bullet(intl.term1),
                          Space(height: 2.h),
                          bullet(intl.term2),
                          Space(height: 2.h),
                          bullet(intl.term3),
                          Space(height: 2.h),
                          bullet(intl.term4),
                          Space(height: 2.h),
                          bullet(intl.term5),
                          Space(height: 2.h),
                          Text(intl.thanks,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w800,color: AppColors.penColor)),
                        ],
                      ),
                    ),
                  ),
                  Space(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageUtils.fromLocal('assets/images/foodlist/advice/bulb.svg',
                          width: 2.w,
                          height: 2.h,
                      color: AppColors.redBar),
                      Flexible(child: Text(intl.rulesConfirm,style: TextStyle(fontSize: 10.sp,color: AppColors.redBar))),
                    ],
                  ),
                  Space(height: 2.h),
                  button(AppColors.primaryVariantLight, intl.readRules, Size(70.w,5.h),
                          ()=> VxNavigator.of(context).push(Uri.parse(Routes.psychologyPaymentBill), params: args)),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget bullet(String txt){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Icon(Icons.circle,color: AppColors.redBar,size: 3.w),
        ),
        Space(width: 2.w),
        Flexible(child: Text(txt,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w800,color: AppColors.penColor))),
      ],
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
