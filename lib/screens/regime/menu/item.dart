import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logifan/widgets/space.dart';
import 'package:behandam/widget/sizer/sizer.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({Key? key, required this.onClick, required this.menu,}) : super(key: key);

  final Function onClick;
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    AppLocalizations intl = context.intl;
    TextTheme typography = context.typography;

    return GestureDetector(
      onTap: () => onClick.call(),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: AppDecorations.boxLarge.copyWith(
          color: AppColors.onPrimary,
        ),
        padding:
        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.title,
                    style: typography.caption,
                    textAlign: TextAlign.start,
                  ),
                  Space(height: 0.2.h),
                  Text(
                    menu.description ?? '',
                    style: typography.caption?.apply(
                      fontSizeDelta: -2,
                    ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Space(width: 2.w),
            helpBox(),
          ],
        ),
      ),
    );
  }

  Widget helpBox() {
    return Container(
      decoration: AppDecorations.boxMedium.copyWith(
        color: AppColors.primary.withOpacity(0.2),
      ),
      width: 15.w,
      height: 15.w,
      child: Center(
        child: ImageUtils.fromLocal(
          'assets/images/diet/help_icon.svg',
          width: 6.w,
          color: AppColors.iconsColor,
        ),
      ),
    );
  }
}
