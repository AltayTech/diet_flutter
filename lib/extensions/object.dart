import 'package:behandam/base/first_class_functions.dart';

extension ObjectExtensions<T> on T {
  R let<R>(R Function(T it) op) => op(this);

  T also(void Function(T it) block) {
    block(this);
    return this;
  }
}

extension ObjectNullableExtensions<T> on T? {
  String valueOrDefault<E>(E Function(T value) selector, {String defaultData = '-'}) {
    return this != null ? selector(this!).toString() : defaultData;
  }

  T errorIfNull([var message]) {
    if (this == null) error(message ?? 'Exception');
    return this!;
  }
}
