import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
// import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/daily_menu/bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/input_widget.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
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
  bool isInitial = false;

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
    bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!isInitial) {
      meal = ModalRoute
          .of(context)
          ?.settings
          .arguments as Meals;
      debugPrint('meal list food ${meal?.id}');
      if (meal != null) bloc.onMealChanged(meal!.id);
      scrollController = ScrollController()
        ..addListener(onScroll);
      isInitial = true;
    }
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
                    hintStyle: typography.caption?.apply(
                      color: AppColors.labelColor,
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
                    )),
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
            itemBuilder: (_, index) => tagItem(snapshot.data?[index], index),
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

  Widget foods() {
    return StreamBuilder(
      stream: bloc.foods,
      builder: (_, AsyncSnapshot<List<ListFood>?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.error is NoResultFoundError) {
            return SearchNoResult(intl.foodNotFoundMessage);
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return EmptyBox();
          }
          debugPrint('food length ${snapshot.requireData!.length}');
          return ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                if (index == snapshot.requireData!.length) {
                  return loadMoreProgress();
                }
                return foodItem(snapshot.requireData![index]);
              },
              itemCount: snapshot.requireData!.length + 1,
            ),
          );
        }
        return Center(child: Progress());
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

  Widget foodItem(ListFood food) {
    return StreamBuilder(
      stream: bloc.selectedFood,
      builder: (_, AsyncSnapshot<ListFood?> snapshot) {
        debugPrint('food/view item ${food.title} / ${food.freeFoodItems?.length} / ${snapshot.data?.id == food.id} / ${food.selectedFreeFood}');
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ...makingFoodItems(food, snapshot.data)
                                .map((item) => item)
                                .toList(),
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
                  if (snapshot.data?.id == food.id &&
                      food.freeFoodItems != null &&
                      food.freeFoodItems!.length > 0)
                    Text(
                      intl.selectOneFreeFood,
                      style: typography.caption?.apply(
                        fontSizeDelta: -2,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  if (snapshot.data?.id == food.id &&
                      food.freeFoodItems != null &&
                      food.freeFoodItems!.length > 0)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 0,
                      children: [
                        ...food.freeFoodItems!
                            .map((freeFood) => freeFoodItem(freeFood, snapshot.data))
                            .toList(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> makingFoodItems(ListFood food, ListFood? selectedFood) {
    // Expanded(
    //   child: Chip(
    //       label:Text(food.title!)),
    // ),
    // List<int> items = List.generate((food.foodItems!.length * 2) - 1, (i) => i);
    List<Widget> widgets = [];
    // int index = 0;
    // for (int i = 0; i < items.length; i++) {
    //   if (i % 2 == 0) {
    List<String> title = food.title!.split("+");
    for (int i = 0; i < title.length; i++) {
         widgets.add(Chip(
           backgroundColor: selectedFood != null && food.id == selectedFood.id
               ? Colors.grey[200]
               : AppColors.onPrimary,
           label: Text(
             title[i].trim(),
             style: typography.caption,
             textAlign: TextAlign.center,
             softWrap: true,
           ),
         )) ;
         if( i!= title.length-1)
          widgets.add(Icon(
            Icons.add,
            size: 6.w,
          ));
    }
        // index++;
      // } else {
      //   widgets.add(Icon(
      //     Icons.add,
      //     size: 6.w,
      //   ));
      // }
    // }
    return widgets;
  }

  Widget floatingActionButton() {
    return StreamBuilder(
      stream: bloc.selectedFood,
      builder: (_, AsyncSnapshot<ListFood?> snapshot) {
        debugPrint('add to list ${snapshot.data?.toJson()}');
        if (snapshot.hasData)
          return FloatingActionButton.extended(
            onPressed: () {
              if(snapshot.data != null)
              VxNavigator.of(context).returnAndPush(snapshot.requireData);
              else
                Utils.getSnackbarMessage(context, 'message');
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

  Widget freeFoodItem(ListFoodItem freeFood, ListFood? selectedFood){
    debugPrint('free food item ${selectedFood?.toJson()}');
    return GestureDetector(
      onTap: () => bloc.onFreeFoodSelected(freeFood),
      child: Card(
        color: AppColors.onPrimary,
        elevation: selectedFood?.selectedFreeFood != null && freeFood.id == selectedFood!.selectedFreeFood!.id ? 0 : 2,
        shape: AppShapes.rectangleLarge,
        child: Container(
          decoration:
          AppDecorations.boxLarge.copyWith(
            border: Border.all(
              color: selectedFood != null &&
                  selectedFood.selectedFreeFood != null &&
                  freeFood.id ==
                      selectedFood
                          .selectedFreeFood!.id
                  ? AppColors.primary
                  : Colors.transparent,
            ),
          ),
          padding:
          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
          child: Text(
            freeFood.title,
            style: typography.caption?.apply(
              color: selectedFood != null &&
                  selectedFood.selectedFreeFood != null &&
                  freeFood.id ==
                      selectedFood
                          .selectedFreeFood!.id
                  ? AppColors.primary
                  : null,
              heightDelta: -10,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
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
