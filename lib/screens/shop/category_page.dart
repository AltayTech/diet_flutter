import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/category_bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends ResourcefulState<CategoryPage> {
  late CategoryBloc categoryBloc;
  Category? args;

  @override
  void initState() {
    super.initState();
    categoryBloc = CategoryBloc();
    listenBloc();
  }

  void listenBloc() {
    categoryBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Category;
    super.build(context);
    categoryBloc.getProduct();
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
                    FlavorConfig.instance.variables["baseUrlFile"] + args!.image),
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: categoryBloc.products,
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
                                          firstTile(
                                              product.productName, product.productThambnail),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                                            child: Line(color: AppColors.strongPen, height: 0.1.h),
                                          ),
                                          secondTile(product.sellingPrice, product.discountPrice),
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
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: ListTile(
        leading: ImageUtils.fromNetwork(FlavorConfig.instance.variables["baseUrlFile"] + pic,
            width: 20.w, height: 10.h),
        title: Text(name!),
      ),
    );
  }

  Widget secondTile(int? selling, int? discount) {
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
            onPressed: () {},
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
                Text(intl.buyCourse,
                    style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loadMoreProgress() {
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
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
