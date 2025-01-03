import 'package:behandam/screens/widget/progress.dart';
import 'package:flutter/material.dart';
import 'package:behandam/widget/sizer/sizer.dart';

import 'empty_box.dart';

class CenteredCircularProgressIndicator extends StatelessWidget {
  CenteredCircularProgressIndicator({
    this.visible = true,
    this.axis = Axis.vertical,
    this.margin,
  });

  final Axis axis;
  final EdgeInsets? margin;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return EmptyBox();
    }
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: axis == Axis.vertical
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Progress(size: 5.w,)],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Progress(size: 5.w)],
            ),
    );
  }
}
