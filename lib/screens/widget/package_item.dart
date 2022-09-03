import 'dart:math';

import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/screens/widget/custom_banner.dart' as banner;
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

enum PackageWidgetType { service, package }

class PackageWidget extends StatelessWidget {
  late Function() onTap;
  String title;
  late bool isSelected;
  bool? isBorder;
  Color? borderColor;
  bool? isOurSuggestion;
  String? description;
  String? price;
  String? finalPrice;
  double? maxHeight;
  TextTheme? typography;
  late PackageWidgetType _packageWidgetType;

  PackageWidget(
      {required this.onTap,
      required this.title,
      required this.isSelected,
      required this.description,
      required this.price,
      required this.finalPrice,
      required this.maxHeight,
      required this.isOurSuggestion,
      required this.borderColor,
      required this.isBorder}) {
    _packageWidgetType = PackageWidgetType.package;
  }

  PackageWidget.service(
      {required this.onTap,
      required this.title,
      required this.isSelected,
      required this.description,
      required this.price,
      required this.finalPrice,
      required this.maxHeight,
      required this.isOurSuggestion,
      required this.borderColor,
      required this.isBorder}) {
    _packageWidgetType = PackageWidgetType.service;
  }

  @override
  Widget build(BuildContext context) {
    typography = context.typography;
    switch (_packageWidgetType) {
      case PackageWidgetType.service:
        return service(context);
      case PackageWidgetType.package:
        return isOurSuggestion!
            ? ClipRect(
                child: banner.CustomBanner(
                  location: banner.BannerLocation.topEnd,
                  message: context.intl.suggestion,
                  color: AppColors.suggestion,
                  textStyle:
                      typography!.overline!.copyWith(color: Colors.white, letterSpacing: -0.3),
                  child: content(context),
                ),
              )
            : content(context);
    }
  }

  Widget content(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder!
              ? isSelected
                  ? Border.all(color: borderColor ?? AppColors.priceColor, width: 2)
                  : Border.all(
                      color:
                          borderColor != null ? borderColor!.withOpacity(0.3) : Color(0x443498DB),
                      width: 2)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
       // constraints: BoxConstraints(maxHeight:maxHeight ?? 8.h),
        constraints: BoxConstraints.tightFor(height: max(maxHeight ?? 8.h, ((maxHeight ?? 8.h) + 3.h))),
        child: Container(
          margin: EdgeInsets.only(right: 16, top: 16, left: 16, bottom: 16),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                    child: ImageUtils.fromLocal(
                      isSelected
                          ? 'assets/images/physical_report/selected.svg'
                          : 'assets/images/bill/not_select.svg',
                      width: 5.w,
                      height: 5.w,
                    ),
                    alignment: Alignment.topRight,
                    height: double.maxFinite),
              ),
              Space(
                width: 2.w,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        title,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: typography!.caption!.copyWith(
                            letterSpacing: -0.02,
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Space(
                      height: 1.h,
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        description ?? "",
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: typography!.overline!.copyWith(color: Color(0xff454545)),
                      ),
                    ),
                    Space(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        CustomPaint(
                          painter: MyLine(),
                          child: Text(
                            '$price'.seRagham() + '${context.intl.toman}',
                            softWrap: true,
                            textAlign: TextAlign.start,
                            style: typography!.caption!.copyWith(
                                letterSpacing: -0.02,
                                color: Colors.grey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Space(
                          width: 2.w,
                        ),
                        RichText(
                          softWrap: true,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '${context.intl.toman}',
                                  style: typography!.caption!.copyWith(
                                      letterSpacing: -0.02,
                                      color: AppColors.priceColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700))
                            ],
                            text: '$finalPrice'.seRagham(),
                            style: typography!.caption!.copyWith(
                                letterSpacing: -0.02,
                                color: AppColors.priceColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget service(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder!
              ? isSelected
                  ? Border.all(color: borderColor ?? AppColors.priceColor, width: 2)
                  : Border.all(
                      color:
                          borderColor != null ? borderColor!.withOpacity(0.3) : Color(0x443498DB),
                      width: 2)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.only(right: 16, top: 16, left: 16, bottom: 16),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                    child: ImageUtils.fromLocal(
                      isSelected
                          ? 'assets/images/physical_report/icon_checked.svg'
                          : 'assets/images/physical_report/none_checked.svg',
                      width: 5.w,
                      height: 5.w,
                    ),
                    alignment: Alignment.topRight,
                    height: double.maxFinite),
              ),
              Space(
                width: 2.w,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        title,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: typography!.caption!.copyWith(
                            letterSpacing: -0.02,
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Space(
                      height: 1.h,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: '${context.intl.toman}',
                                style: typography!.caption!.copyWith(
                                    letterSpacing: -0.02,
                                    color: Color(0xff454545),
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w300))
                          ],
                          text: '$price'.seRagham() + '+ ',
                          style: typography!.caption!.copyWith(
                              letterSpacing: -0.02,
                              color: Color(0xff454545),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
