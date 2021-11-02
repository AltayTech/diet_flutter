import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Toolbar extends AppBar{

  late Widget item;
  late String titleBar;
  Toolbar({required this.titleBar}){
    item= Text(
      titleBar,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15.sp,
      ),
    );
  }

  @override
  // TODO: implement title
  Widget? get title => item;


}
