import 'package:karsu/screens/auth/auth.dart';
import 'package:karsu/screens/auth/login.dart';
import 'package:karsu/screens/auth/register.dart';
import 'package:karsu/screens/home/home.dart';

abstract class Routes {
  static const home = '/home';


  /// All available routes to Navigator
  static final all = {
    home: (context) => HomePage(),
  };
}
