import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/food_list/food_list.dart';
import 'package:behandam/extensions/object.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

import 'week_day.dart';

class FoodListBloc {
  FoodListBloc() {
    debugPrint('bloc');
    _loadContent();
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _foodList = BehaviorSubject<FoodListData?>();
  final _date = BehaviorSubject<String>();
  final _selectedWeekDay = BehaviorSubject<WeekDay>();
  final _weekDays = BehaviorSubject<List<WeekDay?>?>();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<FoodListData?> get foodList => _foodList.stream;

  Stream<String> get date => _date.stream;

  Stream<WeekDay> get selectedWeekDay => _selectedWeekDay.stream;

  Stream<List<WeekDay?>?> get weekDays => _weekDays.stream;

  String _previousDate = DateTime.now().toString().substring(0, 10);

  void _loadContent() {
    _loadingContent.value = true;
    _repository
        .foodList(
            _date.valueOrNull ?? DateTime.now().toString().substring(0, 10))
        .then((value) {
      debugPrint('food list ${value.data}');
      _foodList.value = value.data!;
      // _foodList.value?.meals.sort((a, b) => a.order.compareTo(b.order));
      // for (int i = 0; i < _foodList.value!.menu.foods.length; i++) {
      // _foodList.value?.meals[i].food = _foodList.value?.menu.foods[i];
      // _foodList.value?.meals[i].food?.ratios[0].ratioFoodItems
      //     .sort((a, b) => a.order.compareTo(b.order));
      // _foodList.value?.meals[i].food?.ratios[0].ratioFoodItems
      //     .map((ratioFoodItem) {
      //       debugPrint('ratio food ${ratioFoodItem.toJson()}');
      //   if (checkDefaultUnit(ratioFoodItem)) {
      //     _foodList.value!.meals[i].food!.fullTitle +=
      //         ratioFoodItem.amount?.defaultUnit?.representational +
      //             ratioFoodItem.amount?.defaultUnit?.title;
      //   }
      //   if (checkSecondUnit(ratioFoodItem)) {
      //     _foodList.value!.meals[i].food!.fullTitle +=
      //         ratioFoodItem.amount?.secondUnit?.representational +
      //             ratioFoodItem.amount?.secondUnit?.title;
      //   }
      //   _foodList.value!.meals[i].food!.fullTitle += ratioFoodItem.title;
      // });
      // _foodList.value!.meals[i].food!.fullTitle += ' + ';
      // }
      fillWeekDays();
    }).whenComplete(() => _loadingContent.value = false);
  }

  // bool checkDefaultUnit(RatioFoodItem ratioFoodItem) {
  //   return ratioFoodItem.amount?.defaultUnit?.amount != null &&
  //       ratioFoodItem.amount?.defaultUnit?.amount != 0;
  // }
  //
  // bool checkSecondUnit(RatioFoodItem ratioFoodItem) {
  //   return ratioFoodItem.amount?.secondUnit?.amount != null &&
  //       ratioFoodItem.amount?.secondUnit?.amount != 0;
  // }

  void fillWeekDays() {
    DateTime gregorianDate =
        DateTime.parse(_foodList.value!.menu.startedAt).toUtc().toLocal();
    Jalali jalaliDate = Jalali.fromDateTime(gregorianDate);
    List<WeekDay> data = [];
    debugPrint(
        'date2 $gregorianDate / $jalaliDate / ${WeekDay(gregorianDate: gregorianDate, jalaliDate: jalaliDate)}');
    data.add(WeekDay(gregorianDate: gregorianDate, jalaliDate: jalaliDate));
    debugPrint('date2 $gregorianDate / $jalaliDate');
    for (int i = 1; i < 7; i++) {
      debugPrint(
          'week day ${gregorianDate.add(Duration(days: i))} / ${jalaliDate.add(days: i)}');
      data.add(WeekDay(
          gregorianDate: gregorianDate.add(Duration(days: i)),
          jalaliDate: jalaliDate.add(days: i)));
    }
    _weekDays.value = data;
    _selectedWeekDay.value = _weekDays.value!.firstWhere((element) =>
        element!.gregorianDate.toString().substring(0, 10) ==
        (_date.valueOrNull ?? DateTime.now().toString().substring(0, 10)))!;
  }

  void changeDate(String newDate) {
    if (_previousDate != newDate) {
      _date.value = newDate;
      _previousDate = newDate;
      _foodList.value = null;
      _selectedWeekDay.value = _weekDays.value!.firstWhere((element) =>
          element!.gregorianDate.toString().substring(0, 10) == _date.value)!;
      _loadFoodList();
    }
  }

  void _loadFoodList() {
    _loadingContent.value = true;
    _repository
        .foodList(
            _date.valueOrNull ?? DateTime.now().toString().substring(0, 10))
        .then((value) {
      debugPrint('food list ${value.data}');
      _foodList.value = value.data!;
      _foodList.value?.meals.sort((a, b) => a.order.compareTo(b.order));
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
