import 'package:behandam/extensions/object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intlLib;


extension ContextExtensions on BuildContext {
  /// Localized strings of project
  AppLocalizations get intl => AppLocalizations.of(this)!;

  /// Typography for textStyle used in [Text] widget
  TextTheme get typography => Theme.of(this).textTheme;

  /// Arguments received between two Navigation destination
  Object get arguments => ModalRoute.of(this)!.settings.arguments.errorIfNull('Argument required');

  TextDirection get textDirectionOfLocale {
    if (isRtl) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  TextDirection get textDirectionOfLocaleInversed {
    if (isRtl) {
      return TextDirection.ltr;
    } else {
      return TextDirection.rtl;
    }
  }

  TextDirection get textDirectionOfContext => Directionality.of(this);

  TextDirection get textDirectionOfContextInversed {
    if (Directionality.of(this) == TextDirection.rtl) {
      return TextDirection.ltr;
    } else {
      return TextDirection.rtl;
    }
  }

  bool get isRtl => intlLib.Bidi.isRtlLanguage(Localizations.localeOf(this).languageCode);

  bool get keyboardIsOpened => MediaQuery.of(this).viewInsets.bottom != 0.0;
}
