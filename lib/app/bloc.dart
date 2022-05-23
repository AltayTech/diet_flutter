import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  final _locale = BehaviorSubject<Locale>();
  final _theme = BehaviorSubject<ThemeData>();


  Stream<Locale> get locale => _locale.stream;

  Stream<ThemeData> get theme => _theme.stream;

  Function(Locale) get changeLocale => _locale.sink.add;

  void changeTheme(ThemeAppColor themeAppColor){
    AppColors(themeAppColor: themeAppColor);

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

  TextTheme buildTextTheme(Locale locale) {
    final appTypography = AppTypography(locale);
    return TextTheme(
      headline1: appTypography.headline1,
      headline2: appTypography.headline2,
      headline3: appTypography.headline3,
      headline4: appTypography.headline4,
      headline5: appTypography.headline5,
      headline6: appTypography.headline6,
      bodyText1: appTypography.bodyText1,
      bodyText2: appTypography.bodyText2,
      caption: appTypography.caption,
      overline: appTypography.overline,
      subtitle1: appTypography.subtitle1,
      subtitle2: appTypography.subtitle2,
      button: appTypography.button,
    );
  }


  void dispose() {
    _locale.close();
    _theme.close();
  }
}

enum ThemeType{
  Fast,
  original,
}