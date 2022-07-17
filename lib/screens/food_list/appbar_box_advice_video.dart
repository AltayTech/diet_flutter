import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_food/article.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import 'week_day.dart';

class AppbarBoxAdviceVideo extends StatefulWidget {
  AppbarBoxAdviceVideo({Key? key}) : super(key: key);

  @override
  _AppbarBoxAdviceVideoState createState() => _AppbarBoxAdviceVideoState();
}

class _AppbarBoxAdviceVideoState
    extends ResourcefulState<AppbarBoxAdviceVideo> {
  late FoodListBloc bloc;

  // int? _selectedDayIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = FoodListProvider.of(context);
    super.build(context);
    return appbarStackBox();
  }

  Widget appbarStackBox() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Card(
        shape: AppShapes.rectangleMedium,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: StreamBuilder(
            stream: bloc.selectedWeekDay,
            builder: (_, AsyncSnapshot<WeekDay?> snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder(
                  stream: bloc.adviceVideo,
                  builder: (_, AsyncSnapshot<ArticleVideo> articleVideo) {
                    if (articleVideo.hasData) {
                      if (isAfterToday(snapshot.data!))
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                appbarStackBoxText(snapshot.requireData!),
                                style: typography.caption,
                                softWrap: true,
                              ),
                            ),
                            todayButton(),
                          ],
                        );
                      else
                        return Row(
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection: context.textDirectionOfLocale,
                              children: [
                                Text(
                                  intl.descriptionArticle,
                                  style: typography.caption,
                                ),
                                Text(
                                  articleVideo.requireData.title!,
                                  textAlign: TextAlign.start,
                                  textDirection: context.textDirectionOfLocale,
                                  maxLines: 1,
                                  style: typography.overline!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            )),
                            Space(
                              width: 2.w,
                            ),
                            videoButton(),
                          ],
                        );
                    }
                    return Center(
                        child: Text(
                      intl.noAdviceVideo,
                      style: typography.caption,
                    ));
                  },
                );
              }
              return Center(child: Container(height: 8.h, child: EmptyBox()));
            },
          ),
        ),
      ),
    );
  }

  String appbarStackBoxText(WeekDay weekday) {
    String text = '';
    text = intl.viewingMenu(
        '${weekday.jalaliDate.formatter.wN} ${weekday.jalaliDate.formatter.d} ${weekday.jalaliDate.formatter.mN}');
    return text;
  }

  Widget videoButton() {
    return GestureDetector(
      child: Container(
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.primary.withOpacity(0.3),
          ),
          width: 35.w,
          height: 6.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: AppDecorations.boxLarge.copyWith(
                  color: AppColors.primary.withOpacity(0.6),
                ),
                width: 7.w,
                height: 7.w,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 5.w,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                  child: Text(
                intl.showVideoButton,
                textAlign: TextAlign.center,
                style: typography.overline?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              )),
            ],
          )),
      onTap: () {
        VxNavigator.of(context)
            .push(Uri.parse('${Routes.dailyMessage}/${bloc.adviceId}'));
      },
    );
  }

  Widget todayButton() {
    return GestureDetector(
      child: Container(
        decoration: AppDecorations.boxLarge.copyWith(
          color: AppColors.primary.withOpacity(0.3),
        ),
        width: 25.w,
        height: 6.h,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Center(
          child: Text(
            intl.goToToday,
            style: typography.caption!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
            softWrap: true,
          ),
        ),
      ),
      onTap: () {
        bloc.changeDateWithString(DateTime.now().toString().substring(0, 10));
      },
    );
  }

  bool isAfterToday(WeekDay day) {
    return day.gregorianDate
        .isAfter(DateTime.parse(DateTime.now().toString().substring(0, 10)));
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
