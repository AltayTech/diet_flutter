import 'dart:io';

import 'package:behandam/api/error/error_observer.dart';
import 'package:behandam/app/app.dart';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/data/entity/auth/status.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/maintenance.dart';
import 'package:behandam/screens/widget/network.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Global error handler for dio requests
class ErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.error is SocketException) {
      if (err.requestOptions.method.contains("GET")) {
        _isTypeRequestGet = false;
      } else
        _isTypeRequestGet = true;
      _handleNoInternetError();
      return super.onError(err, handler);
    }
    if (err.type == DioErrorType.sendTimeout) {
      _showToast(err);
      _submitNonFatalReport(err, 'send timeout');
      return super.onError(err, handler);
    }
    if (err.type == DioErrorType.receiveTimeout) {
      _showToast(err);
      _submitNonFatalReport(err, 'receive timeout');
      return super.onError(err, handler);
    }
    final statusCode = err.response?.statusCode;
    switch (statusCode) {
      case HttpStatus.badRequest:
      case HttpStatus.forbidden:
      case HttpStatus.notFound:
        _showToastIfNotRelease(err);
        _submitNonFatalReport(err);
        break;
      case HttpStatus.internalServerError:
        _showToast(err);
        _submitNonFatalReport(err);
        break;
      case HttpStatus.unauthorized:
        _handleUnauthorizedError(err);
        break;
      case HttpStatus.unprocessableEntity:
        _showToast(err);
        break;
      case HttpStatus.serviceUnavailable:
        _handleMaintenanceError(err);
        break;
      default:
        _showToastIfNotRelease(err);
        break;
    }
    return super.onError(err, handler);
  }

  BuildContext? get _context => navigator.navigatorKey!.currentContext;

  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  bool _isNetworkAlertShown = false;
  bool _isTypeRequestGet = false;
  bool _isMaintenanceAlertShown = false;

  void _showToastIfNotRelease(DioError err) async {
    final packageInfo = await PackageInfo.fromPlatform();
    _showToast(err);
  }

  void _showToast(DioError err) {
    if (_context == null) {
      return;
    }
    final intl = _context!.intl;
    String? message;
    if (err.response?.statusCode == HttpStatus.internalServerError) {
      message = intl.serverInternalError;
    }
    // print('ttt ${err.response.toString()}');
    try {
      if (message == null && err.response?.data != null && err.response?.data != '') {
        message = NetworkResponse<dynamic>.fromJson(
                err.response!.data, (json) => CheckStatus.fromJson(json as Map<String, dynamic>))
            .error!
            .message;
      }
    } catch (e) {}
    message ??= intl.httpErrorWithCode(err.response?.statusCode.toString() ?? 'Unknown');

    //Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
    //Utils.getSnackbarMessage(_context!, message);
    dioErrorObserver.showMessage(message);
    navigatorMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('$message'),
    ));
  }

  void _handleUnauthorizedError(DioError err) async {
    if (navigator.currentConfiguration!.path != Routes.login &&
        navigator.currentConfiguration!.path != Routes.refundVerify &&
        navigator.currentConfiguration!.path != Routes.authVerify &&
        navigator.currentConfiguration!.path != Routes.passVerify) {
      await AppSharedPreferences.logout();
      navigator.routeManager.clearAndPush(Uri(path: Routes.auth));
    } else {
      _showToast(err);
    }
  }

  void _submitNonFatalReport(DioError err, [String? message]) {
    final headers = Map.of(err.requestOptions.headers);
    headers.remove('Authorization');
    headers.remove('Fcm-Token');
    final reason = '${message ?? ''}${message != null ? '\n' : ''}'
        'Http ${err.response?.statusCode} error\n'
        'Request URI: ${err.requestOptions.uri}\n'
        'Request Body: ${err.requestOptions.data}\n'
        'Request Headers: $headers';
    _crashlytics.recordError(err.error, err.stackTrace, reason: reason);
  }

  void _handleMaintenanceError(DioError err) async {
    if (_context == null) {
      return;
    }
    String? message;
    try {
      if (message == null && err.response?.data != null && err.response?.data != '') {
        message = NetworkResponse<dynamic>.fromJson(
                err.response!.data, (json) => CheckStatus.fromJson(json as Map<String, dynamic>))
            .error!
            .message;
      }
    } catch (e) {}

    await DialogUtils.showDialogPage(
      context: _context!,
      isDismissible: false,
      child: MaintenancePage(
        message: message,
      ),
    );
  }

  void _handleNoInternetError() async {
    if (_context == null || MemoryApp.isNetworkAlertShown) {
      return;
    }
    MemoryApp.isNetworkAlertShown = true;
    await DialogUtils.showDialogPage(context: _context!, child: NetworkAlertPage());
    MemoryApp.isNetworkAlertShown = false;
    if (_isTypeRequestGet)
      dioErrorObserver.retryForInternetConnectivity();
    else
      dioErrorObserver.retryForLoadingPage();
  }
}
