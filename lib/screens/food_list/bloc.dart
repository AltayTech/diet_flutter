import 'dart:async';

import 'package:behandam/app/bloc.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/list_food/daily_menu.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/screens/fast/bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

import 'week_day.dart';
import 'package:velocity_x/velocity_x.dart';

class FoodListBloc {
  FoodListBloc(bool fillFood) {
    if (_date.valueOrNull == null && MemoryApp.selectedDate == null)
      _date.value = DateTime.now().toString().substring(0, 10);
    else if (_date.valueOrNull == null && MemoryApp.selectedDate != null)
      _date.value = MemoryApp.selectedDate!;
    debugPrint('bloc foodlist ${_date.value}');
    _loadContent(invalidate: true, fillFood: fillFood);
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _foodList = BehaviorSubject<FoodListData?>();
  final _date = BehaviorSubject<String>();
  final _selectedWeekDay = BehaviorSubject<WeekDay>();
  final _weekDays = BehaviorSubject<List<WeekDay?>?>();
  final AppBloc _appBloc = AppBloc();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<FoodListData?> get foodList => _foodList.stream;

  Stream<String> get date => _date.stream;

  Stream<WeekDay> get selectedWeekDay => _selectedWeekDay.stream;

  Stream<List<WeekDay?>?> get weekDays => _weekDays.stream;

  late WeekDay _previousWeekDay;

  void _loadContent({bool invalidate = false, bool fillFood = true}) {
    _loadingContent.value = true;
    _repository.foodList(_date.value, invalidate: invalidate).then((value) {
      debugPrint('food list ${value.data} / $fillFood');
      _foodList.value = value.data!;
      _foodList.value?.meals.sort((a, b) => a.order.compareTo(b.order));
      setTheme();
      if(fillFood) foodForMeal();
      fillWeekDays();
    }).whenComplete(() => _loadingContent.value = false);
  }

  void foodForMeal(){
    for (int i = 0; i < _foodList.value!.menu.foods.length; i++) {
      _foodList.value?.meals[i].food = _foodList.value?.menu.foods[i];
      _foodList.value?.meals[i].food?.ratios?[0].ratioFoodItems
          ?.sort((a, b) => a.order.compareTo(b.order));
      debugPrint('fill food ${_foodList.value!.meals[i].food!.ratios?[0].ratioFoodItems?.length}');
      _foodList.value?.meals[i].food?.ratios?[0].ratioFoodItems
          ?.forEach((ratioFoodItem) {
        ratioFoodItem.unitTitle = '';
        debugPrint('ratio food ${ratioFoodItem.toJson()}');
        if (checkDefaultUnit(ratioFoodItem)) {
          ratioFoodItem.unitTitle += '${ratioFoodItem.amount?.defaultUnit?.representational} ${ratioFoodItem.amount?.defaultUnit?.title}';
          if (checkSecondUnit(ratioFoodItem)) {
            ratioFoodItem.unitTitle += ' * ${ratioFoodItem.amount?.secondUnit?.representational} ${ratioFoodItem.amount?.secondUnit?.title}';
          }
        }else if (checkSecondUnit(ratioFoodItem)) {
          ratioFoodItem.unitTitle += '${ratioFoodItem.amount?.secondUnit?.representational} ${ratioFoodItem.amount?.secondUnit?.title}';
        }
      });
    }
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
    DateTime gregorianDate =
        DateTime.parse(_foodList.value!.menu.startedAt).toUtc().toLocal();
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
      debugPrint(
          'week day ${gregorianDate.add(Duration(days: i))} / ${jalaliDate.add(days: i)}');
      data.add(WeekDay(
          gregorianDate: gregorianDate.add(Duration(days: i)),
          jalaliDate: jalaliDate.add(days: i),
          isSelected: gregorianDate
                  .add(Duration(days: i))
                  .toString()
                  .substring(0, 10) ==
              _date.value));
    }
    _weekDays.value = data;
    _selectedWeekDay.value = _weekDays.value!.firstWhere((element) =>
        element!.gregorianDate.toString().substring(0, 10) == _date.value)!;
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
          debugPrint(
              'change date 2 ${_selectedWeekDay.value.isSelected} / ${element.isSelected}');
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
      _foodList.value = value.data!;
      _foodList.value?.meals.sort((a, b) => a.order.compareTo(b.order));
      foodForMeal();
      setTheme();
    }).whenComplete(() => _loadingContent.value = false);
  }

  void onMealFood(Food newFood, int mealId){
    final index = _foodList.valueOrNull?.meals.indexWhere((element) => element.id == mealId);
    _foodList.valueOrNull?.meals[index!].food = newFood;
  }

  onDailyMenu(BuildContext context){
    _loadingContent.value = true;
    List<DailyFood> foods = [];
    int day = _weekDays.value!.indexWhere((element) => element!.gregorianDate == _selectedWeekDay.value.gregorianDate);
    _foodList.value?.meals.forEach((meal) {
      //ToDo calculate the free food id
      foods.add(DailyFood(meal.food!.id!, meal.id, day + 1, null));
      debugPrint('daily menu change ${foods.last.toJson()}');
    });
    DailyMenuRequestData requestData = DailyMenuRequestData(foods);
    _repository.dailyMenu(requestData).then((value) {
      if(value.data != null && value.requireData)
        Navigator.of(context).pop(true);
        // VxNavigator.of(context).returnAndPush(true);
        // onRefresh(invalidate: true);
    }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _foodList.close();
    _date.close();
    _weekDays.close();
    _selectedWeekDay.close();
  }
}
