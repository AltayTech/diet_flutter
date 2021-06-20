import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Localized strings of project
  AppLocalizations intl() {
    return AppLocalizations.of(this)!;
  }
}