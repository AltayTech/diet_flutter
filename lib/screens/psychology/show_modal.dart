import 'package:behandam/base/utils.dart';
import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/data/entity/psychology/plan.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/utility/modal.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

showModal(BuildContext ctx, SelectedTime info, Planning item) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    context: ctx,
    builder: (_) {
      return Popover(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: 10.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.help,
                      ),
                      child: IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close, color: AppColors.redBar))),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: info.adviserImage == null
                      ? ImageUtils.fromLocal('assets/images/profile/psychology.svg',
                          width: 20.w, height: 7.h)
                      : ImageUtils.fromNetwork(Utils.getCompletePath(info.adviserImage),
                          width: 20.w, height: 10.h),
                ),
                Column(
                  children: [
                    Text(info.adviserName!),
                    Text(info.role!),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(ctx)!.sessionDuration,
                      style: TextStyle(fontSize: 12.sp)),
                  Text("${info.duration.toString() + AppLocalizations.of(ctx)!.min}",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryVariantLight)),
                ],
              ),
            ),
            line(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(ctx)!.day, style: TextStyle(fontSize: 12.sp)),
                  Text(DateTimeUtils.dateToNamesOfDay(info.date!),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryVariantLight)),
                ],
              ),
            ),
            line(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(ctx)!.time, style: TextStyle(fontSize: 12.sp)),
                  Text(item.startTime.toString().substring(0, 5),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryVariantLight)),
                ],
              ),
            ),
            line(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(ctx)!.date, style: TextStyle(fontSize: 12.sp)),
                  Text(info.date!,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryVariantLight)),
                ],
              ),
            ),
            line(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(ctx)!.price, style: TextStyle(fontSize: 12.sp)),
                  Text("${info.finalPrice.toString() + AppLocalizations.of(ctx)!.currency} ",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryVariantLight)),
                ],
              ),
            ),
            Space(height: 2.h),
            button(AppColors.btnColor, AppLocalizations.of(ctx)!.reserveThisTime, Size(70.w, 5.h),
                () {
              ctx.vxNav.push(Uri.parse(Routes.psychologyTerms), params: {
                'sessionId': item.id,
                'packageId': info.packageId,
                'name': info.adviserName,
                'price': info.price,
                'finalPrice': info.finalPrice,
                'day': DateTimeUtils.dateToNamesOfDay(info.date!),
                'date': DateTimeUtils.dateToDetail(info.date!),
                'time': item.startTime.toString().substring(0, 5),
              });
            }),
            Space(height: 1.h),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(70.w, 5.h)),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(AppColors.penColor),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              child: Text(AppLocalizations.of(ctx)!.iDoNot,
                  style: TextStyle(color: AppColors.penColor, fontSize: 16.sp)),
            ),
          ],
        ),
      );
    },
  );
}

Widget line() {
  return Padding(
    padding: const EdgeInsets.only(right: 12.0, left: 12.0),
    child: Line(color: AppColors.strongPen, height: 0.1.h),
  );
}
