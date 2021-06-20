import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

abstract class AppShapes {
  /// 1 percent of width
  static late RoundedRectangleBorder rectangleVerySmall = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusVerySmall,
  );

  /// 2.5 percent of width
  static late RoundedRectangleBorder rectangleSmall = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusSmall,
  );

  /// 3 percent of width
  static late RoundedRectangleBorder rectangleMild = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusMild,
  );

  /// 3.5 percent of width
  static late RoundedRectangleBorder rectangleMedium = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusMedium,
  );

  /// 4 percent of width
  static late RoundedRectangleBorder rectangleDefault = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusDefault,
  );

  /// 6 percent of width
  static late RoundedRectangleBorder rectangleLarge = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusLarge,
  );

  /// 8 percent of width
  static late RoundedRectangleBorder rectangleExtraLarge = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusExtraLarge,
  );

  /// 4 percent of width
  static late RoundedRectangleBorder rectangleTopDefault = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusTopDefault,
  );

  /// 6 percent of width
  static late RoundedRectangleBorder rectangleTopLarge = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusTopLarge,
  );

  /// 8 percent of width
  static late RoundedRectangleBorder rectangleTopExtraLarge = RoundedRectangleBorder(
    borderRadius: AppBorderRadius.borderRadiusTopExtraLarge,
  );
}

abstract class AppDecorations {
  static late BoxDecoration circle = BoxDecoration(
    shape: BoxShape.circle,
  );

  /// 1 percent of width
  static late BoxDecoration boxVerySmall = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusVerySmall,
  );

  /// 2.5 percent of width
  static late BoxDecoration boxSmall = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusSmall,
  );

  /// 3 percent of width
  static late BoxDecoration boxMild = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusMild,
  );

  /// 3.5 percent of width
  static late BoxDecoration boxMedium = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusMedium,
  );

  /// 4 percent of width
  static late BoxDecoration boxDefault = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusDefault,
  );

  /// 6 percent of width
  static late BoxDecoration boxLarge = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusLarge,
  );

  /// 8 percent of width
  static late BoxDecoration boxExtraLarge = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusExtraLarge,
  );

  /// 4 percent of width
  static late BoxDecoration boxTopDefault = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusTopDefault,
  );

  /// 6 percent of width
  static late BoxDecoration boxTopLarge = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusTopLarge,
  );

  /// 8 percent of width
  static late BoxDecoration boxTopExtraLarge = BoxDecoration(
    borderRadius: AppBorderRadius.borderRadiusTopExtraLarge,
  );
}

abstract class AppOutlineInputBorder {
  /// 2.5 percent of width
  static late OutlineInputBorder borderSmall = OutlineInputBorder(
    borderRadius: AppBorderRadius.borderRadiusSmall,
  );

  /// 3 percent of width
  static late OutlineInputBorder borderMild = OutlineInputBorder(
    borderRadius: AppBorderRadius.borderRadiusMild,
  );

  /// 3.5 percent of width
  static late OutlineInputBorder borderMedium = OutlineInputBorder(
    borderRadius: AppBorderRadius.borderRadiusMedium,
  );

  /// 4 percent of width
  static late OutlineInputBorder borderDefault = OutlineInputBorder(
    borderRadius: AppBorderRadius.borderRadiusDefault,
  );

  /// 6 percent of width
  static late OutlineInputBorder borderLarge = OutlineInputBorder(
    borderRadius: AppBorderRadius.borderRadiusLarge,
  );

  /// 8 percent of width
  static late OutlineInputBorder borderExtraLarge = OutlineInputBorder(
    borderRadius: AppBorderRadius.borderRadiusExtraLarge,
  );
}

abstract class AppBorderRadius {
  static late BorderRadius borderRadiusVerySmall = BorderRadius.all(AppRadius.radiusVerySmall);
  static late BorderRadius borderRadiusSmall = BorderRadius.all(AppRadius.radiusSmall);
  static late BorderRadius borderRadiusMild = BorderRadius.all(AppRadius.radiusMild);
  static late BorderRadius borderRadiusMedium = BorderRadius.all(AppRadius.radiusMedium);
  static late BorderRadius borderRadiusDefault = BorderRadius.all(AppRadius.radiusDefault);
  static late BorderRadius borderRadiusLarge = BorderRadius.all(AppRadius.radiusLarge);
  static late BorderRadius borderRadiusExtraLarge = BorderRadius.all(AppRadius.radiusExtraLarge);

  static late BorderRadius borderRadiusTopDefault = BorderRadius.only(
    topLeft: AppRadius.radiusDefault,
    topRight: AppRadius.radiusDefault,
  );

  static late BorderRadius borderRadiusTopLarge = BorderRadius.only(
    topLeft: AppRadius.radiusLarge,
    topRight: AppRadius.radiusLarge,
  );

  static late BorderRadius borderRadiusTopExtraLarge = BorderRadius.only(
    topLeft: AppRadius.radiusExtraLarge,
    topRight: AppRadius.radiusExtraLarge,
  );
}

abstract class AppRadius {
  static late Radius radiusVerySmall = Radius.circular(1.w);
  static late Radius radiusSmall = Radius.circular(2.5.w);
  static late Radius radiusMild = Radius.circular(3.w);
  static late Radius radiusMedium = Radius.circular(3.5.w);
  static late Radius radiusDefault = Radius.circular(4.w);
  static late Radius radiusLarge = Radius.circular(6.w);
  static late Radius radiusExtraLarge = Radius.circular(8.w);
}
