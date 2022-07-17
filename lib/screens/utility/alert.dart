import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Alert extends StatelessWidget {
  const Alert({Key? key, required this.text, required this.boxColor, required this.iconPath, this.widget}) : super(key: key);
  const Alert.widget({Key? key, required this.widget, required this.boxColor, required this.iconPath, this.text}) : super(key: key);
  final String? text;
  final Widget? widget;
  final Color boxColor;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    AppLocalizations intl = context.intl;
    TextTheme typography = context.typography;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 13.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70.0),
                      topRight: Radius.circular(70.0)),
                ),
              ),
            ),
            Container(
              decoration: AppDecorations.boxLarge.copyWith(
                color: boxColor,
              ),
              padding: EdgeInsets.fromLTRB(3.w, 3.h, 3.w, 2.h),
              child: Center(
                child: this.text!=null ? Text(
                  text!,
                  style: typography.caption?.copyWith(
                    color: AppColors.alertCallTextColor,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.center,
                ) : this.widget,
              ),
            ),
          ],
        ),
        Positioned(
          top: 5,
          right: 0,
          left: 0,
          child: ImageUtils.fromLocal(
            iconPath,
            width: 8.w,
            height: 8.w,
          ),
        ),
      ],
    );
  }
}
