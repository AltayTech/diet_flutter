import 'dart:async';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:rxdart/rxdart.dart';

class CalendarBloc {
  CalendarBloc() {
    if (_startDate.valueOrNull == null)
      _startDate.value = DateTime.now().subtract(Duration(days: 100)).toString().substring(0, 10);
    if (_endDate.valueOrNull == null)
      _endDate.value = DateTime.now().add(Duration(days: 100)).toString().substring(0, 10);
    _loadContent();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _endDate = BehaviorSubject<String>();
  final _startDate = BehaviorSubject<String>();
  final _calendar = BehaviorSubject<CalendarData?>();

  // final FoodListBloc _foodListBloc = FoodListBloc();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<String> get startDate => _startDate.stream;

  Stream<String> get endDate => _endDate.stream;

  //
  Stream<CalendarData?> get calendar => _calendar.stream;

  void _loadContent() {
    _loadingContent.safeValue = true;
    _repository.calendar(_startDate.value, _endDate.value).then((value) {
      _calendar.value = value.requireData;
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void dispose() {
    _loadingContent.close();
    _startDate.close();
    _endDate.close();
    _calendar.close();
  }
}
