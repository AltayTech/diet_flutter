import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/box_end_date_subscription.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class SubscriptionWidget extends StatefulWidget {
  SubscriptionWidget();

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends ResourcefulState<SubscriptionWidget> {
  late ProfileBloc profileBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    profileBloc = ProfileProvider.of(context);
    return Column(
      children: [
        subscriptionBox(),
        Space(height: 1.h),
        StreamBuilder<SubscriptionPendingData?>(
          stream: profileBloc.subscriptionPending,
          builder: (context, subscriptionPending) {
            if (subscriptionPending.hasData && subscriptionPending.data != null)
              return pendingSubscriptionBox(subscriptionPending.requireData!);
            else
              return EmptyBox();
          },
        ),
        Space(height: 2.h),
      ],
    );
  }

  Widget pendingSubscriptionBox(SubscriptionPendingData subscriptionPendingData) {
    return DottedBorder(
      radius: Radius.circular(20),
      borderType: BorderType.RRect,
      color: AppColors.primary,
      strokeCap: StrokeCap.round,
      dashPattern: [6, 3, 2, 3],
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
            width: double.maxFinite,
            color: AppColors.primary.withOpacity(0.2),
            alignment: Alignment.topCenter,
            constraints: BoxConstraints(minHeight: 8.h),
            padding: EdgeInsets.only(
              bottom: 1.h,
              top: 1.h,
              left: 5.w,
              right: 5.w,
            ),
            child: descriptionStatusPaymentSubscription(
                subscriptionPendingData: subscriptionPendingData)),
      ),
    );
  }

  Widget descriptionStatusPaymentSubscription(
      {required SubscriptionPendingData subscriptionPendingData}) {
    return Text(
      intl.descriptionStatusPaymentSubscription(
          subscriptionPendingData.packageName,
          '${DateTimeUtils.formatCustomDate(subscriptionPendingData.createdAt.split("T")[0])}',
          subscriptionPendingData.termDays),
      softWrap: true,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.overline!.copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget subscriptionBox() {
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder<TermPackage>(
          stream: profileBloc.termPackage,
          builder: (context, termPackage) {
            if (termPackage.hasData)
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BoxEndTimeSubscription(
                      mainAxisAlignment: MainAxisAlignment.start, termPackage: termPackage.data!),
                  buttonSubscription(termPackage.data),
                ],
              );
            return Progress();
          }),
    );
  }

  Widget buttonRenewSubscription() {
    return SubmitButton(
      onTap: () {
        VxNavigator.of(context).push(Uri.parse(Routes.selectPackageSubscription));
      },
      label: intl.reviveSubscription,
      size: Size(35.w, 5.h),
    );
  }

  Widget buttonBuySubscription() {
    return SubmitButton(
      onTap: () {
        VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
      },
      label: intl.newSubscription,
      size: Size(35.w, 5.h),
    );
  }

  Widget buttonSubscription(TermPackage? termPackage) {
    return StreamBuilder<SubscriptionPendingData?>(
      stream: profileBloc.subscriptionPending,
      builder: (context, subscriptionPending) {
        if (subscriptionPending.data == null)
          return termPackage!.subscriptionTermData!.currentSubscriptionRemainingDays! > 0
              ? buttonRenewSubscription()
              : buttonBuySubscription();
        else
          return EmptyBox();
      },
    );
  }
}
