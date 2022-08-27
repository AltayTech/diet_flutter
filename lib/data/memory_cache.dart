import 'package:behandam/data/entity/auth/status.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/list_food/article.dart';
import 'package:behandam/data/entity/refund.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'entity/auth/country.dart';
import 'entity/list_view/food_list.dart';
import 'entity/user/user_information.dart';

class MemoryApp {
  static String? token;
  static int inboxCount = 0;
  static int showR = 0;
  static UserInformation? userInformation;
  static TermPackage? termPackage;
  static RefundItem? refundItem;
  static CityProvinceModel? cityProvinceModel;
  static List<Country>? countries;
  static String? selectedDate;
  static String? routeName;
  static Jalali? day;
  static bool forgetPass = false;
  static bool needRoute = true;
  static bool  isShowDialog = false;
  static bool  isNetworkAlertShown = false;
  static FirebaseAnalytics? analytics;
  static List<String> fastingDates = [];
  List<ArticleVideo>? _articles;
  static int page = 0;

  static WhatsappInfo? whatsappInfo;

  Map<String, FoodListData> _foodList = {};
  Map<String, int> _selectedFastPatten = {};
  String? _date;
  UserInformation? _profile;
  List<FastPatternData>? _patterns;

  // FastPatternData? _selectedPattern;
  String? get date => _date;

  UserInformation? get profile => _profile;

  List<FastPatternData>? get patterns => _patterns;

  void saveFoodList(FoodListData data, String date) {
    if (_foodList.containsKey(date)) {
      _foodList.update(date, (value) => data);
    } else {
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
    if (_selectedFastPatten.containsKey(_date)) {
      _selectedFastPatten.update(_date!, (value) => patternIndex);
    } else {
      _selectedFastPatten.addAll({_date!: patternIndex});
    }
    debugPrint('patterns $_selectedFastPatten');
  }

  FoodListData? get foodList {
    FoodListData? foodListData;
    _foodList.forEach((key, value) {
      if (key == _date) foodListData = value;
    });
    return foodListData;
  }

  int? get selectedPattern {
    int? patternIndex;
    _selectedFastPatten.forEach((key, value) {
      if (key == _date) patternIndex = value;
    });
    debugPrint('selected pattern $patternIndex');
    void saveDate(String date) {
      _date = date;
      debugPrint('save date $date');
    }

    return patternIndex;
  }

  void saveArticle(List<ArticleVideo> articles) {
    _articles = articles;
  }

  List<ArticleVideo>? get articles => _articles;
}
