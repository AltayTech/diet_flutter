final dioErrorObserver = DioErrorObserver();

abstract class DioErrorListener {
  /// When http 503 error occurs and user press retry
  void onRetryAfterMaintenance();

  /// When device is offline and user press retry or just close dialog
  void onRetryAfterNoInternet();

  /// When any dialog needed to retry loading page is closed
  void onRetryLoadingPage();

  void onShowMessage(String value);
}

class DioErrorObserver {
  final List<DioErrorListener> _listeners = [];

  void subscribe(DioErrorListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void unsubscribe(DioErrorListener listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }

  void retryForMaintenance() {
    for (var element in _listeners) {
      element.onRetryAfterMaintenance();
    }
  }

  void retryForInternetConnectivity() {
    for (var element in _listeners) {
      element.onRetryAfterNoInternet();
    }
  }


  void showMessage(String message) {
    for (var element in _listeners) {
      element.onShowMessage(message);
    }
  }

  void retryForLoadingPage() {
    for (var element in _listeners) {
      element.onRetryLoadingPage();
    }
  }
}
