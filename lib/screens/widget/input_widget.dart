import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
class InputWidget extends StatefulWidget{
  String? labelText;
  bool shouldObscure;
  InputWidget({this.labelText, this.shouldObscure = false});
  @override
  State createState() => InputWidgetState(this.labelText,this.shouldObscure);
  
}
class InputWidgetState extends ResourcefulState<InputWidget>{
  String? labelText;
  bool shouldObscure;
  InputWidgetState(this.labelText,this.shouldObscure);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return TextField(
      cursorColor: AppColors.onPrimary,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 0.5.h),
        labelStyle: typography.subtitle1?.apply(
          color: AppColors.onPrimary.withOpacity(0.60),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.onPrimary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.onPrimary),
        ),
      ),
      obscureText: shouldObscure,
      style: typography.bodyText1?.apply(
        color: AppColors.onPrimary,
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
  
}