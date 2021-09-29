import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  final _locale = BehaviorSubject<Locale>();


  Stream<Locale> get locale => _locale.stream;

  Function(Locale) get changeLocale => _locale.sink.add;


  void dispose() {
    _locale.close();
  }
}