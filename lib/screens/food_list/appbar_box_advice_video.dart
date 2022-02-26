import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_food/article.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

import 'week_day.dart';

class AppbarBoxAdviceVideo extends StatefulWidget {
  AppbarBoxAdviceVideo({Key? key}) : super(key: key);

  @override
  _AppbarBoxAdviceVideoState createState() => _AppbarBoxAdviceVideoState();
}

class _AppbarBoxAdviceVideoState extends ResourcefulState<AppbarBoxAdviceVideo> {
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
    return GestureDetector(
      child: appbarStackBox(),
      onTap: () {},
    );
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
                      return Row(
                        children: [
                          ImageUtils.fromLocal("assets/images/foodlist/advice/video_advice.svg"),
                          Space(
                            width: 2.w,
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                intl.descriptionArticle,
                                style: typography.caption,
                              ),
                              Text(
                                articleVideo.requireData.title!,
                                style: typography.caption!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))
                        ],
                      );
                    }
                    return Center(child: EmptyBox());
                  },
                );
              }
              return Center(child: EmptyBox());
            },
          ),
        ),
      ),
    );
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
