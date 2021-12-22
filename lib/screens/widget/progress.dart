import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Progress extends StatelessWidget {
  Progress({
    Key? key,
    this.size,
  }) : super(key: key);

  double? size;

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: size ?? 7.w,
      color: AppColors.primary,
    );
  }
}
