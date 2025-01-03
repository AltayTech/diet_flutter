extension DoubleExtensions on double {
  String get toStringAsFixedOneWithoutZero {
    String string = this.toStringAsFixed(1);
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return string.replaceAll(regex, '');
  }

  String toStringAsFixedWithoutZero(int fix) {
    String string = this.toStringAsFixed(fix);
    RegExp regex = RegExp(r'([.]0*)(?!.*\d)');
    return string.replaceAll(regex, '');
  }

  String toStringAsFixedWithOneZero(int fix) {
    String string = this.toStringAsFixed(fix);
    RegExp regex = RegExp(r'(\.0{1,})');
    return string.replaceAll(regex, '.0');
  }

  double setZiro() {
    return this == null ? 0.0 : this;
  }
}
