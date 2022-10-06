import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/shop/home/bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/slider_app.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({Key? key}) : super(key: key);

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends ResourcefulState<ShopHomeScreen> {
  late ShopHomeBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ShopHomeBloc();
    bloc.loadContent();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {});
    bloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(
        titleBar: intl.shop,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: bloc.loadingContent,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == false)
              return Container(
                height: 85.h,
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 4.w, bottom: 4.w),
                    itemBuilder: (context, index) {
                      switch (bloc.list![index].styleType) {
                        case StyleType.slider:
                          return SliderApp(banners: bloc.list![index].items!);
                        case StyleType.userAction:
                          return Card(
                            elevation: 0,
                            margin: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                              top: 4.w,
                            ),
                            shape: AppShapes.rectangleMedium,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                textDirection: context.textDirectionOfLocale,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.loose,
                                      children: [
                                        RotatedBox(
                                          child: ImageUtils.fromLocal(
                                              'assets/images/shop/back_rec.svg',
                                              width: 14.w,
                                              height: 12.w,
                                              color: AppColors.primary),
                                          quarterTurns: context.isRtl ? 0 : 90,
                                        ),
                                        ImageUtils.fromNetwork(
                                            Utils.getCompletePathShop(bloc.list![index].icon_url),
                                            width: 7.0.w,
                                            height: 8.w,
                                            color: AppColors.primary)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      bloc.list![index].title ?? '',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                    flex: 1,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      if (bloc.list![index].action_type == ActionType.deepLink) {
                                        VxNavigator.of(context)
                                            .push(Uri.parse('/${bloc.list![index].action}'));
                                      } else if (bloc.list![index].action_type == ActionType.link) {
                                        Utils.launchURL(bloc.list![index].action!);
                                      }
                                    },
                                    child: Text(
                                      intl.view,
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline!
                                          .copyWith(color: AppColors.primary),
                                    ),
                                  ),
                                  Space(
                                    width: 1.w,
                                  ),
                                  Stack(
                                    children: [
                                      Positioned(
                                        left: context.isRtl ? 5 : null,
                                        right: context.isRtl ? null : 5,
                                        child: Icon(
                                          Icons.navigate_next,
                                          color: AppColors.primary.withOpacity(0.6),
                                          size: 5.w,
                                        ),
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        color: AppColors.primary,
                                        size: 5.w,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        case StyleType.productCategory:
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w),
                                child: Row(
                                  textDirection: context.textDirectionOfLocale,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        bloc.list![index].category!.category_name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      flex: 1,
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        VxNavigator.of(context).push(Uri.parse(
                                            '${Routes.shopCategory}/${bloc.list![index].category!.id}'));
                                      },
                                      child: Text(
                                        intl.viewAll,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 33.h,
                                width: 100.w,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemExtent: 55.w,
                                  cacheExtent: 50,
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        VxNavigator.of(context).push(Uri.parse(
                                            '${Routes.shopProduct}/${bloc.list![index].category!.products![i].id}'));
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        margin: EdgeInsets.only(
                                            left: i ==
                                                    (bloc.list![index].category!.products!.length -
                                                        1)
                                                ? 4.w
                                                : 2.w,
                                            right: i == 0 ? 4.w : 2.w,
                                            top: 0.5.h,
                                            bottom: 0.5.h),
                                        shape: AppShapes.rectangleDefault,
                                        child: Padding(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (bloc.list![index].category!.products![i]
                                                      .userOrderDate !=
                                                  null)
                                                ClipRect(
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: ImageUtils.fromNetwork(
                                                        Utils.getCompletePathShop(bloc
                                                            .list![index]
                                                            .category!
                                                            .products![i]
                                                            .productThambnail),
                                                        showPlaceholder: false,
                                                        decoration: AppDecorations.boxMild,
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                              if (bloc.list![index].category!.products![i]
                                                      .userOrderDate ==
                                                  null)
                                                AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: ImageUtils.fromNetwork(
                                                      Utils.getCompletePathShop(bloc.list![index]
                                                          .category!.products![i].productThambnail),
                                                      showPlaceholder: false,
                                                      decoration: AppDecorations.boxMild,
                                                      fit: BoxFit.fill),
                                                ),
                                              Space(
                                                height: 1.h,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  bloc.list![index].category!.products![i]
                                                          .productName ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  textDirection: context.textDirectionOfLocale,
                                                ),
                                              ),
                                              Space(
                                                height: 1.h,
                                              ),
                                              Line(
                                                color: Colors.grey,
                                                height: 0.1.w,
                                                width: double.maxFinite,
                                              ),
                                              Space(
                                                height: 1.h,
                                              ),
                                              (bloc.list![index].category!.products![i]
                                                          .userOrderDate ==
                                                      null)
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                                '${bloc.list![index].category!.products![i].sellingPrice}',
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration.lineThrough,
                                                                    color: Colors.grey,
                                                                    fontSize: 10.sp)),
                                                            Text(
                                                                '${bloc.list![index].category!.products![i].discountPrice} ${intl.currency}',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .overline)
                                                          ],
                                                        ),
                                                        MaterialButton(
                                                          onPressed: () {
                                                            VxNavigator.of(context).push(Uri.parse(
                                                                '${Routes.shopProduct}/${bloc.list![index].category!.products![i].id}'));
                                                          },
                                                          minWidth: 7.w,
                                                          height: 7.w,
                                                          child: bloc.list![index].category!
                                                                      .products![i].userOrderDate !=
                                                                  null
                                                              ? Text(intl.view,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .button!
                                                                      .copyWith(
                                                                          color: AppColors.primary))
                                                              : Container(
                                                                  padding: EdgeInsets.all(2.w),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      color: Colors.white,
                                                                      border: Border.all(
                                                                          width: 0.2.w,
                                                                          color:
                                                                              AppColors.primary)),
                                                                  child: ImageUtils.fromLocal(
                                                                      'assets/images/shop/add_cart.svg',
                                                                      padding: EdgeInsets.all(1.w),
                                                                      width: 5.w,
                                                                      height: 5.w,
                                                                      color: AppColors.primary),
                                                                ),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(intl.buyThisCourse,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .overline!
                                                                .copyWith(
                                                                    color: AppColors.priceColor,
                                                                    fontWeight: FontWeight.w700)),
                                                        SubmitButton(
                                                          onTap: () {
                                                            VxNavigator.of(context).push(Uri.parse(
                                                                '${Routes.shopProduct}/${bloc.list![index].category!.products![i].id}'));
                                                          },
                                                          label: intl.view,
                                                          size: Size(23.w, 8.w),
                                                        ),
                                                      ],
                                                    )
                                            ],
                                          ),
                                          padding: EdgeInsets.all(3.w),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: bloc.list![index].category!.products!.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                            ],
                          );
                          break;
                        case StyleType.banner:
                          return GestureDetector(
                            onTap: () {
                              if (bloc.list![index].banner!.action_type == ActionType.deepLink) {
                                VxNavigator.of(context)
                                    .push(Uri.parse('/${bloc.list![index].banner!.action}'));
                              } else if (bloc.list![index].banner!.action_type == ActionType.link) {
                                Utils.launchURL(bloc.list![index].banner!.action!);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.w),
                              child: ImageUtils.fromNetwork(
                                  Utils.getCompletePathShop(bloc.list![index].banner!.sliderImg),
                                  decoration: AppDecorations.boxMedium,
                                  showPlaceholder: false,
                                  width: 80.h,
                                  height: 15.5.h,
                                  fit: BoxFit.fitWidth),
                            ),
                          );

                        default:
                          return Container();
                      }
                      return Container();
                    },
                    shrinkWrap: true,
                    itemCount: bloc.list?.length ?? 0,
                  ),
                ),
              );
            else
              return Progress();
          },
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentTab: BottomNavItem.SHOP,
      ),
    );
  }

  @override
  void onRetryLoadingPage() {
    bloc.setRepository();
    bloc.loadContent();
  }
}
