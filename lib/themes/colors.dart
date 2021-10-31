import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF0D83DD);
  static const onPrimary = Colors.white;
  static const primaryVariantLight = Color(0xFF0E8DEE);
  static const surface = Colors.white;
  static const onSurface = Colors.black;
  static const scaffold = Color(0xFFF5F8FE);
  static const onScaffold = onSurface;
  static const ArcColor = Color(0xFAEDECEC);
  static const btnColor = Color(0xfffd5d5f);
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
