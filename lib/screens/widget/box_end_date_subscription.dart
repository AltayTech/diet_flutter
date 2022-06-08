import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class BoxEndTimeSubscription extends StatelessWidget {
  late String time;
  late TermPackage termPackage;
  late bool isExpired;
  late MainAxisAlignment mainAxisAlignment;

  BoxEndTimeSubscription({required this.termPackage, required this.mainAxisAlignment}) {
    isExpired = termPackage.subscriptionTermData!.currentSubscriptionRemainingDays! == 0;
    time =
        '${termPackage.subscriptionTermData!.currentSubscriptionRemainingDays! + termPackage.subscriptionTermData!.reservedSubscriptionsDuration!}';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      textDirection: context.textDirectionOfLocale,
      children: [
        ImageUtils.fromLocal("assets/images/subscription.svg", width: 11.w, height: 11.w),
        Space(
          width: 3.w,
        ),
        if (!isExpired)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textDirection: context.textDirectionOfLocale,
                text: TextSpan(
                  text: time,
                  children: [
                    TextSpan(
                      text: ' ${context.intl.day}',
                      style: context.typography.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        letterSpacing: -0.8,
                      ),
                    )
                  ],
                  style: context.typography.bodyText1!
                      .copyWith(fontWeight: FontWeight.w700, fontFamily: 'yekan', fontSize: 18.sp),
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
          ),
        if (isExpired)
          Center(
            child: Text(
              termPackage.term==null ? context.intl.notActiveTerm : context.intl.expireTerm,
              style: context.typography.labelSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Iransans-light',
                  letterSpacing: -0.5,
                  color: Color(0xff212121)),
            ),
          ),
      ],
    );
  }
}
