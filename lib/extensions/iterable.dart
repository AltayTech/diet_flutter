import 'dart:math' as math;

extension StringIterableExtensions on Iterable<String> {
  /// Check if substring exists in iterable
  bool containsSubstring(String substring) {
    var contains = false;
    this.forEach((element) {
      if (substring.contains(element)) {
        contains = true;
      }
    });
    return contains;
  }
}

extension DoubleIterableExtensions on Iterable<double> {
  double get min => reduce(math.min);

  double get max => reduce(math.max);
}

extension NullableIterableExtensions<E> on Iterable<E>? {
  List<T> mapOrEmpty<T>(T transform(E element)) => this?.map(transform).toList() ?? [];

  bool get isNullOrEmpty => this == null || (this != null && this!.isEmpty);
}
