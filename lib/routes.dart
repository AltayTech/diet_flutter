import 'package:flutter/material.dart';


final GlobalKey<ScaffoldMessengerState> navigatorMessengerKey = GlobalKey();

abstract class Routes {
  static const home = '/home';
  static const login = '/login';
  static const pass = '/pass';
  static const register = '/register';
  static const verify = '/verify';
  static const resetCode = '/resetCode';
  static const resetPass = '/resetPass';
  static const regimeType = '/regimeType';
  static const helpType = '/help';
  static const profile = '/profile';
  static const foodList = '/list/view';

  /// All available routes to Navigator
  static final all = <String, Widget Function(BuildContext)>{
    //   home: (context) => HomePage(),
  };
}
