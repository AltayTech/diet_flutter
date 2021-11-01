import 'package:persian_number_utility/persian_number_utility.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  bool get isValidMobileOrEmail {
    if (contains('@')) {
      return isValidEmail;
    } else {
      return isValidMobile;
    }
  }

  bool get isValidMobile {
    final regex = RegExp(r'^\+?[0-9]+$'); // accepts both +989... and 09...
    return regex.hasMatch(toEnglishDigit());
  }

  bool get isValidEmail {
    final regex = RegExp(r'^.+@.+(\..+)+$'); // keeping it simple for brevity
    return regex.hasMatch(this);
  }

  bool get isImageFile {
    return endsWith('.jpg') ||
        endsWith('.jpeg') ||
        endsWith('.png') ||
        endsWith('.tiff') ||
        endsWith('.webp') ||
        endsWith('.exif');
  }
}

extension StringNullableExtensions on String? {
  bool get isNullOrEmpty => this == null || this == '';

  bool get isNotNullAndEmpty => this != null && this != '';
}
