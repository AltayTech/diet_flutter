import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/enable_discount_box.dart';
import 'package:behandam/screens/subscription/bill_payment/payment_type.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/subscription/bill_payment/purchased_subscription.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class CustomCheckBox extends StatefulWidget {
  String? title;
  bool? value;
  Function(bool?)? onChange;

  CustomCheckBox({Key? key, this.title, this.value, this.onChange}) : super(key: key);

  @override
  _CustomCheckBox createState() => _CustomCheckBox();
}

class _CustomCheckBox extends ResourcefulState<CustomCheckBox> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return customCheckBox(widget.title, widget.value, widget.onChange);
  }

  Widget customCheckBox(String? title, bool? value, Function(bool?)? onChange) {
    return Container(
      color: Colors.red,
      margin: EdgeInsets.all(2.w),
      height: 8.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            activeColor: AppColors.priceGreenColor,
            value: value ?? false,
            onChanged: onChange!,
          ),
          Expanded(
            child: Text(
              title ?? '',
              textDirection: context.textDirectionOfLocale,
              style: typography.caption!.copyWith(fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}
