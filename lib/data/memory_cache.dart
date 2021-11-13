import 'entity/auth/country_code.dart';

import 'package:behandam/data/entity/fast/fast.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'entity/list_view/food_list.dart';
import 'entity/user/user_information.dart';

import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/user_information.dart';

class MemoryApp {
  static String? token;
  static int inboxCount = 0;
  static int showR = 0;
  static UserInformation? userInformation;
  static CityProvinceModel? cityProvinceModel;
  static List<CountryCode>? countryCode;
  static String? selectedDate;
  static String? routeName;

  Map<String, FoodListData> _foodList = {};
  Map<String, int> _selectedFastPatten = {};
  String? _date;
  UserInformation? _profile;
  List<FastPatternData>? _patterns;
  // FastPatternData? _selectedPattern;

  void saveFoodList(FoodListData data, String date) {
    if(_foodList.containsKey(date)) {
      _foodList.update(date, (value) => data);
    }else {
      _foodList.addAll({date: data});
    }
    debugPrint('cache $_foodList');
  }

  void saveDate(String date) {
    _date = date;
    debugPrint('save date $date');
  }

  void saveProfile(UserInformation profile) {
    _profile = profile;
  }

  void savePatterns(List<FastPatternData> patterns) {
    _patterns = patterns;
  }

  void saveSelectedPattern(int patternIndex) {
    if(_selectedFastPatten.containsKey(_date)) {
      _selectedFastPatten.update(_date!, (value) => patternIndex);
    }else {
      _selectedFastPatten.addAll({_date!: patternIndex});
    }
    debugPrint('patterns $_selectedFastPatten');
  }

  FoodListData? get foodList{
    FoodListData? foodListData;
    _foodList.forEach((key, value) {
      if(key == _date) foodListData = value;
    });
    return foodListData;
  }

  String? get date => _date;

  UserInformation? get profile => _profile;

  List<FastPatternData>? get patterns => _patterns;

  int? get selectedPattern {
    int? patternIndex;
    _selectedFastPatten.forEach((key, value) {
      if(key == _date) patternIndex = value;
    });
    debugPrint('selected pattern $patternIndex');
    return patternIndex;
  }

}
