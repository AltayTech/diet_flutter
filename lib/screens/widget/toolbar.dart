import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Toolbar extends AppBar {
  late Widget item;
  late String titleBar;
  Color? color;

  Toolbar({required this.titleBar}) {
    color = AppColors.primary;
    item = Text(
      titleBar,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13.sp,
      ),
    );
  }

  @override
  // TODO: implement title
  Widget? get title => item;

  Color? get backgroundColor => color;
}
