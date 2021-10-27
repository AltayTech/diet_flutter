import 'package:flutter/material.dart';

abstract class Routes {
  static const home = '/home';
  static const auth = '/auth';
  static const login = '/login';
  static const pass = '/pass';
  static const entrance = '/entrance';
  static const verify = '/verify';


  /// All available routes to Navigator
  static final all = <String, Widget Function(BuildContext)>{
 //   home: (context) => HomePage(),
  };
}
