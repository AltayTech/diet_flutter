import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/utility/CustomRuler.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class BodyStateScreen extends StatefulWidget {
  const BodyStateScreen({Key? key}) : super(key: key);

  @override
  _BodyStateScreenState createState() => _BodyStateScreenState();
}

class _BodyStateScreenState extends ResourcefulState<BodyStateScreen> {
  int? height;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Center(child: Text(intl.stateOfBody)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0,bottom: 20.0),
                  child: Text(intl.enterYourState,textAlign: TextAlign.center,),
                ),
              CustomRuler(
                rulerType: RulerType.Weight,
                value: height != null ? height : 50,
                max: 200,
                min: 30,
                heading: intl.weight,
                unit: intl.kilo,
                color: AppColors.purpleRuler,
                helpClick: () => VxNavigator.of(context).push(Uri.parse(Routes.helpType)) ,
                iconPath: 'assets/images/diet/weight_icon.svg',
                callback: (value) {
                  setState(() {
                    height = value;
                  });
                },
              ),
              SizedBox(height: 5.h),
              CustomRuler(
                rulerType: RulerType.Normal,
                value: height != null ? height : 50,
                max: 300,
                min: 50,
                heading: intl.height,
                unit: intl.centimeter,
                color: AppColors.pinkRuler,
                helpClick: () => VxNavigator.of(context).push(Uri.parse(Routes.helpType)) ,
                iconPath: 'assets/images/diet/height_icon.svg',
                callback: (value) {
                  setState(() {
                    height = value;
                  });
                },
              ),
              SizedBox(height: 5.h),
              CustomRuler(
                rulerType: RulerType.Normal,
                value: height != null ? height : 50,
                max: 30,
                min: 10,
                heading: intl.wrist,
                unit: intl.centimeter,
                color: AppColors.blueRuler,
                helpClick: () => VxNavigator.of(context).push(Uri.parse(Routes.helpType)) ,
                iconPath: 'assets/images/diet/wrist_icon.svg',
                callback: (value) {
                  setState(() {
                    height = value;
                  });
                },
              ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    SvgPicture.asset('assets/images/diet/birth_icon.svg',
                        width: 6.w,
                        height: 6.h),
                    Text(intl.birthday),
                    click(() => VxNavigator.of(context).push(Uri.parse(Routes.helpType)))
                  ],
                ),
                SizedBox(height: 5.h),
                button(AppColors.btnColor, intl.confirmContinue,Size(100.w,8.h),
                        (){
                      // VerificationCode verification = VerificationCode();
                      // verification.mobile = args['mobile'];
                      // verification.verifyCode = code;
                      // authBloc.verifyMethod(verification);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget click(Function func){
    return InkWell(
      child: SvgPicture.asset('assets/images/physical_report/guide.svg',
          width: 5.w, height: 5.h),
      onTap: () => func.call(),
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
}
