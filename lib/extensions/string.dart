import 'package:persian_number_utility/persian_number_utility.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  bool get isValidMobileOrEmail {
    if (this.contains('@')) {
      return this.isValidEmail;
    } else {
      return this.isValidMobile;
    }
  }



  bool get isValidMobile {
    final regex = RegExp(r'^\+?[0-9]+$'); // accepts both +989... and 09...
    return regex.hasMatch(this.toEnglishDigit());
  }

  bool get isValidEmail {
    final regex = RegExp(r'^.+@.+(\..+)+$'); // keeping it simple for brevity
    return regex.hasMatch(this);
  }
}

extension StringNullableExtensions on String? {
  bool get isNullOrEmpty => this == null || this == '';

  bool get isNotNullAndEmpty => this != null && this != '';

  double toDouble() {
    final input = this?.replaceAll(',', '.') ?? '0';
    return double.tryParse(input) ?? 0.0;
  }

}
