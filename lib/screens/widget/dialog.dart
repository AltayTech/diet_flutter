import 'dart:ui';

import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

abstract class DialogUtils {
  static Future<T?> showBottomSheetPage<T>({
    required BuildContext context,
    required Widget child,
    bool enableDrag = true,
    bool isDismissible = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Wrap(children: [child]),
        );
      },
    );
  }

  static Future<T?> showDialogPage<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return WillPopScope(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
          onWillPop: () async => isDismissible,
        );
      },
    );
  }

  static Future showDialogProgress({
    required BuildContext context,
    bool isDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return WillPopScope(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SpinKitCircle(
              size: 8.w,
              color: AppColors.primary,
            ),
          ),
          onWillPop: () async => isDismissible,
        );
      },
    );
  }
}
