import 'package:shared_preferences/shared_preferences.dart';

enum SharedP {
  token,
  Image,
  simpleDayNumber,
  simpleDayTime,
  proDayNumber,
  proDayTime,
  username,
  fcmToken,
}

class SharedPreference {
  static SharedPreferences? pref;

  static iniSharedPreference() async {
    pref = await SharedPreferences.getInstance();
  }
}
