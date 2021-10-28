import 'package:behandam/data/entity/language.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:flutter/material.dart';


extension LocaleExtensions on Locale {
  String localizedName(BuildContext context) {
    final intl = context.intl;
    switch (this.languageCode) {
      case 'fa':
        return intl.farsi;
      case 'en':
        return intl.english;
      case 'ar':
        return intl.arabic;
    }
    throw 'Locale with languageCode: ${this.languageCode} not defined';
  }

  UserLanguage get toUserLanguage {
    switch(this.languageCode) {
      case 'fa':
        return UserLanguage.farsi;
      case 'en':
        return UserLanguage.english;
      case 'ar':
        return UserLanguage.arabic;
    }
    throw 'Locale with languageCode: ${this.languageCode} not defined';
  }
}