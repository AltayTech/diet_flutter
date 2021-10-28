final dioErrorObserver = DioErrorObserver();

abstract class DioErrorListener {
  /// When http 503 error occurs and user press retry
  void onRetryAfterMaintenance();

  /// When device is offline and user press retry or just close dialog
  void onRetryAfterNoInternet();

  /// When any dialog needed to retry loading page is closed
  void onRetryLoadingPage();
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
    _listeners.forEach((element) {
      element.onRetryAfterMaintenance();
    });
  }

  void retryForInternetConnectivity() {
    _listeners.forEach((element) {
      element.onRetryAfterNoInternet();
    });
  }

  void retryForLoadingPage() {
    _listeners.forEach((element) {
      element.onRetryLoadingPage();
    });
  }
}
