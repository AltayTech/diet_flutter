import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:logifan/widgets/space.dart';
class BoxEndTimeSubscription extends StatelessWidget{

  late String time;
  late MainAxisAlignment mainAxisAlignment;
  BoxEndTimeSubscription({required this.time,required this.mainAxisAlignment});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      textDirection: context.textDirectionOfLocale,
      children: [
        ImageUtils.fromLocal("assets/images/subscription.svg",
            width: 11.w, height: 11.w),
        Space(
          width: 3.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textDirection: context.textDirectionOfLocale,
              text: TextSpan(
                text: time,
                children: [
                  TextSpan(
                    text: ' روز',
                    style: context.typography.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp, letterSpacing: -0.8,),
                  )
                ],
                style: context.typography.bodyText1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'yekan',
                    fontSize: 18.sp),
              ),
            ),
            Text(
              context.intl.endYourTermDiet,
              style: context.typography.labelSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Iransans-light',
                  letterSpacing: -0.5,
                  color: Color(0xff212121)),
            ),
          ],
        )
      ],
    );
  }

}