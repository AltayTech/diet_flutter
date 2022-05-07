import 'dart:ui';

import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

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
      backgroundColor: Colors.transparent,
      enableDrag: enableDrag,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40))),
              padding: EdgeInsets.all(16),
              child: Wrap(children: [child])),
        );
      },
    );
  }

  /* static Future<T?> showDialogPage<T>({
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
  }*/

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

  static Future showDialogProgress({
    required BuildContext context,
    bool isDismissible = false,
  }) {
    MemoryApp.isShowDialog = true;
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

class ContentWidgetDialog extends StatelessWidget {
  late String title;
  late String titleButtonAccept;
  late String titleButtonCancel;
  String? content;
  late VoidCallback actionButtonAccept;
  late VoidCallback actionButtonCancel;

  ContentWidgetDialog(
      {required this.title,
      this.content,
      required this.titleButtonAccept,
      required this.titleButtonCancel,
      required this.actionButtonAccept,
      required this.actionButtonCancel});

  @override
  Widget build(BuildContext context) {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              textDirection: context.textDirectionOfLocale,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Space(height: 2.h),
            if (content != null)
              Text(
                content!,
                textDirection: context.textDirectionOfLocale,
                style: Theme.of(context).textTheme.caption,
              ),
            if (content != null) Space(height: 3.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 6.h,
                    width: 30.w,
                    child: MaterialButton(
                      child: Text(
                        titleButtonAccept,
                        style:
                            Theme.of(context).textTheme.caption!.copyWith(color: AppColors.primary),
                      ),
                      onPressed: actionButtonAccept,
                      color: Colors.white,
                      elevation: 0,
                    ),
                  ),
                  flex: 1,
                ),
                Space(width: 2.w),
                Expanded(
                  child: Container(
                    height: 6.h,
                    width: 30.w,
                    child: MaterialButton(
                      child: Text(
                        titleButtonCancel,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      onPressed: actionButtonCancel,
                      color: Colors.white,
                      elevation: 0,
                    ),
                  ),
                  flex: 1,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
