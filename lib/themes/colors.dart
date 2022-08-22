import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ThemeAppColor { DEFAULT, BLUE, DARK, PURPLE, FASTTING, FASTTINGLIST }

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
  static late Color labelColor;
  static late Color labelTextColor;
  static late Color labelTab;
  static late Color warning = Colors.orange.shade100;

  static const btnColorsGradient =
      LinearGradient(colors: [Color(0xfff7879d), Color(0xffff5757)]);
  static const penColor = Color(0xff666666);
  static const redBar = Color(0xffFF5757);
  static const looseType = Color(0xfff6ded5);
  static const stableType = Color(0xffD5E9E3);
  static const gainType = Color(0xffE6CEEF);
  static const diabeticType = Color(0xffF7EBC7);
  static const pregnantType = Color(0xffF3D1D9);
  static const ketogenicType = Color.fromARGB(255, 246, 222, 213);
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
  static late Color colorCardGray;
  static late Color colorTextApp;
  static late Color colorSelectDepartmentTicket;
  static const grey = Color(0xffF5F5F5);
  static const priceGreyColor = Color(0xff454545);
  static const priceDiscountColor = Color(0xffED4C67);
  static const priceGreenColor = Color(0xff1ABC9C);
  static const priceColor = Color.fromRGBO(86, 195, 180, 1);
  static const purpleRuler = Color(0xff927DFC);
  static const pinkRuler = Color(0xffEC4CA2);
  static const blueRuler = Color(0xff65A8E0);
  static const greenRuler = Color(0xff59CBB1);
  static const box = Color.fromARGB(255, 245, 245, 245);
  static const pregnantPink = Color(0xffFE92A3);
  static const chartBorder = Color.fromARGB(255, 255, 87, 87);
  static const pinkPass = Color(0xffFFE2E2);
  static const redDate = Color(0xffFF5757);
  static const greyDate = Color(0xff454545);
  static const alertCallTextColor = Color(0xff5282a5);
  static const suggestion = Color(0xff1DD1A1);
  static const weightBoxColorRedLight = Color(0xffff7373 );
  static const weightBoxColorGreen = Color(0xff8BC384);
  static const weightBoxColorOrange = Color(0xffFFAC6F);
  static const weightBoxColorRed = Color(0xffbb0101);
  static const weightBoxColorBlue = Color(0xff84C8D0);
  static const dietTypeBoxColor = Color(0xffddf5f0);
  static const bodyStateBlueColor = Color(0xff3498db);
  static const bodyStatePurpleColor = Color(0xff686de0);
  static const bodyStateOrangeColor = Color(0xfff8924f);
  static const bodyStateGreenColor = Color(0xff1abc9c);
  static const bodyStateRedColor = Color(0xffed4c67);
  static const bodyStateDarkBlueColor = Color(0xff273c75);
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
  static var mealColors = [
    {
      'color': Color.fromRGBO(255, 125, 112, 1),
      'bgColor': Color.fromRGBO(254, 223, 214, 1),
    },
    {
      'color': Color.fromRGBO(141, 79, 255, 1),
      'bgColor': Color.fromRGBO(233, 221, 255, 1),
    },
    {
      'color': Color.fromRGBO(67, 210, 208, 1),
      'bgColor': Color.fromRGBO(224, 246, 245, 1),
    },
    {
      'color': Color.fromRGBO(228, 125, 155, 1),
      'bgColor': Color.fromRGBO(255, 231, 238, 1),
    },
    {
      'color': Color.fromRGBO(66, 192, 230, 1),
      'bgColor': Color.fromRGBO(224, 248, 255, 1),
    },
    {
      'color': Color.fromRGBO(220, 127, 148, 1),
      'bgColor': Color.fromRGBO(240, 225, 228, 1),
    },
    {
      'color': Color.fromRGBO(255, 125, 112, 1),
      'bgColor': Color.fromRGBO(254, 223, 214, 1),
    },
    {
      'color': Color.fromRGBO(141, 79, 255, 1),
      'bgColor': Color.fromRGBO(233, 221, 255, 1),
    },
    {
      'color': Color.fromRGBO(67, 210, 208, 1),
      'bgColor': Color.fromRGBO(224, 246, 245, 1),
    },
    {
      'color': Color.fromRGBO(228, 125, 155, 1),
      'bgColor': Color.fromRGBO(255, 231, 238, 1),
    },
    {
      'color': Color.fromRGBO(141, 79, 255, 1),
      'bgColor': Color.fromRGBO(233, 221, 255, 1),
    },
    {
      'color': Color.fromRGBO(67, 210, 208, 1),
      'bgColor': Color.fromRGBO(224, 246, 245, 1),
    },
    {
      'color': Color.fromRGBO(228, 125, 155, 1),
      'bgColor': Color.fromRGBO(255, 231, 238, 1),
    },
    {
      'color': Color.fromRGBO(66, 192, 230, 1),
      'bgColor': Color.fromRGBO(224, 248, 255, 1),
    },
    {
      'color': Color.fromRGBO(67, 210, 208, 1),
      'bgColor': Color.fromRGBO(224, 246, 245, 1),
    },
    {
      'color': Color.fromRGBO(228, 125, 155, 1),
      'bgColor': Color.fromRGBO(255, 231, 238, 1),
    },
    {
      'color': Color.fromRGBO(67, 210, 208, 1),
      'bgColor': Color.fromRGBO(224, 246, 245, 1),
    },
    {
      'color': Color.fromRGBO(228, 125, 155, 1),
      'bgColor': Color.fromRGBO(255, 231, 238, 1),
    },
  ];

  static late Color replaceFoodButton;
  static late Color helpFastingButton;
  static late Color menuColorDefault=Color.fromRGBO(250, 114, 126, 1.0);
  static late Color menuColorFasting=Color(0xff65A8E0);
  static late Color newBackground=Color(0xffF5F5F5);
  static late Color newBackgroundFlow=Color(0xffffffff);

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
        shadowColor = Color.fromARGB(255, 246, 246, 246);
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        labelColor = Color(0xf48e8e8e);
        labelTab = Color(0xffffffff);
        statusTicketClose = Colors.grey[700]!;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = primaryVariantLight;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        background = Color.fromARGB(255, 245, 245, 245);
        colorTextDepartmentTicket = Color.fromRGBO(210, 210, 210, 1);
        colorSelectDepartmentTicket = Color.fromRGBO(243, 243, 249, 1);
        labelTextColor = Color(0xff7f7f7f);
        colorCardGray = Color.fromRGBO(245, 245, 245, 1);
        colorTextApp = Color.fromRGBO(147, 147, 147, 1);
        replaceFoodButton = onPrimary;
        helpFastingButton = Color.fromRGBO(255, 138, 55, 1);
        break;
      case ThemeAppColor.BLUE:
        primary = Color(0x0ff011230);
        accentColor = Color(0xff092a49);
        primaryColorDark = Color(0x0ff000c21);
        onPrimary = Colors.white;
        primaryVariantLight = Color.fromRGBO(87, 206, 121, 1);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor = Color.fromARGB(255, 246, 246, 246);
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        labelColor = Color(0xf48e8e8e);
        labelTab = Color(0xffffffff);
        statusTicketClose = primaryVariantLight;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = Colors.grey[700]!;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        background = Color.fromARGB(255, 245, 245, 245);
        colorTextDepartmentTicket = Color.fromRGBO(210, 210, 210, 1);
        colorSelectDepartmentTicket = Color.fromRGBO(243, 243, 249, 1);
        labelTextColor = Color(0xff7f7f7f);
        colorCardGray = Color.fromRGBO(245, 245, 245, 1);
        colorTextApp = Color.fromRGBO(147, 147, 147, 1);
        replaceFoodButton = onPrimary;
        helpFastingButton = Color.fromRGBO(255, 138, 55, 1);
        break;
      case ThemeAppColor.DARK:
        primary = Color(0x0ff011230);
        accentColor = Color(0xff092a49);
        primaryColorDark = Color(0x0ff000c21);
        onPrimary = Colors.white;
        primaryVariantLight = Color.fromRGBO(87, 206, 121, 1);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor = Color.fromARGB(255, 246, 246, 246);
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        labelColor = Color(0xf48e8e8e);
        labelTab = Color(0xffffffff);
        statusTicketClose = Colors.grey[700]!;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = primaryVariantLight;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        background = Color.fromARGB(255, 245, 245, 245);
        colorTextDepartmentTicket = Color.fromRGBO(210, 210, 210, 1);
        colorSelectDepartmentTicket = Color.fromRGBO(243, 243, 249, 1);
        labelTextColor = Color(0xff7f7f7f);
        colorCardGray = Color.fromRGBO(245, 245, 245, 1);
        colorTextApp = Color.fromRGBO(147, 147, 147, 1);
        replaceFoodButton = onPrimary;
        helpFastingButton = Color.fromRGBO(255, 138, 55, 1);
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
        shadowColor = Color.fromARGB(255, 246, 246, 246);
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        labelColor = Color(0xf48e8e8e);
        labelTab = Color(0xffffffff);
        statusTicketClose = primaryVariantLight;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = Colors.grey[700]!;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        replaceFoodButton = onPrimary;
        helpFastingButton = Color.fromRGBO(255, 138, 55, 1);
        break;
      case ThemeAppColor.FASTTING:
        accentColor = Color.fromRGBO(72, 157, 220, 1);
        primaryColorDark = Color.fromARGB(255, 16, 95, 149);
        primary = Color.fromARGB(255, 53, 144, 214);
        onPrimary = Colors.white;
        primaryVariantLight = Color.fromRGBO(87, 206, 121, 1);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor = Color.fromARGB(255, 246, 246, 246);
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        labelColor = Color(0xf48e8e8e);
        labelTab = Color(0xffffffff);
        statusTicketClose = Colors.grey[700]!;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = primaryVariantLight;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        background = Color.fromARGB(255, 245, 245, 245);
        colorTextDepartmentTicket = Color.fromRGBO(210, 210, 210, 1);
        colorSelectDepartmentTicket = Color.fromRGBO(243, 243, 249, 1);
        labelTextColor = Color(0xff7f7f7f);
        colorCardGray = Color.fromRGBO(245, 245, 245, 1);
        colorTextApp = Color.fromRGBO(147, 147, 147, 1);
        replaceFoodButton = Color.fromRGBO(254, 223, 214, 1);
        helpFastingButton = Color.fromRGBO(255, 138, 55, 1);
        break;
      case ThemeAppColor.FASTTINGLIST:
        accentColor = Color.fromRGBO(15, 92, 150, 1);
        primaryColorDark = Color.fromARGB(255, 11, 63, 99);
        primary = Color.fromARGB(255, 15, 92, 150);
        onPrimary = Colors.white;
        primaryVariantLight = Color.fromRGBO(87, 206, 121, 1);
        iconsColor = Color(0xff646464);
        surface = Colors.white;
        onSurface = Colors.black;
        scaffold = Color(0xFFF5F8FE);
        onScaffold = onSurface;
        shadowColor = Color.fromARGB(255, 246, 246, 246);
        arcColor = Color(0xFAEDECEC);
        btnColor = Color(0xfffd5d5f);
        labelColor = Color(0xf48e8e8e);
        labelTab = Color(0xffffffff);
        statusTicketClose = Colors.grey[700]!;
        statusTicketResolved = Color.fromRGBO(235, 197, 69, 1);
        statusTicketPendingAdminResponse = Colors.lightBlue;
        statusTicketPendingUserResponse = Colors.pinkAccent;
        statusTicketOnHold = primaryVariantLight;
        statusTicketGlobalIssue = Color(0xFFF3543C);
        background = Color.fromARGB(255, 245, 245, 245);
        colorTextDepartmentTicket = Color.fromRGBO(210, 210, 210, 1);
        colorSelectDepartmentTicket = Color.fromRGBO(243, 243, 249, 1);
        labelTextColor = Color(0xff7f7f7f);
        colorCardGray = Color.fromRGBO(245, 245, 245, 1);
        colorTextApp = Color.fromRGBO(147, 147, 147, 1);
        replaceFoodButton = Color.fromRGBO(212, 240, 255, 1);
        helpFastingButton = Color.fromRGBO(255, 138, 55, 1);
        break;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColorDark,
      // status bar color
      statusBarBrightness: Brightness.dark,
      //status bar brigtness
      statusBarIconBrightness: Brightness.light,
      //status barIcon Brightness
      systemNavigationBarDividerColor: Colors.transparent,
      //Navigation bar divider color
      systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
    ));
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
