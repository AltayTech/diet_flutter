import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logifan/widgets/space.dart';

class RulerHeader extends StatelessWidget {
  RulerHeader({
    Key? key,
    required this.value,
    required this.heading,
    required this.color,
    this.onHelpClick,
  }) : super(key: key);

  final String value;
  final String heading;
  final Color color;
  final Function? onHelpClick;

  @override
  Widget build(BuildContext context) {
    AppLocalizations intl = context.intl;
    TextTheme typography = context.typography;

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              heading,
              style: typography.subtitle2,
            ),
            Space(width: 2.w,),
            if (onHelpClick != null)
              InkWell(
                  child: ImageUtils.fromLocal('assets/images/physical_report/help.svg',
                      width: 5.w, height: 5.h),
                  onTap: () => onHelpClick!.call()),
          ],
        ),
        Center(child:  Text(
          value,
          textAlign: TextAlign.center,
          style: typography.headline6!.copyWith(color: color),
        ),)
      ],
    );
  }
}
