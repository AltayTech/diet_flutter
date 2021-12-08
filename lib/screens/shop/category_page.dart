import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends ResourcefulState<CategoryPage> {
  late ProductBloc productBloc;
  ShopCategory? args;

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc();
    listenBloc();
  }

  void listenBloc() {
    productBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ShopCategory;
    super.build(context);
    productBloc.getProducts();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.shop),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            args!.image == null
                ? ImageUtils.fromLocal('assets/images/shop/title.png')
                : ImageUtils.fromNetwork(
                    FlavorConfig.instance.variables["baseUrlFileShop"] + args!.image,
                    width: 100.w,
                    height: 12.h,
                    fit: BoxFit.fill),
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: productBloc.products,
                builder: (context, AsyncSnapshot<List<ShopProduct>> snapshot) {
                  if (snapshot.hasData)
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        if (index == snapshot.requireData.length) {
                          return loadMoreProgress();
                        }
                        return Column(
                          children: [
                            ...snapshot.data!
                                .where((element) => element.categoryId == args!.id)
                                .map((product) => Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)),
                                      child: Column(
                                        children: [
                                          firstTile(product.productName, product.productThambnail),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                                            child: Line(color: AppColors.strongPen, height: 0.1.h),
                                          ),
                                          secondTile(product.sellingPrice, product.discountPrice,
                                              product.id),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        );
                      },
                      itemCount: snapshot.requireData.length + 1,
                    );
                  else
                    return Progress();
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget firstTile(String? name, String? pic) {
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
                child: ImageUtils.fromNetwork(
                    FlavorConfig.instance.variables["baseUrlFileShop"] + pic,
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
                  name!,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondTile(int? selling, int? discount, int? productId) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(selling.toString(),
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.sp)),
              Text(discount.toString() + intl.currency, style: TextStyle(fontSize: 12.sp))
            ],
          ),
          OutlinedButton(
            onPressed: () => productBloc.onProduct(productId!),
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(45.w, 6.h)),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(AppColors.redBar),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                side: MaterialStateProperty.all(BorderSide(color: AppColors.redBar))),
            child: Row(
              children: [
                ImageUtils.fromLocal('assets/images/shop/add_cart.svg', width: 2.w, height: 3.h),
                SizedBox(width: 2.w),
                Text(intl.buyCourse, style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loadMoreProgress() {
    return StreamBuilder(
      stream: productBloc.loadingMoreProducts,
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
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
