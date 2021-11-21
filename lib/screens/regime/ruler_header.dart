import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RulerHeader extends StatelessWidget {
  RulerHeader({
    Key? key,
    required this.iconPath,
    required this.heading,
    this.onHelpClick,
  }) : super(key: key);

  final String iconPath;
  final String heading;
  final Function? onHelpClick;

  @override
  Widget build(BuildContext context) {
    AppLocalizations intl = context.intl;
    TextTheme typography = context.typography;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageUtils.fromLocal(iconPath, width: 5.w, height: 5.h),
        Space(width: 3.w),
        Expanded(
          child: Text(
            heading,
            style: typography.subtitle2,
          ),
        ),
        if (onHelpClick != null)
          InkWell(
              child: ImageUtils.fromLocal(
                  'assets/images/physical_report/guide.svg',
                  width: 5.w,
                  height: 5.h),
              onTap: () => onHelpClick!.call()),
      ],
    );
  }
}
