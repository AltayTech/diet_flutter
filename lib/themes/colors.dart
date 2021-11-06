import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF0D83DD);
  static const onPrimary = Colors.white;
  static const primaryVariantLight = Color(0xFF0E8DEE);
  static const surface = Colors.white;
  static const onSurface = Colors.black;
  static const scaffold = Color(0xFFF5F8FE);
  static const onScaffold = onSurface;
  static const ArcColor = Color(0xffF5F5F5);
  static const btnColor = Color(0xfffd5d5f);
  static const penColor = Color(0xff8A8A8A);
  static const redBar = Color(0xffFF5757);
  static const looseType = Color(0xffF6DED5);
  static const gainType = Color(0xffE6CEEF);
  static const stableType = Color(0xffD5E9E3);
  static const diabetType = Color(0xffF7EBC7);
  static const pregnantType = Color(0xffF3D1D9);
  static const ketoType = Color(0xffE6F2EE);
  static const sportType = Color(0xffE6F2EE);
  static const notricaType = Color(0xffB8BEE9);
  static const help = Color(0xffFFE7E7);
  static const strongPen = Color(0xffC0C0C0);
//#C0C0C0
}

abstract class AppMaterialColors {
  static const MaterialColor primary = const MaterialColor(
    0xFF0D83DD,
    const <int, Color>{
      50: const Color(0xFFe2f1fc),
      100: const Color(0xFFB9DCF8),
      200: const Color(0xFF8DC7F4),
      300: const Color(0xFF60B1F0),
      400: const Color(0xFF3CA0EE),
      500: const Color(0xFF1191EB),
      600: const Color(0xFF0D83DD),
      700: const Color(0xFF0671CA),
      800: const Color(0xFF0160B8),
      900: const Color(0xFF00439A),
    },
  );
}
