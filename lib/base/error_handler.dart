// import 'dart:io';
//
// import 'package:dio/dio.dart';
// // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:karsu/data/network/error/error_observer.dart';
// import 'package:karsu/data/sharedpreferences.dart';
// import 'package:karsu/extensions/build_context.dart';
// import 'package:karsu/routes.dart';
// // import 'package:karsu/screens/alert/maintenance.dart';
// // import 'package:karsu/screens/alert/network.dart';
// // import 'package:karsu/utils/dialog.dart';
//
// /// Global error handler for dio requests
// class ErrorHandlerInterceptor extends Interceptor {
//   @override
//   void onError(DioError err, ErrorInterceptorHandler handler) {
//     final statusCode = err.response?.statusCode;
//     print('onError $statusCode');
//     // if (statusCode == 400) {
//     //   _handleBadRequestError(err);
//     // }
//     // if (statusCode == 401) {
//     //   _handleUnauthorizedError();
//     // }
//     // if (statusCode == 403) {
//     //   _handleAccessDeniedError(err);
//     // }
//     // if (statusCode == 404) {
//     //   _handleNotFoundError(err);
//     // }
//     // if (statusCode == 408) {
//     //   _handleRequestTimeoutError(err);
//     // }
//     // if (statusCode == 500) {
//     //   _handleInternalServerError(err);
//     // }
//     // if (statusCode == 503) {
//     //   _handleMaintenanceError();
//     // }
//     // if (err.type == DioErrorType.sendTimeout) {
//     //   _handleSendTimeoutError(err);
//     // }
//     // if (err.type == DioErrorType.receiveTimeout) {
//     //   _handleReceiveTimeoutError(err);
//     // }
//     // if (err.error is SocketException) {
//     //   _handleNoInternetError();
//     // }
//     super.onError(err, handler);
//   }
//
//   // BuildContext? get _context => navigatorKey.currentContext;
//   //
//   // NavigatorState? get _state => navigatorKey.currentState;
//   //
//   // FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;
//   //
//   // void _handleInternalServerError(DioError err) {
//   //   if (_context != null) {
//   //     final intl = _context!.intl;
//   //     Fluttertoast.showToast(msg: intl.serverInternalError, toastLength: Toast.LENGTH_LONG);
//   //   }
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: '500 http error');
//   // }
//
//   // void _handleAccessDeniedError(DioError err) {
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: '403 http error');
//   // }
//   //
//   // void _handleNotFoundError(DioError err) {
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: '404 http error');
//   // }
//   //
//   // void _handleBadRequestError(DioError err) {
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: '400 http error');
//   // }
//   //
//   // void _handleRequestTimeoutError(DioError err) {
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: '408 http error');
//   // }
//   //
//   // void _handleSendTimeoutError(DioError err) {
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: 'send timeout');
//   // }
//   //
//   // void _handleReceiveTimeoutError(DioError err) {
//   //   _crashlytics.recordError(err.error, err.stackTrace, reason: 'receive timeout');
//   // }
//   //
//   // void _handleUnauthorizedError() async {
//   //   await AppSharedPreferences.logout();
//   //   _state?.pushNamedAndRemoveUntil(Routes.login, ModalRoute.withName(Routes.splash));
//   // }
//   //
//   // void _handleMaintenanceError() async {
//   //   if (_context == null) {
//   //     return;
//   //   }
//   //   await DialogUtils.showDialogPage(
//   //     context: _context!,
//   //     isDismissible: false,
//   //     child: MaintenancePage(),
//   //   );
//   //   dioErrorObserver.retryForMaintenance();
//   //   dioErrorObserver.retryForLoadingPage();
//   // }
//   //
//   // void _handleNoInternetError() async {
//   //   if (_context == null) {
//   //     return;
//   //   }
//   //   await DialogUtils.showDialogPage(context: _context!, child: NetworkAlertPage());
//   //   dioErrorObserver.retryForInternetConnectivity();
//   //   dioErrorObserver.retryForLoadingPage();
//   // }
// }
