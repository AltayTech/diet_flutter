import 'dart:async';

import 'package:behandam/base/first_class_functions.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

extension StreamExtensions<T> on Stream<T> {
  /// Clear previous SnackBar when new event is triggered
  StreamSubscription<T> listenClearingSnackBars(
    BuildContext Function() contextOf,
    void Function(T event)? onData,
  ) {
    return listen((event) {
      ScaffoldMessenger.of(contextOf.call()).clearSnackBars();
      onData?.call(event);
    });
  }
}

extension BehaviorSubjectExtensions<T> on BehaviorSubject<T> {
  /// Set debounce on stream controller


  /// Add value to the stream only when it is not closed, otherwise do nothing
  set safeValue(T newValue) => isClosed == false ? add(newValue) : doNothing();
}
