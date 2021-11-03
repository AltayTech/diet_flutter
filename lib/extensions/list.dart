extension ListNullableExtensions<E> on List<E>? {
  bool existWhere(bool test(E element), [int start = 0]) {
    return this != null && this!.indexWhere((element) => test(element), start) != -1;
  }
}
