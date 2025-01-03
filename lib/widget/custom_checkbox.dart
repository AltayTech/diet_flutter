import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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
          InkWell(
              onTap: () => context.vxNav.push(Uri(path: Routes.termsApp)),
              child: Text(
                '${intl.termsAndConditions} ',
                textAlign: TextAlign.end,
                textDirection: context.textDirectionOfLocale,
                style: typography.caption!.copyWith(
                    color: AppColors.priceGreenColor,
                    fontSize: 10.sp,
                    decoration: TextDecoration.underline),
              )),
          Text(intl.kermanyRegimeConfirm,
              textAlign: TextAlign.end,
              textDirection: context.textDirectionOfLocale,
              style: typography.caption!.copyWith(color: Colors.black, fontSize: 10.sp))
        ],
      ),
    );
  }
}
