import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:behandam/widget/sizer/sizer.dart';

class ToolbarEmpty extends AppBar {
  late Widget item;
  String? titleBar;
  Color? color;
  double? elevationValue;

  ToolbarEmpty({this.elevationValue = 0}) {
    color = AppColors.primary;
    item = Text(
      titleBar ?? '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    );
  }

  @override
  // TODO: implement title
  Widget? get title => item;

  @override
  Color? get backgroundColor => color;

  @override
  double? get elevation => elevationValue;

  @override
  Size get preferredSize => Size.fromHeight(0);

  @override
  bool? get centerTitle => true;

}
