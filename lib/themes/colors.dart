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
  static late Color lableTextColor;
  static late Color lableTab;
  static const penColor = Color(0xff8A8A8A);
  static const redBar = Color(0xffFF5757);
  static const looseType = Color(0xffF6DED5);
  static const stableType = Color(0xffD5E9E3);
  static const gainType = Color(0xffE6CEEF);
  static const diabetType = Color(0xffF7EBC7);
  static const pregnantType = Color(0xffF3D1D9);
  static const ketoType = Color.fromARGB(255, 246, 222, 213);
  static const notricaType = Color.fromARGB(255, 213, 233, 227);
  static const sportType = Color.fromARGB(255, 230, 206, 239);
  static const help = Color(0xffFFE7E7);
  static const strongPen = Color(0xffC0C0C0);
  static late Color statusTicketClose;
  static late Color statusTicketResolved;
  static late Color statusTicketPendingAdminResponse;
  static late Color statusTicketPendingUserResponse;
  static late Color statusTicketOnHold;
  static late Color statusTicketGlobalIssue;
  static late Color background;
  static late Color colorTextDepartmentTicket;
  static late Color colorselectDepartmentTicket;
  static const grey = Color(0xffF5F5F5);
  static const purpleRuler = Color(0xff927DFC);
  static const pinkRuler = Color(0xffEC4CA2);
  static const blueRuler = Color(0xff65A8E0);
  static const greenRuler = Color(0xff59CBB1);
  static const box = Color.fromARGB(255, 245, 245, 245);
  static const pregnantPink = Color(0xffFFD6DC);
  static var colorPackages = [
  {
  'barColor': Color.fromARGB(255, 249, 203, 202),
  'priceColor': primary,
  },
  {
  'barColor': Color.fromRGBO(200, 224, 221, 1),
  'priceColor': Color.fromRGBO(86, 195, 180, 1),
  },
  ];
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
        lableTab = Color(0xffffffff);
        statusTicketClose =Colors.grey[700]!;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold =  primaryVariantLight;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        background = Color.fromARGB(255, 245, 245, 245);
        colorTextDepartmentTicket = Color.fromRGBO(210, 210, 210, 1);
        colorselectDepartmentTicket = Color.fromRGBO(243, 243, 249, 1);
        lableTextColor = Color(0xff7f7f7f);
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
        lableTab = Color(0xffffffff);
        statusTicketClose = primaryVariantLight;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = Colors.grey[700]!;
        statusTicketGlobalIssue = Color(0xFFF3543C);
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
        lableTab = Color(0xffffffff);
        statusTicketClose = primaryVariantLight;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = Colors.grey[700]!;
        statusTicketGlobalIssue = Color(0xFFF3543C);
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
        lableTab = Color(0xffffffff);
        statusTicketClose = primaryVariantLight;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = Colors.grey[700]!;
        statusTicketGlobalIssue = Color(0xFFF3543C);
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
