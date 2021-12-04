import 'dart:async';

import 'package:behandam/app/bloc.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/list_food/daily_menu.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'week_day.dart';

class FoodListBloc {
  FoodListBloc(bool fillFood) {
    if (_date.valueOrNull == null && MemoryApp.selectedDate == null)
      _date.value = DateTime.now().toString().substring(0, 10);
    else if (_date.valueOrNull == null && MemoryApp.selectedDate != null)
      _date.value = MemoryApp.selectedDate!;
    debugPrint('bloc foodlist ${_date.value}');
    _loadContent(invalidate: true, fillFood: fillFood);
  }

  FoodListBloc.fillWeek() {
    if (_date.valueOrNull == null && MemoryApp.selectedDate == null)
      _date.value = DateTime.now().toString().substring(0, 10);
    else if (_date.valueOrNull == null && MemoryApp.selectedDate != null)
      _date.value = MemoryApp.selectedDate!;
    fillWeekDays();
  }

  final _showServerError = LiveEvent();
  final _navigateTo = LiveEvent();
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _foodList = BehaviorSubject<FoodListData?>();
  final _date = BehaviorSubject<String>();
  final _selectedWeekDay = BehaviorSubject<WeekDay>();
  final _weekDays = BehaviorSubject<List<WeekDay?>?>();
  final AppBloc _appBloc = AppBloc();
  String? _pdfPath;

  String? get pdfPath => _pdfPath;

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream get showServerError => _showServerError.stream;
  Stream get navigateTo => _navigateTo.stream;

  Stream<FoodListData?> get foodList => _foodList.stream;

  Stream<String> get date => _date.stream;

  Stream<WeekDay> get selectedWeekDay => _selectedWeekDay.stream;

  Stream<List<WeekDay?>?> get weekDays => _weekDays.stream;

  late WeekDay _previousWeekDay;

  void _loadContent({bool invalidate = false, bool fillFood = true}) {
    _loadingContent.value = true;
    _repository.foodList(_date.value, invalidate: invalidate).then((value) {
      if (value.data?.menu != null) {
        debugPrint('food list ${value.data?.menu?.title} / $fillFood');
        _foodList.value = value.data;
        _foodList.value?.meals?.sort((a, b) => a.order.compareTo(b.order));
        setTheme();
        fillWeekDays();
      } else {
        _showServerError.fire(value.next);
      }
    }).whenComplete(() => _loadingContent.value = false);
  }

  bool checkDefaultUnit(RatioFoodItem ratioFoodItem) {
    return ratioFoodItem.amount?.defaultUnit?.amount != null &&
        ratioFoodItem.amount?.defaultUnit?.amount != 0;
  }

  bool checkSecondUnit(RatioFoodItem ratioFoodItem) {
    return ratioFoodItem.amount?.secondUnit?.amount != null &&
        ratioFoodItem.amount?.secondUnit?.amount != 0;
  }

  void setTheme() {
    debugPrint(
        'theme ${_foodList.value?.isFasting} / ${_foodList.value?.isFasting == boolean.True}');
    if (_foodList.value?.isFasting == boolean.True)
      _appBloc.changeTheme(ThemeAppColor.DARK);
    else
      _appBloc.changeTheme(ThemeAppColor.DEFAULT);
  }

  void fillWeekDays() {
    DateTime gregorianDate;
    if (_foodList.hasValue)
      gregorianDate = DateTime.parse(_foodList.value!.menu!.startedAt!).toUtc().toLocal();
    else
      gregorianDate = DateTime.now().toUtc().toLocal();
    Jalali jalaliDate = Jalali.fromDateTime(gregorianDate);
    List<WeekDay> data = [];
    debugPrint(
        'date2 $gregorianDate / $jalaliDate / ${WeekDay(gregorianDate: gregorianDate, jalaliDate: jalaliDate)}');
    data.add(WeekDay(
        gregorianDate: gregorianDate,
        jalaliDate: jalaliDate,
        isSelected: gregorianDate.toString().substring(0, 10) == _date.value));
    debugPrint('date2 $gregorianDate / $jalaliDate');
    for (int i = 1; i < 7; i++) {
      data.add(WeekDay(
          gregorianDate: gregorianDate.add(Duration(days: i)),
          jalaliDate: gregorianDate.add(Duration(days: i)).toJalali(),
          isSelected:
              gregorianDate.add(Duration(days: i)).toString().substring(0, 10) == _date.value));
      debugPrint(
          'week day ${data.length} / ${data.last.gregorianDate} / ${gregorianDate.add(Duration(days: i))} /');
    }
    _weekDays.value = data;
    _selectedWeekDay.value = _weekDays.value!.firstWhere(
        (element) => element!.gregorianDate.toString().substring(0, 10) == _date.value)!;
    _previousWeekDay = _selectedWeekDay.value;
  }

  void changeDateWithString(String newDate) {
    debugPrint(
        'change date 1 $newDate / ${_previousWeekDay.gregorianDate} / ${_weekDays.value!.length}');
    if (_previousWeekDay.gregorianDate.toString().substring(0, 10) != newDate) {
      _loadingContent.value = true;
      _date.value = newDate;
      _weekDays.value!.forEach((element) {
        debugPrint('change date 4 ${element?.gregorianDate} / ');
        if (element!.gregorianDate.toString().substring(0, 10) == newDate) {
          element.isSelected = true;
          _selectedWeekDay.value = element;
          debugPrint('change date 2 ${_selectedWeekDay.value.isSelected} / ${element.isSelected}');
        } else
          element.isSelected = false;
      });
      _foodList.value = null;
      _previousWeekDay = _selectedWeekDay.value;
      debugPrint('change date 3 $newDate / ${_previousWeekDay.gregorianDate}');
      MemoryApp.selectedDate = newDate;
      onRefresh();
    }
  }

  void onRefresh({bool invalidate = false}) {
    _loadingContent.value = true;
    _repository.foodList(_date.value, invalidate: invalidate).then((value) {
      debugPrint('food list ${value.data}');
      _foodList.value = value.data;
      _foodList.value?.meals?.sort((a, b) => a.order.compareTo(b.order));
      setTheme();
    }).whenComplete(() => _loadingContent.value = false);
  }

  void onMealFood(ListFood newFood, int mealId) {
    debugPrint('newfood1 ${newFood.toJson()}');
    final index = _foodList.valueOrNull?.meals?.indexWhere((element) => element.id == mealId);
    // _foodList.valueOrNull?.meals[index!].food = newFood;
    _foodList.valueOrNull?.meals?[index!].newFood = newFood;
    debugPrint(
        'newfood ${_foodList.valueOrNull?.meals?[index!].title} / ${_foodList.valueOrNull?.meals?[index!].newFood?.toJson()}');
  }

  onDailyMenu() {
    _loadingContent.value = true;
    List<DailyFood> foods = [];
    int day = _weekDays.value!
        .indexWhere((element) => element!.gregorianDate == _selectedWeekDay.value.gregorianDate);
    debugPrint('newfood3 ${_foodList.valueOrNull?.meals?[0].newFood?.id}');
    _foodList.valueOrNull?.meals?.forEach((meal) {
      debugPrint('daily menu newfood ${meal.id} / ${meal.title} / ${meal.newFood?.toJson()}');
      //ToDo calculate the free food id
      if (meal.newFood?.id != null) foods.add(DailyFood(meal.newFood!.id!, meal.id, day + 1, null));
      debugPrint('daily menu change ${foods.last.toJson()}');
    });
    DailyMenuRequestData requestData = DailyMenuRequestData(foods);
    _repository.dailyMenu(requestData).then((value) {
      if (value.data != null && value.requireData) {
        onRefresh(invalidate: true);
      }
    }).whenComplete(() => _loadingContent.value = false);
  }

  void onReplacingFood(int mealId) {
    _loadingContent.value = true;
    List<DailyFood> foods = [];
    int day = _weekDays.value!
        .indexWhere((element) => element!.gregorianDate == _selectedWeekDay.value.gregorianDate);
    final meal = _foodList.value?.meals?.firstWhere((element) => element.id == mealId);
    foods.add(DailyFood(meal!.newFood!.id!, meal.id, day + 1, null));
    debugPrint('replace Food ${foods.last.toJson()}');
    DailyMenuRequestData requestData = DailyMenuRequestData(foods);
    _repository.dailyMenu(requestData).then((value) {
      if (value.data != null && value.requireData) {
        onRefresh(invalidate: true);
      }
    }).whenComplete(() => _loadingContent.value = false);
    makingFoodEmpty(mealId);
  }

  void makingFoodEmpty(int mealId) {
    _foodList.valueOrNull?.meals?.firstWhere((element) => element.id == mealId).newFood = null;
  }

  void nextStep(){
    _repository.nextStep().then((value) {
      _navigateTo.fire(value.next);
    }).whenComplete(() {
      _showServerError.fire(false);
    });
  }
  void getPdfMeal(FoodDietPdf type) {
    _repository.getPdfUrl(type).then((value) {
      Utils.launchURL(value.data!.url!);
      // Share.share(value['data']['url'])
    }).whenComplete(() {
      _navigateTo.fire(false);
    });
  }
  void dispose() {
    _loadingContent.close();
    _foodList.close();
    _navigateTo.close();
    _date.close();
    _weekDays.close();
    _selectedWeekDay.close();
  }
}
