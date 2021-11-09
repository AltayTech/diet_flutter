import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/screens/daily_menu/bloc.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/input_widget.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class ListFoodPage extends StatefulWidget {
  const ListFoodPage({Key? key}) : super(key: key);

  @override
  _ListFoodPageState createState() => _ListFoodPageState();
}

class _ListFoodPageState extends ResourcefulState<ListFoodPage> {
  late ListFoodBloc bloc;
  String? mealTitle;

  @override
  void initState() {
    super.initState();
    bloc = ListFoodBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    mealTitle = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: Toolbar(titleBar: intl.selectFoodIn(mealTitle ?? '')),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: bloc.loadingContent,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && !snapshot.requireData)
              return Column(
                children: [
                  Container(
                    color: Colors.grey[300],
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: Column(
                      children: [
                        InputWidget(labelText: intl.whatFoodAreYouLookingFor),
                        Space(height: 2.h),
                        StreamBuilder(
                          stream: bloc.listFood,
                          builder: (_, AsyncSnapshot<ListFoodData> snapshot){
                            if (snapshot.error is NoResultFoundError) {
                              return SearchNoResult(intl.foodNotFoundMessage);
                            }
                            if (!snapshot.hasData || snapshot.hasError) {
                              return EmptyBox();
                            }
                            return Container(
                              height: 5.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) => Container(
                                  decoration: AppDecorations.boxLarge.copyWith(
                                    color: AppColors.onPrimary,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Center(
                                    child: Text(
                                      snapshot.requireData.items.tags[index].title,
                                      style: typography.caption,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                separatorBuilder: (_, __) => Space(width: 2.w),
                                itemCount: snapshot.requireData.items.tags.length,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            return Center(child: CircularProgressIndicator());
          },
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
}
