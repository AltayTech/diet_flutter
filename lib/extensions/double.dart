extension DoubleExtensions on double {
  String get toStringAsFixedOneWithoutZero {
    String string = this.toStringAsFixed(1);
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return string.replaceAll(regex, '');
  }
}
