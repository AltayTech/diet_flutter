import 'dart:ui';

import 'package:flutter/material.dart';

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
            child: child,
          ),
          onWillPop: () async => isDismissible,
        );
      },
    );
  }
}
