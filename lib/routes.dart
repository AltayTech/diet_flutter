import 'package:flutter/material.dart';


final GlobalKey<ScaffoldMessengerState> navigatorMessengerKey = GlobalKey();

abstract class Routes {
  static const home = '/home';
  static const login = '/login';
  static const pass = '/pass';
  static const register = '/register';
  static const verify = '/verify';
  static const profile = '/profile';

  /// All available routes to Navigator
  static final all = <String, Widget Function(BuildContext)>{
    //   home: (context) => HomePage(),
  };
}
