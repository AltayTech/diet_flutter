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
  static late Color arcColor;
  static late Color btnColor;
  static late Color onScaffold;
  static late Color lableColor;

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
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        lableColor = Color(0xf48e8e8e);
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
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        lableColor = Color(0xf48e8e8e);
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
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        lableColor = Color(0xf48e8e8e);
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
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        lableColor = Color(0xf48e8e8e);
        break;
    }
  }
  static const penColor = Color(0xff8A8A8A);
  static const redBar = Color(0xffFF5757);
  static const looseType = Color(0xffF6DED5);
  static const stableType = Color(0xffD5E9E3);
  static const gainType = Color(0xffE6CEEF);
  static const diabetType = Color(0xffF7EBC7);
  static const pregnantType = Color(0xffF3D1D9);
  static const ketoType = Color(0xffE6F2EE);
  static const notricaType = Color(0xffB8BEE9);
  static const sportType = Color(0xffE6F2EE);
  static const help = Color(0xffFFE7E7);
  static const strongPen = Color(0xffC0C0C0);
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
