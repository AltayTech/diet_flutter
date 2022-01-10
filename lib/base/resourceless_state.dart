import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:behandam/extensions/build_context.dart';

export 'package:sizer/sizer.dart';
export 'package:behandam/extensions/build_context.dart';


abstract class ResourcelessState <T extends StatelessWidget> {
  late AppLocalizations intl;
  late TextTheme typography;

  @mustCallSuper
  Widget build(BuildContext context) {
    intl = context.intl;
    typography = context.typography;

    return Text('Not implemented body');
  }
}