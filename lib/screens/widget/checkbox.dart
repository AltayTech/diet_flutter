import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

enum CheckBoxType { NoneIcon, Icon, Description }

enum IconSelectType { Radio, Checked }

class CheckBoxApp extends StatelessWidget {
  late final CheckBoxType checkBoxType;
  IconSelectType? iconSelectType;
  late Function() onTap;
  String title;
  late bool isSelected;
  bool? isBorder;
  String? description;
  String? iconPath;
  String? iconPathSelected;
  double? maxHeight;
  double? contentPadding;
  TextTheme? typography;
  MainAxisAlignment? rowMainAxisAlignment;
  double? titleFontSize;

  CheckBoxApp({
    required this.onTap,
    required this.title,
    required this.isSelected,
    this.maxHeight,
    this.iconSelectType,
    this.isBorder,
    this.rowMainAxisAlignment,
    this.titleFontSize
  }) {
    this.checkBoxType = CheckBoxType.NoneIcon;
    this.isBorder ??= true;
    this.iconSelectType ??= IconSelectType.Radio;
  }

  CheckBoxApp.icon(
      {required this.onTap,
      required this.title,
      required this.isSelected,
      required this.iconPath,
      this.maxHeight,
      this.isBorder,
      required this.iconPathSelected,
      this.iconSelectType}) {
    this.checkBoxType = CheckBoxType.Icon;
    this.isBorder ??= true;
    this.iconSelectType ??= IconSelectType.Radio;
  }

  CheckBoxApp.description(
      {required this.onTap,
      required this.title,
      required this.isSelected,
      this.maxHeight,
      this.isBorder,
        this.contentPadding,
      required this.description,
      this.iconSelectType}) {
    this.checkBoxType = CheckBoxType.Description;
    this.isBorder ??= true;
    this.iconSelectType ??= IconSelectType.Radio;
  }

  @override
  Widget build(BuildContext context) {
    typography = context.typography;
    switch (checkBoxType) {
      case CheckBoxType.NoneIcon:
        return checkItemNoneIcon();
      case CheckBoxType.Icon:
        return checkItemIcon();
      case CheckBoxType.Description:
        return checkItemDescription();
    }
  }

  Widget checkItemIcon() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder!
              ? isSelected
              ? Border.all(color: AppColors.priceColor)
              : Border.all(color: Colors.grey)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(maxHeight: maxHeight ?? 8.h),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(top: 8),
                    child: ImageUtils.fromLocal(
                      isSelected
                          ? iconSelectType == IconSelectType.Radio
                          ? 'assets/images/physical_report/selected.svg'
                          : 'assets/images/physical_report/icon_checked.svg'
                          : iconSelectType == IconSelectType.Radio
                          ? 'assets/images/bill/not_select.svg'
                          : 'assets/images/physical_report/none_checked.svg',
                      width: 5.w,
                      height: 5.w,
                    ),
                    alignment: Alignment.topRight,
                    height: double.maxFinite),
              ),
              Space(
                width: 1.w,
              ),
              Expanded(
                flex: 2,
                child: ImageUtils.fromLocal(
                  isSelected ? iconPathSelected! : iconPath!,
                  width: 10.w,
                  height: 10.w,
                ),
              ),
              Space(
                width: 1.w,
              ),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.maxFinite,
                  child: Text(
                    title,
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography!.caption!.copyWith(
                        color: isSelected ? Colors.black : Colors.grey, fontSize: 10.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkItemNoneIcon() {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder!
              ? isSelected
              ? Border.all(color: AppColors.priceColor)
              : Border.all(color: Colors.grey)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(maxHeight: maxHeight ?? 8.h),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          child: Row(
            mainAxisAlignment: rowMainAxisAlignment ?? MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                    child: ImageUtils.fromLocal(
                      isSelected
                          ? iconSelectType == IconSelectType.Radio
                          ? 'assets/images/physical_report/selected.svg'
                          : 'assets/images/physical_report/icon_checked.svg'
                          : iconSelectType == IconSelectType.Radio
                          ? 'assets/images/bill/not_select.svg'
                          : 'assets/images/physical_report/none_checked.svg',
                      width: 5.w,
                      height: 5.w,
                    ),
                    alignment: Alignment.center,
                    height: double.maxFinite),
              ),
              Space(
                width: 2.w,
              ),
              Expanded(
                flex: 0,
                child: Container(
                  child: Text(
                    title,
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography!.caption!.copyWith(
                        color: isSelected ? Color(0xff1ABC9C) : Color(0xff454545),
                        fontSize: titleFontSize ?? 10.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkItemDescription() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder!
              ? isSelected
              ? Border.all(color: AppColors.priceColor)
              : Border.all(color: Colors.grey)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(maxHeight: maxHeight ?? 8.h),
        child: Padding(
          padding: EdgeInsets.all(contentPadding ?? 0),
          child: Container(
            margin: EdgeInsets.only(right: 2.w),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: ImageUtils.fromLocal(
                      isSelected
                          ? iconSelectType == IconSelectType.Radio
                          ? 'assets/images/physical_report/selected.svg'
                          : 'assets/images/physical_report/icon_checked.svg'
                          : iconSelectType == IconSelectType.Radio
                          ? 'assets/images/bill/not_select.svg'
                          : 'assets/images/physical_report/none_checked.svg',
                      width: 5.w,
                      height: 5.w,
                    ),
                    height: double.maxFinite),
                Space(
                  width: 2.w,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: Text(
                          title,
                          softWrap: false,
                          textAlign: TextAlign.start,
                          style: typography!.caption!.copyWith(
                              letterSpacing: -0.02,
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: Text(
                          description!,
                          softWrap: false,
                          textAlign: TextAlign.start,
                          style: typography!.overline!.copyWith(color: Color(0xff454545)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
