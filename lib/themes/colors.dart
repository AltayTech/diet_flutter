import 'package:flutter/material.dart';

enum ThemeAppColor { DEFAULT, BLUE, DARK, PURPLE }

class AppColors {
  late ThemeAppColor themeAppColor;
  static late Color primary;

  static late Color accentColor;

  static late Color primaryColorDark;

  static late Color onPrimary;

  static late Color primaryVariantLight;

  static late Color iconsColor;
  static late Color shadowColor;
  static late Color surface;
  static late Color onSurface;
  static late Color scaffold;

  static late Color onScaffold;

  AppColors({required this.themeAppColor}) {
    switch (this.themeAppColor) {
      case ThemeAppColor.DEFAULT:
        accentColor = Color.fromRGBO(250, 114, 126, 1);
        primaryColorDark = Color.fromARGB(255, 255, 55, 87);
        primary = Color.fromARGB(255, 255, 87, 87);
        onPrimary = Colors.white;
        primaryVariantLight = Color.fromRGBO(87, 206, 121, 1);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor=Color.fromARGB(255, 246, 246, 246);
        break;
      case ThemeAppColor.BLUE:
        primary = Color(0xFF0D83DD);
        accentColor = Color(0xFF71BBF9);
        primaryColorDark = Color(0xFF043882);
        onPrimary = Colors.white;
        primaryVariantLight = Color(0xFF0BF995);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor=Color.fromARGB(255, 246, 246, 246);
        break;
      case ThemeAppColor.DARK:
        primary = Color(0xFF0D83DD);
        onPrimary = Colors.white;
        primaryVariantLight = Color(0xFF0E8DEE);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor=Color.fromARGB(255, 246, 246, 246);
        break;
      case ThemeAppColor.PURPLE:
        primary = Color(0xFF0D83DD);
        onPrimary = Colors.white;
        primaryVariantLight = Color(0xFF0E8DEE);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor=Color.fromARGB(255, 246, 246, 246);
        break;
    }
  }
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
