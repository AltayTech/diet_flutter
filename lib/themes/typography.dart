import 'package:flutter/material.dart';
import 'package:karsu/themes/colors.dart';
import 'package:karsu/themes/locale.dart';
import 'package:sizer/sizer.dart';

// todo: resolve locale at runtime in app.dart
class AppTypography {
  final Locale locale;

  AppTypography(this.locale);

  late TextStyle headline1 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w700,
    fontSize: 32.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle headline2 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle headline3 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w700,
    fontSize: 22.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle headline4 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle headline5 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle headline6 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle bodyText1 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle bodyText2 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle subtitle1 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle subtitle2 = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle overline = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle caption = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.onScaffold,
  );

  late TextStyle button = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.onPrimary,
  );

  /// decide which fontFamily to apply with current locale of app
  String getFontFamily() {
    if (locale == AppLocale.fa || locale == AppLocale.ar) {
      return 'Iransans';
    }
    return 'Iransans';
  }
}
