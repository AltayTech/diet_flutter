import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/daily_menu/bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/input_widget.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class ListFoodPage extends StatefulWidget {
  const ListFoodPage({Key? key}) : super(key: key);

  @override
  _ListFoodPageState createState() => _ListFoodPageState();
}

class _ListFoodPageState extends ResourcefulState<ListFoodPage> {
  late ListFoodBloc bloc;
  Meals? meal;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    bloc = ListFoodBloc();
  }

  void onScroll() {
    if (scrollController.position.extentAfter <
        AppSizes.verticalPaginationExtent) {
      bloc.onScrollReachingEnd();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    meal = ModalRoute.of(context)?.settings.arguments as Meals;
    if (meal != null) bloc.onMealChanged(meal!.id);
    scrollController = ScrollController()..addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.selectFoodIn(meal?.title ?? '')),
      body: Container(
        child: SingleChildScrollView(
          controller: scrollController,
          child: StreamBuilder(
            stream: bloc.loadingContent,
            builder: (_, AsyncSnapshot<bool> snapshot) {
              return content();
              // return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[300],
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Column(
            children: [
              TextField(
                cursorColor: AppColors.iconsColor,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.onPrimary,
                  hintText: intl.whatFoodAreYouLookingFor,
                  contentPadding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
                  hintStyle: typography.caption?.apply(
                    color: AppColors.lableColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.onPrimary),
                    borderRadius: AppBorderRadius.borderRadiusExtraLarge,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.onPrimary),
                    borderRadius: AppBorderRadius.borderRadiusExtraLarge,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    size: 10.w,
                    color: AppColors.iconsColor,
                  )
                ),
                style: typography.subtitle2?.apply(
                  color: AppColors.onSurface.withOpacity(0.9),
                ),
                onChanged: (value) => bloc.onSearchInputChanged(value),
              ),
              Space(height: 2.h),
              tags(),
            ],
          ),
        ),
        Space(height: 2.h),
        Container(
          decoration: AppDecorations.boxMild.copyWith(
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: foods(),
        ),
      ],
    );
  }

  Widget tags() {
    return StreamBuilder(
      stream: bloc.tags,
      builder: (_, AsyncSnapshot<List<Tag>?> snapshot) {
        if (snapshot.error is NoResultFoundError) {
          return SearchNoResult(intl.foodNotFoundMessage);
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return EmptyBox();
        }
        return Container(
          height: 4.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) =>
                tagItem(snapshot.data?[index], index),
            separatorBuilder: (_, __) => Space(width: 2.w),
            itemCount: snapshot.data?.length ?? 0,
          ),
        );
      },
    );
  }

  Widget tagItem(Tag? tag, int index) {
    return StreamBuilder(
      stream: bloc.selectedTagIds,
      builder: (_, AsyncSnapshot<List<int>?> snapshot) {
        return GestureDetector(
          onTap: () => bloc.onTagChanged(tag?.id ?? 0),
          child: Container(
            decoration: AppDecorations.boxLarge.copyWith(
              color: snapshot.hasData && snapshot.requireData!.contains(tag?.id)
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.onPrimary,
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: Text(
                tag?.title ?? '',
                style: typography.caption?.apply(
                  color: snapshot.hasData &&
                          snapshot.requireData!.contains(tag?.id)
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget foods(){
    return StreamBuilder(
      stream: bloc.foods,
      builder: (_, AsyncSnapshot<List<Food>?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.error is NoResultFoundError) {
            return SearchNoResult(intl.foodNotFoundMessage);
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return EmptyBox();
          }
          debugPrint(
              'food length ${snapshot.requireData!.length}');
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              if (index == snapshot.requireData!.length) {
                return loadMoreProgress();
              }
              return foodItem(snapshot.requireData![index]);
            },
            itemCount: snapshot.requireData!.length + 1,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget loadMoreProgress() {
    return StreamBuilder(
      stream: bloc.loadingMoreFoods,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return CenteredCircularProgressIndicator(
          visible: snapshot.data == true,
        );
      },
    );
  }

  Widget foodItem(Food food) {
    return StreamBuilder(
      stream: bloc.selectedFood,
      builder: (_, AsyncSnapshot<Food?> snapshot) {
        return GestureDetector(
          onTap: () => bloc.onFoodChanged(food),
          child: Card(
            margin: EdgeInsets.only(bottom: 2.h),
            shape: AppShapes.rectangleMild,
            elevation: 2,
            child: Container(
              decoration: AppDecorations.boxMild.copyWith(
                border: snapshot.data?.id == food.id
                    ? Border.all(
                        color: AppColors.primary,
                        width: 0.3,
                      )
                    : null,
                color: snapshot.data?.id == food.id
                    ? AppColors.onPrimary
                    : Colors.grey[200],
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ...makingFoodItems(food).map((e) => e).toList(),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: snapshot.data?.id == food.id
                            ? AppColors.primary
                            : Colors.grey[500]!,
                        width: 0.5,
                      ),
                      color: snapshot.data?.id == food.id
                          ? AppColors.primary
                          : Colors.grey[200],
                    ),
                    width: 7.w,
                    height: 7.w,
                    child: snapshot.data?.id == food.id
                        ? Icon(
                            Icons.check,
                            size: 6.w,
                            color: AppColors.onPrimary,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> makingFoodItems(Food food){
    List<int> items = List.generate((food.foodItems!.length * 2) - 1, (i) => i);
    List<Widget> widgets = [];
    int index = 0;
    for(int i = 0; i < items.length; i++){
      if (i % 2 == 0) {
        widgets.add(Chip(
          backgroundColor: AppColors.onPrimary,
          label: Text(
            food.foodItems![index].title,
            style: typography.caption,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ));
        index++;
      }else {
        widgets.add(Icon(
          Icons.add,
          size: 6.w,
        ));
      }
    }
    return widgets;
  }

  Widget floatingActionButton(){
    return StreamBuilder(
      stream: bloc.selectedFood,
      builder: (_, AsyncSnapshot<Food?> snapshot) {
        if (snapshot.hasData)
          return FloatingActionButton.extended(
            onPressed: () {
              VxNavigator.of(context).returnAndPush(snapshot.requireData);
            },
            label: Text(
              intl.addToList,
              style: typography.caption?.apply(
                color: AppColors.onPrimary,
              ),
              softWrap: false,
            ),
            icon: Icon(
              Icons.add,
              size: 6.w,
              color: AppColors.onPrimary,
            ),
          );
        return EmptyBox();
      },
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
