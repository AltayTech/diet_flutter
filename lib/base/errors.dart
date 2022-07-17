import 'dart:io';

import 'package:behandam/utils/crashlytics.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// An error model to indicate NoResultFound in AsyncSnapshot used inside Streams
class NoResultFoundError extends Error {}

/// A global error handler for whole application inside entry point
abstract class GlobalErrorHandler {
  /// Handle errors not caught by flutter framework
  static void handleUncaughtErrors(Object error, StackTrace stack) {
    if (_isUselessErrorToSubmit(error)) {
      return;
    }
    AppCrashlytics.recordError(error, stack: stack);
  }

  /// Handle errors caught by flutter framework
  static void handleCaughtErrors() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (_isUselessErrorToSubmit(details.exception)) {
        return;
      }
      AppCrashlytics.recordFlutterError(details);
    };
  }

  static bool _isUselessErrorToSubmit(Object error) {
    return error is DioError || // already handled in DioErrorHandlerInterceptor
        error is HttpException || // already handled in DioErrorHandlerInterceptor
        error is SocketException || // not useful
        error is HandshakeException || // not useful
        error is OSError; // not useful
  }
}
