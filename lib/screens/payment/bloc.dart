import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class PaymentBloc {
  PaymentBloc();

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _latestInvoice = BehaviorSubject<LatestInvoiceData>();
  // final _selectedPattern = BehaviorSubject<FastPatternData>();
  // final _fast = BehaviorSubject<FastMenuRequestData>();
  // final FoodListBloc _foodListBloc = FoodListBloc();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<LatestInvoiceData> get latestInvoice => _latestInvoice.stream;
  //
  // Stream<FastPatternData> get selectedPattern => _selectedPattern.stream;
  //
  // Stream<FastMenuRequestData> get fast => _fast.stream;

  void latestInvoiceLoad() {
    _loadingContent.value = true;
    _repository.latestInvoice().then((value) {
      _latestInvoice.value = value.data!;
      debugPrint('latest invoice bloc ${_latestInvoice.value.amount}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void newPayment(LatestInvoiceData newInvoice){
    _loadingContent.value = true;
    _repository.newPayment(newInvoice).then((value) {
      _latestInvoice.value = value.data!;
      debugPrint('new invoice bloc ${_latestInvoice.value.amount}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _latestInvoice.close();
  }
}
