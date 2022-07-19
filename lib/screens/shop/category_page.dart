import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/sizes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'category_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends ResourcefulState<CategoryPage> {
  late CategoryBloc categoryBloc;
  String? args;
  ScrollController? scrollController;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(onScroll);
    categoryBloc = CategoryBloc();
    listenBloc();
  }

  void listenBloc() {
    categoryBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  void onScroll() {
    if (scrollController!.hasClients) if (scrollController!.position.extentAfter <
        AppSizes.verticalPaginationExtent) {
      categoryBloc.onScrollReachingEnd();
    }
  }

  @override
  void dispose() {
    scrollController!.dispose();
    categoryBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      args = ModalRoute.of(context)!.settings.arguments as String;
      categoryBloc.getCategory(args!);
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
        stream: categoryBloc.category,
        builder: (context, AsyncSnapshot<ShopCategory> snapshot) {
          if (snapshot.hasData)
            return Scaffold(
              appBar: Toolbar(
                titleBar: snapshot.data!.category_name!,
              ),
              body: SafeArea(
                child: TouchMouseScrollable(
                  child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ImageUtils.fromNetwork(Utils.getCompletePathShop(snapshot.data!.image),
                              width: 100.w,
                              height: 12.h,
                              showPlaceholder: false,
                              fit: BoxFit.fill),
                          SizedBox(height: 2.h),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder(
                              stream: categoryBloc.categoryProduct,
                              builder: (context, AsyncSnapshot<List<ShopProduct>> snapshot) {
                                if (snapshot.hasData)
                                  return ScrollConfiguration(
                                    behavior: MyCustomScrollBehavior(),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        if (index == snapshot.requireData.length) {
                                          return loadMoreProgress();
                                        }
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0)),
                                          child: Column(
                                            children: [
                                              firstTile(snapshot.data![index]),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(right: 12.0, left: 12.0),
                                                child:
                                                    Line(color: AppColors.strongPen, height: 0.1.h),
                                              ),
                                              secondTile(snapshot.data![index]),
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount: snapshot.requireData.length + 1,
                                    ),
                                  );
                                else
                                  return Progress();
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            );
          else
            return Scaffold(body: Progress());
        });
  }

  Widget firstTile(ShopProduct product) {
    return Padding(
      padding: EdgeInsets.only(top: 2.w, bottom: 2.w, left: 2.w, right: 2.w),
      child: Container(
        height: 10.h,
        child: Row(
          textDirection: context.textDirectionOfLocale,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: ImageUtils.fromNetwork( Utils.getCompletePathShop(product.productThambnail),
                    width: 20.w,
                    height: 9.h,
                    fit: BoxFit.fill)),
            Space(
              width: 3.w,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.productName!,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondTile(ShopProduct product) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(product.sellingPrice.toString().seRagham(),
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.sp)),
              Text(product.discountPrice.toString().seRagham() + intl.currency,
                  style: TextStyle(fontSize: 12.sp))
            ],
          ),
          OutlinedButton(
            onPressed: () =>
                VxNavigator.of(context).push(Uri.parse('${Routes.shopProduct}/${product.id!}')),
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(45.w, 6.h)),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(AppColors.primary),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                side: MaterialStateProperty.all(BorderSide(color: AppColors.primary))),
            child: product.userOrderDate == null
                ? Row(
                    textDirection: context.textDirectionOfLocale,
                    children: [
                      ImageUtils.fromLocal('assets/images/shop/add_cart.svg',
                          width: 2.w, height: 3.h),
                      SizedBox(width: 2.w),
                      Text(intl.buyCourse,
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: AppColors.primary)),
                    ],
                  )
                : Text(intl.view,
                    style: Theme.of(context).textTheme.button!.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget loadMoreProgress() {
    onScroll();
    return StreamBuilder(
      stream: categoryBloc.loadingMoreProducts,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return CenteredCircularProgressIndicator(
          visible: snapshot.data == true,
        );
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
    categoryBloc.getCategory(args!);
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
